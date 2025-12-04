<template>
  <div class="admin-dashboard">
    <h1 class="page-title">Dashboard</h1>
    
    <div class="stats-grid">
      <GlassCard class="stat-card">
        <div class="stat-content">
          <div class="stat-icon">🚀</div>
          <div class="stat-info">
            <h3 class="stat-value">{{ projectCount }}</h3>
            <p class="stat-label">Total Projects</p>
          </div>
        </div>
      </GlassCard>

      <GlassCard class="stat-card">
        <div class="stat-content">
          <div class="stat-icon">💼</div>
          <div class="stat-info">
            <h3 class="stat-value">{{ experienceCount }}</h3>
            <p class="stat-label">Experiences</p>
          </div>
        </div>
      </GlassCard>

      <GlassCard class="stat-card">
        <div class="stat-content">
          <div class="stat-icon">✉️</div>
          <div class="stat-info">
            <h3 class="stat-value">{{ contactCount }}</h3>
            <p class="stat-label">Messages</p>
          </div>
        </div>
      </GlassCard>

      <GlassCard class="stat-card">
        <div class="stat-content">
          <div class="stat-icon">🔔</div>
          <div class="stat-info">
            <h3 class="stat-value">{{ unreadCount }}</h3>
            <p class="stat-label">Unread</p>
          </div>
        </div>
      </GlassCard>
    </div>

    <div class="recent-section">
      <GlassCard>
        <h2 class="section-title">Recent Messages</h2>
        <div v-if="recentContacts.length > 0" class="contacts-list">
          <div v-for="contact in recentContacts" :key="contact.id" class="contact-item">
            <div class="contact-header">
              <h4>{{ contact.name }}</h4>
              <span class="contact-date">{{ formatDate(contact.createdAt) }}</span>
            </div>
            <p class="contact-subject">{{ contact.subject }}</p>
            <p class="contact-preview">{{ truncate(contact.message, 100) }}</p>
            <span v-if="!contact.read" class="unread-badge">New</span>
          </div>
        </div>
        <p v-else class="empty-message">No messages yet</p>
      </GlassCard>
    </div>

    <div class="quick-actions">
      <h2 class="section-title">Quick Actions</h2>
      <div class="actions-grid">
        <GlassButton @click="navigate('/admin/projects/new')">+ New Project</GlassButton>
        <GlassButton @click="navigate('/admin/experiences/new')">+ New Experience</GlassButton>
        <GlassButton variant="secondary" @click="navigate('/admin/contacts')">View All Messages</GlassButton>
      </div>
    </div>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted } from 'vue';
import { useRouter } from 'vue-router';
import { useProjects } from '@/composables/useProjects';
import { useExperiences } from '@/composables/useExperiences';
import { useContacts } from '@/composables/useContacts';
import GlassCard from '@/components/GlassCard.vue';
import GlassButton from '@/components/GlassButton.vue';
import type { ContactDTO } from '@/domain/dtos';

const router = useRouter();
const { getAllProjects } = useProjects();
const { getAllExperiences } = useExperiences();
const { getAllContacts, getUnreadCount } = useContacts();

const projectCount = ref(0);
const experienceCount = ref(0);
const contactCount = ref(0);
const unreadCount = ref(0);
const recentContacts = ref<ContactDTO[]>([]);

onMounted(() => {
  projectCount.value = getAllProjects().length;
  experienceCount.value = getAllExperiences().length;
  const contacts = getAllContacts();
  contactCount.value = contacts.length;
  unreadCount.value = getUnreadCount();
  recentContacts.value = contacts.slice(0, 5);
});

const navigate = (path: string) => {
  router.push(path);
};

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(date);
};

const truncate = (text: string, length: number): string => {
  return text.length > length ? text.substring(0, length) + '...' : text;
};
</script>

<style scoped>
.admin-dashboard {
  max-width: 1400px;
  margin: 0 auto;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 2rem;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
  gap: 1.5rem;
  margin-bottom: 2rem;
}

.stat-card {
  padding: 1.5rem !important;
}

.stat-content {
  display: flex;
  align-items: center;
  gap: 1.5rem;
}

.stat-icon {
  font-size: 2.5rem;
}

.stat-info {
  flex: 1;
}

.stat-value {
  font-size: 2rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0 0 0.25rem;
}

.stat-label {
  color: var(--text-tertiary);
  margin: 0;
  font-size: 0.875rem;
}

.recent-section {
  margin-bottom: 2rem;
}

.section-title {
  font-size: 1.5rem;
  font-weight: 600;
  color: var(--text-primary);
  margin: 0 0 1.5rem;
}

.contacts-list {
  display: flex;
  flex-direction: column;
  gap: 1rem;
}

.contact-item {
  position: relative;
  padding: 1rem;
  background: var(--glass-bg);
  border-radius: 12px;
  border: 1px solid var(--border-color);
  transition: all 0.3s ease;
}

.contact-item:hover {
  background: var(--glass-bg-hover);
  border-color: var(--border-color-hover);
}

.contact-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 0.5rem;
}

.contact-header h4 {
  color: var(--text-primary);
  font-size: 1.125rem;
  margin: 0;
}

.contact-date {
  color: var(--text-tertiary);
  font-size: 0.875rem;
}

.contact-subject {
  color: var(--text-secondary);
  font-weight: 500;
  margin: 0 0 0.5rem;
}

.contact-preview {
  color: var(--text-tertiary);
  margin: 0;
  font-size: 0.9rem;
}

.unread-badge {
  position: absolute;
  top: 1rem;
  right: 1rem;
  background: rgba(239, 68, 68, 0.3);
  color: #fca5a5;
  padding: 0.25rem 0.75rem;
  border-radius: 6px;
  font-size: 0.75rem;
  font-weight: 600;
  border: 1px solid rgba(239, 68, 68, 0.5);
}

.empty-message {
  color: var(--text-tertiary);
  text-align: center;
  padding: 2rem;
  margin: 0;
}

.quick-actions {
  margin-top: 2rem;
}

.actions-grid {
  display: flex;
  gap: 1rem;
  flex-wrap: wrap;
}
</style>
