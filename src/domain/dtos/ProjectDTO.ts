import type { ChangelogDTO } from './ChangelogDTO';

export interface ProjectCardDTO {
  id: string;
  title: string;
  description: string;
  dateCreated: string; // ISO string
  stack: string[];
  pictureUrl?: string;
  projectUrl?: string;
}

export interface ProjectDetailDTO {
  id: string;
  title: string;
  description: string;
  fullDescription: string;
  dateCreated: string;
  stack: string[];
  pictureUrl?: string;
  projectUrl?: string;
  changelog: ChangelogDTO[];
}

export interface CreateProjectDTO {
  title: string;
  description: string;
  fullDescription: string;
  dateCreated: string;
  stack: string[];
  pictureUrl?: string;
  projectUrl?: string;
}

export interface UpdateProjectDTO {
  id: string;
  title?: string;
  description?: string;
  fullDescription?: string;
  dateCreated?: string;
  stack?: string[];
  pictureUrl?: string;
  projectUrl?: string;
}
