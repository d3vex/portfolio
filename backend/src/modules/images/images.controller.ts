import { Controller, Get, Post, Param, Res, UseInterceptors, UploadedFile, ParseFilePipe, MaxFileSizeValidator } from '@nestjs/common';
import { FileInterceptor } from '@nestjs/platform-express';
import { ApiTags, ApiOperation, ApiConsumes } from '@nestjs/swagger';
import { Response } from 'express';
import { ImagesService } from './images.service';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Images')
@Controller('api/images')
export class ImagesController {
  constructor(private service: ImagesService) {}

  @Post('upload')
  @ApiConsumes('multipart/form-data')
  @ApiOperation({ summary: 'Upload an image' })
  @UseInterceptors(FileInterceptor('file'))
  async upload(
    @UploadedFile(
      new ParseFilePipe({
        validators: [new MaxFileSizeValidator({ maxSize: 15 * 1024 * 1024 })],
      }),
    )
    file: Express.Multer.File,
  ) {
    const image = await this.service.create(file.buffer, file.mimetype, file.originalname);
    return { id: image.id, url: `/api/images/${image.id}` };
  }

  @Get()
  @ApiOperation({ summary: 'List all images (metadata only)' })
  async getAll() {
    return this.service.findAll();
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Get image by id' })
  async get(@Param('id') id: string, @Res() res: Response) {
    const image = await this.service.findOne(id);
    res.setHeader('Content-Type', image.mimeType);
    res.setHeader('Content-Length', image.size.toString());
    res.setHeader('Cache-Control', 'public, max-age=31536000');
    res.send(image.data);
  }
}
