import { defineStore } from 'pinia';
import { ref, computed } from 'vue';
import type { Contact } from '@/domain/models';
import type { ContactDTO, CreateContactDTO } from '@/domain/dtos';
import { ContactPresenter } from '@/domain/presenters';
import { mockContacts } from './mockData/contacts';

export const useContactStore = defineStore('contacts', () => {
  const contacts = ref<Contact[]>([...mockContacts]);

  const getAllContacts = (): ContactDTO[] => {
    return contacts.value
      .sort((a, b) => b.createdAt.getTime() - a.createdAt.getTime())
      .map(ContactPresenter.toDTO);
  };

  const getUnreadCount = computed(() => {
    return contacts.value.filter(c => !c.read).length;
  });

  const createContact = (dto: CreateContactDTO): ContactDTO => {
    const id = `${Date.now()}`;
    const contact = ContactPresenter.fromCreateDTO(dto, id);
    contacts.value.push(contact);
    return ContactPresenter.toDTO(contact);
  };

  const markAsRead = (id: string): boolean => {
    const contact = contacts.value.find(c => c.id === id);
    if (!contact) return false;
    contact.read = true;
    return true;
  };

  const deleteContact = (id: string): boolean => {
    const index = contacts.value.findIndex(c => c.id === id);
    if (index === -1) return false;
    contacts.value.splice(index, 1);
    return true;
  };

  return {
    getAllContacts,
    getUnreadCount,
    createContact,
    markAsRead,
    deleteContact,
  };
});
