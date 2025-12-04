import type { Experience } from '../models/Experience';
import type { ExperienceCardDTO, ExperienceDetailDTO, CreateExperienceDTO } from '../dtos';
import { ChangelogPresenter } from './ChangelogPresenter';

export class ExperiencePresenter {
  static toCardDTO(experience: Experience): ExperienceCardDTO {
    return {
      id: experience.id,
      companyName: experience.companyName,
      role: experience.role,
      jobLabel: experience.jobLabel,
      description: experience.description,
      startDate: experience.startDate.toISOString(),
      endDate: experience.endDate?.toISOString(),
      pictureUrl: experience.pictureUrl,
    };
  }

  static toDetailDTO(experience: Experience): ExperienceDetailDTO {
    return {
      id: experience.id,
      companyName: experience.companyName,
      role: experience.role,
      jobLabel: experience.jobLabel,
      description: experience.description,
      fullDescription: experience.fullDescription,
      startDate: experience.startDate.toISOString(),
      endDate: experience.endDate?.toISOString(),
      pictureUrl: experience.pictureUrl,
      companyDetails: { ...experience.companyDetails },
      changelog: experience.changelog.map(ChangelogPresenter.toDTO),
    };
  }

  static fromCreateDTO(dto: CreateExperienceDTO, id: string): Experience {
    const now = new Date();
    return {
      id,
      companyName: dto.companyName,
      role: dto.role,
      jobLabel: dto.jobLabel,
      description: dto.description,
      fullDescription: dto.fullDescription,
      startDate: new Date(dto.startDate),
      endDate: dto.endDate ? new Date(dto.endDate) : undefined,
      pictureUrl: dto.pictureUrl,
      companyDetails: { ...dto.companyDetails },
      changelog: [],
      createdAt: now,
      updatedAt: now,
    };
  }
}
