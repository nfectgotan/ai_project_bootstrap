# AI-GUIDE.md — Start Here

<!-- TEMPLATE: copy into the repo root as AI-GUIDE.md. Fill every {{...}}
     placeholder, then delete all comments like this one. Keep it to one page —
     this file is written for the WEAKEST plausible model: imperative voice,
     no nuance, most important items first. -->

You are an AI agent working in this repository. Read this file completely before
doing anything else. It is written to be followed literally — do not improvise
around it, do not skip sections because you think you know better.

## Reading order

1. This file.
2. `AI-CHARTER.md` — the working rules. Canonical. Nothing here overrides it.
3. The guidance file for your role:
   - `{{CLAUDE.md — owns: backend, data, ...}}`
   - `{{AGENTS.md — owns: web UI, ...}}`
4. The committed spec for your task, if one exists: `specs/NNN-feature/spec.md`.
   The spec beats anything said in chat. If they conflict, stop (see below).

Read nothing else until you have a task. Do not load every doc into context —
read the section that matches the task.

## STOP — ask the human before you:

- Add, remove, or upgrade **any dependency** (`{{requirements.txt / package.json / ...}}`).
- Create a **new file or directory** (editing existing files is fine).
- Touch **{{the data model / schema files}}** or anything in `{{migrations dir}}`.
- Write code **outside your ownership lane** (see step 3 above).
- Proceed when the **committed spec and the conversation disagree** — the spec
  is reconciled first, never silently overridden (charter rule 18).
- Delete or overwrite anything you did not create this session.
- Mark **any task done** without running the gate below.

If you are unsure whether a STOP applies, it applies. Guessing is the failure mode.

## DO NOT — no exceptions

<!-- Universal items first; add the 2–4 project-specific landmines below them.
     Negative constraints are the instruction format weak models follow best. -->

- Never embed a secret (API key, token, env value) in served output, a log
  line, an error message, or a commit.
- Never claim something works that you did not run.
- Never let an agent feature act outwardly without explicit human confirmation.
- {{Never call the model provider outside <the one designated layer>.}}
- {{Never bypass <the canonical save/write path> from a handler.}}
- {{Project-specific landmine #3...}}

## Golden files — copy these shapes, don't invent new ones

| To build… | Copy the shape of… |
|---|---|
| {{a new endpoint}} | {{path/to/canonical_endpoint}} |
| {{a new model/agent call}} | {{path/to/canonical_agent.py}} |
| {{a new test}} | {{path/to/canonical_test.py}} |
| {{a new migration}} | {{generated via <command>, never hand-rolled}} |

## Fixing a bug? Reproduce it first

Write a test that **fails on the current code** before you change anything — it
proves you found the real defect, not a guess. Then fix until that test passes
and the gate below is green. Never delete or weaken a test to go green. (Full
loop — reproduce, fix, then propagate the lesson: `AI-CHARTER.md` § 6.)

## Definition of done

You may not report a task complete until **all** of these are true:

1. `scripts/selfcheck.sh` exits **0**. Run it; do not predict its result.
2. Every **warning** the script prints is either fixed or explicitly justified
   in your summary (one sentence each).
3. Your summary states: what changed, what you deliberately did not touch, and
   what the human should test manually.
4. `TASKS.md` has a session handoff entry if you changed any endpoint, schema,
   workflow, or contract another model builds against.
