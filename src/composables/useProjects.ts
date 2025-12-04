import { useProjectStore } from '@/stores/projectStore';
import type { ProjectCardDTO, ProjectDetailDTO, CreateProjectDTO, UpdateProjectDTO } from '@/domain/dtos';

export function useProjects() {
  const projectStore = useProjectStore();

  const getAllProjects = (): ProjectCardDTO[] => {
    return projectStore.getAllProjects();
  };

  const getProjectById = (id: string): ProjectDetailDTO | null => {
    return projectStore.getProjectById(id);
  };

  const createProject = (dto: CreateProjectDTO): ProjectDetailDTO => {
    return projectStore.createProject(dto);
  };

  const updateProject = (dto: UpdateProjectDTO): ProjectDetailDTO | null => {
    return projectStore.updateProject(dto);
  };

  const deleteProject = (id: string): boolean => {
    return projectStore.deleteProject(id);
  };

  return {
    getAllProjects,
    getProjectById,
    createProject,
    updateProject,
    deleteProject,
  };
}
