export interface ChangelogDTO {
  id: string;
  date: string; // ISO string
  title: string;
  description: string;
  type: 'feature' | 'improvement' | 'bugfix' | 'milestone';
}
