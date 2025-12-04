<template>
  <GlassCard hoverable clickable @click="handleClick">
    <div class="experience-card">
      <div class="card-header">
        <div v-if="experience.pictureUrl" class="company-logo">
          <img :src="experience.pictureUrl" :alt="experience.companyName" />
        </div>
        <div class="header-content">
          <h3 class="company-name">{{ experience.companyName }}</h3>
          <h4 class="role">{{ experience.role }}</h4>
          <span class="job-label">{{ experience.jobLabel }}</span>
        </div>
      </div>
      <p class="description">{{ experience.description }}</p>
      <div class="dates">
        <span class="date">{{ formatDate(experience.startDate) }}</span>
        <span class="separator">—</span>
        <span class="date">{{ experience.endDate ? formatDate(experience.endDate) : 'Present' }}</span>
        <span class="duration">({{ calculateDuration() }})</span>
      </div>
      <div class="card-footer">
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

<style scoped>
.experience-card {
  display: flex;
  flex-direction: column;
  gap: 1.25rem;
}

.card-header {
  display: flex;
  gap: 1rem;
  align-items: flex-start;
}

.company-logo {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  overflow: hidden;
  flex-shrink: 0;
  background: var(--glass-bg);
}

.company-logo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.header-content {
  flex: 1;
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.company-name {
  color: var(--text-primary);
  font-size: 1.25rem;
  font-weight: 600;
  margin: 0;
}

.role {
  color: var(--text-secondary);
  font-size: 1.125rem;
  font-weight: 500;
  margin: 0;
}

.job-label {
  color: var(--text-tertiary);
  font-size: 0.875rem;
}

.description {
  color: var(--text-secondary);
  line-height: 1.6;
  margin: 0;
}

.dates {
  display: flex;
  align-items: center;
  gap: 0.5rem;
  color: var(--text-secondary);
  font-size: 0.9rem;
}

.separator {
  color: var(--text-tertiary);
}

.duration {
  color: var(--text-tertiary);
  font-style: italic;
}

.card-footer {
  padding-top: 0.5rem;
}
</style>
