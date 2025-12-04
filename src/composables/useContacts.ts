import { useContactStore } from '@/stores/contactStore';
import type { ContactDTO, CreateContactDTO } from '@/domain/dtos';

export function useContacts() {
  const contactStore = useContactStore();

  const getAllContacts = (): ContactDTO[] => {
    return contactStore.getAllContacts();
  };

  const getUnreadCount = () => {
    return contactStore.getUnreadCount;
  };

  const createContact = (dto: CreateContactDTO): ContactDTO => {
    return contactStore.createContact(dto);
  };

  const markAsRead = (id: string): boolean => {
    return contactStore.markAsRead(id);
  };

  const deleteContact = (id: string): boolean => {
    return contactStore.deleteContact(id);
  };

  return {
    getAllContacts,
    getUnreadCount,
    createContact,
    markAsRead,
    deleteContact,
  };
}
