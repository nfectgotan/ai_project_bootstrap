# .claude/hooks/stop-goal-gate.ps1
# Stop hook: keeps the agent working until the done-gate (scripts/selfcheck.ps1)
# passes -- but ONLY while a /goal is active. Registered in .claude/settings.json.
#
# Verified Claude Code behavior:
#   - To force the agent to keep working: print {"decision":"block","reason":"..."}
#     to stdout. The reason becomes the agent's next instruction.
#   - To allow the agent to stop: print nothing and exit 0.
#   - NEVER exit with a non-zero/error code on the "not done" path. Claude Code treats
#     an errored hook as broken and lets the turn END -- the gate fails OPEN. So we
#     always exit 0 and signal only through the JSON. (Test this on purpose -- see LOOP.md.)

$ErrorActionPreference = 'Stop'
$goalFile  = ".claude/.goal"
$countFile = ".claude/.goal-count"
$maxLoops  = 6   # token-budget guard: break to the human after this many forced passes

function Allow { exit 0 }                       # no stdout = allow stop
function Block([string]$reason) {
    (@{ decision = "block"; reason = $reason } | ConvertTo-Json -Compress) | Write-Output
    exit 0
}

try {
    # Read and ignore the event JSON on stdin; we key off the goal file instead.
    [void][Console]::In.ReadToEnd()

    # No active goal -> normal session, do not loop.
    if (-not (Test-Path $goalFile)) { Allow }
    $goal = (Get-Content $goalFile -Raw).Trim()

    # Loop-count guard so we never churn forever (or burn unbounded tokens).
    $count = 0
    if (Test-Path $countFile) { [int]::TryParse(((Get-Content $countFile -Raw).Trim()), [ref]$count) | Out-Null }
    if ($count -ge $maxLoops) {
        Remove-Item $goalFile, $countFile -ErrorAction SilentlyContinue
        Block("Goal loop hit its $maxLoops-pass limit and the done-gate still is not green. Stopping the loop now. Summarize exactly what still fails and what you need from the human -- do NOT keep looping.")
    }

    # Run the existing done-gate, capturing output + exit code.
    $out  = & powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1 2>&1 | Out-String
    $code = $LASTEXITCODE

    if ($code -eq 0) {
        # Gate green -> mechanical floor met. End the loop.
        Remove-Item $goalFile, $countFile -ErrorAction SilentlyContinue
        Allow
    }

    # Gate failed -> force another pass.
    ($count + 1) | Set-Content $countFile
    $tail = (($out -split "`r?`n") | Select-Object -Last 15) -join "`n"
    Block("Done-gate (scripts/selfcheck.ps1) is NOT green yet.`nGOAL: $goal`n--- selfcheck output (tail) ---`n$tail`n--- Fix what selfcheck reported, then ACTUALLY RUN the thing and confirm real output before finishing. Honor AI-CHARTER STOP conditions: ask the human instead of looping past a new dependency, schema/format change, data deletion, a security boundary, or genuine ambiguity.")
}
catch {
    # The hook itself errored. Fail OPEN (allow stop) so the user is never trapped,
    # but make it loud. NOTE: while erroring, the gate is a placebo -- test it (LOOP.md).
    [Console]::Error.WriteLine("stop-goal-gate hook error: $($_.Exception.Message)")
    exit 0
}
