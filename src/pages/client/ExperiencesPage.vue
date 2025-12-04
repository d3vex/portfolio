<template>
  <div class="experiences-page">
    <div class="page-header">
      <h1 class="page-title">Experience</h1>
      <p class="page-subtitle">My professional journey and achievements</p>
    </div>
    
    <div v-if="experiences.length > 0" class="experiences-grid">
      <ExperienceCard
        v-for="experience in experiences"
        :key="experience.id"
        :experience="experience"
        @click="navigateToExperience"
      />
    </div>
    
    <div v-else class="empty-state">
      <p>No experiences available yet.</p>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useExperiences } from '@/composables/useExperiences';
import ExperienceCard from '@/components/ExperienceCard.vue';
import type { ExperienceCardDTO } from '@/domain/dtos';

const router = useRouter();
const { getAllExperiences } = useExperiences();

const experiences = ref<ExperienceCardDTO[]>([]);

onMounted(() => {
  experiences.value = getAllExperiences();
});

const navigateToExperience = (id: string) => {
  router.push(`/experiences/${id}`);
};
</script>

<style scoped>
.experiences-page {
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
  background: linear-gradient(135deg, var(--secondary) 0%, #059669 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.page-subtitle {
  font-size: clamp(1rem, 2vw, 1.25rem);
  color: var(--text-secondary);
  margin: 0;
}

.experiences-grid {
  display: grid;
  grid-template-columns: repeat(auto-fill, minmax(400px, 1fr));
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

@media (max-width: 768px) {
  .experiences-grid {
    grid-template-columns: 1fr;
  }
}
</style>
