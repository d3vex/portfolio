import type { Contact } from '@/domain/models';

export const mockContacts: Contact[] = [
  {
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    subject: 'Collaboration Opportunity',
    message: 'Hi! I came across your portfolio and I\'m impressed with your work. I\'d like to discuss a potential collaboration on a Vue.js project.',
    createdAt: new Date('2025-11-28'),
    read: false,
  },
  {
    id: '2',
    name: 'Jane Smith',
    email: 'jane.smith@techcompany.com',
    subject: 'Job Opportunity',
    message: 'We\'re looking for a senior frontend developer and your profile matches perfectly. Would you be interested in discussing this opportunity?',
    createdAt: new Date('2025-11-25'),
    read: true,
  },
  {
    id: '3',
    name: 'Mike Johnson',
    email: 'mike.j@startup.io',
    subject: 'Question about E-Commerce Project',
    message: 'I noticed your e-commerce platform project. Could you share more details about the architecture and tech stack used?',
    createdAt: new Date('2025-11-20'),
    read: true,
  },
];
