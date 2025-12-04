export interface Changelog {
  id: string;
  date: Date;
  title: string;
  description: string;
  type: 'feature' | 'improvement' | 'bugfix' | 'milestone';
}
