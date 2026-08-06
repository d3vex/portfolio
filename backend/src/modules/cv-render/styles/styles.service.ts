import { Injectable } from '@nestjs/common';
import { existsSync, readFileSync } from 'fs';
import { join } from 'path';
import { CvStyleMetadata } from './styles.types';

export const DEFAULT_STYLE_ID = 'classic';

const STYLE_REGISTRY: CvStyleMetadata[] = [
  {
    id: 'classic',
    name: 'Classic',
    description: 'Dark sidebar, blue accent, single-page editorial layout (matches the in-app print preview).',
    accent: '#2563EB',
    sidebar: '#18181B',
  },
  {
    id: 'ats',
    name: 'ATS',
    description: 'Single-column, black on white, system fonts and machine-readable dates. Optimized for applicant tracking systems.',
    accent: '#111111',
    sidebar: '#FFFFFF',
  },
  {
    id: 'two-column-blue',
    name: 'Two-Column Blue',
    description: 'Light blue sidebar with white main column — a modern, airy two-column layout.',
    accent: '#2563EB',
    sidebar: '#EFF6FF',
  },
];

function resolveStyleAsset(styleId: string, file: string): string {
  const candidates = [
    // dist/ or src/ layout relative to the compiled/running module file
    join(__dirname, 'styles', styleId, file),
    // dev run from project root (ts-node-dev / ts-node)
    join(process.cwd(), 'src', 'modules', 'cv-render', 'styles', styleId, file),
    // production build (dist/) when assets were copied alongside
    join(process.cwd(), 'dist', 'modules', 'cv-render', 'styles', styleId, file),
  ];
  for (const candidate of candidates) {
    if (existsSync(candidate)) return candidate;
  }
  throw new Error(
    `CV render style asset not found: ${styleId}/${file} (tried: ${candidates.join(', ')})`,
  );
}

@Injectable()
export class StylesService {
  list(): CvStyleMetadata[] {
    return STYLE_REGISTRY;
  }

  get(id: string | undefined): CvStyleMetadata {
    return STYLE_REGISTRY.find((style) => style.id === id) ?? STYLE_REGISTRY[0];
  }

  getTemplate(styleId: string): string {
    return readFileSync(resolveStyleAsset(styleId, 'template.hbs'), 'utf8');
  }

  getCss(styleId: string): string {
    return readFileSync(resolveStyleAsset(styleId, 'style.css'), 'utf8');
  }
}
