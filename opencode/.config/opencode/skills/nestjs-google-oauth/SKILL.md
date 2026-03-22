---
name: nestjs-google-oauth
description: Implement Google OAuth authentication in NestJS using google-auth-library
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Verify Google OAuth ID tokens using google-auth-library
- Find or create users from Google account data
- Link Google accounts to existing users
- Generate JWT tokens after successful Google authentication

## When to use me

Use this when adding Google Sign-In to your application. Combine with nestjs-authentication for complete auth flow.

## Google Auth Service

```typescript
import { Injectable, Logger } from '@nestjs/common';
import { OAuth2Client } from 'google-auth-library';
import { ConfigService } from '@nestjs/config';

export interface GoogleUser {
  email: string;
  name: string;
  picture?: string;
  googleId: string;
}

@Injectable()
export class GoogleAuthService {
  private readonly logger = new Logger(GoogleAuthService.name);
  private client: OAuth2Client;

  constructor(private configService: ConfigService) {
    this.client = new OAuth2Client(this.configService.get('GOOGLE_CLIENT_ID'));
  }

  async verifyGoogleToken(idToken: string): Promise<GoogleUser> {
    try {
      const ticket = await this.client.verifyIdToken({
        idToken,
        audience: this.configService.get('GOOGLE_CLIENT_ID'),
      });

      const payload = ticket.getPayload();

      if (!payload) {
        throw new Error('Invalid token payload');
      }

      return {
        email: payload.email,
        name: payload.name,
        picture: payload.picture,
        googleId: payload.sub,
      };
    } catch (error) {
      this.logger.error('Failed to verify Google token', error);
      throw new Error('Invalid Google token');
    }
  }

  async findOrCreateUser(googleUser: GoogleUser) {
    let user = await this.userService.findByGoogleId(googleUser.googleId);

    if (!user) {
      user = await this.userService.findByEmail(googleUser.email);

      if (user) {
        user.googleId = googleUser.googleId;
        user.profileImgUrl = googleUser.picture || user.profileImgUrl;
        await user.save();
      } else {
        user = await this.userService.createFromGoogle(googleUser);
      }
    }

    return user;
  }
}
```

## Google Auth Controller

```typescript
import { Controller, Post, Body, Res, UseGuards } from '@nestjs/common';
import { Response } from 'express';
import { GoogleAuthService } from './googleAuth.service';
import { TokenService } from './token.service';

@Controller('auth/google')
export class GoogleAuthController {
  constructor(
    private readonly googleAuthService: GoogleAuthService,
    private readonly tokenService: TokenService,
  ) {}

  @Post()
  async googleLogin(
    @Body('idToken') idToken: string,
    @Res({ passthrough: true }) res: Response,
  ) {
    const googleUser = await this.googleAuthService.verifyGoogleToken(idToken);
    const user = await this.googleAuthService.findOrCreateUser(googleUser);

    const accessToken = await this.tokenService.generateAccessToken(user.id, user.email);
    const refreshToken = await this.tokenService.generateRefreshToken(user.id);

    await this.redisService.storeRefreshToken(user.id, refreshToken);

    res.cookie('access_token', accessToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      maxAge: 15 * 60 * 1000,
    });

    res.cookie('refresh_token', refreshToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'strict',
      maxAge: 15 * 24 * 60 * 60 * 1000,
    });

    return { user: { id: user.id, name: user.name, email: user.email } };
  }
}
```

## User Service Methods

```typescript
import { Injectable } from '@nestjs/common';
import { Inject } from '@nestjs/common';
import { User } from './user.entity';
import { usersRepositoryToken } from './users.providers';
import { GoogleUser } from 'src/auth/googleAuth.service';

@Injectable()
export class UsersService {
  constructor(
    @Inject(usersRepositoryToken) private usersRepository: typeof User,
  ) {}

  async findByGoogleId(googleId: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { googleId } });
  }

  async createFromGoogle(googleUser: GoogleUser): Promise<User> {
    const slug = this.generateSlug(googleUser.name);

    return this.usersRepository.create({
      name: googleUser.name,
      email: googleUser.email,
      slug,
      googleId: googleUser.googleId,
      profileImgUrl: googleUser.picture || 'https://default-avatar.png',
    });
  }

  private generateSlug(name: string): string {
    const baseSlug = name
      .toLowerCase()
      .replace(/[^a-z0-9]+/g, '-')
      .replace(/(^-|-$)/g, '');
    return `${baseSlug}-${Date.now()}`;
  }
}
```

## LoginGoogleDto

```typescript
import { IsString, IsNotEmpty } from 'class-validator';

export class LoginGoogleDto {
  @IsString()
  @IsNotEmpty()
  idToken: string;
}
```

## Google Console Setup

1. Go to Google Cloud Console (console.cloud.google.com)
2. Create a new project or select existing
3. Go to APIs & Services > Credentials
4. Create OAuth 2.0 Client ID
5. Configure authorized origins:
   - http://localhost:3000 (development)
   - https://yourdomain.com (production)
6. Copy Client ID and Client Secret

## Environment Variables

```bash
GOOGLE_CLIENT_ID=your-google-client-id.apps.googleusercontent.com
GOOGLE_CLIENT_SECRET=your-google-client-secret
```

## Installation

```bash
npm install google-auth-library
```
