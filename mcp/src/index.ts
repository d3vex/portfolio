#!/usr/bin/env node

/**
 * Entry point for the CV MCP server.
 * Selects transport based on environment:
 *   - CV_HTTP_PORT set → StreamableHTTP over Express
 *   - otherwise        → stdio
 */

import { StdioServerTransport } from "@modelcontextprotocol/sdk/server/stdio.js";
import { loadConfig } from "./config.js";
import { createMcpServer } from "./server.js";

async function main(): Promise<void> {
  const cfg = loadConfig();
  const { server } = createMcpServer(cfg);

  if (cfg.httpPort !== null) {
    // ── HTTP transport ─────────────────────────────────────────────
    const express = (await import("express")).default;
    const { StreamableHTTPServerTransport } = await import(
      "@modelcontextprotocol/sdk/server/streamableHttp.js"
    );

    const app = express();
    app.use(express.json());

    // CORS: allow all origins for MCP clients
    app.use((_req, res, next) => {
      res.header("Access-Control-Allow-Origin", "*");
      res.header("Access-Control-Allow-Methods", "GET, POST, DELETE, OPTIONS");
      res.header(
        "Access-Control-Allow-Headers",
        "Content-Type, Authorization, Mcp-Session-Id",
      );
      if (_req.method === "OPTIONS") {
        res.sendStatus(204);
        return;
      }
      next();
    });

    // Stateful: one transport per session, keyed by session ID
    const sessions = new Map<
      string,
      { transport: InstanceType<typeof StreamableHTTPServerTransport>; server: ReturnType<typeof createMcpServer> }
    >();

    app.all("/mcp", async (req, res) => {
      try {
        const sessionId = req.headers["mcp-session-id"] as string | undefined;

        if (req.method === "POST" && !sessionId) {
          // New session
          const transport = new StreamableHTTPServerTransport({
            sessionIdGenerator: () => crypto.randomUUID(),
          });

          const freshServer = createMcpServer(cfg);
          await freshServer.server.connect(transport);

          const newSessionId = (transport as unknown as { sessionId: string }).sessionId ?? crypto.randomUUID();
          sessions.set(newSessionId, { transport, server: freshServer });

          res.setHeader("Mcp-Session-Id", newSessionId);
          await transport.handleRequest(req, res);
          return;
        }

        if (sessionId) {
          const session = sessions.get(sessionId);
          if (!session) {
            res.status(404).json({ error: "Session not found" });
            return;
          }

          if (req.method === "DELETE") {
            await session.transport.close();
            sessions.delete(sessionId);
            res.sendStatus(204);
            return;
          }

          await session.transport.handleRequest(req, res);
          return;
        }

        res.status(400).json({ error: "Missing Mcp-Session-Id header" });
      } catch (err: unknown) {
        process.stderr.write(
          `[cv-mcp] HTTP error: ${err instanceof Error ? err.message : String(err)}\n`,
        );
        if (!res.headersSent) {
          res.status(500).json({ error: "Internal server error" });
        }
      }
    });

    app.listen(cfg.httpPort, () => {
      process.stderr.write(
        `[cv-mcp] HTTP transport listening on port ${cfg.httpPort} (endpoint: /mcp)\n`,
      );
    });
  } else {
    // ── Stdio transport ────────────────────────────────────────────
    const transport = new StdioServerTransport();
    await server.connect(transport);
    process.stderr.write("[cv-mcp] stdio transport ready\n");
  }
}

main().catch((err: unknown) => {
  process.stderr.write(
    `[cv-mcp] Fatal: ${err instanceof Error ? err.message : String(err)}\n`,
  );
  process.exit(1);
});
