/**
 * Environment configuration for the CV MCP server.
 * All env parsing happens here; other modules import `config`.
 */

export interface Config {
  /** Base URL of the NestJS REST API (no trailing slash) */
  baseUrl: string;
  /** Username for JWT authentication */
  username: string;
  /** Password for JWT authentication */
  password: string;
  /** MCP server name shown to clients */
  serverName: string;
  /** If set, run HTTP transport on this port; otherwise use stdio */
  httpPort: number | null;
}

function requireEnv(name: string): string {
  const val = process.env[name];
  if (!val) {
    throw new Error(
      `Missing required environment variable: ${name}. See .env.example.`,
    );
  }
  return val;
}

function optionalEnv(name: string, fallback: string): string {
  return process.env[name] ?? fallback;
}

export function loadConfig(): Config {
  return {
    baseUrl: optionalEnv("CV_API_BASE_URL", "http://localhost:3001/api").replace(/\/+$/, ""),
    username: optionalEnv("CV_USERNAME", "ai-agent"),
    password: requireEnv("CV_PASSWORD"),
    serverName: optionalEnv("CV_SERVER_NAME", "cv-mcp-server"),
    httpPort: process.env["CV_HTTP_PORT"]
      ? Number(process.env["CV_HTTP_PORT"])
      : null,
  };
}
