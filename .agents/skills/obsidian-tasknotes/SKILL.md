---
name: obsidian-tasknotes
description: Manage structured Obsidian tasks through the local TaskNotes MCP server, including listing, querying, creating, updating, completing, archiving, and deleting tasks; time tracking; Pomodoro sessions; task statistics; and calendar events. Use this skill whenever the user asks about TaskNotes, Obsidian task management, task status or priorities, due or scheduled tasks, recurring tasks, tracked task time, Pomodoro state, or TaskNotes calendar data, even when they do not explicitly mention MCP.
compatibility: Requires Python 3 and a running TaskNotes MCP server, normally at http://localhost:8989/mcp.
---

# Obsidian TaskNotes

Use the bundled `scripts/tasknotes_mcp.py` client to interact with TaskNotes through MCP. Prefer this API over editing TaskNotes Markdown files directly because TaskNotes owns its property schema, recurrence behavior, time sessions, and status transitions.

## Connection

The default endpoint is `http://localhost:8989/mcp`. Override it with `TASKNOTES_MCP_URL` when needed.

Set the script path before issuing commands:

```bash
TASKNOTES_CLIENT="$HOME/.agents/skills/obsidian-tasknotes/scripts/tasknotes_mcp.py"
```

Check the server before the first substantive operation:

```bash
python3 "$TASKNOTES_CLIENT" health
```

If the request fails, report that TaskNotes or Obsidian may not be running. Do not silently fall back to modifying vault files.

## Workflow

1. Run `health` once to verify the endpoint and identify the active vault.
2. Discover current tools and schemas with `list-tools` rather than assuming a stale schema.
3. Select the narrowest tool matching the user's intent.
4. Pass arguments as one valid JSON object.
5. Read the tool result and summarize the affected task, important fields, and any error.

List available tools:

```bash
python3 "$TASKNOTES_CLIENT" list-tools
```

Inspect one tool's current input schema:

```bash
python3 "$TASKNOTES_CLIENT" list-tools --tool tasknotes_create_task
```

Call a tool:

```bash
python3 "$TASKNOTES_CLIENT" call tasknotes_get_stats '{}'
python3 "$TASKNOTES_CLIENT" call tasknotes_list_tasks '{"limit":20,"offset":0}'
python3 "$TASKNOTES_CLIENT" call tasknotes_create_task '{"title":"Review project notes","due":"2026-07-16","priority":"high"}'
```

## Tool Selection

Discover schemas dynamically, then use these tool families:

- Read and search: `tasknotes_list_tasks`, `tasknotes_get_task`, `tasknotes_query_tasks`, `tasknotes_get_filter_options`, `tasknotes_get_stats`
- Create: `tasknotes_create_task`, `tasknotes_create_task_from_text`, `tasknotes_materialize_occurrence`
- Modify: `tasknotes_update_task`, `tasknotes_toggle_status`, `tasknotes_toggle_archive`, `tasknotes_complete_recurring_instance`
- Delete: `tasknotes_delete_task`
- Time tracking: `tasknotes_start_time_tracking`, `tasknotes_stop_time_tracking`, `tasknotes_get_active_time_sessions`, `tasknotes_get_time_summary`, `tasknotes_get_task_time_data`
- Pomodoro: `tasknotes_start_pomodoro`, `tasknotes_stop_pomodoro`, `tasknotes_pause_pomodoro`, `tasknotes_resume_pomodoro`, `tasknotes_get_pomodoro_status`
- Calendar: `tasknotes_get_calendar_events`

Use `tasknotes_create_task_from_text` when the user supplies natural-language task syntax and wants TaskNotes to parse it. Use `tasknotes_create_task` when fields are explicit and deterministic.

Use `tasknotes_toggle_status` only when the user explicitly wants the next status in the configured cycle. Use `tasknotes_update_task` when the desired target status is known.

## Query Construction

For advanced queries, fetch `tasknotes_query_tasks` from `list-tools --tool` before constructing filters. Give each condition or group a unique `id`. Use ISO dates (`YYYY-MM-DD`) and preserve the server's configured status and priority values; query `tasknotes_get_filter_options` if those values are unknown.

## Safety

- Treat task paths returned by TaskNotes as opaque IDs. Reuse them exactly.
- Before updating, archiving, completing, or deleting an ambiguous task, query candidates and resolve the intended task from title, path, and dates.
- Obtain explicit confirmation immediately before `tasknotes_delete_task` unless the user already clearly requested deletion of an unambiguous task in the current turn.
- Do not invent a successful mutation. Return MCP errors clearly and leave the task unchanged.
- Avoid exposing absolute vault paths unless they are relevant to troubleshooting.

## Response Style

For reads, return the requested task information concisely. For mutations, state the action performed and identify the task. Mention the MCP tool only when useful for debugging; users usually care about the TaskNotes result, not the transport.
