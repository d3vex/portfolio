/**
 * Read-only tool registrations for the CV MCP server.
 * All these tools perform GET requests against public backend endpoints.
 */

import { z } from "zod";
import type { McpServer } from "@modelcontextprotocol/sdk/server/mcp.js";
import type { ApiClient } from "../client.js";

function formatResult(data: unknown) {
  return {
    content: [{ type: "text" as const, text: JSON.stringify(data, null, 2) }],
  };
}

function formatError(status: number, data: unknown) {
  const message =
    typeof data === "object" && data !== null && "message" in data
      ? String((data as { message: unknown }).message)
      : JSON.stringify(data);
  return {
    isError: true as const,
    content: [{ type: "text" as const, text: `Error ${status}: ${message}` }],
  };
}

/** Register all read-only GET tools on the MCP server. */
export function registerReadTools(server: McpServer, api: ApiClient): void {
  // ── Resource GET tools ─────────────────────────────────────────────

  const resourceTools: Array<{
    name: string;
    path: string;
    description: string;
  }> = [
    {
      name: "get_profile",
      path: "/profile",
      description: "Get all profile entries from the CV portfolio.",
    },
    {
      name: "get_contacts",
      path: "/contact",
      description: "Get all contact entries from the CV portfolio.",
    },
    {
      name: "get_skills",
      path: "/skills",
      description: "Get all skills from the CV portfolio.",
    },
    {
      name: "get_languages",
      path: "/languages",
      description: "Get all languages from the CV portfolio.",
    },
    {
      name: "get_passions",
      path: "/passions",
      description: "Get all passions/hobbies from the CV portfolio.",
    },
    {
      name: "get_experiences",
      path: "/experiences",
      description: "Get all work experiences from the CV portfolio.",
    },
    {
      name: "get_projects",
      path: "/projects",
      description: "Get all projects from the CV portfolio.",
    },
    {
      name: "get_education",
      path: "/education",
      description: "Get all education entries from the CV portfolio.",
    },
    {
      name: "get_categories",
      path: "/categories",
      description: "Get all skill/experience categories from the CV portfolio.",
    },
  ];

  for (const tool of resourceTools) {
    server.registerTool(
      tool.name,
      {
        description: tool.description,
        inputSchema: {},
      },
      async () => {
        const res = await api.request("GET", tool.path);
        if (res.status >= 400) return formatError(res.status, res.data);
        return formatResult(res.data);
      },
    );
  }

  // ── CV tools ───────────────────────────────────────────────────────

  server.registerTool(
    "list_cvs",
    {
      description: "List all CV configurations in the portfolio.",
      inputSchema: {},
    },
    async () => {
      const res = await api.request("GET", "/cv");
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );

  server.registerTool(
    "get_cv",
    {
      description: "Get a single CV configuration by its ID.",
      inputSchema: {
        id: z.string().uuid().describe("The UUID of the CV to retrieve"),
      },
    },
    async ({ id }) => {
      const res = await api.request("GET", `/cv/${id}`);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );

  // ── AI status ──────────────────────────────────────────────────────

  server.registerTool(
    "get_ai_status",
    {
      description:
        "Check the status of the AI generation service (Ollama availability, model info).",
      inputSchema: {},
    },
    async () => {
      const res = await api.request("GET", "/ai/status");
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );
}
