// ---------------------------------------------------------------------------
// AI Module — shared types
// ---------------------------------------------------------------------------

export type Specialization = 'auto' | 'webdev' | 'appdev' | 'devops' | 'itsupport';
export type CvStyle = 'auto' | 'classic' | 'ats' | 'two-column-blue';
export type AboutLength = 'short' | 'medium' | 'long';
export type Tone = 'professional' | 'enthusiastic' | 'technical';

export interface GenerateCvOptions {
  specialization?: Specialization;
  style?: CvStyle;
  aboutLength?: AboutLength;
  maxExperiences?: number;
  maxProjects?: number;
  includeSoftSkills?: boolean;
  includeLanguages?: boolean;
  tone?: Tone;
  allowSkillSuggestions?: boolean;
  allowBulletSuggestions?: boolean;
  customInstructions?: string;
}

export interface SuggestedSkill {
  id: string;
  name: string;
  description: string;
  cvCategory: 'hard' | 'soft';
  categoryName: string;
  level: number;
  rationale: string;
}

export interface SuggestedBullet {
  id: string;
  entityType: 'project' | 'experience';
  entityId: string;
  text: string;
  skillIds: string[];
  rationale: string;
}

export interface GenerateCvResult {
  cv: {
    name: string;
    candidateName: string | null;
    specialization: string;
    titleOverride: string;
    aboutText: string;
    availability: string | null;
    style: string;
    pictureId: string | null;
    skillIds: string[];
    experienceIds: string[];
    projectIds: string[];
    cvProjectPointIds: string[];
    educationIds: string[];
    languageIds: string[];
    passionIds: string[];
  };
  suggestions: {
    skills: SuggestedSkill[];
    bullets: SuggestedBullet[];
  };
  justification: string;
}

export interface ApplySkillInput {
  name: string;
  description?: string;
  cvCategory: 'hard' | 'soft';
  categoryName: string;
  level: number;
  suggestionId?: string;
}

export interface ApplyBulletInput {
  entityType: 'project' | 'experience';
  entityId: string;
  text: string;
  skillIds: string[];
  suggestionId?: string;
}

export interface AppliedSkillResult {
  suggestionId: string | null;
  name: string;
  id: string;
  categoryId: string | null;
}

export interface AppliedBulletResult {
  suggestionId: string | null;
  entityType: string;
  entityId: string;
  pointId: string;
  order: number;
  index: number;
}

export interface OllamaStatus {
  available: boolean;
  model: string;
  baseUrl: string;
  models: string[];
  error: string | null;
}

export interface OllamaChatMessage {
  role: 'system' | 'user' | 'assistant';
  content: string;
}

// LLM emits projectBullets as an array of {projectId, indices} (Ollama-safe
// schema); the service converts it to Record<string, number[]> on the API.
export interface LlmProjectBullets {
  projectId: string;
  indices: number[];
}

// Two LLM calls (selection, then writing) keep each response small enough
// for slow CPU-only Ollama models.
export interface CvSelectionRaw {
  name: string;
  candidateName: string;
  specialization: string;
  style: string;
  pictureId: string;
  skillIds: string[];
  experienceIds: string[];
  projectIds: string[];
  projectBullets: LlmProjectBullets[];
  educationIds: string[];
  languageIds: string[];
  passionIds: string[];
}

export interface CvWritingRaw {
  titleOverride: string;
  aboutText: string;
  availability: string;
  suggestions: {
    skills: SuggestedSkill[];
    bullets: SuggestedBullet[];
  };
  justification: string;
}

/**
 * JSON Schema for phase 1 (id selection), handed to Ollama's `format` option
 * (grammar-constrained generation). Deliberately limited to the subset Ollama
 * supports: object / array / string / integer / enum / required. No nullable
 * unions and no additionalProperties.
 */
export const SELECTION_JSON_SCHEMA = {
  type: 'object',
  properties: {
    name: { type: 'string' },
    candidateName: { type: 'string' },
    specialization: { type: 'string' },
    style: { type: 'string', enum: ['classic', 'ats', 'two-column-blue'] },
    pictureId: { type: 'string' },
    skillIds: { type: 'array', items: { type: 'string' } },
    experienceIds: { type: 'array', items: { type: 'string' } },
    projectIds: { type: 'array', items: { type: 'string' } },
    projectBullets: {
      type: 'array',
      items: {
        type: 'object',
        properties: {
          projectId: { type: 'string' },
          indices: { type: 'array', items: { type: 'integer' } },
        },
        required: ['projectId', 'indices'],
      },
    },
    educationIds: { type: 'array', items: { type: 'string' } },
    languageIds: { type: 'array', items: { type: 'string' } },
    passionIds: { type: 'array', items: { type: 'string' } },
  },
  required: [
    'name',
    'candidateName',
    'specialization',
    'style',
    'pictureId',
    'skillIds',
    'experienceIds',
    'projectIds',
    'projectBullets',
    'educationIds',
    'languageIds',
    'passionIds',
  ],
} as const;

/**
 * JSON Schema for phase 2 (textual content), handed to Ollama's `format`
 * option. Same subset constraints as SELECTION_JSON_SCHEMA.
 */
export const WRITING_JSON_SCHEMA = {
  type: 'object',
  properties: {
    titleOverride: { type: 'string' },
    aboutText: { type: 'string' },
    availability: { type: 'string' },
    suggestions: {
      type: 'object',
      properties: {
        skills: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              id: { type: 'string' },
              name: { type: 'string' },
              description: { type: 'string' },
              cvCategory: { type: 'string', enum: ['hard', 'soft'] },
              categoryName: { type: 'string' },
              level: { type: 'integer', minimum: 1, maximum: 5 },
              rationale: { type: 'string' },
            },
            required: [
              'id',
              'name',
              'description',
              'cvCategory',
              'categoryName',
              'level',
              'rationale',
            ],
          },
        },
        bullets: {
          type: 'array',
          items: {
            type: 'object',
            properties: {
              id: { type: 'string' },
              entityType: { type: 'string', enum: ['project', 'experience'] },
              entityId: { type: 'string' },
              text: { type: 'string' },
              skillIds: { type: 'array', items: { type: 'string' } },
              rationale: { type: 'string' },
            },
            required: ['id', 'entityType', 'entityId', 'text', 'skillIds', 'rationale'],
          },
        },
      },
      required: ['skills', 'bullets'],
    },
    justification: { type: 'string' },
  },
  required: ['titleOverride', 'aboutText', 'availability', 'suggestions', 'justification'],
} as const;
