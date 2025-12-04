import type { Contact } from '../models/Contact';
import type { ContactDTO, CreateContactDTO } from '../dtos';

export class ContactPresenter {
  static toDTO(contact: Contact): ContactDTO {
    return {
      id: contact.id,
      name: contact.name,
      email: contact.email,
      subject: contact.subject,
      message: contact.message,
      createdAt: contact.createdAt.toISOString(),
      read: contact.read,
    };
  }

  static fromCreateDTO(dto: CreateContactDTO, id: string): Contact {
    return {
      id,
      name: dto.name,
      email: dto.email,
      subject: dto.subject,
      message: dto.message,
      createdAt: new Date(),
      read: false,
    };
  }
}
