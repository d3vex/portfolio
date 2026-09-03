/**
 * AI tool registrations: generate_cv, apply_suggestions.
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

/** Register AI tools on the MCP server. */
export function registerAiTools(server: McpServer, api: ApiClient): void {
  // ── generate_cv ────────────────────────────────────────────────────

  server.registerTool(
    "generate_cv",
    {
      description:
        "Generate a tailored CV from a job description using AI. Returns the generated CV with suggested skills, bullets, and configuration.",
      inputSchema: {
        jobDescription: z
          .string()
          .min(1)
          .describe("The full job description text to tailor the CV for"),
        options: z
          .object({
            specialization: z
              .string()
              .optional()
              .describe("Target specialization (e.g. 'Frontend Developer')"),
            style: z
              .string()
              .optional()
              .describe("Visual style ID for the generated CV"),
            aboutLength: z
              .number()
              .int()
              .positive()
              .optional()
              .describe("Target word count for the about section"),
            maxExperiences: z
              .number()
              .int()
              .positive()
              .optional()
              .describe("Maximum number of experiences to include"),
            maxProjects: z
              .number()
              .int()
              .positive()
              .optional()
              .describe("Maximum number of projects to include"),
            includeSoftSkills: z
              .boolean()
              .optional()
              .describe("Whether to suggest soft skills"),
            includeLanguages: z
              .boolean()
              .optional()
              .describe("Whether to include languages"),
            tone: z
              .string()
              .optional()
              .describe("Writing tone (e.g. 'professional', 'casual')"),
            allowSkillSuggestions: z
              .boolean()
              .optional()
              .describe("Allow AI to suggest new skills"),
            allowBulletSuggestions: z
              .boolean()
              .optional()
              .describe("Allow AI to suggest new bullet points"),
            customInstructions: z
              .string()
              .optional()
              .describe("Additional freeform instructions for the AI"),
          })
          .optional()
          .describe("Optional generation parameters"),
      },
    },
    async (args) => {
      const res = await api.request("POST", "/ai/generate-cv", args);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );

  // ── apply_suggestions ──────────────────────────────────────────────

  server.registerTool(
    "apply_suggestions",
    {
      description:
        "Apply AI-generated skill and bullet suggestions to the portfolio. Creates new skills and adds bullet points to experiences/projects.",
      inputSchema: {
        skills: z
          .array(
            z.object({
              name: z.string().describe("Skill name"),
              description: z
                .string()
                .optional()
                .describe("Brief description of the skill"),
              cvCategory: z
                .string()
                .describe("Category type: 'technical', 'soft', 'language', or 'other'"),
              categoryName: z
                .string()
                .describe(
                  "Name of the category to assign (must exist in the portfolio)",
                ),
              level: z
                .string()
                .describe(
                  "Proficiency level: 'beginner', 'intermediate', 'advanced', or 'expert'",
                ),
              suggestionId: z
                .string()
                .optional()
                .describe("ID of the suggestion this was generated from"),
            }),
          )
          .optional()
          .describe("Skills to add to the portfolio"),
        bullets: z
          .array(
            z.object({
              entityType: z
                .enum(["project", "experience"])
                .describe("Whether this bullet belongs to a project or experience"),
              entityId: z
                .string()
                .uuid()
                .describe("UUID of the project or experience"),
              text: z
                .string()
                .describe("The bullet point text"),
              skillIds: z
                .array(z.string().uuid())
                .describe("UUIDs of skills this bullet relates to"),
              suggestionId: z
                .string()
                .optional()
                .describe("ID of the suggestion this was generated from"),
            }),
          )
          .optional()
          .describe("Bullet points to add to projects or experiences"),
      },
    },
    async (args) => {
      const res = await api.request("POST", "/ai/apply-suggestions", args);
      if (res.status >= 400) return formatError(res.status, res.data);
      return formatResult(res.data);
    },
  );
}
