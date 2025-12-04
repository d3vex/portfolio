import type { Project } from '../models/Project';
import type { ProjectCardDTO, ProjectDetailDTO, CreateProjectDTO } from '../dtos';
import { ChangelogPresenter } from './ChangelogPresenter';

export class ProjectPresenter {
  static toCardDTO(project: Project): ProjectCardDTO {
    return {
      id: project.id,
      title: project.title,
      description: project.description,
      dateCreated: project.dateCreated.toISOString(),
      stack: [...project.stack],
      pictureUrl: project.pictureUrl,
      projectUrl: project.projectUrl,
    };
  }

  static toDetailDTO(project: Project): ProjectDetailDTO {
    return {
      id: project.id,
      title: project.title,
      description: project.description,
      fullDescription: project.fullDescription,
      dateCreated: project.dateCreated.toISOString(),
      stack: [...project.stack],
      pictureUrl: project.pictureUrl,
      projectUrl: project.projectUrl,
      changelog: project.changelog.map(ChangelogPresenter.toDTO),
    };
  }

  static fromCreateDTO(dto: CreateProjectDTO, id: string): Project {
    const now = new Date();
    return {
      id,
      title: dto.title,
      description: dto.description,
      fullDescription: dto.fullDescription,
      dateCreated: new Date(dto.dateCreated),
      stack: [...dto.stack],
      pictureUrl: dto.pictureUrl,
      projectUrl: dto.projectUrl,
      changelog: [],
      createdAt: now,
      updatedAt: now,
    };
  }
}
