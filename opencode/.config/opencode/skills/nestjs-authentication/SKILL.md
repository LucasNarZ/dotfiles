---
name: nestjs-authentication
description: Implement JWT + refresh token authentication with HTTP-only cookies, guards, and decorators
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Implement JWT authentication with access and refresh tokens
- Store tokens in HTTP-only secure cookies
- Create AuthGuard for route protection
- Provide CurrentUser decorator for accessing authenticated user
- Generate tokens with configurable expiration times

## When to use me

Use this when implementing user authentication in NestJS. Consider combining with guards for role-based access control.

## JWT Utility

```typescript
import { Request } from 'express';

export const extractTokenFromCookie = (req: Request, cookieName: string = 'access_token'): string | null => {
  return req.cookies?.[cookieName] || null;
};

export const extractTokenFromHeader = (req: Request): string | null => {
  const [type, token] = req.headers.authorization?.split(' ') || [];
  return type === 'Bearer' ? token : null;
};
```

## AuthGuard

```typescript
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';
import { extractTokenFromCookie } from 'src/utils/jwt.util';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const req = context.switchToHttp().getRequest<Request>();
    const token = extractTokenFromCookie(req);

    if (!token) {
      throw new UnauthorizedException('No token provided');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token);
      req['user'] = payload;
    } catch {
      throw new UnauthorizedException('Invalid token');
    }

    return true;
  }
}
```

## Token Service

```typescript
import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Injectable()
export class TokenService {
  constructor(
    private jwtService: JwtService,
    private configService: ConfigService,
  ) {}

  async generateAccessToken(userId: string, email: string): Promise<string> {
    return this.jwtService.signAsync(
      { sub: userId, email },
      { secret: this.configService.get('JWT_ACCESS_SECRET'), expiresIn: '15m' },
    );
  }

  async generateRefreshToken(userId: string): Promise<string> {
    return this.jwtService.signAsync(
      { sub: userId },
      { secret: this.configService.get('JWT_REFRESH_SECRET'), expiresIn: '15d' },
    );
  }
}
```

## Setting HTTP-only Cookies

```typescript
@Post('login')
async login(@Body() loginDto: LoginDto, @Res({ passthrough: true }) res: Response) {
  const user = await this.authService.validateUser(loginDto.email, loginDto.password);
  const accessToken = await this.tokenService.generateAccessToken(user.id, user.email);
  const refreshToken = await this.tokenService.generateRefreshToken(user.id);

  await this.redisService.storeRefreshToken(user.id, refreshToken);

  res.cookie('access_token', accessToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 15 * 60 * 1000, // 15 minutes
  });

  res.cookie('refresh_token', refreshToken, {
    httpOnly: true,
    secure: true,
    sameSite: 'strict',
    maxAge: 15 * 24 * 60 * 60 * 1000, // 15 days
  });

  return { user };
}
```

## CurrentUser Decorator

```typescript
import { createParamDecorator, ExecutionContext } from '@nestjs/common';

export const CurrentUser = createParamDecorator(
  (data: unknown, ctx: ExecutionContext) => {
    const request = ctx.switchToHttp().getRequest();
    return request.user;
  },
);
```

## Using Guard and Decorator

```typescript
import { UseGuards } from '@nestjs/common';
import { AuthGuard } from 'src/auth/guards/auth.guard';
import { CurrentUser } from 'src/decorators/current-user.decorator';

@Controller('profile')
@UseGuards(AuthGuard)
export class ProfileController {
  @Get()
  getProfile(@CurrentUser() user: any) {
    return { userId: user.sub, email: user.email };
  }
}
```

## Module Configuration

```typescript
import { JwtModule } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';

@Module({
  imports: [
    JwtModule.registerAsync({
      inject: [ConfigService],
      useFactory: (config: ConfigService) => ({
        secret: config.get('JWT_ACCESS_SECRET'),
        signOptions: { expiresIn: '15m' },
      }),
    }),
  ],
})
export class AuthModule {}
```

## Installation

```bash
npm install @nestjs/jwt @nestjs/config
```
