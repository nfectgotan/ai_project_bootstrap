# Changelog

All notable changes to this project will be documented in this file.

This format follows the spirit of Keep a Changelog, and project versions should
track meaningful shipped increments.

## [Unreleased]

### Added

- Initial reusable project bootstrap.
- AI working agreement files: `AI-CHARTER.md`, `AI-GUIDE.md`, `AGENTS.md`, and
  `CLAUDE.md`.
- Project workflow files: `PROJECT-BRIEF.md`, `TASKS.md`, and `specs/template.md`.
- Mechanical done-gates: `scripts/selfcheck.sh` and `scripts/selfcheck.ps1`.

### Changed

- Documented MCP servers as global agent configuration rather than project-local
  install artifacts.
- Added `MCP.md` with the known Windows-local `codebase-memory-mcp` binary path,
  standard installer location, approximate binary size, Claude Code registration
  path, version, user scope, and deployment boundary.
- Expanded startup docs for secondary users: hosted template repo setup,
  downstream project creation, global MCP verification, first smoke test,
  done-gate, and first feature spec.
- Added concrete `codebase-memory-mcp` verification and Claude Code registration
  commands for Windows users.
