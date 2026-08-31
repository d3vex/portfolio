import {
  Body,
  Controller,
  Get,
  Param,
  Post,
  Query,
  Req,
  Res,
} from '@nestjs/common';
import { ApiOperation, ApiProduces, ApiTags } from '@nestjs/swagger';
import { Request, Response } from 'express';
import { Public } from '../../common/decorators/public.decorator';
import { ExportCvDto } from './dto/export-cv.dto';
import { PdfService } from './pdf.service';
import { RenderService } from './render.service';
import { StylesService } from './styles/styles.service';

@ApiTags('CV Rendering')
@Controller('api/cv')
export class CvRenderController {
  constructor(
    private readonly styles: StylesService,
    private readonly render: RenderService,
    private readonly pdf: PdfService,
  ) {}

  @Public()
  @Get('styles')
  @ApiOperation({ summary: 'List available CV render styles' })
  listStyles() {
    return this.styles.list();
  }

  @Public()
  @Get(':id/render')
  @ApiOperation({ summary: 'Render a CV as a standalone HTML document' })
  @ApiProduces('text/html')
  async renderCv(
    @Param('id') id: string,
    @Query('style') style: string | undefined,
    @Query('zoom') zoom: string | undefined,
    @Req() req: Request,
    @Res() res: Response,
  ) {
    const zoomValue = parseZoom(zoom);
    const { html } = await this.render.renderHtml(
      id,
      style,
      this.buildBaseUrl(req),
      zoomValue,
    );
    res.set({ 'Content-Type': 'text/html; charset=utf-8' });
    res.send(html);
  }

  @Public()
  @Post(':id/export')
  @ApiOperation({ summary: 'Export a CV as a PDF attachment' })
  @ApiProduces('application/pdf')
  async exportCv(
    @Param('id') id: string,
    @Body() dto: ExportCvDto,
    @Req() req: Request,
    @Res() res: Response,
  ) {
    const { html, displayName, styleId } = await this.render.renderHtml(
      id,
      dto.style,
      this.buildBaseUrl(req),
      dto.zoom,
    );
    const pdf = await this.pdf.render(html);
    const filename = `${displayName || 'CV'}-${styleId}.pdf`
      .replace(/["\\\r\n]+/g, '')
      .replace(/\s+/g, '-');
    res.set({
      'Content-Type': 'application/pdf',
      'Content-Disposition': `attachment; filename="${filename}"`,
      'Content-Length': pdf.length.toString(),
    });
    res.end(pdf);
  }

  private buildBaseUrl(req: Request): string {
    return `${req.protocol}://${req.get('host')}`;
  }
}

function parseZoom(raw: string | undefined): number | undefined {
  if (raw === undefined || raw === '') return undefined;
  const value = Number(raw);
  if (Number.isNaN(value)) return undefined;
  return Math.min(2, Math.max(0.5, value));
}
