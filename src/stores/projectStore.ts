import { defineStore } from 'pinia';
import { ref } from 'vue';
import type { Project } from '@/domain/models';
import type { ProjectCardDTO, ProjectDetailDTO, CreateProjectDTO, UpdateProjectDTO } from '@/domain/dtos';
import { ProjectPresenter } from '@/domain/presenters';
import { mockProjects } from './mockData/projects';
import type { CreateChangelogDTO } from '@/domain/dtos';
import { ChangelogPresenter } from '@/domain/presenters';

export const useProjectStore = defineStore('projects', () => {
  const projects = ref<Project[]>([...mockProjects]);

  const getAllProjects = (): ProjectCardDTO[] => {
    return projects.value.map(ProjectPresenter.toCardDTO);
  };

  const getProjectById = (id: string): ProjectDetailDTO | null => {
    const project = projects.value.find(p => p.id === id);
    return project ? ProjectPresenter.toDetailDTO(project) : null;
  };

  const createProject = (dto: CreateProjectDTO): ProjectDetailDTO => {
    const id = `${Date.now()}`;
    const project = ProjectPresenter.fromCreateDTO(dto, id);
    projects.value.push(project);
    return ProjectPresenter.toDetailDTO(project);
  };

  const updateProject = (dto: UpdateProjectDTO): ProjectDetailDTO | null => {
    const index = projects.value.findIndex(p => p.id === dto.id);
    if (index === -1) return null;

    const project = projects.value[index];
    if (dto.title) project.title = dto.title;
    if (dto.description) project.description = dto.description;
    if (dto.fullDescription) project.fullDescription = dto.fullDescription;
    if (dto.dateCreated) project.dateCreated = new Date(dto.dateCreated);
    if (dto.stack) project.stack = [...dto.stack];
    if (dto.pictureUrl !== undefined) project.pictureUrl = dto.pictureUrl;
    if (dto.projectUrl !== undefined) project.projectUrl = dto.projectUrl;
    project.updatedAt = new Date();

    return ProjectPresenter.toDetailDTO(project);
  };

  const deleteProject = (id: string): boolean => {
    const index = projects.value.findIndex(p => p.id === id);
    if (index === -1) return false;
    projects.value.splice(index, 1);
    return true;
  };

  const addChangelog = (projectId: string, dto: CreateChangelogDTO): boolean => {
    const project = projects.value.find(p => p.id === projectId);
    if (!project) return false;

    const id = `${Date.now()}`;
    const changelog = ChangelogPresenter.fromCreateDTO(dto, id);
    project.changelog.push(changelog);
    project.updatedAt = new Date();
    return true;
  };

  const deleteChangelog = (projectId: string, changelogId: string): boolean => {
    const project = projects.value.find(p => p.id === projectId);
    if (!project) return false;

    const index = project.changelog.findIndex(c => c.id === changelogId);
    if (index === -1) return false;

    project.changelog.splice(index, 1);
    project.updatedAt = new Date();
    return true;
  };

  return {
    getAllProjects,
    getProjectById,
    createProject,
    updateProject,
    deleteProject,
    addChangelog,
    deleteChangelog,
  };
});
