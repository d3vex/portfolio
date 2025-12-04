<template>
  <GlassCard hoverable clickable @click="handleClick">
    <div class="flex flex-col gap-5">
      <div class="flex gap-4 items-start">
        <div v-if="experience.pictureUrl" class="h-16 w-16 rounded-xl overflow-hidden shrink-0 bg-glass-bg">
          <img :src="experience.pictureUrl" :alt="experience.companyName" class="w-full h-full object-cover" />
        </div>
        <div class="flex flex-col gap-1 flex-1">
          <h3 class="text-text-primary! text-xl! font-semibold! m-0">{{ experience.companyName }}</h3>
          <h4 class="text-text-secondary! font-medium! text-lg m-0">{{ experience.role }}</h4>
          <span class="text-text-tertiary! text-sm!">{{ experience.jobLabel }}</span>
        </div>
      </div>
      <p class="text-text-secondary leading-relaxed m-0">{{ experience.description }}</p>
      <div class="flex items-center gap-2 text-sm text-text-secondary">
        <span class="date">{{ formatDate(experience.startDate) }}</span>
        <span class="separator">—</span>
        <span class="date">{{ experience.endDate ? formatDate(experience.endDate) : 'Present' }}</span>
        <span class="text-text-tertiary italic">({{ calculateDuration() }})</span>
      </div>
      <div class="pt-2">
        <GlassButton variant="secondary" size="small">View Details</GlassButton>
      </div>
    </div>
  </GlassCard>
</template>

<script setup lang="ts">
import type { ExperienceCardDTO } from '@/domain/dtos';
import GlassCard from './GlassCard.vue';
import GlassButton from './GlassButton.vue';

interface Props {
  experience: ExperienceCardDTO;
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

const calculateDuration = (): string => {
  const start = new Date(props.experience.startDate);
  const end = props.experience.endDate ? new Date(props.experience.endDate) : new Date();
  
  const months = (end.getFullYear() - start.getFullYear()) * 12 + (end.getMonth() - start.getMonth());
  const years = Math.floor(months / 12);
  const remainingMonths = months % 12;
  
  if (years === 0) {
    return `${remainingMonths} month${remainingMonths !== 1 ? 's' : ''}`;
  } else if (remainingMonths === 0) {
    return `${years} year${years !== 1 ? 's' : ''}`;
  } else {
    return `${years} year${years !== 1 ? 's' : ''}, ${remainingMonths} month${remainingMonths !== 1 ? 's' : ''}`;
  }
};

const handleClick = () => {
  emit('click', props.experience.id);
};
</script>
