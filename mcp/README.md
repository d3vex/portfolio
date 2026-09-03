# cv-mcp-server

MCP (Model Context Protocol) server wrapping the CV Portfolio NestJS REST API.
Lets any MCP-compatible agent (Claude Code, OpenCode, Cursor, etc.) manage the
CV portfolio — read data, generate tailored CVs with AI, and write changes back.

## Prerequisites

1. **Docker Compose** running Ollama (for AI features):
   ```bash
   cd ../backend && docker compose up -d ollama
   ```
2. **Backend API** running at `http://localhost:3001`:
   ```bash
   cd ../backend && npm run dev
   ```
3. **AI agent user** registered in the database with the `ai` role. The
   `CV_PASSWORD` env var must match this user's password.

## Install & Build

```bash
cd mcp
npm install
npm run build          # produces dist/
```

## Environment Variables

| Variable | Required | Default | Description |
|---|---|---|---|
| `CV_API_BASE_URL` | No | `http://localhost:3001/api` | Backend API base URL |
| `CV_USERNAME` | No | `ai-agent` | Username for JWT authentication |
| `CV_PASSWORD` | **Yes** | — | Password for the ai-agent user |
| `CV_SERVER_NAME` | No | `cv-mcp-server` | MCP server name shown to clients |
| `CV_HTTP_PORT` | No | — (stdio) | Set to a port number to enable HTTP transport |

## Configuration Examples

### Claude Code (`.mcp.json`)

Add to your project's `.mcp.json` or `~/.claude/mcp.json`:

```json
{
  "mcpServers": {
    "cv": {
      "command": "node",
      "args": ["/absolute/path/to/portfolio/mcp/dist/index.js"],
      "env": {
        "CV_PASSWORD": "your-ai-agent-password"
      }
    }
  }
}
```

### OpenCode

Add to your `opencode.json` under `mcpServers`:

```json
{
  "mcpServers": {
    "cv": {
      "command": "node",
      "args": ["/absolute/path/to/portfolio/mcp/dist/index.js"],
      "env": {
        "CV_PASSWORD": "your-ai-agent-password"
      }
    }
  }
}
```

### Generic MCP Client (HTTP mode)

If you set `CV_HTTP_PORT=3002`, the server exposes a Streamable HTTP endpoint:

```bash
CV_PASSWORD=xxx CV_HTTP_PORT=3002 node dist/index.js
```

Then point your MCP client at `http://localhost:3002/mcp`.

## Available Tools

### Read (GET — no auth required by backend, but MCP authenticates anyway)

| Tool | Description |
|---|---|
| `get_profile` | Get all profile entries |
| `get_contacts` | Get all contact entries |
| `get_skills` | Get all skills |
| `get_languages` | Get all languages |
| `get_passions` | Get all passions/hobbies |
| `get_experiences` | Get all work experiences |
| `get_projects` | Get all projects |
| `get_education` | Get all education entries |
| `get_categories` | Get all skill/experience categories |
| `list_cvs` | List all CV configurations |
| `get_cv` | Get a single CV by UUID |
| `get_ai_status` | Check AI service status (Ollama, model info) |

### AI

| Tool | Description |
|---|---|
| `generate_cv` | Generate a tailored CV from a job description using AI |
| `apply_suggestions` | Apply AI-generated skill and bullet suggestions |

### Write (POST/PATCH/DELETE — require auth)

| Tool | Description |
|---|---|
| `create_cv` | Create a new CV configuration |
| `update_cv` | Update an existing CV (partial patch) |
| `delete_cv` | Delete a CV by UUID |

## Security Note

The `ai-agent` role can only **DELETE** CVs it created (where `aiGenerated=true`).
Attempting to delete a CV created by a human user will return a 403 Forbidden from
the backend. This is enforced server-side.

## Transport

- **Default (stdio):** The server communicates over stdin/stdout. All logging goes
  to stderr. This is the standard transport for Claude Code, Cursor, and most MCP
  clients.
- **HTTP:** Set `CV_HTTP_PORT` to run an Express server with Streamable HTTP
  transport. The MCP endpoint is at `/mcp`. CORS is enabled for all origins.

## Authentication Flow

On startup the server logs in via `POST /api/auth/login` and stores the JWT token.
All subsequent API requests include `Authorization: Bearer <token>`. If a 401 is
received, the server automatically re-authenticates and retries the request once.
