import { useExperienceStore } from '@/stores/experienceStore';
import type { ExperienceCardDTO, ExperienceDetailDTO, CreateExperienceDTO, UpdateExperienceDTO } from '@/domain/dtos';

export function useExperiences() {
  const experienceStore = useExperienceStore();

  const getAllExperiences = (): ExperienceCardDTO[] => {
    return experienceStore.getAllExperiences();
  };

  const getExperienceById = (id: string): ExperienceDetailDTO | null => {
    return experienceStore.getExperienceById(id);
  };

  const createExperience = (dto: CreateExperienceDTO): ExperienceDetailDTO => {
    return experienceStore.createExperience(dto);
  };

  const updateExperience = (dto: UpdateExperienceDTO): ExperienceDetailDTO | null => {
    return experienceStore.updateExperience(dto);
  };

  const deleteExperience = (id: string): boolean => {
    return experienceStore.deleteExperience(id);
  };

  return {
    getAllExperiences,
    getExperienceById,
    createExperience,
    updateExperience,
    deleteExperience,
  };
}
