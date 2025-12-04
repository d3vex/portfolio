<template>
  <GlassCard hoverable clickable @click="handleClick" class="group">
    <div class="flex flex-col h-full">
      <div v-if="project.pictureUrl" class="w-full h-48 rounded-xl overflow-hidden mb-6">
        <img class="w-full h-full object-cover transition-transform duration-300 ease-initial group-hover:scale-105" :src="project.pictureUrl" :alt="project.title" />
      </div>
      <div class="flex flex-col gap-4 flex-1">
        <div class="flex justify-between items-start gap-4">
          <h3 class="text-primary text-2xl font-semibold m-0">{{ project.title }}</h3>
          <span class="text-tertiary text-sm whitespace-nowrap">{{ formatDate(project.dateCreated) }}</span>
        </div>
        <p class="text-text-secondary leading-relaxed m-0">{{ project.description }}</p>
        <div class="flex flex-wrap gap-2">
          <span v-for="tech in project.stack" :key="tech" 
          class="bg-glass-bg px-3 py-1 text-sm text-text-primary border border-glass-border rounded-md">{{ tech }}</span>
        </div>
        <div class="flex gap-3 mt-auto pt-4">
          <GlassButton v-if="project.projectUrl" size="small" variant="primary" @click.capture="openProject($event)">
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

const openProject = (event: Event) => {
  event.stopPropagation();// avoid redirection
  if (props.project.projectUrl) {
    window.open(props.project.projectUrl, '_blank');
  }
};
</script>

