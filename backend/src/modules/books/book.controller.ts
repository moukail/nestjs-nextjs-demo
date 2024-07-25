import { Controller, Get, UseGuards } from '@nestjs/common';
import { JwtAuthGuard } from '../auth/guards/jwt-auth.guard';

@Controller('books')
export class BookController {

  @Get()
  @UseGuards(JwtAuthGuard)
  getBooks() {
    return { message: 'This is protected data' };
  }
}
