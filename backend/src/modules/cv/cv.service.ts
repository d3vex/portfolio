import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Cv } from './entities/cv.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Project } from '../project/entities/project.entity';
import { Experience } from '../experience/entities/experience.entity';
import { Education } from '../education/entities/education.entity';
import { Language } from '../language/entities/language.entity';
import { Passion } from '../passion/entities/passion.entity';
import { Contact } from '../contact/entities/contact.entity';
import { Category } from '../category/entities/category.entity';
import { CreateCvDto } from './dto/create-cv.dto';
import { UpdateCvDto } from './dto/update-cv.dto';

@Injectable()
export class CvService {
  constructor(
    @InjectRepository(Cv) private repo: Repository<Cv>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Project) private projectRepo: Repository<Project>,
    @InjectRepository(Experience) private experienceRepo: Repository<Experience>,
    @InjectRepository(Education) private educationRepo: Repository<Education>,
    @InjectRepository(Language) private languageRepo: Repository<Language>,
    @InjectRepository(Passion) private passionRepo: Repository<Passion>,
    @InjectRepository(Contact) private contactRepo: Repository<Contact>,
    @InjectRepository(Category) private categoryRepo: Repository<Category>,
  ) {}

  findAll() {
    return this.repo.find({ relations: { skills: true, languages: true, passions: true, experiences: true, projects: true, education: true, contacts: true, picture: true }, order: { createdAt: 'DESC' } });
  }

  async findOne(id: string) {
    const cv = await this.repo.findOne({ where: { id }, relations: { skills: true, languages: true, passions: true, experiences: true, projects: true, education: true, contacts: true, picture: true } });
    if (!cv) throw new NotFoundException('CV not found');
    return cv;
  }

  async create(dto: CreateCvDto) {
    const { skillIds, languageIds, passionIds, experienceIds, projectIds, educationIds, contactIds, ...rest } = dto;
    const entity = this.repo.create(rest);
    entity.skills = skillIds?.length ? await this.skillRepo.findBy({ id: In(skillIds) }) : [];
    entity.languages = languageIds?.length ? await this.languageRepo.findBy({ id: In(languageIds) }) : [];
    entity.passions = passionIds?.length ? await this.passionRepo.findBy({ id: In(passionIds) }) : [];
    entity.experiences = experienceIds?.length ? await this.experienceRepo.findBy({ id: In(experienceIds) }) : [];
    entity.projects = projectIds?.length ? await this.projectRepo.findBy({ id: In(projectIds) }) : [];
    entity.education = educationIds?.length ? await this.educationRepo.findBy({ id: In(educationIds) }) : [];
    entity.contacts = contactIds?.length ? await this.contactRepo.findBy({ id: In(contactIds) }) : [];
    return this.repo.save(entity);
  }

  async update(id: string, dto: UpdateCvDto) {
    const entity = await this.findOne(id);
    const { skillIds, languageIds, passionIds, experienceIds, projectIds, educationIds, contactIds, ...rest } = dto as any;
    Object.assign(entity, rest);
    if (skillIds !== undefined) entity.skills = skillIds?.length ? await this.skillRepo.findBy({ id: In(skillIds) }) : [];
    if (languageIds !== undefined) entity.languages = languageIds?.length ? await this.languageRepo.findBy({ id: In(languageIds) }) : [];
    if (passionIds !== undefined) entity.passions = passionIds?.length ? await this.passionRepo.findBy({ id: In(passionIds) }) : [];
    if (experienceIds !== undefined) entity.experiences = experienceIds?.length ? await this.experienceRepo.findBy({ id: In(experienceIds) }) : [];
    if (projectIds !== undefined) entity.projects = projectIds?.length ? await this.projectRepo.findBy({ id: In(projectIds) }) : [];
    if (educationIds !== undefined) entity.education = educationIds?.length ? await this.educationRepo.findBy({ id: In(educationIds) }) : [];
    if (contactIds !== undefined) entity.contacts = contactIds?.length ? await this.contactRepo.findBy({ id: In(contactIds) }) : [];
    return this.repo.save(entity);
  }

  async remove(id: string) {
    const cv = await this.findOne(id);
    return this.repo.remove(cv);
  }

  async getDashboardStats() {
    const [cvs, totalCvs] = await this.repo.findAndCount();
    const skills = await this.skillRepo.find();
    const projects = await this.projectRepo.find();
    const experiences = await this.experienceRepo.find();
    const education = await this.educationRepo.find();
    const languages = await this.languageRepo.find();
    const passions = await this.passionRepo.find();
    const categories = await this.categoryRepo.find();

    const totals = {
      totalCvs,
      hardSkills: skills.filter(s => s.cvCategory === 'hard').length,
      softSkills: skills.filter(s => s.cvCategory === 'soft').length,
      experiences: experiences.length,
      projects: projects.length,
      education: education.length,
      languages: languages.length,
      passions: passions.length,
      categories: categories.length,
    };

    const specializationCount: Record<string, number> = {};
    for (const cv of cvs) {
      const spec = cv.specialization || 'general';
      specializationCount[spec] = (specializationCount[spec] || 0) + 1;
    }

    return {
      ...totals,
      specializationCount,
      recentCvs: cvs.slice(0, 5),
    };
  }
}
