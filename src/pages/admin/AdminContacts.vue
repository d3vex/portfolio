<template>
  <div class="admin-contacts">
    <div class="page-header">
      <h1 class="page-title">Contact Messages</h1>
      <div class="header-actions">
        <span class="unread-count">{{ unreadCount }} unread</span>
      </div>
    </div>

    <div v-if="contacts.length > 0" class="contacts-grid">
      <GlassCard v-for="contact in contacts" :key="contact.id" class="contact-card">
        <div class="card-header">
          <div class="contact-info">
            <h3>{{ contact.name }}</h3>
            <a :href="`mailto:${contact.email}`" class="email">{{ contact.email }}</a>
          </div>
          <span v-if="!contact.read" class="unread-indicator">●</span>
        </div>
        
        <div class="contact-content">
          <div class="meta">
            <span class="subject">{{ contact.subject }}</span>
            <span class="date">{{ formatDate(contact.createdAt) }}</span>
          </div>
          <p class="message">{{ contact.message }}</p>
        </div>

        <div class="card-actions">
          <GlassButton v-if="!contact.read" size="small" @click="markAsRead(contact.id)">
            Mark as Read
          </GlassButton>
          <GlassButton variant="danger" size="small" @click="deleteMessage(contact.id)">
            Delete
          </GlassButton>
        </div>
      </GlassCard>
    </div>

    <GlassCard v-else>
      <p class="empty-state">No contact messages yet</p>
    </GlassCard>
  </div>
</template>

<script setup lang="ts">
import { ref, onMounted, computed } from 'vue';
import { useContacts } from '@/composables/useContacts';
import GlassCard from '@/components/GlassCard.vue';
import GlassButton from '@/components/GlassButton.vue';
import type { ContactDTO } from '@/domain/dtos';

const { getAllContacts, markAsRead: markContactAsRead, deleteContact, getUnreadCount } = useContacts();

const contacts = ref<ContactDTO[]>([]);
const unreadCount = computed(() => getUnreadCount());

onMounted(() => {
  loadContacts();
});

const loadContacts = () => {
  contacts.value = getAllContacts();
};

const markAsRead = (id: string) => {
  markContactAsRead(id);
  loadContacts();
};

const deleteMessage = (id: string) => {
  if (confirm('Are you sure you want to delete this message?')) {
    deleteContact(id);
    loadContacts();
  }
};

const formatDate = (dateString: string): string => {
  const date = new Date(dateString);
  return new Intl.DateTimeFormat('en-US', {
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit',
  }).format(date);
};
</script>

<style scoped>
.admin-contacts {
  max-width: 1200px;
  margin: 0 auto;
}

.page-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 2rem;
}

.page-title {
  font-size: 2.5rem;
  font-weight: 700;
  color: var(--text-primary);
  margin: 0;
}

.header-actions {
  display: flex;
  gap: 1rem;
  align-items: center;
}

.unread-count {
  background: rgba(239, 68, 68, 0.2);
  color: #fca5a5;
  padding: 0.5rem 1rem;
  border-radius: 8px;
  font-weight: 600;
  border: 1px solid rgba(239, 68, 68, 0.3);
}

.contacts-grid {
  display: flex;
  flex-direction: column;
  gap: 1.5rem;
}

.contact-card {
  position: relative;
}

.card-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-start;
  margin-bottom: 1rem;
}

.contact-info h3 {
  color: var(--text-primary);
  font-size: 1.25rem;
  margin: 0 0 0.25rem;
}

.email {
  color: var(--primary);
  text-decoration: none;
  font-size: 0.9rem;
}

.email:hover {
  text-decoration: underline;
}

.unread-indicator {
  color: #ef4444;
  font-size: 1.5rem;
  line-height: 1;
}

.contact-content {
  margin-bottom: 1.5rem;
}

.meta {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 1rem;
  gap: 1rem;
}

.subject {
  color: var(--text-primary);
  font-weight: 600;
  font-size: 1.1rem;
}

.date {
  color: var(--text-tertiary);
  font-size: 0.875rem;
  white-space: nowrap;
}

.message {
  color: var(--text-secondary);
  line-height: 1.8;
  margin: 0;
  white-space: pre-wrap;
}

.card-actions {
  display: flex;
  gap: 0.75rem;
  flex-wrap: wrap;
}

.empty-state {
  text-align: center;
  color: var(--text-tertiary);
  padding: 3rem;
  margin: 0;
  font-size: 1.125rem;
}
</style>
