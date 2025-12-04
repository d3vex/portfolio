<template>
  <GlassCard hoverable clickable @click="handleClick">
    <div class="project-card">
      <div v-if="project.pictureUrl" class="card-image">
        <img :src="project.pictureUrl" :alt="project.title" />
      </div>
      <div class="card-content">
        <div class="card-header">
          <h3 class="card-title">{{ project.title }}</h3>
          <span class="card-date">{{ formatDate(project.dateCreated) }}</span>
        </div>
        <p class="card-description">{{ project.description }}</p>
        <div class="card-stack">
          <span v-for="tech in project.stack" :key="tech" class="tech-badge">{{ tech }}</span>
        </div>
        <div class="card-footer">
          <GlassButton v-if="project.projectUrl" size="small" @click.stop="openProject">
            Visit Project
          </GlassButton>
          <GlassButton variant="secondary" size="small">View Details</GlassButton>
        </div>
      </div>
    </div>
  </GlassCard>
</template>

<script setup lang="ts">
import type { ProjectCardDTO } from '@/domain/dtos';
import GlassCard from './GlassCard.vue';
import GlassButton from './GlassButton.vue';

interface Props {
  project: ProjectCardDTO;
}

const props = defineProps<Props>();

const emit = defineEmits<{
  click: [id: string];
}>();

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'short',
  }).format(date);
};

const handleClick = () => {
  emit('click', props.project.id);
};

const openProject = () => {
  if (props.project.projectUrl) {
    window.open(props.project.projectUrl, '_blank');
  }
};
</script>

<style scoped>
.project-card {
  display: flex;
  flex-direction: column;
  height: 100%;
}

.card-image {
  width: 100%;
  height: 200px;
  border-radius: 12px;
  overflow: hidden;
  margin-bottom: 1.5rem;
}

.card-image img {
  width: 100%;
  height: 100%;
  object-fit: cover;
  transition: transform 0.3s ease;
}

.project-card:hover .card-image img {
  transform: scale(1.05);
}

.card-content {
  display: flex;
  flex-direction: column;
  gap: 1rem;
  flex: 1;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  gap: 1rem;
}

.card-title {
  color: var(--text-primary);
  font-size: 1.5rem;
  font-weight: 600;
  margin: 0;
}

.card-date {
  color: var(--text-tertiary);
  font-size: 0.875rem;
  white-space: nowrap;
}

.card-description {
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
}

.card-stack {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
}

.tech-badge {
  background: var(--glass-bg);
  color: var(--primary);
  padding: 0.25rem 0.75rem;
  border-radius: 6px;
  font-size: 0.875rem;
  border: 1px solid var(--border-color);
}

.card-footer {
  display: flex;
  gap: 0.75rem;
  margin-top: auto;
  padding-top: 1rem;
}
</style>
