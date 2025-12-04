<template>
  <div class="projects-page">
    <div class="page-header">
      <h1 class="page-title">Projects</h1>
      <p class="page-subtitle">Explore my recent work and side projects</p>
    </div>
    
    <div v-if="projects.length > 0" class="projects-grid">
      <ProjectCard
        v-for="project in projects"
        :key="project.id"
        :project="project"
        @click="navigateToProject"
      />
    </div>
    
    <div v-else class="empty-state">
      <p>No projects available yet.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useProjects } from '@/composables/useProjects';
import ProjectCard from '@/components/ProjectCard.vue';
import type { ProjectCardDTO } from '@/domain/dtos';

const router = useRouter();
const { getAllProjects } = useProjects();

const projects = ref<ProjectCardDTO[]>([]);

onMounted(() => {
  projects.value = getAllProjects();
});

const navigateToProject = (id: string) => {
  router.push(`/projects/${id}`);
};
</script>

<style scoped>
.projects-page {
  max-width: 1400px;
  margin: 0 auto;
  padding: 4rem 2rem;
}

.page-header {
  text-align: center;
  margin-bottom: 4rem;
  animation: fadeInDown 0.8s ease-out;
}

.page-title {
  font-size: clamp(2.5rem, 5vw, 4rem);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 1rem;
  background: linear-gradient(135deg, var(--primary) 0%, var(--primary-dark) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  font-size: clamp(1rem, 2vw, 1.25rem);
  color: var(--text-secondary);
  margin: 0;
}

.projects-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(350px, 1fr));
  gap: 2rem;
  animation: fadeIn 1s ease-out;
}

.empty-state {
  text-align: center;
  padding: 4rem 2rem;
  color: var(--text-tertiary);
  font-size: 1.25rem;
}

@keyframes fadeInDown {
  from {
    opacity: 0;
    transform: translateY(-20px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes fadeIn {
  from {
    opacity: 0;
  }
  to {
    opacity: 1;
  }
}
</style>
