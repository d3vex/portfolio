<template>
  <div v-if="experience" class="experience-detail-page">
    <div class="page-header">
      <GlassButton variant="secondary" @click="goBack" size="small">← Back</GlassButton>
      <div class="header-content">
        <h1 class="experience-title">{{ experience.role }}</h1>
        <h2 class="company-name">{{ experience.companyName }}</h2>
        <div class="experience-meta">
          <span class="job-label">{{ experience.jobLabel }}</span>
          <span class="separator">•</span>
          <span class="dates">
            {{ formatDate(experience.startDate) }} - {{ experience.endDate ? formatDate(experience.endDate) : 'Present' }}
          </span>
        </div>
      </div>
    </div>

    <GlassCard>
      <div class="experience-content">
        <div v-if="experience.pictureUrl" class="company-logo">
          <img :src="experience.pictureUrl" :alt="experience.companyName" />
        </div>
        
        <div class="description-section">
          <h3>Overview</h3>
          <p class="short-description">{{ experience.description }}</p>
        </div>
      </div>
    </GlassCard>

    <GlassCard class="details-section">
      <div class="markdown-content" v-html="renderMarkdown(experience.fullDescription)"></div>
    </GlassCard>

    <GlassCard class="company-details">
      <h2>About {{ experience.companyDetails.name }}</h2>
      <div class="company-info">
        <div class="info-item">
          <span class="label">Industry:</span>
          <span class="value">{{ experience.companyDetails.industry }}</span>
        </div>
        <div v-if="experience.companyDetails.size" class="info-item">
          <span class="label">Company Size:</span>
          <span class="value">{{ experience.companyDetails.size }}</span>
        </div>
        <div v-if="experience.companyDetails.location" class="info-item">
          <span class="label">Location:</span>
          <span class="value">{{ experience.companyDetails.location }}</span>
        </div>
        <div v-if="experience.companyDetails.website" class="info-item">
          <span class="label">Website:</span>
          <a :href="experience.companyDetails.website" target="_blank" class="value link">
            {{ experience.companyDetails.website }}
          </a>
        </div>
      </div>
      <p class="company-description">{{ experience.companyDetails.description }}</p>
    </GlassCard>

    <GlassCard v-if="experience.changelog.length > 0">
      <ChangelogTimeline :items="experience.changelog" title="Career Milestones" />
    </GlassCard>
  </div>
  
  <div v-else class="not-found">
    <GlassCard>
      <h2>Experience not found</h2>
      <GlassButton @click="goBack">Go Back</GlassButton>
    </GlassCard>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useExperiences } from '@/composables/useExperiences';
import GlassCard from '@/components/GlassCard.vue';
import GlassButton from '@/components/GlassButton.vue';
import ChangelogTimeline from '@/components/ChangelogTimeline.vue';
import type { ExperienceDetailDTO } from '@/domain/dtos';

const route = useRoute();
const router = useRouter();
const { getExperienceById } = useExperiences();

const experience = ref<ExperienceDetailDTO | null>(null);

onMounted(() => {
  const id = route.params.id as string;
  experience.value = getExperienceById(id);
});

const goBack = () => {
  router.push('/experiences');
};

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
  }).format(date);
};

const renderMarkdown = (markdown: string): string => {
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
.experience-detail-page {
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
  gap: 0.75rem;
}

.experience-title {
  font-size: clamp(2rem, 5vw, 3rem);
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.company-name {
  font-size: clamp(1.5rem, 3vw, 2rem);
  font-weight: 600;
  color: var(--text-secondary);
  margin: 0;
}

.experience-meta {
  display: flex;
  gap: 1rem;
  align-items: center;
  flex-wrap: wrap;
  color: var(--text-tertiary);
  font-size: 1rem;
}

.separator {
  color: var(--text-tertiary);
}

.experience-content {
  display: flex;
  flex-direction: column;
  gap: 2rem;
}

.company-logo {
  width: 120px;
  height: 120px;
  border-radius: 16px;
  overflow: hidden;
  background: rgba(255, 255, 255, 0.05);
}

.company-logo img {
  width: 100%;
  height: 100%;
  object-fit: cover;
}

.description-section h3 {
  color: var(--text-primary);
  font-size: 1.25rem;
  margin: 0 0 1rem;
}

.short-description {
  color: var(--text-secondary);
  line-height: 1.8;
  font-size: 1.1rem;
  margin: 0;
}

.details-section {
  margin-top: 1rem;
}

.markdown-content {
  color: var(--text-secondary);
  line-height: 1.8;
}

.markdown-content :deep(h1),
.markdown-content :deep(h2),
.markdown-content :deep(h3) {
  color: var(--text-primary);
  margin: 1.5rem 0 1rem;
  font-weight: 600;
}

.markdown-content :deep(p) {
  margin: 0.75rem 0;
}

.markdown-content :deep(li) {
  margin: 0.5rem 0 0.5rem 2rem;
  list-style-type: disc;
}

.company-details h2 {
  color: var(--text-primary);
  font-size: 1.75rem;
  margin: 0 0 1.5rem;
}

.company-info {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1rem;
  margin-bottom: 1.5rem;
}

.info-item {
  display: flex;
  flex-direction: column;
  gap: 0.25rem;
}

.label {
  color: var(--text-tertiary);
  font-size: 0.875rem;
  font-weight: 500;
}

.value {
  color: var(--text-primary);
  font-size: 1rem;
}

.value.link {
  color: var(--primary);
  text-decoration: none;
  transition: color 0.3s ease;
}

.value.link:hover {
  color: var(--primary-dark);
}

.company-description {
  color: var(--text-secondary);
  line-height: 1.8;
  margin: 0;
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
