# TASKS.md

## Current Focus

- [ ] Replace `PROJECT_NAME` and `PROJECT_SUMMARY` placeholders.
- [ ] Choose the first project stack.
- [ ] Add a smoke test for that stack.
- [ ] Create `specs/001-first-useful-version/spec.md`.
- [ ] Run the selfcheck gate.

## Backlog

- [ ] Decide ownership lanes for agents.
- [ ] Add stack-specific checks to `scripts/selfcheck.sh` and `scripts/selfcheck.ps1`.
- [ ] Document required environment variables in `AGENTS.md` and `CLAUDE.md`.
- [ ] Add deployment notes once deployment exists.

## Session Handoffs

### 2026-06-20 - Bootstrap created

**Changed:** Created the reusable project bootstrap: AI working docs, project
brief, tasks/changelog, spec template, selfcheck gate, and generic gitignore.

**Did not touch:** No application framework, dependencies, credentials, or
product-specific code were added.

**Human action required:** Rename/fill placeholders, choose the first stack, write
the first smoke test before feature work, then run the selfcheck gate.

### 2026-06-20 - MCP treated as global

**Changed:** Removed project-local MCP installer guidance. The bootstrap now
documents MCP servers as globally configured agent capabilities.

**Did not touch:** No app stack or product-specific code.

**Human action required:** For any downstream project that requires a particular
MCP server, name the expected global capability in that project's `AGENTS.md`.

### 2026-06-20 - Global MCP locations documented

**Changed:** Added `MCP.md` with the Windows-local `codebase-memory-mcp` binary
path, Claude Code registration file, known version, and deployment boundary.

**Did not touch:** No project-local installer, binary, or agent registration file
was added.

**Human action required:** Keep `MCP.md` updated if the global MCP binary moves
or the Claude registration path changes.
