import type { Changelog } from '../models/Changelog';
import type { ChangelogDTO, CreateChangelogDTO } from '../dtos';

export class ChangelogPresenter {
  static toDTO(changelog: Changelog): ChangelogDTO {
    return {
      id: changelog.id,
      date: changelog.date.toISOString(),
      title: changelog.title,
      description: changelog.description,
      type: changelog.type,
    };
  }

  static toDomain(dto: ChangelogDTO): Changelog {
    return {
      id: dto.id,
      date: new Date(dto.date),
      title: dto.title,
      description: dto.description,
      type: dto.type,
    };
  }

  static fromCreateDTO(dto: CreateChangelogDTO, id: string): Changelog {
    return {
      id,
      date: new Date(dto.date),
      title: dto.title,
      description: dto.description,
      type: dto.type,
    };
  }
}
