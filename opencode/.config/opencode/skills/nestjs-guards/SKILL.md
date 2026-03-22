---
name: nestjs-guards
description: Implement AuthGuard, AdminGuard, and custom guards for role-based access control
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create AuthGuard for JWT token verification
- Implement AdminGuard for admin-only routes
- Build RolesGuard for role-based access control (RBAC)
- Provide decorator utilities for specifying required roles

## When to use me

Use this for implementing authorization and access control. Combine with nestjs-authentication for complete auth solution.

## AuthGuard

```typescript
import { Injectable, CanActivate, ExecutionContext, UnauthorizedException, Inject } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { Request } from 'express';
import { extractTokenFromCookie } from 'src/utils/jwt.util';

@Injectable()
export class AuthGuard implements CanActivate {
  constructor(private jwtService: JwtService) {}

  async canActivate(context: ExecutionContext): Promise<boolean> {
    const request = context.switchToHttp().getRequest<Request>();
    const token = extractTokenFromCookie(request);

    if (!token) {
      throw new UnauthorizedException('No token provided');
    }

    try {
      const payload = await this.jwtService.verifyAsync(token);
      request['user'] = payload;
    } catch {
      throw new UnauthorizedException('Invalid or expired token');
    }

    return true;
  }
}
```

## AdminGuard

```typescript
import { Injectable, CanActivate, ExecutionContext, ForbiddenException } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

export const IS_ADMIN_KEY = 'isAdmin';

@Injectable()
export class AdminGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const isAdmin = this.reflector.getAllAndOverride<boolean>(IS_ADMIN_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!isAdmin) {
      return true; // Not marked as admin-only, allow
    }

    const request = context.switchToHttp().getRequest();
    const user = request.user;

    if (!user || !user.isAdmin) {
      throw new ForbiddenException('Admin access required');
    }

    return true;
  }
}
```

## RolesGuard

```typescript
import { Injectable, CanActivate, ExecutionContext } from '@nestjs/common';
import { Reflector } from '@nestjs/core';

export const ROLES_KEY = 'roles';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const requiredRoles = this.reflector.getAllAndOverride<string[]>(ROLES_KEY, [
      context.getHandler(),
      context.getClass(),
    ]);

    if (!requiredRoles) {
      return true;
    }

    const { user } = context.switchToHttp().getRequest();
    
    if (!user) {
      return false;
    }

    return requiredRoles.some((role) => user.roles?.includes(role));
  }
}
```

## Role Decorators

```typescript
import { SetMetadata } from '@nestjs/common';
import { ROLES_KEY } from './roles.guard';
import { IS_ADMIN_KEY } from './admin.guard';

export const Roles = (...roles: string[]) => SetMetadata(ROLES_KEY, roles);

export const Admin = () => SetMetadata(IS_ADMIN_KEY, true);
```

## Using Guards in Controller

```typescript
import { Controller, Get, Post, UseGuards } from '@nestjs/common';
import { AuthGuard } from 'src/auth/guards/auth.guard';
import { AdminGuard, Admin } from 'src/auth/guards/admin.guard';
import { RolesGuard, Roles } from 'src/auth/guards/roles.guard';

@Controller('posts')
@UseGuards(AuthGuard)
export class PostsController {
  @Get()
  @UseGuards(RolesGuard)
  @Roles('user', 'admin')
  findAll() {
    return [];
  }

  @Post()
  @UseGuards(AdminGuard)
  @Admin()
  create() {
    return { created: true };
  }

  @Get('admin-only')
  @UseGuards(AuthGuard, AdminGuard)
  adminEndpoint() {
    return { admin: true };
  }
}
```

## Accessing User in Controller

```typescript
import { Controller, Get, Request, UseGuards } from '@nestjs/common';
import { AuthGuard } from 'src/auth/guards/auth.guard';

@Controller('profile')
@UseGuards(AuthGuard)
export class ProfileController {
  @Get()
  getProfile(@Request() req: any) {
    return {
      userId: req.user.sub,
      email: req.user.email,
      isAdmin: req.user.isAdmin,
    };
  }
}
```
