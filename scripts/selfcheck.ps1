# Mechanical "am I done" gate for Windows PowerShell.
#
# Run from anywhere:
#   powershell -ExecutionPolicy Bypass -File scripts/selfcheck.ps1
#
# Keep this in sync with scripts/selfcheck.sh when project-specific checks are
# added.
$ErrorActionPreference = "Continue"
Set-Location (Join-Path $PSScriptRoot "..")

$fail = $false

function Warn-Line {
    param([string]$Message)
    Write-Host "WARNING: $Message"
}

function Test-CommandExists {
    param([string]$Name)
    return [bool](Get-Command $Name -ErrorAction SilentlyContinue)
}

Write-Host "== repository hygiene =="
& git rev-parse --is-inside-work-tree *> $null
if ($LASTEXITCODE -ne 0) {
    Write-Host "FAIL: this directory is not a git repository."
    $fail = $true
}

Write-Host "== tests, if configured =="
if ((Test-Path "pytest.ini") -or (Test-Path "tests")) {
    if (Test-CommandExists "python") {
        & python -m pytest -q
        if ($LASTEXITCODE -ne 0) {
            Write-Host "FAIL: pytest suite is not green."
            $fail = $true
        }
    } else {
        Write-Host "FAIL: Python tests are present, but python is not on PATH."
        $fail = $true
    }
} elseif (Test-Path "package.json") {
    if (Test-CommandExists "npm") {
        & npm test --silent
        if ($LASTEXITCODE -ne 0) {
            Write-Host "FAIL: npm test is not green."
            $fail = $true
        }
    } else {
        Write-Host "FAIL: package.json exists, but npm is not on PATH."
        $fail = $true
    }
} elseif (Test-Path "go.mod") {
    & go test ./...
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL: go test is not green."
        $fail = $true
    }
} elseif (Test-Path "Cargo.toml") {
    & cargo test --quiet
    if ($LASTEXITCODE -ne 0) {
        Write-Host "FAIL: cargo test is not green."
        $fail = $true
    }
} else {
    Warn-Line "no test harness detected yet; add one with the first real stack."
}

Write-Host "== secrets in added content =="
& git rev-parse --verify HEAD *> $null
$hasHead = $LASTEXITCODE -eq 0
if ($hasHead) {
    $added = (& git diff HEAD | Where-Object { $_ -match '^\+[^+]' }) -join "`n"
} else {
    $added = ""
}
$untracked = @(& git ls-files --others --exclude-standard)
if ($untracked.Count -gt 0) {
    $untrackedContent = foreach ($path in $untracked) {
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Get-Content -LiteralPath $path -Raw -ErrorAction SilentlyContinue
        }
    }
    $added = "$added`n$($untrackedContent -join "`n")"
}

$secretPattern = 'sk-ant-[A-Za-z0-9_-]{8,}|sk-proj-[A-Za-z0-9_-]{8,}|xox[bp]-[A-Za-z0-9-]{8,}|ghp_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'
if ($added -match $secretPattern) {
    Write-Host "FAIL: an API token or private key pattern appears in added content."
    $fail = $true
}

if ($hasHead) {
    $changedNames = @(& git diff HEAD --name-only --diff-filter=d) + @(& git ls-files --others --exclude-standard)
} else {
    $changedNames = @(& git ls-files --others --exclude-standard)
}
$envNames = $changedNames | Where-Object {
    ($_ -match '(^|/|\\)\.env(\..+)?$') -and ($_ -notmatch '(^|/|\\)\.env\.example$')
}
if ($envNames.Count -gt 0) {
    Write-Host "FAIL: an env file is in the diff. Commit .env.example, not .env."
    $fail = $true
}

Write-Host "== slop-pattern warnings =="
if ($hasHead) {
    $codeAdded = (& git diff HEAD -- '*.py' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.rs' | Where-Object { $_ -match '^\+[^+]' }) -join "`n"
} else {
    $codeAdded = ""
}
$codeUntracked = @(& git ls-files --others --exclude-standard -- '*.py' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.rs')
if ($codeUntracked.Count -gt 0) {
    $codeContent = foreach ($path in $codeUntracked) {
        if (Test-Path -LiteralPath $path -PathType Leaf) {
            Get-Content -LiteralPath $path -Raw -ErrorAction SilentlyContinue
        }
    }
    $codeAdded = "$codeAdded`n$($codeContent -join "`n")"
}

if ($codeAdded -match '\bexcept\b|\bcatch\b') {
    Warn-Line "added an exception handler; confirm it surfaces failures instead of hiding them."
}
if ($codeAdded -match '\[0\]') {
    Warn-Line "added '[0]' indexing; confirm empty collections are handled."
}
if ($codeAdded -match '\.all\(\)|SELECT \*') {
    Warn-Line "added an unbounded query; confirm it is paginated or intentionally bounded elsewhere."
}

if ($fail) {
    Write-Host "selfcheck: FAILED"
    exit 1
}

Write-Host "selfcheck: OK (justify any warnings above in your summary)"
