# AI-GUIDE.md - Start Here

You are an AI agent working in the `PROJECT_NAME` repository. Read this file
completely before doing anything else. Follow it literally.

## Reading Order

1. This file.
2. `AI-CHARTER.md` - canonical working rules.
3. `PROJECT-BRIEF.md` - product intent and non-goals.
4. Your agent-specific facts file:
   - `AGENTS.md` for Codex and OpenAI coding agents.
   - `CLAUDE.md` for Claude Code.
5. The committed spec for your task, if one exists:
   `specs/NNN-feature/spec.md`.

The committed spec beats chat. If the spec and conversation conflict, stop and
ask the human to reconcile the spec first.

## STOP - Ask Before You

- Add, remove, or upgrade any dependency.
- Create a new public API, database table, migration, background job, or model
  call.
- Write code outside the ownership lane documented in `AGENTS.md` or `CLAUDE.md`.
- Delete or overwrite anything you did not create in the current session.
- Commit, push, deploy, send, notify, purchase, book, or otherwise act outwardly.
- Mark a task complete without running the selfcheck gate.

If unsure whether a STOP applies, ask.

## DO NOT

- Never commit secrets, `.env` files, tokens, private keys, real customer data,
  or raw production payloads.
- Never claim something works unless you ran the relevant command.
- Never let an agentic feature act outwardly without explicit human approval.
- Never build from chat memory when a committed spec exists.
- Never add abstractions for one caller.

## Before Writing Code

Climb the ladder from `AI-CHARTER.md` rule 3:

1. Does this need to exist? If no, do not build it.
2. Does the standard library already do it? Use it.
3. Is there a native platform/runtime feature? Use it.
4. Is there an already-installed dependency? Use it.
5. Is it one line? Write the one line.
6. Only now, write the minimum that works.

Robustness still applies: validate trust boundaries, protect data, avoid secret
leaks, preserve accessibility, and surface failures.

## Golden Files

| To build... | Copy the shape of... |
|---|---|
| a new feature spec | `specs/template.md` |
| a new session handoff | `TASKS.md` |
| a new changelog entry | `CHANGELOG.md` |
| a new done-gate check | `scripts/selfcheck.sh` and `scripts/selfcheck.ps1` |

## Definition Of Done

You may not report a task complete until:

1. The selfcheck gate exits 0: `powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1` on Windows, or `bash scripts/selfcheck.sh` where Bash is configured.
2. Every warning is fixed or justified in the summary.
3. `TASKS.md` has a session handoff if you changed a contract, workflow, schema,
   dependency, command, or model behavior.
4. The summary states what changed, what was deliberately not touched, and what
   the human should test manually.
