import { Controller, Post, Body, HttpCode, HttpStatus, ForbiddenException } from '@nestjs/common';
import { ApiTags, ApiOperation } from '@nestjs/swagger';
import { AuthService } from './auth.service';
import { RegisterDto } from './dto/register.dto';
import { LoginDto } from './dto/login.dto';
import { Public } from '../../common/decorators/public.decorator';

@ApiTags('Authentication')
@Controller('api/auth')
export class AuthController {
  constructor(private authService: AuthService) {}

  @Post('register')
  @HttpCode(HttpStatus.FORBIDDEN)
  @ApiOperation({ summary: 'Register a new user' })
  register(@Body() dto: RegisterDto) {
    throw new ForbiddenException('Registration is disabled');
  }

  @Public()
  @Post('login')
  @HttpCode(HttpStatus.OK)
  @ApiOperation({ summary: 'Login and get JWT token' })
  async login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }
}
