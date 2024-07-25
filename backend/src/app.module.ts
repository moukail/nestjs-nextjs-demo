import { Module } from '@nestjs/common';
import { TypeOrmModule } from '@nestjs/typeorm';
import { AppController } from './modules/app/app.controller';
import { AppService } from './modules/app/app.service';
import { User } from './database/entities/user.entity';
import { RefreshToken } from './database/entities/refresh-token.entity';
import { AuthModule } from './modules/auth/auth.module';
import { AuthController } from './auth/auth.controller';
import { AuthService } from './auth/auth.service';
import { UserModule } from './user/user.module';

@Module({
  imports: [
    TypeOrmModule.forRoot({
      type: 'postgres',
      host: 'database',
      port: 5432,
      username: 'myuser',
      password: 'secret',
      database: 'mydatabase',
      entities: [User, RefreshToken],
      synchronize: true, // Use only in development
    }),
    AuthModule,
    UserModule,
  ],
  controllers: [AppController, AuthController],
  providers: [AppService, AuthService],
})
export class AppModule {}
