import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { CvModule } from '../cv/cv.module';
import { Profile } from '../profile/entities/profile.entity';
import { CvRenderController } from './cv-render.controller';
import { PdfService } from './pdf.service';
import { RenderService } from './render.service';
import { StylesService } from './styles/styles.service';

/**
 * CV rendering module (HTML + PDF).
 *
 * - CvService is consumed from CvModule via lazy global ModuleRef resolution
 *   (CvModule does not export CvService yet — see render.service.ts).
 * - ProfileService is not exported by ProfileModule either, so the Profile
 *   repository is registered locally with TypeOrmModule.forFeature.
 *
 * Note: in app.module.ts this module must be imported BEFORE CvModule so that
 * the static `GET /api/cv/styles` route is registered before CvController's
 * `GET /api/cv/:id` param route (Express matches routes in registration
 * order; otherwise `styles` would be captured as a CV id).
 */
@Module({
  imports: [TypeOrmModule.forFeature([Profile]), CvModule],
  controllers: [CvRenderController],
  providers: [StylesService, RenderService, PdfService],
})
export class CvRenderModule {}
