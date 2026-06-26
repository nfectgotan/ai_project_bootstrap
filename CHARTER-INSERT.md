# Paste-in edits for AI-CHARTER.md and CHANGELOG.md

I don't have your current charter text in front of me, so here are two small inserts in
the charter's voice. Place them, don't let me overwrite anything.

## 1. AI-CHARTER.md — add to your working rules (near the "definition of done" idea)

> **Done means verified by running, not by reading.** A task is not done because the code
> looks right or the unit tests pass. Run the actual code path and confirm real output —
> run the command/app, make the real call, check the log/file/output. Tests passing is
> necessary, not sufficient. When working under a `/goal` loop, keep going until the
> done-gate is green, but break the loop and surface to the human on any STOP condition
> (new dependency, schema/format change, data deletion, security boundary, real
> ambiguity). Autonomy never overrides a STOP. See `LOOP.md`.

## 2. CHANGELOG.md — add under your latest version (Keep-a-Changelog style)

> ### Added
> - Optional **goal loop** (`LOOP.md`): a Claude Code Stop hook that re-runs
>   `scripts/selfcheck` whenever the agent tries to finish and sends it back until the
>   gate is green, driven by a `/goal` command. Exit condition is the existing done-gate;
>   loop is capped (default 6 passes) and honors AI-CHARTER STOP conditions.
>
> ### Changed
> - Definition of done now requires verification by *running* the code and checking real
>   output, not only passing tests.
>
> Trigger: external article on Claude Code loops (Kjosbakken, *Towards Data Science*,
> 2026-06-23). The kit already had the goal-as-contract (`specs/`) and the finish line
> (`selfcheck`); this adds the driver and the run-it-for-real standard. Field-test before
> treating as settled (per AI-CHARTER refinement protocol).
