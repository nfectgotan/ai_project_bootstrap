# AI-CHARTER.md

**A portable working charter for AI-assisted software projects.**
Version 1.5 · 2026-06-17 · Maintained by the founder; refined over time (see § 8).

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
   no drive-by cleanup, no extra files, no helpers for a single caller. Before
   writing code, climb this ladder and stop at the first rung that holds:
   (1) does this need to exist? — no → skip it; (2) stdlib does it → use it;
   (3) native platform/runtime feature → use it; (4) installed dependency →
   use it; (5) one line → one line; (6) only then, the minimum that works.
   Robustness is never a rung you skip: trust-boundary validation, data-loss
   handling, security, and accessibility stay (Priority 1; rules 1, 5, 13).
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
| 1.5 | 2026-06-17 | Rule 3: added the laziness ladder (stop at the first rung that holds — exist? → stdlib → platform → installed dep → one line → minimum) and the explicit robustness floor so the ladder can't be misread as cutting safety. AI-GUIDE reproduces the ladder imperatively before any code is written. | External review of the `ponytail` skill (published benchmarks: ~80-94% less code, 3-6× faster, 47-77% cheaper). It operationalized Priority 2 / rule 3, held only as principle before. The ladder is a sharpening of an existing rule, so it ships now; the companion `DEFER` shortcut marker was reviewed but held back as unproven new machinery until a real incident earns it (§ 8 rule 2; see `FIELD-NOTES.md`). |
