export interface ContactDTO {
  id: string;
  name: string;
  email: string;
  subject: string;
  message: string;
  createdAt: string; // ISO string
  read: boolean;
}

export interface CreateContactDTO {
  name: string;
  email: string;
  subject: string;
  message: string;
}
