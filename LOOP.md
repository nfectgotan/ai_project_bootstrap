# LOOP.md — the goal loop (verify-until-done)

This repo can run a **goal loop**: you give the agent a goal, and it keeps working —
re-checking itself every time it tries to finish — until the done-gate passes. The
loop's finish line is your existing `scripts/selfcheck` gate, so nothing new decides
"done"; the gate you already trust does.

This is optional. Without an active goal, sessions behave exactly as before.

## The pieces

| Path | What it does |
| --- | --- |
| `.claude/commands/goal.md` | The `/goal` command. Sets the goal + the verification standard, then starts work. |
| `.claude/hooks/stop-goal-gate.ps1` / `.sh` | The Stop hook. Runs `selfcheck` each time the agent tries to finish; sends it back until green. |
| `.claude/settings.json` | Registers the Stop hook. |
| `.claude/.goal`, `.claude/.goal-count` | Scratch files the loop uses. **Gitignore these** (see below). |

## How to use it

1. Register the hook: merge the `hooks` block from `.claude/settings.json` into your
   real `.claude/settings.json`. On macOS/Linux, swap the `.ps1` command line for
   `bash .claude/hooks/stop-goal-gate.sh`. Restart Claude Code.
2. Add the scratch files to `.gitignore`:
   ```
   .claude/.goal
   .claude/.goal-count
   ```
3. Start a loop:
   ```
   /goal Implement the parser in specs/003-cfg-parser/spec.md. Verify by running it on
   a real .cfg file and showing the parsed output. Add a test so the gate enforces it.
   ```
4. The agent works, and every time it tries to stop, the hook runs `selfcheck`. If the
   gate fails, the agent is sent back with the exact failures. When the gate is green,
   the loop ends and the agent reports what it did and how to re-check it.

## What "done" means in the loop

The hook can only mechanically check the **floor**: `selfcheck` is green. The richer
part of "done" — the feature actually works, end to end — is enforced by the standard
baked into `/goal`: the agent must *run the real thing and show real output*, and add a
test so the gate keeps enforcing it. Tests passing is necessary, not sufficient; running
it for real is the point (this is the main lesson from the loops article that prompted
this). For a UI you'd verify in a browser; for the CLI tools, parsers, and scripts in
this repo, "verify" means run the actual command and check the output/log/file.

## Guardrails (why this loop is safe)

- **Capped.** After `maxLoops` (default 6) forced passes without a green gate, the loop
  stops and asks you. It cannot churn forever or burn unbounded tokens.
- **Respects STOP conditions.** The loop will not bulldoze past a new dependency, a
  schema/format change, data deletion, a security boundary, or real ambiguity — it
  breaks and asks. Autonomy never overrides an AI-CHARTER STOP.
- **Goal-gated.** The hook only loops while `.claude/.goal` exists. Normal sessions are
  untouched.

## The one thing you must test

A Stop hook that errors out (exits with a plain error) is treated by Claude Code as
*broken*, and it lets the agent finish anyway — so a broken gate fails **open** and you
won't notice until the day a check actually fails. These scripts are written to avoid
that (they only ever exit 0 and signal through JSON), but verify it yourself once:

1. Temporarily make `selfcheck` fail (e.g., add `exit 1` near the top, or break a test).
2. Start a trivial `/goal` and let the agent try to finish.
3. Confirm it is **blocked and sent back** (you'll see the selfcheck tail in its next
   message), not allowed to stop.
4. Undo the temporary break.

If step 3 doesn't block, the gate is a placebo — fix it before trusting the loop.

## Cost note

A loop does more work autonomously, which means it uses more tokens than a single pass.
That's the trade for not having to babysit. Use it for well-specified tasks with a real
gate; for quick one-offs, a normal session is cheaper.
