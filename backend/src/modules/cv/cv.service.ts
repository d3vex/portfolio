import { Injectable, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Repository, In } from 'typeorm';
import { Cv } from './entities/cv.entity';
import { CvSkill } from './entities/cv-skill.entity';
import { CvProject } from './entities/cv-project.entity';
import { CvPassion } from './entities/cv-passion.entity';
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

type OrderedCv = Omit<Cv, 'skillLinks' | 'projectLinks' | 'passionLinks'> & {
  skills: Skill[];
  projects: Project[];
  passions: Passion[];
};

@Injectable()
export class CvService {
  constructor(
    @InjectRepository(Cv) private repo: Repository<Cv>,
    @InjectRepository(CvSkill) private cvSkillRepo: Repository<CvSkill>,
    @InjectRepository(CvProject) private cvProjectRepo: Repository<CvProject>,
    @InjectRepository(CvPassion) private cvPassionRepo: Repository<CvPassion>,
    @InjectRepository(Skill) private skillRepo: Repository<Skill>,
    @InjectRepository(Project) private projectRepo: Repository<Project>,
    @InjectRepository(Experience) private experienceRepo: Repository<Experience>,
    @InjectRepository(Education) private educationRepo: Repository<Education>,
    @InjectRepository(Language) private languageRepo: Repository<Language>,
    @InjectRepository(Passion) private passionRepo: Repository<Passion>,
    @InjectRepository(Contact) private contactRepo: Repository<Contact>,
    @InjectRepository(Category) private categoryRepo: Repository<Category>,
  ) {}

  async findAll(): Promise<OrderedCv[]> {
    const cvs = await this.repo.find({
      relationLoadStrategy: 'query',
      relations: {
        skillLinks: { skill: true },
        projectLinks: { project: { projectPoints: true } },
        passionLinks: { passion: true },
        languages: true,
        experiences: { experiencePoints: true },
        education: true,
        contacts: true,
      },
      order: {
        createdAt: 'DESC',
      },
    });
    return cvs.map((cv) => this.applyOrdering(cv));
  }

  async findOne(id: string): Promise<OrderedCv> {
    const cv = await this.repo.findOne({
      where: { id },
      relationLoadStrategy: 'query',
      relations: {
        skillLinks: { skill: true },
        projectLinks: { project: { projectPoints: true } },
        passionLinks: { passion: true },
        languages: true,
        experiences: { experiencePoints: true },
        education: true,
        contacts: true,
      },
    });
    if (!cv) throw new NotFoundException('CV not found');
    return this.applyOrdering(cv);
  }

  async create(dto: CreateCvDto) {
    const { skillIds, languageIds, passionIds, experienceIds, projectIds, educationIds, contactIds, ...rest } = dto;
    const entity = this.repo.create(rest);
    entity.languages = languageIds?.length ? await this.languageRepo.findBy({ id: In(languageIds) }) : [];
    entity.experiences = experienceIds?.length ? await this.experienceRepo.findBy({ id: In(experienceIds) }) : [];
    entity.education = educationIds?.length ? await this.educationRepo.findBy({ id: In(educationIds) }) : [];
    entity.contacts = contactIds?.length ? await this.contactRepo.findBy({ id: In(contactIds) }) : [];
    const saved = await this.repo.save(entity);

    if (skillIds?.length) {
      const links = skillIds.map((skillId, i) => this.cvSkillRepo.create({ cvId: saved.id, skillId, order: i }));
      await this.cvSkillRepo.save(links);
    }
    if (projectIds?.length) {
      const links = projectIds.map((projectId, i) => this.cvProjectRepo.create({ cvId: saved.id, projectId, order: i }));
      await this.cvProjectRepo.save(links);
    }
    if (passionIds?.length) {
      const links = passionIds.map((passionId, i) => this.cvPassionRepo.create({ cvId: saved.id, passionId, order: i }));
      await this.cvPassionRepo.save(links);
    }

    return this.findOne(saved.id);
  }

  async update(id: string, dto: UpdateCvDto) {
    const entity = await this.findOne(id);
    const { skillIds, languageIds, passionIds, experienceIds, projectIds, educationIds, contactIds, ...rest } = dto;
    Object.assign(entity, rest);
    if (languageIds !== undefined) entity.languages = languageIds?.length ? await this.languageRepo.findBy({ id: In(languageIds) }) : [];
    if (experienceIds !== undefined) entity.experiences = experienceIds?.length ? await this.experienceRepo.findBy({ id: In(experienceIds) }) : [];
    if (educationIds !== undefined) entity.education = educationIds?.length ? await this.educationRepo.findBy({ id: In(educationIds) }) : [];
    if (contactIds !== undefined) entity.contacts = contactIds?.length ? await this.contactRepo.findBy({ id: In(contactIds) }) : [];
    await this.repo.save(entity);

    if (skillIds !== undefined) {
      await this.cvSkillRepo.delete({ cvId: id });
      if (skillIds.length) {
        const links = skillIds.map((skillId, i) => this.cvSkillRepo.create({ cvId: id, skillId, order: i }));
        await this.cvSkillRepo.save(links);
      }
    }
    if (projectIds !== undefined) {
      await this.cvProjectRepo.delete({ cvId: id });
      if (projectIds.length) {
        const links = projectIds.map((projectId, i) => this.cvProjectRepo.create({ cvId: id, projectId, order: i }));
        await this.cvProjectRepo.save(links);
      }
    }
    if (passionIds !== undefined) {
      await this.cvPassionRepo.delete({ cvId: id });
      if (passionIds.length) {
        const links = passionIds.map((passionId, i) => this.cvPassionRepo.create({ cvId: id, passionId, order: i }));
        await this.cvPassionRepo.save(links);
      }
    }

    return this.findOne(id);
  }

  async clone(id: string) {
    const original = await this.findOne(id);
    const entity = this.repo.create({
      name: `${original.name} (Copie)`,
      candidateName: original.candidateName,
      specialization: original.specialization,
      titleOverride: original.titleOverride,
      aboutText: original.aboutText,
      availability: original.availability,
      pictureId: original.pictureId,
      projectBullets: original.projectBullets,
      style: original.style,
      isDefault: false,
    });
    entity.languages = original.languages || [];
    entity.experiences = original.experiences || [];
    entity.education = original.education || [];
    entity.contacts = original.contacts || [];
    const saved = await this.repo.save(entity);

    const [skillLinks, projectLinks, passionLinks] = await Promise.all([
      this.cvSkillRepo.find({ where: { cvId: id }, order: { order: 'ASC' } }),
      this.cvProjectRepo.find({ where: { cvId: id }, order: { order: 'ASC' } }),
      this.cvPassionRepo.find({ where: { cvId: id }, order: { order: 'ASC' } }),
    ]);
    if (skillLinks.length) {
      const links = skillLinks.map((l) => this.cvSkillRepo.create({ cvId: saved.id, skillId: l.skillId, order: l.order }));
      await this.cvSkillRepo.save(links);
    }
    if (projectLinks.length) {
      const links = projectLinks.map((l) => this.cvProjectRepo.create({ cvId: saved.id, projectId: l.projectId, order: l.order }));
      await this.cvProjectRepo.save(links);
    }
    if (passionLinks.length) {
      const links = passionLinks.map((l) => this.cvPassionRepo.create({ cvId: saved.id, passionId: l.passionId, order: l.order }));
      await this.cvPassionRepo.save(links);
    }

    return this.findOne(saved.id);
  }

  async remove(id: string) {
    const cv = await this.repo.findOne({ where: { id } });
    if (!cv) throw new NotFoundException('CV not found');
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

  private applyOrdering(cv: Cv): OrderedCv {
    const { skillLinks = [], projectLinks = [], passionLinks = [], ...rest } = cv;
    const byOrder = (a: { order: number }, b: { order: number }) => a.order - b.order;
    return {
      ...rest,
      skills: skillLinks.slice().sort(byOrder).map((l) => l.skill),
      projects: projectLinks.slice().sort(byOrder).map((l) => l.project),
      passions: passionLinks.slice().sort(byOrder).map((l) => l.passion),
    };
  }
}
