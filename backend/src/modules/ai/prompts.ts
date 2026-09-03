import { GenerateCvOptions } from './types';

const TONE_MAP: Record<GenerateCvOptions['tone'], string> = {
  professional: 'professional, precise, and result-oriented',
  enthusiastic: 'enthusiastic, energetic, and engaging',
  technical: 'technical, dense, and detail-oriented',
};

const SPECIALIZATION_MAP: Record<NonNullable<GenerateCvOptions['specialization']>, string> = {
  auto: '',
  webdev: 'Web Development',
  appdev: 'Mobile / App Development',
  devops: 'DevOps & Infrastructure',
  itsupport: 'IT Support & Operations',
};

const ABOUT_LENGTH_HINT: Record<GenerateCvOptions['aboutLength'], string> = {
  short: 'around 2-3 sentences',
  medium: 'around 3-5 sentences',
  long: 'around 5-7 sentences',
};

const STYLE_HINT: Record<GenerateCvOptions['style'], string> = {
  auto: 'choose the one that best fits the offer and the candidate profile',
  classic: 'use "classic"',
  ats: 'use "ats"',
  'two-column-blue': 'use "two-column-blue"',
};

export function buildSelectionSystemPrompt(options: GenerateCvOptions): string {
  const styleHint = STYLE_HINT[options.style ?? 'auto'];
  const specialization = options.specialization && options.specialization !== 'auto'
    ? SPECIALIZATION_MAP[options.specialization]
    : null;

  return [
    'You are an expert CV writer and recruitment specialist. You tailor a candidate\'s portfolio data to a specific job offer and return ONE JSON object. You write in the language of the job offer (or French if the offer is ambiguous).',
    '',
    '# Task (phase 1: selection)',
    '1. Read the CANDIDATE PROFILE DATA section below (it is complete: never invent data that is not present, never search anywhere else).',
    specialization
      ? `2. Focus the CV on the specialization: ${specialization}.`
      : '2. Focus the CV on what the offer requires most.',
    `3. Select the most relevant skills, experiences, projects, education, languages and passions for the offer and order them by relevance (best first). Select at most 12 skills, at most ${options.maxExperiences ?? 5} experiences and at most ${options.maxProjects ?? 5} projects.${options.includeLanguages === false ? ' Do NOT include languages.' : ''}`,
    '4. For each selected project, keep only its 1-2 points MOST relevant to the offer in projectBullets. NEVER keep every point of a project: always drop the least relevant ones.',
    '5. Choose ONE profile picture for the CV header: pick the pictureId from the AVAILABLE IMAGES section that best represents the candidate (prefer a real photo - image/jpeg - over a diagram).',
    '',
    '# JSON output rules (STRICT)',
    '- Output raw JSON only. No markdown, no code fences, no commentary, no trailing commas.',
    '- Refer to entities ONLY by their exact ids from the profile data. Never fabricate ids.',
    '- Include ONLY the items you actually select: never list every skill, project or experience from the data.',
    '- projectBullets is an ARRAY of objects: [{"projectId": "...", "indices": [0, 2]}] where indices are the 0-based point indices printed in each project\'s data. Keep at most 2 indices per project, and never all of them.',
    '- pictureId MUST be one of the exact ids listed in the AVAILABLE IMAGES section (or "" if no image fits).',
    '- skillIds / experienceIds / projectIds / educationIds / languageIds / passionIds: array order defines display order (best first).',
    `- style: ${styleHint}.`,
    '',
    '# CANDIDATE PROFILE DATA (complete: use ONLY these ids and point indices)',
  ].join('\n');
}

export function buildSelectionUserPrompt(jobDescription: string): string {
  return [
    '# Job offer to tailor the CV for',
    jobDescription,
    '',
    'Produce the selection JSON now (entity ids only), using only the CANDIDATE PROFILE DATA provided in your instructions.',
  ].join('\n');
}

export function buildWritingSystemPrompt(options: GenerateCvOptions): string {
  const tone = TONE_MAP[options.tone ?? 'professional'];
  const aboutHint = ABOUT_LENGTH_HINT[options.aboutLength ?? 'medium'];

  const parts: string[] = [
    'You are an expert CV writer and recruitment specialist. You tailor a candidate\'s portfolio data to a specific job offer and return ONE JSON object. You write in the language of the job offer (or French if the offer is ambiguous).',
    '',
    '# Task (phase 2: writing)',
    '1. The SELECTION SUMMARY below lists the entities already chosen for the CV. The SELECTED ENTITIES DATA below contains their full details. Write only the textual parts; never change the selection.',
    `2. Rewrite the aboutText to match the offer (${aboutHint}) with a tone that is ${tone}.`,
    options.allowSkillSuggestions === false
      ? '3. Do NOT suggest new skills.'
      : `3. Suggest new skills that strengthen the application (${options.includeSoftSkills === false ? 'hard only' : 'hard and soft'}).`,
    options.allowBulletSuggestions === false
      ? '4. Do NOT suggest new points.'
      : '4. Suggest new points (bullets) that strengthen the application, grounded in the selected projects and experiences.',
  ];

  if (options.customInstructions) {
    parts.push(`5. Additional instructions: ${options.customInstructions}`);
  }

  parts.push(
    '',
    '# JSON output rules (STRICT)',
    '- Output raw JSON only. No markdown, no code fences, no commentary, no trailing commas.',
    '- Use "" (empty string) for optional text fields that have no value (never null).',
    '- Suggested skills: only genuinely relevant to the offer; level 1-5; categoryName is an existing category from the data if one fits, otherwise a short sensible name; max 10.',
    '- Suggested bullets: rewrite or create points matching the offer (quantify when the data allows); skillIds may only reference EXISTING skill ids from the SELECTION SUMMARY or SELECTED ENTITIES DATA, max 3 per bullet; text max 160 characters; max 10 bullets.',
    '- justification: one paragraph explaining the strategic choices.',
    '',
  );

  return parts.join('\n');
}

export function buildWritingUserPrompt(jobDescription: string): string {
  return [
    '# Job offer to tailor the CV for',
    jobDescription,
    '',
    'Produce the writing JSON now (textual parts only), using the SELECTION SUMMARY and SELECTED ENTITIES DATA provided in your instructions.',
  ].join('\n');
}
