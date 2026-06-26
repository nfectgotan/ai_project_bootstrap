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
