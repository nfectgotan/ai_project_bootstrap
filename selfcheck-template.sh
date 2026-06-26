#!/usr/bin/env bash
# Mechanical "am I done" gate (see AI-GUIDE.md § Definition of done).
#
# TEMPLATE: copy into the repo as scripts/selfcheck.sh, chmod +x, complete the
# SWAP sections for your stack, delete what doesn't apply. Make it exit 0 on
# the empty project BEFORE writing any feature code.
#
# AI agents: you may not report a task complete until this exits 0.
# FAILURES (non-zero exit): broken tests, schema/migrations out of sync,
#   secrets or env files in the diff.
# WARNINGS (exit 0, printed loudly): known slop patterns — each must be
#   fixed or justified in the agent's summary.
set -u
cd "$(dirname "$0")/.."

fail=0

echo "== test suite =="
# SWAP: replace the placeholder line with your test runner. Prefer the
# project-local toolchain over a global one.
#   Python:  venv/bin/pytest -q          Node:  npm test --silent
#   Go:      go test ./...               Rust:  cargo test --quiet
# NOTE: most runners FAIL on an empty suite (pytest exits 5 with no tests) —
# seed one smoke test before expecting this gate to pass (kit README step 4).
TEST_CMD="false"  # SWAP — deliberately fails until you configure it
if ! $TEST_CMD; then
    echo "FAIL: test suite is not green (or TEST_CMD not configured yet)."
    fail=1
fi

echo "== schema matches migrations =="
# SWAP: replace with your migration checker — or delete this whole block if
# the project has no database.
#   Alembic:  venv/bin/alembic check     Prisma:  npx prisma migrate diff ...
#   Django:   python manage.py makemigrations --check --dry-run
MIGRATION_CMD="false"  # SWAP — deliberately fails until configured or deleted
if ! $MIGRATION_CMD; then
    echo "FAIL: data model and migrations are out of sync (charter rule 15), or MIGRATION_CMD not configured."
    fail=1
fi

echo "== secrets in the diff =="
# Added lines in tracked changes PLUS full content of untracked files —
# `git diff HEAD` alone ignores brand-new files, which is exactly where
# agents put new code (and leaked keys).
added=$(git diff HEAD | grep -E '^\+[^+]' || true)
untracked=$(git ls-files --others --exclude-standard)
if [ -n "$untracked" ]; then
    added="$added
$(git ls-files --others --exclude-standard -z | xargs -0 cat 2>/dev/null)"
fi
# Common token shapes: Anthropic, OpenAI, Slack, GitHub, AWS, private keys.
# SWAP: add patterns for the providers this project actually uses.
if printf '%s' "$added" | grep -qE 'sk-ant-[A-Za-z0-9_-]{8,}|sk-proj-[A-Za-z0-9_-]{8,}|xox[bp]-[A-Za-z0-9-]{8,}|ghp_[A-Za-z0-9]{16,}|AKIA[0-9A-Z]{16}|BEGIN (RSA |EC |OPENSSH )?PRIVATE KEY'; then
    echo "FAIL: an API token / private key pattern appears in added lines (charter rule 13)."
    fail=1
fi
changed_names=$(git diff HEAD --name-only; git ls-files --others --exclude-standard)
if printf '%s\n' "$changed_names" | grep -qE '(^|/)\.env(\..+)?$'; then
    echo "FAIL: an env file is in the diff. It must never be committed."
    fail=1
fi

echo "== slop-pattern warnings (added lines) =="
warn() { printf 'WARNING: %s\n' "$1"; }
# SWAP: keep/adapt per language. The pattern: grep ADDED lines for the
# mistakes this codebase has actually made, and force a justification.
code_added=$(git diff HEAD -- '*.py' '*.ts' '*.js' '*.go' | grep -E '^\+[^+]' || true)
code_untracked=$(git ls-files --others --exclude-standard -- '*.py' '*.ts' '*.js' '*.go')
if [ -n "$code_untracked" ]; then
    code_added="$code_added
$(git ls-files --others --exclude-standard -z -- '*.py' '*.ts' '*.js' '*.go' | xargs -0 cat 2>/dev/null)"
fi
if printf '%s\n' "$code_added" | grep -qE '\bexcept\b|\bcatch\b'; then
    warn "added an exception handler — is it swallowing an error instead of surfacing it? (rule 5)"
fi
if printf '%s\n' "$code_added" | grep -qE '\[0\]'; then
    warn "added '[0]' indexing — can the collection be empty? Guard it."
fi
if printf '%s\n' "$code_added" | grep -qE '\.all\(\)|SELECT \*'; then
    warn "added an unbounded query — is it paginated/limited?"
fi
# SWAP: add this project's own recurring mistakes here as they surface.

if [ "$fail" -ne 0 ]; then
    echo "selfcheck: FAILED"
    exit 1
fi
echo "selfcheck: OK (justify any warnings above in your summary)"
