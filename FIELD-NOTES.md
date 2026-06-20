# Field Notes — Kit Testing Log

Living record of real-world tests of this kit. **Do not delete findings** — they
are the evidence behind template/charter changes and the memory of what has and
hasn't been proven. Add a new dated section per test campaign.

## External review 1 — 2026-06-17 (ponytail skill)

Not a kit field test and not an internal incident — an external tool reviewed for
ideas worth importing, logged here to keep the evidence trail § 8 expects.

**Source:** `ponytail` (github.com/DietrichGebert/ponytail), a code-minimalism
skill for AI agents. Core mechanism: before writing code the agent stops at the
first rung that holds (exists? → stdlib → platform → installed dep → one line →
minimum); every shortcut carries an in-code comment naming its upgrade path,
harvestable via a debt command. Published benchmarks (median of 10 runs across
Haiku/Sonnet/Opus): ~80-94% less code, 3-6× faster, 47-77% cheaper.

**Overlapped, not imported.** The philosophy is already ours — Priority 2, rule 3
(smallest viable change), rule 4 (no abstraction < 3 callers), rule 5 (validate at
boundaries only). Ponytail's plugin machinery (lite/full/ultra modes, 13-agent
adapters, lifecycle hooks) is out of scope for a docs kit; importing it would be
the over-engineering both projects warn against.

**Imported (v1.5).** (1) The ladder — operationalizes the abstract "smallest
viable change" into a procedure even a weak model can follow rung by rung.
(2) The explicit robustness floor on rule 3, so the ladder can't be misread as a
license to cut a trust boundary. Both are a sharpening of a principle the kit
already held — low risk, shipped.

**Considered and held.** The `DEFER(cond): path` marker + selfcheck ledger — an
in-code deferral convention — was reviewed alongside but NOT shipped. § 8 rule 2
wants rules earned by a real incident or repeated friction, not a good idea from
elsewhere, and unlike the ladder this one adds genuinely new machinery the kit
has never run. Carry forward: if deferred shortcuts start getting lost between
sessions (the exact friction the marker would fix), that is the incident that
earns it. Until then it stays out.

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
