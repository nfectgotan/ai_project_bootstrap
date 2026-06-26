---
description: Start a verify-until-done loop toward a goal, gated by selfcheck and the charter.
---
You are starting a GOAL LOOP. The goal is:

$ARGUMENTS

Do this now, in order:

1. Write the exact goal text above to `.claude/.goal` (create it; overwrite if it exists).
2. Write `0` to `.claude/.goal-count`.
3. Begin working toward the goal in the smallest viable steps (AI-CHARTER rule 3 / the ladder).

A Stop hook re-runs `scripts/selfcheck` every time you try to finish and will send you
back to work until it passes. You are NOT done until ALL of these are true:

- `scripts/selfcheck.ps1` (or `scripts/selfcheck.sh`) passes with no failures.
- The acceptance criteria in the relevant `specs/NNN-*/spec.md` are met (if a spec exists).
- You have ACTUALLY RUN the thing and seen real output prove it works — not just read the
  code, not just unit tests. Run the command or app, make the real call, check the real
  log / file / output. For logic that can be tested, ADD a test so the gate enforces it
  from now on (this is how the loop "remembers" the verification).

Break the loop and ASK THE HUMAN — do not loop past these — if you hit any AI-CHARTER STOP
condition: adding a new dependency, changing a schema or data format, deleting data, a
security/auth boundary, or genuine ambiguity about what was asked.

When everything above holds, delete `.claude/.goal`, then stop and report three things:
what you built, how you verified it (show the real output), and exactly how I can re-check it.
