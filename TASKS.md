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
brief, tasks/changelog, spec template, selfcheck gate, generic gitignore, and
optional codebase-memory MCP installer.

**Did not touch:** No application framework, dependencies, credentials, or
product-specific code were added.

**Human action required:** Rename/fill placeholders, choose the first stack, write
the first smoke test before feature work, then run the selfcheck gate.
