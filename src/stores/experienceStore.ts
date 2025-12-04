import { defineStore } from 'pinia';
import { ref } from 'vue';
import type { Experience } from '@/domain/models';
import type { ExperienceCardDTO, ExperienceDetailDTO, CreateExperienceDTO, UpdateExperienceDTO } from '@/domain/dtos';
import { ExperiencePresenter } from '@/domain/presenters';
import { mockExperiences } from './mockData/experiences';
import type { CreateChangelogDTO } from '@/domain/dtos';
import { ChangelogPresenter } from '@/domain/presenters';

export const useExperienceStore = defineStore('experiences', () => {
  const experiences = ref<Experience[]>([...mockExperiences]);

  const getAllExperiences = (): ExperienceCardDTO[] => {
    return experiences.value.map(ExperiencePresenter.toCardDTO);
  };

  const getExperienceById = (id: string): ExperienceDetailDTO | null => {
    const experience = experiences.value.find(e => e.id === id);
    return experience ? ExperiencePresenter.toDetailDTO(experience) : null;
  };

  const createExperience = (dto: CreateExperienceDTO): ExperienceDetailDTO => {
    const id = `${Date.now()}`;
    const experience = ExperiencePresenter.fromCreateDTO(dto, id);
    experiences.value.push(experience);
    return ExperiencePresenter.toDetailDTO(experience);
  };

  const updateExperience = (dto: UpdateExperienceDTO): ExperienceDetailDTO | null => {
    const index = experiences.value.findIndex(e => e.id === dto.id);
    if (index === -1) return null;

    const experience = experiences.value[index];
    if (dto.companyName) experience.companyName = dto.companyName;
    if (dto.role) experience.role = dto.role;
    if (dto.jobLabel) experience.jobLabel = dto.jobLabel;
    if (dto.description) experience.description = dto.description;
    if (dto.fullDescription) experience.fullDescription = dto.fullDescription;
    if (dto.startDate) experience.startDate = new Date(dto.startDate);
    if (dto.endDate !== undefined) experience.endDate = dto.endDate ? new Date(dto.endDate) : undefined;
    if (dto.pictureUrl !== undefined) experience.pictureUrl = dto.pictureUrl;
    if (dto.companyDetails) experience.companyDetails = { ...dto.companyDetails };
    experience.updatedAt = new Date();

    return ExperiencePresenter.toDetailDTO(experience);
  };

  const deleteExperience = (id: string): boolean => {
    const index = experiences.value.findIndex(e => e.id === id);
    if (index === -1) return false;
    experiences.value.splice(index, 1);
    return true;
  };

  const addChangelog = (experienceId: string, dto: CreateChangelogDTO): boolean => {
    const experience = experiences.value.find(e => e.id === experienceId);
    if (!experience) return false;

    const id = `${Date.now()}`;
    const changelog = ChangelogPresenter.fromCreateDTO(dto, id);
    experience.changelog.push(changelog);
    experience.updatedAt = new Date();
    return true;
  };

  const deleteChangelog = (experienceId: string, changelogId: string): boolean => {
    const experience = experiences.value.find(e => e.id === experienceId);
    if (!experience) return false;

    const index = experience.changelog.findIndex(c => c.id === changelogId);
    if (index === -1) return false;

    experience.changelog.splice(index, 1);
    experience.updatedAt = new Date();
    return true;
  };

  return {
    getAllExperiences,
    getExperienceById,
    createExperience,
    updateExperience,
    deleteExperience,
    addChangelog,
    deleteChangelog,
  };
});
