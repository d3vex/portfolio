<template>
  <div v-if="project" class="project-detail-page">
    <div class="page-header">
      <GlassButton variant="secondary" @click="goBack" size="small">← Back</GlassButton>
      <div class="header-content">
        <h1 class="project-title">{{ project.title }}</h1>
        <div class="project-meta">
          <span class="date">{{ formatDate(project.dateCreated) }}</span>
          <a v-if="project.projectUrl" :href="project.projectUrl" target="_blank" class="project-link">
            Visit Project →
          </a>
        </div>
      </div>
    </div>

    <GlassCard>
      <div v-if="project.pictureUrl" class="project-image">
        <img :src="project.pictureUrl" :alt="project.title" />
      </div>
      
      <div class="project-info">
        <div class="stack-section">
          <h3>Tech Stack</h3>
          <div class="stack">
            <span v-for="tech in project.stack" :key="tech" class="tech-badge">{{ tech }}</span>
          </div>
        </div>
        
        <div class="description-section">
          <h3>Description</h3>
          <p class="short-description">{{ project.description }}</p>
        </div>
      </div>
    </GlassCard>

    <GlassCard class="readme-section">
      <div class="markdown-content" v-html="renderMarkdown(project.fullDescription)"></div>
    </GlassCard>

    <GlassCard v-if="project.changelog.length > 0">
      <ChangelogTimeline :items="project.changelog" title="Project History" />
    </GlassCard>
  </div>
  
  <div v-else class="not-found">
    <GlassCard>
      <h2>Project not found</h2>
      <GlassButton @click="goBack">Go Back</GlassButton>
    </GlassCard>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useProjects } from '@/composables/useProjects';
import GlassCard from '@/components/GlassCard.vue';
import GlassButton from '@/components/GlassButton.vue';
import ChangelogTimeline from '@/components/ChangelogTimeline.vue';
import type { ProjectDetailDTO } from '@/domain/dtos';

const route = useRoute();
const router = useRouter();
const { getProjectById } = useProjects();

const project = ref<ProjectDetailDTO | null>(null);

onMounted(() => {
  const id = route.params.id as string;
  project.value = getProjectById(id);
});

const goBack = () => {
  router.push('/projects');
};

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
  }).format(date);
};

const renderMarkdown = (markdown: string): string => {
  // Simple markdown-to-HTML converter (for production, use a library like marked.js)
  return markdown
    .replace(/^# (.*$)/gim, '<h1>$1</h1>')
    .replace(/^## (.*$)/gim, '<h2>$1</h2>')
    .replace(/^### (.*$)/gim, '<h3>$1</h3>')
    .replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>')
    .replace(/\*(.*?)\*/g, '<em>$1</em>')
    .replace(/^- (.*$)/gim, '<li>$1</li>')
    .replace(/\n\n/g, '</p><p>')
    .replace(/^(?!<[h|l])/gim, '<p>')
    .replace(/(?<![>])$/gim, '</p>');
};
</script>

<style scoped>
.project-detail-page {
  max-width: 1000px;
  margin: 0 auto;
  padding: 4rem 2rem;
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.page-header {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.header-content {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.project-title {
  font-size: clamp(2rem, 5vw, 3rem);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.project-meta {
  display: flex;
  gap: 2rem;
  align-items: center;
  flex-wrap: wrap;
}

.date {
  color: var(--text-tertiary);
  font-size: 1rem;
}

.project-link {
  color: var(--primary);
  text-decoration: none;
  font-weight: 500;
  transition: color 0.3s ease;
}

.project-link:hover {
  color: var(--primary-dark);
}

.project-image {
  width: 100%;
  height: 400px;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 2rem;
}

.project-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.project-info {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.stack-section h3,
.description-section h3 {
  color: var(--text-primary);
  font-size: 1.25rem;
  margin: 0 0 1rem;
}

.stack {
  display: flex;
  flex-wrap: wrap;
  gap: 0.75rem;
}

.tech-badge {
  background: rgba(99, 102, 241, 0.2);
  color: #c4b5fd;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-size: 0.9rem;
  border: 1px solid rgba(99, 102, 241, 0.3);
}

.short-description {
  color: var(--text-secondary);
  line-height: 1.8;
  font-size: 1.1rem;
  margin: 0;
}

.readme-section {
  margin-top: 1rem;
}

.markdown-content {
  color: var(--text-secondary);
  line-height: 1.8;
}

.markdown-content :deep(h1) {
  color: var(--text-primary);
  font-size: 2rem;
  margin: 2rem 0 1rem;
  font-weight: 600;
}

.markdown-content :deep(h2) {
  color: var(--text-primary);
  font-size: 1.5rem;
  margin: 1.5rem 0 0.75rem;
  font-weight: 600;
}

.markdown-content :deep(h3) {
  color: var(--text-primary);
  font-size: 1.25rem;
  margin: 1.25rem 0 0.5rem;
  font-weight: 600;
}

.markdown-content :deep(p) {
  margin: 0.75rem 0;
}

.markdown-content :deep(li) {
  margin: 0.5rem 0 0.5rem 2rem;
  list-style-type: disc;
}

.markdown-content :deep(strong) {
  color: var(--text-primary);
  font-weight: 600;
}

.not-found {
  min-height: 50vh;
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
}

.not-found h2 {
  color: var(--text-primary);
  margin: 0 0 1.5rem;
}
</style>
