# MCP.md

MCP servers for this development machine are configured globally for the coding
agent. They are not project-local dependencies and should not be vendored into
new repositories.

## codebase-memory-mcp

On this Windows machine, `codebase-memory-mcp` is installed globally in the
standard installer location at:

```text
C:\Users\BossG\AppData\Local\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

Equivalent environment-based path:

```text
%LOCALAPPDATA%\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

Known version: `0.8.1`.

The binary is a standalone executable, approximately 270 MB.

Claude Code launches it from the user-scoped registration in:

```text
C:\Users\BossG\.claude.json
```

The relevant registration is the top-level `mcpServers` block. That registration
is user-scoped and applies across projects.

## Setup For Another Windows User

Do this once per development machine, not once per project.

1. Install `codebase-memory-mcp` globally from the approved upstream installer or
   release source so the binary is available at:

```text
%LOCALAPPDATA%\Programs\codebase-memory-mcp\codebase-memory-mcp.exe
```

2. Verify the binary exists:

```powershell
Test-Path "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe"
```

3. Verify the binary runs:

```powershell
& "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" --version
```

4. Register the MCP server with Claude Code:

```powershell
& "$env:LOCALAPPDATA\Programs\codebase-memory-mcp\codebase-memory-mcp.exe" install -y
```

This should write the server registration to the top-level `mcpServers` block in
the user's Claude config file.

5. Restart Claude Code so it launches the server with the new registration.

Do not commit the user's `C:\Users\<User>\.claude.json` file. It is user-scoped
machine configuration.

## How Projects Should Use It

Projects should describe the expected capability, not the installation mechanics.
For example, in a project-specific `AGENTS.md`:

```text
Global MCP: codebase-memory-mcp may be available for codebase memory/search.
If unavailable, read the repo files directly and continue.
```

Agents should treat MCP memory as helpful context, not as the source of truth.
Committed files, specs, tests, and the current working tree win.

Suggested session prompt:

```text
Read AI-GUIDE.md first. Use codebase-memory-mcp for repo memory/search when
helpful. If MCP is unavailable, read the repository files directly and continue.
Committed files and the current working tree are authoritative.
```

## Project Guidance

- Do not copy the MCP binary into a project repo.
- Do not copy global Claude/Codex registration files into a project repo.
- If a project benefits from this server, document the expected capability in
  `AGENTS.md` or `CLAUDE.md`.
- Keep project-local fallback steps available because global MCP availability is
  a development-machine feature, not part of deployment.
- This tool runs on the Windows development machine, not on deployment targets
  such as a Raspberry Pi.
