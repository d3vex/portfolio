/**
 * CV write tool registrations: create, update, delete.
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

/** Register CV write tools (create, update, delete). */
export function registerCvTools(server: McpServer, api: ApiClient): void {
  // ── create_cv ──────────────────────────────────────────────────────

  server.registerTool(
    "create_cv",
    {
      description:
        "Create a new CV configuration. Provide a name and optional arrays of entity IDs to include.",
      inputSchema: {
        name: z.string().describe("Display name for this CV"),
        candidateName: z.string().optional().describe("Candidate full name"),
        specialization: z
          .string()
          .optional()
          .describe("Job specialization (e.g. 'Frontend Developer')"),
        titleOverride: z
          .string()
          .optional()
          .describe("Override the displayed job title"),
        aboutText: z
          .string()
          .optional()
          .describe("Custom about/summary text for this CV"),
        skillIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of skills to include"),
        languageIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of languages to include"),
        passionIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of passions to include"),
        experienceIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of experiences to include"),
        projectIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of projects to include"),
        educationIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of education entries to include"),
        contactIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of contacts to include"),
        projectBullets: z
          .record(z.string(), z.array(z.number().int()))
          .optional()
          .describe(
            "Map of projectId → selected bullet indices for that project",
          ),
        pictureId: z
          .string()
          .optional()
          .describe("UUID of the profile picture image"),
        availability: z
          .string()
          .optional()
          .describe("Availability info (e.g. 'Immediately')"),
        isDefault: z
          .boolean()
          .optional()
          .describe("Whether this is the default CV"),
        style: z
          .string()
          .optional()
          .describe("Visual style identifier for rendering"),
      },
    },
    async (args) => {
      const res = await api.request("POST", "/cv", args);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );

  // ── update_cv ──────────────────────────────────────────────────────

  server.registerTool(
    "update_cv",
    {
      description:
        "Update an existing CV configuration. Only provided fields are changed (partial update).",
      inputSchema: {
        id: z.string().uuid().describe("UUID of the CV to update"),
        name: z.string().optional().describe("Display name"),
        candidateName: z.string().optional().describe("Candidate full name"),
        specialization: z.string().optional().describe("Job specialization"),
        titleOverride: z.string().optional().describe("Override job title"),
        aboutText: z.string().optional().describe("Custom about/summary text"),
        skillIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of skills to include"),
        languageIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of languages to include"),
        passionIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of passions to include"),
        experienceIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of experiences to include"),
        projectIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of projects to include"),
        educationIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of education entries to include"),
        contactIds: z
          .array(z.string().uuid())
          .optional()
          .describe("UUIDs of contacts to include"),
        projectBullets: z
          .record(z.string(), z.array(z.number().int()))
          .optional()
          .describe("Map of projectId → selected bullet indices"),
        pictureId: z.string().optional().describe("Profile picture image UUID"),
        availability: z.string().optional().describe("Availability info"),
        isDefault: z.boolean().optional().describe("Default CV flag"),
        style: z.string().optional().describe("Visual style identifier"),
      },
    },
    async ({ id, ...patch }) => {
      const res = await api.request("PATCH", `/cv/${id}`, patch);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );

  // ── delete_cv ──────────────────────────────────────────────────────

  server.registerTool(
    "delete_cv",
    {
      description:
        "Delete a CV by ID. Note: the ai-agent role can only delete CVs it created (aiGenerated=true).",
      inputSchema: {
        id: z.string().uuid().describe("UUID of the CV to delete"),
      },
    },
    async ({ id }) => {
      const res = await api.request("DELETE", `/cv/${id}`);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );
}
