# Project Bootstrap

A reusable starting repository for new software projects that will be built with
AI assistance from day one.

This repo is intentionally light: it gives every project the operating rules,
agent handoff files, feature-spec workflow, a starter done-gate, and optional MCP
tooling without choosing a product stack for you.

## What You Get

| Path | Purpose |
|---|---|
| `AI-CHARTER.md` | Portable working rules for AI-assisted development. Copy unchanged unless refining by its own protocol. |
| `AI-GUIDE.md` | First file every AI agent should read in this repo. |
| `AGENTS.md` / `CLAUDE.md` | Per-agent project facts and command guide. Keep these current as the stack becomes real. |
| `PROJECT-BRIEF.md` | One-page product/project frame before implementation begins. |
| `TASKS.md` | Current sprint, backlog, and session handoffs. |
| `CHANGELOG.md` | Keep-a-Changelog style project history. |
| `MCP.md` | Notes for globally configured MCP tooling on the development machine. |
| `specs/template.md` | Feature spec template. Copy to `specs/NNN-short-name/spec.md`. |
| `scripts/selfcheck.sh` / `scripts/selfcheck.ps1` | Mechanical done-gates: tests when present, secret scans, env-file scan, and slop warnings. |

## Start A New Project

1. Copy or clone this repository into the new project folder.
2. Replace `PROJECT_NAME` and `PROJECT_SUMMARY` in `PROJECT-BRIEF.md`,
   `AGENTS.md`, and `CLAUDE.md`.
3. Fill the stack-specific sections in `AGENTS.md` and `CLAUDE.md`.
4. Add the first smoke test for the chosen stack.
5. Run:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1
```

Or, where Bash is configured:

```bash
bash scripts/selfcheck.sh
```

6. Write the first non-trivial feature spec in `specs/001-short-name/spec.md`
   before building.

## MCP Notes

MCP servers are expected to be configured globally for the coding agent, not
vendored into each project. See `MCP.md` for the known global
`codebase-memory-mcp` setup on this Windows development machine. If a project
depends on a specific global MCP server, document the expected capability in
`AGENTS.md` and keep project-local fallback steps available.

## Rules Of The Template

- No secrets, credentials, real customer data, or `.env` files belong here.
- No project-specific framework is included by default.
- Do not vendor global agent/MCP setup into project repos unless the project
  itself owns that server.
- Keep this repo boring and portable. Add stack choices only in downstream
  project copies.
- When a downstream project discovers a reusable improvement, fold it back here
  deliberately and note it in `CHANGELOG.md`.
