#!/usr/bin/env python3
"""Minimal Streamable HTTP client for the local TaskNotes MCP server."""

import argparse
import json
import os
import sys
import urllib.error
import urllib.request
from typing import Optional

DEFAULT_URL = "http://localhost:8989/mcp"
PROTOCOL_VERSION = "2025-03-26"


def parse_sse(payload: str) -> dict:
    data_lines = []
    for line in payload.splitlines():
        if line.startswith("data:"):
            data_lines.append(line[5:].lstrip())
        elif not line and data_lines:
            break
    if not data_lines:
        raise ValueError("The server returned an SSE response without a data event")
    return json.loads("\n".join(data_lines))


def request(url: str, method: str, params: dict, request_id: int = 1) -> dict:
    body = json.dumps(
        {"jsonrpc": "2.0", "id": request_id, "method": method, "params": params}
    ).encode("utf-8")
    http_request = urllib.request.Request(
        url,
        data=body,
        method="POST",
        headers={
            "Content-Type": "application/json",
            "Accept": "application/json, text/event-stream",
        },
    )

    try:
        with urllib.request.urlopen(http_request, timeout=15) as response:
            payload = response.read().decode("utf-8")
            content_type = response.headers.get_content_type()
    except urllib.error.HTTPError as error:
        detail = error.read().decode("utf-8", errors="replace")
        raise RuntimeError(f"HTTP {error.code}: {detail}") from error
    except urllib.error.URLError as error:
        raise RuntimeError(f"Cannot connect to {url}: {error.reason}") from error

    message = (
        parse_sse(payload)
        if content_type == "text/event-stream"
        else json.loads(payload)
    )
    if "error" in message:
        error = message["error"]
        raise RuntimeError(f"MCP error {error.get('code')}: {error.get('message')}")
    return message.get("result", {})


def initialize(url: str) -> dict:
    return request(
        url,
        "initialize",
        {
            "protocolVersion": PROTOCOL_VERSION,
            "capabilities": {},
            "clientInfo": {"name": "obsidian-tasknotes-skill", "version": "1.0.0"},
        },
    )


def list_tools(url: str, tool_name: Optional[str]) -> object:
    tools = request(url, "tools/list", {}).get("tools", [])
    if tool_name is None:
        return tools
    for tool in tools:
        if tool.get("name") == tool_name:
            return tool
    raise RuntimeError(f"Unknown TaskNotes tool: {tool_name}")


def call_tool(url: str, name: str, arguments: dict) -> dict:
    result = request(url, "tools/call", {"name": name, "arguments": arguments})
    content = result.get("content", [])
    if result.get("isError"):
        messages = [
            item.get("text", "") for item in content if item.get("type") == "text"
        ]
        raise RuntimeError("; ".join(messages) or f"TaskNotes tool failed: {name}")
    if len(content) == 1 and content[0].get("type") == "text":
        text = content[0].get("text", "")
        try:
            return json.loads(text)
        except json.JSONDecodeError:
            return {"text": text}
    return result


def parse_arguments(raw: str) -> dict:
    try:
        value = json.loads(raw)
    except json.JSONDecodeError as error:
        raise argparse.ArgumentTypeError(f"Invalid JSON: {error}") from error
    if not isinstance(value, dict):
        raise argparse.ArgumentTypeError("Tool arguments must be a JSON object")
    return value


def build_parser() -> argparse.ArgumentParser:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--url",
        default=os.environ.get("TASKNOTES_MCP_URL", DEFAULT_URL),
        help="TaskNotes MCP endpoint",
    )
    subparsers = parser.add_subparsers(dest="command", required=True)

    subparsers.add_parser("initialize", help="Perform an MCP initialize handshake")
    subparsers.add_parser("health", help="Call the TaskNotes health check")

    list_parser = subparsers.add_parser("list-tools", help="List MCP tools and schemas")
    list_parser.add_argument("--tool", help="Return only the named tool")

    call_parser = subparsers.add_parser("call", help="Call a TaskNotes MCP tool")
    call_parser.add_argument("name", help="MCP tool name")
    call_parser.add_argument("arguments", type=parse_arguments, help="JSON object")
    return parser


def main() -> int:
    parser = build_parser()
    args = parser.parse_args()

    try:
        if args.command == "initialize":
            result = initialize(args.url)
        elif args.command == "health":
            result = call_tool(args.url, "tasknotes_health_check", {})
        elif args.command == "list-tools":
            result = list_tools(args.url, args.tool)
        else:
            result = call_tool(args.url, args.name, args.arguments)
        print(json.dumps(result, indent=2, ensure_ascii=False))
        return 0
    except (RuntimeError, ValueError, json.JSONDecodeError) as error:
        print(f"Error: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    raise SystemExit(main())
