# AI Starter Kit — Single-File Sync Bundle

**Purpose:** one file that carries the full contents of every kit file, so the
Google Drive master can be updated in one paste. This is a *generated snapshot* —
the individual files in this folder are the source of truth; regenerate this
bundle whenever any of them change (bump the snapshot line below).

**Snapshot:** kit tracks `AI-CHARTER.md` — currently **v1.4 (2026-06-10)**.

---

## How to use this (in Claude on the web / browser)

Paste this whole file into a Claude conversation that has your Google Drive
connected, with this instruction:

> "Update my `ai-starter-kit` Google Drive folder from this bundle. For each
> `BEGIN FILE` / `END FILE` block, replace that file's entire contents with the
> text between the markers (create the file if it doesn't exist). Do not change
> anything outside the markers. Do **not** copy this bundle file itself into the
> folder unless it's already there."

Each file below is delimited by:

```
>>>>> BEGIN FILE: <path> >>>>>
... exact file contents ...
<<<<< END FILE: <path> <<<<<
```

Everything between those two markers is the literal file body. Markers are chosen
so they never collide with markdown or code-fence syntax inside the files.

## How to regenerate this bundle (for future-me / any agent)

When a kit file changes: update the source file, then rewrite this bundle so each
`BEGIN/END` block matches the current file byte-for-byte, and update the
**Snapshot** line above to the new charter version + date. Keep the file list in
sync — six files today: `AI-CHARTER.md`, `AI-GUIDE-template.md`,
`selfcheck-template.sh`, `spec-template.md`, `README.md`, `FIELD-NOTES.md`.
(This bundle file is not itself part of the kit's day-one scaffolding — it's a
sync convenience.)

================================================================================

>>>>> BEGIN FILE: AI-CHARTER.md >>>>>
# AI-CHARTER.md

**A portable working charter for AI-assisted software projects.**
Version 1.4 · 2026-06-10 · Maintained by the founder; refined over time (see § 8).

This file is project-agnostic. Drop it into the root of any new repo (software,
SaaS, backend, app — anything) on day one, then generate the project-specific
files it calls for in § 7. It encodes everything: the working rules, the human
audit controls, multi-agent coordination, and agentic-product safety. Where this
charter and a project's own files conflict, the project file wins — then update
one of them so they stop conflicting.

---

## 1. Priorities — in this order

1. **Robustness.** Code that fails loudly at known boundaries beats code that
   works silently until it doesn't. Validate at boundaries, surface every
   failure, audit every external call, ship the migration with the schema.
2. **Efficiency.** No wasted compute, no wasted abstraction, no wasted human
   time. Cheap operations gate expensive ones. The smallest viable change is
   the most efficient one. Premature scale work is waste; known scaling cliffs
   get a logged backlog item, not speculative code.
3. **Agility.** Small, reversible, well-attributed changes. Delete cleanly.
   Decisions live in committed files, not in anyone's chat history, so any
   person or model can pick up the work cold.

When two priorities conflict, the one higher on this list wins.

## 2. Working rules (for any human or AI changing code)

1. **Read before writing.** Inspect the files you'll touch AND their call sites
   before proposing changes. If you can't see something, ask — don't guess.
2. **Match the codebase.** Mirror existing patterns, naming, error handling,
   and structure. Don't "improve" adjacent code unless asked.
3. **Smallest viable change.** Solve only what was asked. No bonus features,
   no drive-by cleanup, no extra files, no helpers for a single caller.
4. **No abstraction until 3+ call sites.** Inline first. Never create `utils/`,
   base classes, or frameworks for one use.
5. **Validate at boundaries only.** No defensive try/except around impossible
   cases. Never silently swallow `None` or a failed call — surface or re-raise.
6. **Say "I don't know."** If unsure about an API, version, or context, ask.
   Never fabricate function names, parameters, or behavior.
7. **Plan before code.** For anything beyond a one-line fix, state what you'll
   change, what you won't touch, and what could break. Wait for go-ahead on
   non-trivial work.
8. **Mentally test before presenting.** Walk one realistic input and one edge
   case (empty / None / oversized / concurrent) through the code. State both
   outcomes, including failures. When a value is produced or persisted in one
   place and re-read in another, walk the edge case through *every* reader and
   make them share one parser/validator — never a second hand-rolled weaker one.
   Divergent parsers of the same data fail only on the inputs where they
   disagree, the exact case clean test fixtures never generate.
9. **Delete cleanly.** When replacing code, delete the old version. No
   compatibility shims, dead branches, or commented-out "just in case" code.
10. **No filler.** No obvious comments, placeholder TODOs, or mock data unless
    asked. Names describe intent. Comments that restate code rot silently.
11. **Flag assumptions explicitly,** above the code, not buried in a comment.
12. **Surface conflicts.** If a rule conflicts with the request, raise it
    before proceeding — don't quietly pick one.
13. **Never log secrets or payloads.** No keys, tokens, env values, full
    request/response bodies, or PII in logs, errors, or committed files.
14. **Bound and audit every model call.** Every AI/LLM call sets a token/cost
    bound, runs cheap gates before expensive ones (classify before extract,
    filter before generate), and writes an audit record (model, tokens, status,
    duration, raw output) *before* parsing the response.
15. **Schema changes ship their migration** in the same commit. Never rely on
    an ORM's auto-create to reconcile a production schema.
16. **Guarded execution.** Agents start from a clean tree on a known branch;
    prefer `git reset --hard` and re-prompt over coaxing a confused agent.
    Reads and tests may auto-run; mutations (deletes, installs, commits,
    pushes) are gated. Give agents binary targets ("make this test pass"),
    not open goals. New tests must fail before the fix proves them.
17. *(Reserved per project — promote domain-specific hard rules here only once
    the system they govern is actually being built. Rules for unbuilt systems
    are themselves slop.)*
18. **Attribute AI-authored changes; build against the committed spec, not the
    chat.** Multiple models may touch a repo and each loses context between
    sessions. Tag non-trivial suggestions with their source model. The single
    source of truth is the feature's committed spec (`specs/NNN-feature/spec.md`),
    not any model's conversation history. If a proposal contradicts the spec,
    stop and reconcile the spec first.

Honest disagreement is required, not optional. Agreement bias is a failure mode.

## 3. Human audit controls (disciplines the owner applies)

- **A. Separate feature from test.** Never let one prompt cycle write a feature
  and its test suite. Code first; then a fresh context writes adversarial tests
  designed to break it.
- **B. Compact aggressively.** Clear/compact AI context often. Long chats make
  models optimize for the conversation instead of re-reading the codebase.
- **C. Demand demonstrated failure states.** Require the model to show the raw
  input or error state that triggers each boundary check — not just assert it
  would be caught.
- **D. Review non-trivial work in plan mode.** See the full proposed change set
  before edits land. Auto-apply is for one-liners only; anything touching data
  models, migrations, or agent logic gets reviewed first.
- **E. Capture domain decisions, don't carry them in chat.** Expert/advisor
  input — definitions, taxonomies, escalation logic, what counts as an
  emergency — goes into the feature's committed spec before building against
  it. A decision that exists only in a conversation is one you will re-litigate
  every fresh session.

## 4. Multi-agent coordination

- **Ownership lanes.** Each model/agent owns a named slice (e.g. backend vs.
  UI vs. integrations), written down in the project docs. No agent implements
  in another's lane without the owner (you) explicitly redirecting it.
- **Coordinate at contracts.** When work crosses a lane boundary (a UI needs an
  endpoint; an integration needs a schema field), the handoff is an explicit
  API/data contract in the spec or task file — never "the other model will
  figure it out."
- **Session handoff protocol.** Every working session ends by updating the
  task file with: what changed, what the other agents need next, and what the
  human should test manually. Concrete asks only — exact page/command, sample
  input, expected result.
- **Surfaces stay thin.** One backend is the system of record; every interaction
  surface (chat bot, SMS, web page, CLI) is a translation layer with no business
  logic. If parsing/dedup/classification logic appears in a surface handler, it
  belongs in the backend.

## 5. Agentic-product safety (when the product itself is an AI agent)

- **Confirm before acting.** The agent never takes an outward action (save,
  send, book, notify) autonomously. It drafts, shows a human-readable summary
  — recipient, channel, content, context — and executes only on explicit
  approval. This applies to API design too: "notify"-style endpoints return a
  draft for confirmation, mirroring the extract→confirm pattern.
- **Classify before you act on input.** A cheap gate decides whether input is
  in-domain before any expensive or stateful step. Off-domain input is rejected
  with feedback, never half-processed. This is a safety requirement, not polish.
- **Audit everything.** Every model call is a logged row with cost and outcome
  (rule 14). The audit log — not the chat transcript — is the source of truth
  for "what would have been done."
- **Keep the provider swappable.** Model-vendor specifics live in one layer;
  the API, DB, and surfaces stay provider-neutral so the model can change
  without a rewrite.
- **Do the unit-economics math.** Know the cost per model call and per
  completed user action, and state it as a percentage of what the customer
  pays (e.g. "$0.002 per request ≈ 0.13% of a $149/mo seat"). Cheap-gate
  ordering, rate limits, and spend caps are sized against this number — not
  against vibes. Re-run the math when models, prompts, or pricing change.

## 6. The mechanical done-gate

Self-assessment is unreliable — especially for weaker models — so "done" is
defined by a script, not a feeling. Every project gets a `scripts/selfcheck.sh`
that at minimum: runs the test suite, verifies schema/migrations are in sync,
scans the diff for secret patterns and env files, and greps added code for the
project's known slop patterns (warnings that must be justified). **Scans must
cover untracked files, not just the tracked diff** — brand-new files are exactly
where agents put new code and leaked keys, and `git diff` alone never sees them.
**No agent reports a task complete until the script exits 0.**

### When a defect is found (the remediation loop)

A bug, vulnerability, or near-miss is not "fixed" when the symptom stops. Run the
loop, in order:

1. **Reproduce it as a failing test first.** Before touching the fix, write the
   test that fails on current code — proof it captures the real defect, not a
   guess (rule 16). No demonstrated failure, no fix.
2. **Fix until that test is green** and the done-gate (§ 6) exits 0.
3. **Propagate the lesson, not just the patch.** Update *every* file the defect
   touches — changelog, task file, affected docs. If the defect is a *class*
   (it could recur elsewhere or in another project), make it durable: sharpen the
   relevant working rule here, and add a dated `FIELD-NOTES.md` entry recording
   the bug, *why the gates missed it*, and the fix. A class of bug that leaves
   behind no rule and no note will come back.

The point is compounding: each defect makes the rules and the gate a little
harder to slip past, so the same mistake costs once, not every project.

## 7. New-project scaffolding (create on day one)

| File | Purpose |
|---|---|
| `AI-CHARTER.md` | This file, copied in. The constitution. |
| `AI-GUIDE.md` | Thin per-project entry point for any model: reading order, STOP-and-ask conditions, DO-NOT list, golden-files table, definition of done. Written for the *weakest* plausible reader — imperative, no nuance. |
| `CLAUDE.md` / `AGENTS.md` / equivalents | Per-model project facts: architecture, commands, env vars, ownership lanes. One per model family that works in the repo. |
| `TASKS.md` | Current sprint, backlog, session handoffs. Updated at the end of every session. |
| `CHANGELOG.md` | Keep-a-Changelog format, semantic versioning, tag per meaningful sprint. |
| `specs/NNN-feature/spec.md` | One committed spec per non-trivial feature — the contract all models build against (rule 18) and where domain decisions land (control E). |
| `scripts/selfcheck.sh` | The done-gate (§ 6). |
| `.gitignore` | Includes env files, local scratch/handoff notes, and data directories from the start. |

Adoption order for an existing project: copy this file → write `AI-GUIDE.md` →
write the per-model facts files → stand up `selfcheck.sh` → backfill specs only
for features still being argued about (don't spec finished work).

## 8. Refining this charter

This is a living document. To refine it:

1. Change the text, bump the version (semver: clarification = patch, new rule =
   minor, restructure = major), and add a row to the log below.
2. A rule earns its place by a real incident or a repeated friction — never by
   "seems like a good idea." Cite the trigger in the log.
3. Remove rules that stop paying rent. A charter nobody reads top-to-bottom is
   slop. Target: this file stays readable in one sitting.
4. Propagate: when the master copy (Google Drive) changes, update active
   projects' copies at their next session start — not retroactively.

| Version | Date | Change | Trigger |
|---|---|---|---|
| 1.0 | 2026-06-10 | Initial charter, distilled from the Alfred project (Anti-Slop rules 1–18, audit controls A–E, multi-agent coordination, agentic safety, scaffolding). | Wanting every future project to start with these defaults instead of rediscovering them. |
| 1.1 | 2026-06-10 | § 5: added "Do the unit-economics math" — track cost per call/action as a % of customer price. | Alfred's cost-economics section proved the habit; the charter required auditing costs but never the math against price. |
| 1.2 | 2026-06-10 | § 6: done-gate scans must cover untracked files, not just the tracked diff. | Kit field test loop 3: a planted API key in a brand-new (untracked) file passed the gate because every scan was built on `git diff HEAD`. See kit `FIELD-NOTES.md`. |
| 1.3 | 2026-06-10 | Rule 8: persisted/produced data must be re-read by every consumer through one shared parser/validator; walk the edge case through all readers, not just the one being edited. | Alfred field incident: `output_json` stored raw Claude text the extractor parsed fence-tolerantly, but the save path re-parsed it with plain `json.loads` — a fenced response extracted fine then failed at confirm/Slack-Save/SMS-YES. See kit `FIELD-NOTES.md`. |
| 1.4 | 2026-06-10 | § 6: added "When a defect is found (the remediation loop)" — reproduce as a failing test, fix to green, then propagate the lesson (changelog/docs + a working-rule sharpening and `FIELD-NOTES.md` entry for any defect that is a recurring class). | Codifying the find→reproduce→fix→propagate discipline the founder runs each time a defect surfaces; the two prior incidents (untracked-file scan hole v1.2, parse asymmetry v1.3) followed it ad hoc. Making it explicit so every defect compounds into a harder-to-slip gate. |
<<<<< END FILE: AI-CHARTER.md <<<<<

================================================================================

>>>>> BEGIN FILE: AI-GUIDE-template.md >>>>>
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
<<<<< END FILE: AI-GUIDE-template.md <<<<<

================================================================================

>>>>> BEGIN FILE: selfcheck-template.sh >>>>>
#!/usr/bin/env bash
# Mechanical "am I done" gate (see AI-GUIDE.md § Definition of done).
#
# TEMPLATE: copy into the repo as scripts/selfcheck.sh, chmod +x, complete the
# SWAP sections for your stack, delete what doesn't apply. Make it exit 0 on
# the empty project BEFORE writing any feature code.
#
# AI agents: you may not report a task complete until this exits 0.
# FAILURES (non-zero exit): broken tests, schema/migrations out of sync,
#   secrets or env files in the diff.
# WARNINGS (exit 0, printed loudly): known slop patterns — each must be
#   fixed or justified in the agent's summary.
set -u
cd "$(dirname "$0")/.."

fail=0

echo "== test suite =="
# SWAP: replace the placeholder line with your test runner. Prefer the
# project-local toolchain over a global one.
#   Python:  venv/bin/pytest -q          Node:  npm test --silent
#   Go:      go test ./...               Rust:  cargo test --quiet
# NOTE: most runners FAIL on an empty suite (pytest exits 5 with no tests) —
# seed one smoke test before expecting this gate to pass (kit README step 4).
TEST_CMD="false"  # SWAP — deliberately fails until you configure it
if ! $TEST_CMD; then
    echo "FAIL: test suite is not green (or TEST_CMD not configured yet)."
    fail=1
fi

echo "== schema matches migrations =="
# SWAP: replace with your migration checker — or delete this whole block if
# the project has no database.
#   Alembic:  venv/bin/alembic check     Prisma:  npx prisma migrate diff ...
#   Django:   python manage.py makemigrations --check --dry-run
MIGRATION_CMD="false"  # SWAP — deliberately fails until configured or deleted
if ! $MIGRATION_CMD; then
    echo "FAIL: data model and migrations are out of sync (charter rule 15), or MIGRATION_CMD not configured."
    fail=1
fi

echo "== secrets in the diff =="
# Added lines in tracked changes PLUS full content of untracked files —
# `git diff HEAD` alone ignores brand-new files, which is exactly where
# agents put new code (and leaked keys).
added=$(git diff HEAD | grep -E '^\+[^+]' || true)
untracked=$(git ls-files --others --exclude-standard)
if [ -n "$untracked" ]; then
    added="$added
$(git ls-files --others --exclude-standard -z | xargs -0 cat 2>/dev/null)"
fi
# Common token shapes: Anthropic, OpenAI, Slack, GitHub, AWS, private keys.
# SWAP: add patterns for the providers this project actually uses.
if printf '%s' "$added" | grep -qE 'sk-ant-[A-Za-z0-9_-]{8,}|sk-proj-[A-Za-z0-9_-]{8,}|xox[bp]-[A-Za-z0-9-]{8,}|ghp_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'; then
    echo "FAIL: an API token / private key pattern appears in added lines (charter rule 13)."
    fail=1
fi
changed_names=$(git diff HEAD --name-only; git ls-files --others --exclude-standard)
if printf '%s\n' "$changed_names" | grep -qE '(^|/)\.env(\..+)?$'; then
    echo "FAIL: an env file is in the diff. It must never be committed."
    fail=1
fi

echo "== slop-pattern warnings (added lines) =="
warn() { printf 'WARNING: %s\n' "$1"; }
# SWAP: keep/adapt per language. The pattern: grep ADDED lines for the
# mistakes this codebase has actually made, and force a justification.
code_added=$(git diff HEAD -- '*.py' '*.ts' '*.js' '*.go' | grep -E '^\+[^+]' || true)
code_untracked=$(git ls-files --others --exclude-standard -- '*.py' '*.ts' '*.js' '*.go')
if [ -n "$code_untracked" ]; then
    code_added="$code_added
$(git ls-files --others --exclude-standard -z -- '*.py' '*.ts' '*.js' '*.go' | xargs -0 cat 2>/dev/null)"
fi
if printf '%s\n' "$code_added" | grep -qE '\bexcept\b|\bcatch\b'; then
    warn "added an exception handler — is it swallowing an error instead of surfacing it? (rule 5)"
fi
if printf '%s\n' "$code_added" | grep -qE '\[0\]'; then
    warn "added '[0]' indexing — can the collection be empty? Guard it."
fi
if printf '%s\n' "$code_added" | grep -qE '\.all\(\)|SELECT \*'; then
    warn "added an unbounded query — is it paginated/limited?"
fi
# SWAP: add this project's own recurring mistakes here as they surface.

if [ "$fail" -ne 0 ]; then
    echo "selfcheck: FAILED"
    exit 1
fi
echo "selfcheck: OK (justify any warnings above in your summary)"
<<<<< END FILE: selfcheck-template.sh <<<<<

================================================================================

>>>>> BEGIN FILE: spec-template.md >>>>>
# Spec NNN — {{Feature Name}}

<!-- TEMPLATE: copy to specs/NNN-short-name/spec.md. Fill every section; write
     "none" rather than deleting a section, so its absence is a decision and
     not an oversight. This committed file — not any model's chat history — is
     the contract every model builds against (charter rule 18). Domain
     decisions from advisors/experts land here BEFORE building (control E). -->

**Status:** Draft | Approved | Built — spec only until approved; no implementation.
**Owner:** {{which model/person implements}}. **Consumers:** {{who builds against
this contract — UI model, integration model, etc.}}
**Depends on:** {{existing models, endpoints, auth, prior specs}}

---

## 1. Intent

{{2–3 paragraphs: the user-visible problem, what this feature does about it,
and **why now** — what it unblocks or which customer/vertical it serves.
Plain language; a non-engineer advisor should be able to review this section
alone and confirm the intent is right.}}

## 2. Scope

### In scope
- {{The smallest set of deliverables that achieves the intent.}}

### Explicitly out of scope (this spec)
- {{Everything adjacent that someone will be tempted to build. Name it and
  defer it — each line here prevents a scope-creep argument later. Reference
  Open Decisions (§ 7) where the cut is contested.}}

## 3. Data Model

{{New/changed tables or structures. Copy conventions verbatim from an existing
model — name the model you copied (e.g. "PK and timestamp convention copied
from X"). Include a field table: name, type, nullable, indexed, notes.
State constraints AND where they're enforced (DB vs. app boundary).
"No data model changes" is a valid answer — say it explicitly.}}

## 4. API Contract

{{Exact request/response shapes for every new/changed endpoint — this section
is the handoff surface other models treat as exact. Include: method, path,
auth, success body (real JSON example), and an error table (status / when /
body). State what is deliberately NOT an endpoint. "No API changes" is valid.}}

## 5. Internal Logic

{{Behavior that isn't an endpoint: resolvers, background jobs, state machines.
For each: input → rules → output. Call out non-destructive/safety rules
explicitly (e.g. "fills only empty fields; what the human said wins";
"changes what's proposed, never what's committed").}}

## 6. Edge Cases

{{Numbered list. For each: the situation → the decided behavior. Cover at
minimum: empty/missing input, malformed input, duplicates/idempotency
(what happens on retry or re-run?), partial failure, and the ambiguous case
where the system must NOT guess. Unresolved ones get an Open Decision ID.}}

1. {{...}}
2. {{...}}

## 7. Open Decisions

<!-- The most important section. Every unresolved question gets an ID, the
     trade-off in one or two sentences, and a recommended default — so the
     human decides in minutes and the decision is recorded here, not in chat.
     Resolve ALL of these before any code is written; move resolved items into
     the sections above and mark them "decided". -->

- **D1 — {{question}}?** {{trade-off}}. Recommendation: {{default + why}}.
- **D2 — {{question}}?** {{trade-off}}. Recommendation: {{default + why}}.
<<<<< END FILE: spec-template.md <<<<<

================================================================================

>>>>> BEGIN FILE: README.md >>>>>
# AI Starter Kit

Drop-in working agreement for any AI-assisted software project — SaaS, backend,
app, anything. Distilled from the Alfred project (2026-06). Master copy lives in
Google Drive; this folder is what you copy into a new repo on day one.

**Kit version: tracks `AI-CHARTER.md` — currently v1.4 (2026-06-10).** To check
whether a project's copy is current, compare its charter version + § 8 log
against this. Latest additions: rule 8 (one shared parser for round-tripped data)
and § 6 (the defect-remediation loop). Both came from real bugs, not foresight —
which is how the kit is supposed to grow (§ 8).

## Contents

| File | What it is | How to use it |
|---|---|---|
| `AI-CHARTER.md` | The constitution: priorities, 18 working rules, audit controls, multi-agent coordination, agentic safety, scaffolding checklist. Project-agnostic. | Copy in **unchanged**. Refine only via its § 8 protocol (version bump + log entry). |
| `AI-GUIDE-template.md` | Entry point every AI agent reads first: reading order, STOP conditions, DO-NOT list, golden files, definition of done. | Copy in as `AI-GUIDE.md`, then fill every `{{...}}` placeholder and delete the instruction comments. |
| `selfcheck-template.sh` | The mechanical "am I done" gate — no agent reports done until it exits 0. | Copy in as `scripts/selfcheck.sh`, `chmod +x` it, complete the `SWAP:` sections for your stack, delete what doesn't apply. |
| `spec-template.md` | Skeleton for a committed feature spec — the contract all models build against. | Copy in as `specs/NNN-feature/spec.md` per feature. The Open Decisions section is the point: every unresolved question gets an ID, a trade-off, and a recommended default. |

## Day-one order for a new project

1. `git init`, first commit, `.gitignore` (env files, data dirs, local scratch notes).
2. Copy `AI-CHARTER.md` in unchanged.
3. Write `AI-GUIDE.md` from the template (10 minutes — placeholders only).
4. **Seed the test harness:** install the test runner, add its config so tests can
   import the code (e.g. Python: `pytest.ini` with `pythonpath = .`), and write one
   trivial smoke test (e.g. "the main module imports"). Most runners *fail* on an
   empty suite — pytest exits 5 when no tests are collected — so the smoke test is
   what makes the gate green-able.
5. Stand up `scripts/selfcheck.sh` from the template and complete its `SWAP:`
   sections; it must exit 0 (with the smoke test) before any feature code is written.
6. Write the per-model facts files the charter § 7 lists (`CLAUDE.md`,
   `AGENTS.md`, etc.) as the architecture takes shape — not before.
7. Spec the first non-trivial feature in `specs/001-.../spec.md` before building it.

## Keeping it alive

- The **Drive copy of `AI-CHARTER.md` is the master**. When it changes, update
  active projects' copies at their next session start (charter § 8).
- The templates improve the same way: when a project teaches you something
  reusable, fold it back here and note it in the charter's refinement log.
<<<<< END FILE: README.md <<<<<

================================================================================

>>>>> BEGIN FILE: FIELD-NOTES.md >>>>>
# Field Notes — Kit Testing Log

Living record of real-world tests of this kit. **Do not delete findings** — they
are the evidence behind template/charter changes and the memory of what has and
hasn't been proven. Add a new dated section per test campaign.

## Field incident 1 — 2026-06-10 (Alfred, Claude Code; flagged by Codex)

Not a kit test — a real bug found in a live project, recorded here because it
drove a charter change (rule 8, v1.3).

**Round-trip parse asymmetry.** Alfred's extraction agent stored Claude's *raw*
response text in `AgentRun.output_json`, then parsed it with a fence-tolerant
helper (`parse_json_response`, which strips ```json fences small models add).
The save path (`app/drafts.py`, shared by HTTP confirm, Slack Save, and SMS YES)
re-read the *same* stored text with plain `json.loads`. So a fenced response
extracted fine and showed a draft, then failed at save time — three surfaces
broken by one inconsistency. Existing tests only seeded clean `json.dumps(...)`,
so the gap was invisible.

**Why the gates didn't catch it:** not a secret, not a missing migration, not a
slop pattern — selfcheck was green. It was a *logic* divergence between two
readers of one persisted value, which only a per-input walk through both readers
surfaces. Hand-written fixtures used clean JSON, the one input where the two
parsers agree.

**Fix:** the save path now reuses the extractor's parser; regression test seeds a
fenced payload and asserts the save succeeds. **Charter:** rule 8 sharpened —
persisted/produced data gets one shared parser across all consumers, and the
edge case is walked through every reader, not just the one being edited.

**Carry-forward for the kit:** consider a slop-pattern warning for a second
`json.loads`/parse of a field another module already parses — but the general
form (any divergent parse of round-tripped data) is hard to grep for, so this
stays a review-discipline rule, not a mechanical gate, for now.

## Campaign 1 — 2026-06-10 (Claude Code)

**Method:** built three real projects from scratch, following the kit's own
day-one instructions literally (the way a fresh, weak model would), testing each
gate to failure, fixing the kit between loops, then re-verifying.

| Loop | Project | Result |
|---|---|---|
| 1 | `tick` — CLI task tracker (stdlib, no DB) | **2 failures found**, kit fixed |
| 2 | `contactnorm` — phone/email normalizer library | clean on first try (validated loop-1 fixes) |
| 3 | `limslink` — LIMS sample-event connector (SQLAlchemy + Alembic) | **1 critical failure found**, kit + charter fixed |
| 4 | re-verification across all three + Alfred | all gates green; all planted attacks caught |

Test projects preserved at `/Users/trell/Agentic Scheduler/kit-tests/` for inspection.

### Findings & fixes

1. **"Exit 0 on the empty project" was impossible** (loop 1). `pytest` exits 5
   when no tests are collected, so the README's instruction could not be followed;
   a weak model would loop or weaken the gate to get past it. *Fix:* README day-one
   order rewritten — seed the test harness **and one smoke test** first; the gate
   is expected green *with* the smoke test. Note added beside `TEST_CMD` in the
   template.
2. **No test-harness-config step** (loop 1). Tests couldn't import the code
   (`ModuleNotFoundError`) because nothing told the adopter to create runner
   config (`pytest.ini` with `pythonpath = .`). *Fix:* folded into the new README
   step 4.
3. **Hard-coded "N/4" section numbering lied after customization** (loop 1,
   cosmetic). Deleting the no-DB migration block left "3/4, 4/4" headers. *Fix:*
   headers unnumbered in the template.
4. **CRITICAL — untracked files were invisible to every scan** (loop 3). All
   three scans (secrets, env files, slop patterns) were built on `git diff HEAD`,
   which ignores untracked files — so a planted `sk-ant-…` key in a brand-new
   file passed the gate (proven), and slop in new test files never warned. New
   files are exactly where agents put new code. *Fix:* every scan now also reads
   untracked-file content via `git ls-files --others --exclude-standard`;
   charter § 6 updated (v1.2) to make this a requirement. Patched in the
   template, Alfred's script, and all test projects; re-verified: planted
   untracked key now fails the gate, untracked slop now warns.

### Properties proven good (attack → caught)

- Planted Slack token in a tracked file → FAIL ✓
- Planted Anthropic key in an **untracked** file → FAIL ✓ (after fix 4)
- Staged `.env` file → FAIL ✓
- Schema change without a migration (rule 15) → FAIL via `alembic check` ✓
- Unconfigured template (`TEST_CMD`/`MIGRATION_CMD` placeholders) → FAIL ✓
- Slop patterns (`except`, `[0]`, `.all()`) → WARN without failing ✓
- Idempotent re-ingest, partial-success batch, never-guess normalization — the
  charter § 5 patterns transplanted cleanly into all three project types ✓

### Known untested areas (carry forward to next campaign)

- **Multi-model coordination** (§ 4) — untestable solo; first real test is the
  next project where Codex/Gemini work alongside Claude from day one.
- **Non-Python stacks** — the selfcheck template's Node/Go/Rust SWAP lines are
  written but have never been executed.
- **A genuinely weak model following AI-GUIDE.md** — campaign 1 was run by a
  strong model simulating literal-minded adoption; a real small-model session is
  the truer test.
- Windows (the scripts are bash; Git Bash assumed, unverified).
<<<<< END FILE: FIELD-NOTES.md <<<<<
