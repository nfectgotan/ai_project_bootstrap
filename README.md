# Project Bootstrap

A reusable starting repository for new software projects that will be built with
AI assistance from day one.

This repo is intentionally light: it gives every project the operating rules,
agent handoff files, feature-spec workflow, a starter done-gate, and notes for
globally configured MCP tooling without choosing a product stack for you.

## Should This Be Its Own Repository?

Yes. Make this bootstrap its own repository and use it as the source template for
future projects.

Recommended setup:

1. Create a new GitHub repository named `project-bootstrap` or
   `ai-project-bootstrap`.
2. Push this repo to it.
3. Mark the GitHub repo as a template repository if you want the **Use this
   template** button.
4. For each new project, create a fresh repo from the template, then replace the
   placeholders and add the real stack.

This bootstrap should not live inside another product repo long term. Product
repos should copy from it, not depend on it.

## Fast Start For A New Project

Use this flow when starting a real project from the bootstrap.

### 1. Create the project repo

From GitHub, use **Use this template**.

Or from the command line:

```powershell
git clone <bootstrap-repo-url> my-new-project
cd my-new-project
git remote remove origin
git remote add origin <new-project-repo-url>
```

### 2. Fill in the project facts

Replace `PROJECT_NAME` and `PROJECT_SUMMARY` in:

- `PROJECT-BRIEF.md`
- `AGENTS.md`
- `CLAUDE.md`

Then document the first real stack commands in `AGENTS.md` and `CLAUDE.md`:

- install dependencies
- run locally
- run tests
- lint/typecheck/format, if used
- required environment variable names, with no values

### 3. Confirm global MCP setup

MCP servers are machine-level agent tools. They are not installed inside this
repo.

On the owner's Windows development machine, `codebase-memory-mcp` is already
installed at:

```text
C:\Users\(yourUN)\AppData\Local\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

Claude Code launches it from:

```text
C:\Users\yourUN\.claude.json
```

For another Windows user, install `codebase-memory-mcp` globally from the
approved upstream installer or release source, then confirm:

```powershell
Test-Path "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
```

Verify the installed binary:

```powershell
& "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" --version
```

After the binary exists, register it with Claude Code:

```powershell
& "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" install -y
```

That registration belongs in the user's Claude config, not in the project repo.
Restart Claude Code after registration.

See `MCP.md` for the machine-specific notes and deployment boundary.

### 4. Seed the first test

Add one smoke test for the chosen stack before real feature work. The bootstrap
gate intentionally warns until a stack and test harness exist.

### 5. Run the done-gate

On Windows:

```powershell
powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1
```

Where Bash is configured:

```bash
bash scripts/selfcheck.sh
```

### 6. Spec the first feature

Copy the spec template:

```powershell
New-Item -ItemType Directory -Path specs\001-first-useful-version
Copy-Item specs\template.md specs\001-first-useful-version\spec.md
```

Fill the spec before building anything non-trivial. The committed spec is the
contract future agents build against.

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

## MCP Notes

MCP servers are expected to be configured globally for the coding agent, not
vendored into each project. See `MCP.md` for the known global
`codebase-memory-mcp` setup on this Windows development machine: the binary lives
under `%LOCALAPPDATA%\Programs\codebase-memory-mcp\`, and Claude Code launches it
from the top-level `mcpServers` block in `C:\Users\BossG\.claude.json`. If a
project depends on a specific global MCP server, document the expected capability
in `AGENTS.md` and keep project-local fallback steps available.

## How To Use The AI Files

- Start every AI coding session by telling the agent to read `AI-GUIDE.md`.
- If using Claude Code with global MCP available, tell it: "Use
  `codebase-memory-mcp` for repo memory/search when helpful; committed files and
  the current working tree remain authoritative."
- Keep `AI-CHARTER.md` mostly stable. It is the portable working agreement.
- Keep `AGENTS.md` and `CLAUDE.md` project-specific and current.
- Put non-trivial feature decisions in `specs/NNN-feature/spec.md`, not only in
  chat.
- Update `TASKS.md` at the end of meaningful sessions so another agent can pick
  up the work cold.
- Run the selfcheck gate before reporting a task complete.

## Rules Of The Template

- No secrets, credentials, real customer data, or `.env` files belong here.
- No project-specific framework is included by default.
- Do not vendor global agent/MCP setup into project repos unless the project
  itself owns that server.
- Keep this repo boring and portable. Add stack choices only in downstream
  project copies.
- When a downstream project discovers a reusable improvement, fold it back here
  deliberately and note it in `CHANGELOG.md`.
