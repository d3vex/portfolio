import type { ChangelogDTO } from './ChangelogDTO';

export interface CompanyDetailsDTO {
  name: string;
  description: string;
  industry: string;
  size?: string;
  website?: string;
  location?: string;
}

export interface ExperienceCardDTO {
  id: string;
  companyName: string;
  role: string;
  jobLabel: string;
  description: string;
  startDate: string; // ISO string
  endDate?: string; // ISO string or undefined
  pictureUrl?: string;
}

export interface ExperienceDetailDTO {
  id: string;
  companyName: string;
  role: string;
  jobLabel: string;
  description: string;
  fullDescription: string;
  startDate: string;
  endDate?: string;
  pictureUrl?: string;
  companyDetails: CompanyDetailsDTO;
  changelog: ChangelogDTO[];
}

export interface CreateExperienceDTO {
  companyName: string;
  role: string;
  jobLabel: string;
  description: string;
  fullDescription: string;
  startDate: string;
  endDate?: string;
  pictureUrl?: string;
  companyDetails: CompanyDetailsDTO;
}

export interface UpdateExperienceDTO {
  id: string;
  companyName?: string;
  role?: string;
  jobLabel?: string;
  description?: string;
  fullDescription?: string;
  startDate?: string;
  endDate?: string;
  pictureUrl?: string;
  companyDetails?: CompanyDetailsDTO;
}
