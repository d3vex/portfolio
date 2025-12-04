import type { Changelog } from './Changelog';

export interface Project {
  id: string;
  title: string;
  description: string;
  fullDescription: string; // Full readme content
  dateCreated: Date;
  stack: string[];
  pictureUrl?: string;
  projectUrl?: string;
  changelog: Changelog[];
  createdAt: Date;
  updatedAt: Date;
}
