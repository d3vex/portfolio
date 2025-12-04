import type { Changelog } from './Changelog';

export interface CompanyDetails {
  name: string;
  description: string;
  industry: string;
  size?: string;
  website?: string;
  location?: string;
}

export interface Experience {
  id: string;
  companyName: string;
  role: string;
  jobLabel: string;
  description: string;
  fullDescription: string; // Detailed experience description
  startDate: Date;
  endDate?: Date; // undefined means current
  pictureUrl?: string;
  companyDetails: CompanyDetails;
  changelog: Changelog[];
  createdAt: Date;
  updatedAt: Date;
}
