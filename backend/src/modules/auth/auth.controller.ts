import { Controller, Post, Body, UseGuards, Request } from '@nestjs/common';
import { AuthService } from './auth.service';
import { LocalAuthGuard } from './guards/local-auth.guard';
import * as bcrypt from 'bcryptjs';
import { JwtAuthGuard } from './guards/jwt-auth.guard';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Post('register')
  async register(@Body() body: any) {
    const hashedPassword = await bcrypt.hash(body.password, 10);
    const user = this.authService.userRepository.create({
      username: body.username,
      password: hashedPassword,
    });
    await this.authService.userRepository.save(user);
    return { message: 'User registered successfully' };
  }

  @Post('login')
  @UseGuards(LocalAuthGuard)
  async login(@Request() req) {
    return this.authService.generateTokens(req.user);
  }

  @Post('refresh')
  //@UseGuards(JwtAuthGuard)
  async refresh(@Body() body: any) {
    return this.authService.refreshTokens(body.refreshToken);
  }
}