/**
 * MCP server factory — creates and configures the McpServer instance.
 */

import { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import type { Config } from "./config.js";
import { ApiClient } from "./client.js";
import { registerReadTools, registerCvTools, registerAiTools } from "./tools/index.js";

export interface McpServerInstance {
  server: McpServer;
  client: ApiClient;
}

export function createMcpServer(cfg: Config): McpServerInstance {
  const server = new McpServer({
    name: cfg.serverName,
    version: "1.0.0",
  });

  const client = new ApiClient(cfg);

  // Pre-login on startup so the first tool call is fast.
  client.ensureAuth().catch((err: unknown) => {
    process.stderr.write(
      `[cv-mcp] Warning: could not pre-login: ${err instanceof Error ? err.message : String(err)}\n`,
    );
  });

  // Register all tools
  registerReadTools(server, client);
  registerCvTools(server, client);
  registerAiTools(server, client);

  return { server, client };
}
