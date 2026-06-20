# AGENTS.md

This file gives Codex and OpenAI coding agents the project facts they need for
`PROJECT_NAME`.

## What This Is

`PROJECT_NAME` is:

> PROJECT_SUMMARY

Replace this section before feature work begins. Keep it concrete enough that a
fresh agent can understand the product without reading chat history.

## Current Stack

No application stack has been chosen in this bootstrap repository.

When a real project chooses a stack, document:

- Runtime and package manager.
- How to install dependencies.
- How to run the app locally.
- How to run tests.
- How to run lint/typecheck/format commands.
- Required environment variables, with names only and no values.

## Architecture

Fill this in after the first real implementation decision.

Recommended minimum:

- Main entrypoints.
- Data stores and migration commands, if any.
- External services and ownership boundaries.
- Background jobs or queues, if any.
- Frontend/build toolchain, if any.

## Key Constraints

- Secrets live only in ignored local environment files or the deployment secret
  manager.
- Non-trivial features start with a committed spec in `specs/`.
- Agents run the selfcheck gate before reporting done.
- Agentic or outward actions require explicit human approval.
- MCP servers are globally configured for the agent. Do not add MCP install
  scripts to this repo unless this project owns the server.

## Ownership Lanes

Until the project defines lanes, every agent must stay within the task assigned
by the human and must update the relevant spec before changing shared contracts.

Example lanes to replace:

- Backend/API:
- Frontend/UI:
- Data/migrations:
- Integrations:
- Tests/quality:

## Done Gate

On Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1
```

Where Bash is configured:

```bash
bash scripts/selfcheck.sh
```
