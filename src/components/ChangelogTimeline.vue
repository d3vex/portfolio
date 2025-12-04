<template>
  <div class="changelog-timeline">
    <h3 v-if="title" class="timeline-title">{{ title }}</h3>
    <div class="timeline">
      <div v-for="(item, index) in items" :key="item.id" class="timeline-item">
        <div class="timeline-marker" :class="item.type"></div>
        <div class="timeline-content">
          <div class="timeline-header">
            <h4 class="timeline-item-title">{{ item.title }}</h4>
            <span class="timeline-date">{{ formatDate(item.date) }}</span>
          </div>
          <p class="timeline-description">{{ item.description }}</p>
          <span class="timeline-type" :class="item.type">{{ item.type }}</span>
        </div>
        <div v-if="index !== items.length - 1" class="timeline-line"></div>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import type { ChangelogDTO } from '@/domain/dtos';

interface Props {
  items: ChangelogDTO[];
  title?: string;
}

defineProps<Props>();

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'short',
    day: 'numeric',
  }).format(date);
};
</script>

<style scoped>
.changelog-timeline {
  width: 100%;
}

.timeline-title {
  color: var(--text-primary);
  font-size: 1.5rem;
  margin-bottom: 2rem;
  font-weight: 600;
}

.timeline {
  position: relative;
  padding-left: 2rem;
}

.timeline-item {
  position: relative;
  padding-bottom: 2rem;
}

.timeline-marker {
  position: absolute;
  left: -2rem;
  top: 0;
  width: 16px;
  height: 16px;
  border-radius: 50%;
  border: 3px solid;
  background: var(--glass-bg);
  backdrop-filter: blur(10px);
  z-index: 2;
}

.timeline-marker.milestone {
  border-color: #8b5cf6;
  box-shadow: 0 0 10px rgba(139, 92, 246, 0.5);
}

.timeline-marker.feature {
  border-color: #10b981;
  box-shadow: 0 0 10px rgba(16, 185, 129, 0.5);
}

.timeline-marker.improvement {
  border-color: #3b82f6;
  box-shadow: 0 0 10px rgba(59, 130, 246, 0.5);
}

.timeline-marker.bugfix {
  border-color: #ef4444;
  box-shadow: 0 0 10px rgba(239, 68, 68, 0.5);
}

.timeline-line {
  position: absolute;
  left: -1.5rem;
  top: 16px;
  bottom: 0;
  width: 2px;
  background: linear-gradient(to bottom, var(--border-color), transparent);
}

.timeline-content {
  background: var(--glass-bg);
  backdrop-filter: blur(10px);
  border: 1px solid var(--border-color);
  border-radius: 12px;
  padding: 1.25rem;
  transition: all 0.3s ease;
}

.timeline-content:hover {
  background: var(--glass-bg-hover);
  border-color: var(--border-color-hover);
}

.timeline-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 0.75rem;
  gap: 1rem;
}

.timeline-item-title {
  color: var(--text-primary);
  font-size: 1.125rem;
  font-weight: 600;
  margin: 0;
}

.timeline-date {
  color: var(--text-tertiary);
  font-size: 0.875rem;
  white-space: nowrap;
}

.timeline-description {
  color: var(--text-secondary);
  margin: 0 0 0.75rem 0;
  line-height: 1.6;
}

.timeline-type {
  display: inline-block;
  padding: 0.25rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  text-transform: uppercase;
  letter-spacing: 0.5px;
}

.timeline-type.milestone {
  background: rgba(139, 92, 246, 0.2);
  color: #c4b5fd;
  border: 1px solid rgba(139, 92, 246, 0.3);
}

.timeline-type.feature {
  background: rgba(16, 185, 129, 0.2);
  color: #6ee7b7;
  border: 1px solid rgba(16, 185, 129, 0.3);
}

.timeline-type.improvement {
  background: rgba(59, 130, 246, 0.2);
  color: #93c5fd;
  border: 1px solid rgba(59, 130, 246, 0.3);
}

.timeline-type.bugfix {
  background: rgba(239, 68, 68, 0.2);
  color: #fca5a5;
  border: 1px solid rgba(239, 68, 68, 0.3);
}
</style>
