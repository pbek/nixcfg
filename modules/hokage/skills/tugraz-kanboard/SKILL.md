---
name: tugraz-kanboard
description: Use when a user asks about a TU Graz Kanboard task using a task ID or a plan.tugraz.at/task URL. Fetch the task details and all comments with kanboard-cli.
---

# TU Graz Kanboard Tasks

Use `kanboard-cli` to retrieve task information from the TU Graz Kanboard instance.

## Input

Accept either form:

- A numeric task ID, for example `74932`
- A task URL, for example `https://plan.tugraz.at/task/74932`

For a URL, extract the numeric path component following `/task/`. Reject URLs from other hosts and ask for a TU Graz task ID or a URL on `plan.tugraz.at`.

## Fetch The Task

Run both read-only commands with the normalized task ID:

```sh
KANBOARD_URL=https://plan.tugraz.at kanboard-cli --json task get <task-id>
KANBOARD_URL=https://plan.tugraz.at kanboard-cli --json comment list <task-id>
```

Always retrieve comments, even when the user only asks to inspect or explain the task. Use the JSON output when analyzing the task so no fields are lost.

Summarize the title, description, status, assignee, due date, project or board context, and relevant metadata. Then summarize the comments in chronological order, preserving author and timestamp when available. Clearly distinguish task fields from discussion in comments.

Do not modify, assign, move, close, reopen, or comment on the task unless the user explicitly asks for that separate action.

## Authentication

If authentication is not configured, tell the user to run:

```sh
kanboard-cli auth login --url https://plan.tugraz.at
```

Never ask the user to paste an API token into the conversation and never print stored credentials.
