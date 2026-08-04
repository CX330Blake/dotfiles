"""Cookie-JSON import helpers for ``notebooklm auth import-cookies``.

Split out of :mod:`notebooklm.cli.session_cmd` to keep that module under the
ADR-0008 module-size budget (and to keep stdlib names like ``shutil`` off its
retired patch surface). ``register_session_commands`` imports
:func:`_import_cookie_json` / :func:`_read_auth_json_input` back.

These are presentation-adjacent CLI helpers (they raise ``click.ClickException``
directly), so they live beside the command rather than in ``cli/services/``.
"""

from __future__ import annotations

import json
import shutil
from pathlib import Path
from typing import Any

import click

from .. import auth
from ..auth import cookie_names_from_storage, extract_cookies_from_storage, missing_cookies_hint
from ..io import atomic_write_json
from .services.playwright_login import filter_storage_state_cookies_by_domain_policy

__all__ = ["_import_cookie_json", "_read_auth_json_input"]


def _read_auth_json_input(path: str) -> Any:
    """Read a cookie JSON payload from a file path or stdin (``-``)."""
    try:
        if path == "-":
            return json.loads(click.get_text_stream("stdin").read())
        return json.loads(Path(path).expanduser().read_text(encoding="utf-8"))
    except UnicodeDecodeError as exc:
        raise click.ClickException(  # cli-input-validation: import-cookies text decode failure
            f"Could not decode {path!r} as UTF-8: {exc}"
        ) from None
    except json.JSONDecodeError as exc:
        raise click.ClickException(  # cli-input-validation: import-cookies JSON parse failure
            f"Invalid JSON: {exc}"
        ) from None
    except OSError as exc:
        raise click.ClickException(  # cli-input-validation: import-cookies JSON read failure
            f"Could not read {path!r}: {exc}"
        ) from None


def _coerce_cookie_json_to_storage_state(payload: Any) -> dict[str, Any]:
    """Normalize supported cookie JSON shapes to Playwright storage_state."""
    if isinstance(payload, dict) and isinstance(payload.get("cookies"), list):
        # Import only cookies: a storage_state's ``origins`` (localStorage /
        # sessionStorage) bypass the cookie-domain allowlist, so drop them rather
        # than persist unrelated site data. Matches the bare-list branch below.
        return {
            "cookies": [_normalize_imported_cookie(cookie) for cookie in payload["cookies"]],
            "origins": [],
        }
    if isinstance(payload, list):
        return {
            "cookies": [_normalize_imported_cookie(cookie) for cookie in payload],
            "origins": [],
        }
    raise click.ClickException(  # cli-input-validation: import-cookies JSON shape validation
        "Cookie JSON must be either a Playwright storage_state object "
        "with a 'cookies' list or a bare list of cookie objects."
    )


def _normalize_imported_cookie(cookie: Any) -> dict[str, Any]:
    """Translate common browser-export cookie fields toward storage_state."""
    if not isinstance(cookie, dict):
        # Reject non-object entries at the boundary rather than pass them through
        # to the downstream extractor (which assumes dict-like rows).
        raise click.ClickException(  # cli-input-validation: import-cookies non-object cookie entry
            "Each cookie must be a JSON object; the cookie list contains a non-object entry."
        )

    normalized = dict(cookie)
    if "expires" not in normalized:
        # EditThisCookie / Cookie-Editor style exports usually call this field
        # ``expirationDate``. Playwright storage_state uses ``expires``.
        normalized["expires"] = normalized.pop("expirationDate", -1)
    normalized.setdefault("path", "/")
    normalized.setdefault("httpOnly", False)
    name = normalized.get("name")
    if isinstance(name, str) and name.startswith(("__Secure-", "__Host-")):
        # ``__Secure-``/``__Host-`` prefixed cookies are invalid unless ``Secure``
        # (Chromium rejects them on a storage_state re-injection), so force the
        # flag rather than persist an insecure variant when a bare-list export
        # omitted it. Many Google auth cookies (e.g. ``__Secure-1PSIDTS``) use
        # this prefix.
        normalized["secure"] = True
    else:
        normalized.setdefault("secure", False)
    normalized.setdefault("sameSite", "None")
    return normalized


def _nonempty_cookie_names(filtered_state: dict[str, Any]) -> set[str]:
    """Names of ``filtered_state`` cookies that carry a non-empty string value.

    Reads the raw cookie list rather than the flattened
    ``extract_cookies_from_storage`` dict, so a non-empty cookie is never masked
    by an empty same-name duplicate — matching the runtime jar, which skips empty
    rows when building httpx cookies.
    """
    return {
        cookie["name"]
        for cookie in filtered_state.get("cookies", [])
        if isinstance(cookie, dict)
        and isinstance(cookie.get("name"), str)
        and isinstance(cookie.get("value"), str)
        and cookie["value"]
    }


def _has_usable_secondary_binding(filtered_state: dict[str, Any]) -> bool:
    """Whether ``filtered_state`` carries a non-empty secondary auth binding.

    Mirrors the name-level check in ``_auth.cookie_policy`` (``OSID``, or both
    ``APISID`` and ``SAPISID``) but at the **value** level — that check counts a
    present-but-empty cookie as satisfying the binding, which import-cookies must
    not accept as a usable login.
    """
    nonempty = _nonempty_cookie_names(filtered_state)
    return "OSID" in nonempty or {"APISID", "SAPISID"} <= nonempty


def _backup_existing_storage(storage_path: Path) -> Path | None:
    """Copy an existing ``storage_state.json`` to a ``.bak`` sibling before overwrite.

    ``import-cookies`` replaces the target outright, so a stale-but-valid import
    would otherwise silently destroy a working session with no undo. Copying the
    prior file to ``<name>.bak`` (``copy2`` preserves its ``0o600`` mode) leaves a
    one-step recovery path. Returns the backup path, or ``None`` when there was
    nothing to back up.
    """
    if not storage_path.exists():
        return None
    backup_path = storage_path.with_name(storage_path.name + ".bak")
    shutil.copy2(storage_path, backup_path)
    # ``copy2`` preserves the SOURCE mode; force private perms so a backup of a
    # (legacy/world-readable) storage_state never leaks credentials at rest.
    backup_path.chmod(0o600)
    return backup_path


def _import_cookie_json(
    *,
    payload: Any,
    storage_path: Path,
    include_domains: set[str],
    include_optional: bool,
) -> tuple[dict[str, Any], Path | None]:
    """Validate, filter, and persist cookie JSON to ``storage_state.json``.

    Returns the persisted ``storage_state`` and the path of any ``.bak`` backup
    taken of a pre-existing target (``None`` when none was needed).
    """
    storage_state = _coerce_cookie_json_to_storage_state(payload)
    filtered_state = filter_storage_state_cookies_by_domain_policy(
        storage_state,
        include_optional=include_optional,
        include_domains=include_domains,
    )
    cookie_names = cookie_names_from_storage(filtered_state)
    try:
        # This validates required cookies and catches malformed cookie shapes
        # using the same loader later runtime calls use.
        extracted_cookies = extract_cookies_from_storage(filtered_state)
    except ValueError as exc:
        hint = missing_cookies_hint(cookie_names)
        raise click.ClickException(  # cli-input-validation: import-cookies required-cookie validation
            f"{exc}\n\n{hint}"
        ) from None

    empty_required = sorted(
        name
        for name in auth.MINIMUM_REQUIRED_COOKIES
        if not isinstance(extracted_cookies.get(name), str) or not extracted_cookies[name]
    )
    if empty_required:
        raise click.ClickException(  # cli-input-validation: import-cookies required-cookie value validation
            "Required cookies must have non-empty string values: " + ", ".join(empty_required)
        )

    # The name-level secondary-binding check counts a present-but-empty cookie as
    # satisfying the binding, so a set whose ``APISID``/``SAPISID`` (or ``OSID``)
    # are present-but-empty can pass required-cookie validation yet be unusable.
    # Reject that specific false-"ok". Like the login flow (which only warns), we
    # stay silent when no secondary-binding cookie is present at all.
    secondary_present = {"OSID", "APISID", "SAPISID"} & set(cookie_names)
    if secondary_present and not _has_usable_secondary_binding(filtered_state):
        raise click.ClickException(  # cli-input-validation: import-cookies secondary-binding validation
            "Secondary-binding cookies are present but have empty values "
            "(need a non-empty OSID, or non-empty APISID and SAPISID): "
            + ", ".join(sorted(secondary_present))
        )

    storage_path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    backup_path = _backup_existing_storage(storage_path)
    atomic_write_json(storage_path, filtered_state)
    return filtered_state, backup_path
