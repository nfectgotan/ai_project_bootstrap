#!/usr/bin/env bash
# .claude/hooks/stop-goal-gate.sh
# Bash mirror of stop-goal-gate.ps1. See that file (and LOOP.md) for the full rationale.
#
# Contract with Claude Code:
#   - Force another pass: print {"decision":"block","reason":"..."} to stdout, exit 0.
#   - Allow stop: exit 0 with no stdout.
#   - NEVER exit non-zero on the "not done" path -- an errored hook fails OPEN
#     (Claude Code lets the turn end). Test the fail path on purpose (LOOP.md).

set -u
goal_file=".claude/.goal"
count_file=".claude/.goal-count"
max_loops=6

allow() { exit 0; }
block() {  # $1 = reason. Use python3 for safe JSON escaping of quotes/newlines.
  REASON="$1" python3 -c 'import json,os;print(json.dumps({"decision":"block","reason":os.environ["REASON"]}))'
  exit 0
}

# Read and discard the event JSON on stdin; we key off the goal file instead.
cat >/dev/null 2>&1 || true

[ -f "$goal_file" ] || allow                      # no active goal -> normal session
goal="$(tr -d '\r' < "$goal_file")"

count=0
[ -f "$count_file" ] && count="$(tr -dc '0-9' < "$count_file")"
count="${count:-0}"
if [ "$count" -ge "$max_loops" ]; then
  rm -f "$goal_file" "$count_file"
  block "Goal loop hit its ${max_loops}-pass limit and the done-gate still is not green. Stop looping now; summarize exactly what still fails and what you need from the human."
fi

out="$(bash scripts/selfcheck.sh 2>&1)"; code=$?
if [ "$code" -eq 0 ]; then
  rm -f "$goal_file" "$count_file"
  allow
fi

echo $((count + 1)) > "$count_file"
tail_out="$(printf '%s\n' "$out" | tail -n 15)"
block "Done-gate (scripts/selfcheck.sh) is NOT green yet.
GOAL: ${goal}
--- selfcheck output (tail) ---
${tail_out}
--- Fix what selfcheck reported, then ACTUALLY RUN the thing and confirm real output before finishing. Honor AI-CHARTER STOP conditions: ask the human instead of looping past a new dependency, schema/format change, data deletion, a security boundary, or genuine ambiguity."
