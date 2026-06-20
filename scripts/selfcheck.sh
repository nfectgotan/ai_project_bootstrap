#!/usr/bin/env bash
# Mechanical "am I done" gate.
#
# Run from anywhere:
#   bash scripts/selfcheck.sh
#
# This bootstrap version works before a stack is chosen. As soon as a project
# chooses Python, Node, Go, Rust, etc., add the exact test/lint commands here.
set -u
cd "$(dirname "$0")/.."

fail=0

warn() {
    printf 'WARNING: %s\n' "$1"
}

echo "== repository hygiene =="
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "FAIL: this directory is not a git repository."
    fail=1
fi

echo "== tests, if configured =="
if [ -f pytest.ini ] || [ -d tests ]; then
    if command -v python >/dev/null 2>&1; then
        if ! python -m pytest -q; then
            echo "FAIL: pytest suite is not green."
            fail=1
        fi
    else
        echo "FAIL: Python tests are present, but python is not on PATH."
        fail=1
    fi
elif [ -f package.json ]; then
    if command -v npm >/dev/null 2>&1; then
        if ! npm test --silent; then
            echo "FAIL: npm test is not green."
            fail=1
        fi
    else
        echo "FAIL: package.json exists, but npm is not on PATH."
        fail=1
    fi
elif [ -f go.mod ]; then
    if ! go test ./...; then
        echo "FAIL: go test is not green."
        fail=1
    fi
elif [ -f Cargo.toml ]; then
    if ! cargo test --quiet; then
        echo "FAIL: cargo test is not green."
        fail=1
    fi
else
    warn "no test harness detected yet; add one with the first real stack."
fi

echo "== secrets in added content =="
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    added=$(git diff HEAD | grep -E '^\+[^+]' || true)
else
    added=""
fi
untracked=$(git ls-files --others --exclude-standard)
if [ -n "$untracked" ]; then
    added="$added
$(git ls-files --others --exclude-standard -z | xargs -0 cat 2>/dev/null)"
fi

if printf '%s' "$added" | grep -qE 'sk-ant-[A-Za-z0-9_-]{8,}|sk-proj-[A-Za-z0-9_-]{8,}|xox[bp]-[A-Za-z0-9-]{8,}|ghp_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'; then
    echo "FAIL: an API token or private key pattern appears in added content."
    fail=1
fi

if git rev-parse --verify HEAD >/dev/null 2>&1; then
    changed_names=$(git diff HEAD --name-only --diff-filter=d; git ls-files --others --exclude-standard)
else
    changed_names=$(git ls-files --others --exclude-standard)
fi
env_names=$(printf '%s\n' "$changed_names" | grep -E '(^|/)\.env(\..+)?$' | grep -vE '(^|/)\.env\.example$' || true)
if [ -n "$env_names" ]; then
    echo "FAIL: an env file is in the diff. Commit .env.example, not .env."
    fail=1
fi

echo "== slop-pattern warnings =="
if git rev-parse --verify HEAD >/dev/null 2>&1; then
    code_added=$(git diff HEAD -- '*.py' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.rs' | grep -E '^\+[^+]' || true)
else
    code_added=""
fi
code_untracked=$(git ls-files --others --exclude-standard -- '*.py' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.rs')
if [ -n "$code_untracked" ]; then
    code_added="$code_added
$(git ls-files --others --exclude-standard -z -- '*.py' '*.ts' '*.tsx' '*.js' '*.jsx' '*.go' '*.rs' | xargs -0 cat 2>/dev/null)"
fi

if printf '%s\n' "$code_added" | grep -qE '\bexcept\b|\bcatch\b'; then
    warn "added an exception handler; confirm it surfaces failures instead of hiding them."
fi
if printf '%s\n' "$code_added" | grep -qE '\[0\]'; then
    warn "added '[0]' indexing; confirm empty collections are handled."
fi
if printf '%s\n' "$code_added" | grep -qE '\.all\(\)|SELECT \*'; then
    warn "added an unbounded query; confirm it is paginated or intentionally bounded elsewhere."
fi

if [ "$fail" -ne 0 ]; then
    echo "selfcheck: FAILED"
    exit 1
fi

echo "selfcheck: OK (justify any warnings above in your summary)"
