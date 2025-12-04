export interface CreateChangelogDTO {
  date: string;
  title: string;
  description: string;
  type: 'feature' | 'improvement' | 'bugfix' | 'milestone';
}

export interface UpdateChangelogDTO {
  id: string;
  date?: string;
  title?: string;
  description?: string;
  type?: 'feature' | 'improvement' | 'bugfix' | 'milestone';
}
