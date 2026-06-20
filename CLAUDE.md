# CLAUDE.md

This file gives Claude Code the project facts it needs for `PROJECT_NAME`.

## What This Is

`PROJECT_NAME` is:

> PROJECT_SUMMARY

Replace this section before feature work begins. Keep it aligned with
`AGENTS.md`.

## Running The Project

No runtime has been chosen yet.

When a real project chooses a stack, replace this section with exact commands:

```bash
# install dependencies

# run locally

# run tests

# run the done-gate on Windows
powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1

# or where Bash is configured
bash scripts/selfcheck.sh
```

## Configuration

Document required environment variable names here. Do not include values.

```text
EXAMPLE_API_KEY=
EXAMPLE_BASE_URL=
```

## Architecture

Fill this in after the first real implementation decision.

Include:

- Main code directories.
- Data stores and migrations, if any.
- External integrations.
- Where model/provider-specific code lives, if any.

## Key Constraints

- Follow `AI-GUIDE.md` and `AI-CHARTER.md`.
- Do not add dependencies without asking.
- Do not commit secrets or `.env` files.
- Keep shared contracts in committed specs, not chat.
- Run the selfcheck gate before reporting done.
- Treat MCP servers as globally configured agent tools, not project-local
  dependencies, unless this project owns the server.
