<template>
  <div class="home-page">
    <div class="hero-content">
      <h1 class="name">Loan Mata</h1>
      <p class="tagline">
        {{ displayText }}<span class="cursor">|</span>
      </p>
      <div class="nav-buttons">
        <GlassButton @click="navigate('/projects')">View Projects</GlassButton>
        <GlassButton variant="secondary" @click="navigate('/experiences')">Experience</GlassButton>
        <GlassButton variant="secondary" @click="navigate('/contact')">Contact</GlassButton>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { useRouter } from 'vue-router';
import GlassButton from '@/components/GlassButton.vue';
import { useTypingEffect } from '@/composables/useTypingEffect';

const router = useRouter();

// Define multiple taglines that will cycle through
const taglines = [
  'Développeur Web Full Stack',
  'Développeur logiciel',
  'Expert TypeScript/JavaScript',
  'Administrateur réseau',
  'Administrateur système'
];

const { displayText } = useTypingEffect({
  phrases: taglines,
  typingSpeed: 100,
  deletingSpeed: 50,
  pauseDuration: 500,
  loop: true,
});

const navigate = (path: string) => {
  router.push(path);
};
</script>

<style scoped>
.home-page {
  min-height: calc(100vh - 70px);
  display: flex;
  align-items: center;
  justify-content: center;
  padding: 2rem;
  margin-top: -70px;
}

.hero-content {
  text-align: center;
  animation: fadeInUp 1s ease-out;
}

.name {
  font-size: clamp(3rem, 10vw, 6rem);
  font-weight: 700;
  color: var(--color-text-primary);
  margin: 0;
  background: linear-gradient(135deg, var(--color-primary) 0%, var(--color-primary-dark) 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
  animation: glow 2s ease-in-out infinite alternate;
}

.tagline {
  font-size: clamp(1.25rem, 3vw, 2rem);
  color: var(--text-secondary);
  margin: 1rem 0 3rem;
  font-weight: 300;
  min-height: 3rem;
  display: flex;
  align-items: center;
  justify-content: center;
}

.cursor {
  display: inline-block;
  margin-left: 2px;
  animation: blink 1s step-end infinite;
}

@keyframes blink {
  0%, 50% {
    opacity: 1;
  }
  51%, 100% {
    opacity: 0;
  }
}

.nav-buttons {
  display: flex;
  gap: 1rem;
  justify-content: center;
  flex-wrap: wrap;
}

@keyframes fadeInUp {
  from {
    opacity: 0;
    transform: translateY(30px);
  }
  to {
    opacity: 1;
    transform: translateY(0);
  }
}

@keyframes glow {
  from {
    filter: drop-shadow(0 0 20px var(--color-primary));
  }
  to {
    filter: drop-shadow(0 0 40px var(--color-primary-dark));
  }
}
</style>
