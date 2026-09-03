import { Controller, Post, Get, Body } from '@nestjs/common';
import { ApiTags, ApiOperation, ApiBearerAuth } from '@nestjs/swagger';
import { AiService } from './ai.service';
import { GenerateCvDto } from './dto/generate-cv.dto';
import { ApplySuggestionsDto } from './dto/apply-suggestions.dto';

@ApiTags('AI')
@ApiBearerAuth()
@Controller('api/ai')
export class AiController {
  constructor(private readonly aiService: AiService) {}

  @Post('generate-cv')
  @ApiOperation({ summary: 'Generate a tailored CV from a job offer via LLM' })
  generateCv(@Body() dto: GenerateCvDto) {
    return this.aiService.generateCv(dto);
  }

  @Post('apply-suggestions')
  @ApiOperation({ summary: 'Persist AI-generated skill and bullet suggestions' })
  applySuggestions(@Body() dto: ApplySuggestionsDto) {
    return this.aiService.applySuggestions(dto);
  }

  @Get('status')
  @ApiOperation({ summary: 'Check Ollama LLM availability' })
  getStatus() {
    return this.aiService.getStatus();
  }
}
