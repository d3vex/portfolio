import { Injectable } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Experience } from '../experience/entities/experience.entity';
import { Education } from '../education/entities/education.entity';

@Injectable()
export class TimelineService {
  constructor(
    @InjectRepository(Experience)
    private experienceRepo: Repository<Experience>,
    @InjectRepository(Education)
    private educationRepo: Repository<Education>,
  ) {}

  async getTimeline(): Promise<any[]> {
    const [experiences, education] = await Promise.all([
      this.experienceRepo.find(),
      this.educationRepo.find(),
    ]);

    const timelineEvents = [
      ...experiences.map(exp => ({
        id: exp.id,
        type: 'experience' as const,
        startDate: exp.startDate || '',
        endDate: exp.endDate || undefined,
        title: exp.title,
        subtitle: exp.company,
        description: exp.descriptions?.[0] || '',
        tags: exp.skillIds || [],
        icon: 'mdi:briefcase',
      })),
      ...education.map(edu => ({
        id: edu.id,
        type: 'education' as const,
        startDate: edu.startDate || edu.date || '',
        endDate: edu.endDate || undefined,
        title: edu.title,
        subtitle: edu.school || '',
        description: edu.description || '',
        tags: edu.tags || [],
        icon: 'mdi:school',
      })),
    ];

    timelineEvents.sort((a, b) => {
      const aEnd = a.endDate || '9999-99';
      const bEnd = b.endDate || '9999-99';
      const cmp = bEnd.localeCompare(aEnd);
      if (cmp !== 0) return cmp;
      return b.startDate.localeCompare(a.startDate);
    });

    return timelineEvents;
  }
}
