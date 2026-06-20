# MCP.md

MCP servers for this development machine are configured globally for the coding
agent. They are not project-local dependencies and should not be vendored into
new repositories.

## codebase-memory-mcp

On this Windows machine, `codebase-memory-mcp` is installed globally at:

```text
C:\Users\BossG\AppData\Local\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

Equivalent environment-based path:

```text
%LOCALAPPDATA%\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

Known version: `0.8.1`.

Claude Code launches it from the user-scoped registration in:

```text
C:\Users\BossG\.claude.json
```

The relevant registration is the top-level `mcpServers` block.

## Project Guidance

- Do not copy the MCP binary into a project repo.
- Do not copy global Claude/Codex registration files into a project repo.
- If a project benefits from this server, document the expected capability in
  `AGENTS.md` or `CLAUDE.md`.
- Keep project-local fallback steps available because global MCP availability is
  a development-machine feature, not part of deployment.
- This tool runs on the Windows development machine, not on deployment targets
  such as a Raspberry Pi.
