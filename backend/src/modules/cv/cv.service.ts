import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository } from 'typeorm';
import { Cv } from './entities/cv.entity';
import { Skill } from '../skill/entities/skill.entity';
import { Project } from '../project/entities/project.entity';
import { Experience } from '../experience/entities/experience.entity';
import { Education } from '../education/entities/education.entity';
import { Language } from '../language/entities/language.entity';
import { Passion } from '../passion/entities/passion.entity';
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
    @InjectRepository(Category) private categoryRepo: Repository<Category>,
  ) {}

  findAll() {
    return this.repo.find({ order: { createdAt: 'DESC' } });
  }

  async findOne(id: string) {
    const cv = await this.repo.findOne({ where: { id } });
    if (!cv) throw new NotFoundException('CV not found');
    return cv;
  }

  create(dto: CreateCvDto) {
    return this.repo.save(this.repo.create(dto));
  }

  async update(id: string, dto: UpdateCvDto) {
    const cv = await this.findOne(id);
    Object.assign(cv, dto);
    return this.repo.save(cv);
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
