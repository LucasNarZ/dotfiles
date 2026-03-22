---
name: nestjs-error-handling
description: Implement global exception filters and custom exceptions for consistent error responses
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create global exception filters for consistent JSON error responses
- Implement domain-specific custom exceptions
- Log errors with appropriate severity levels
- Handle both HttpException and generic exceptions

## When to use me

Use this for error handling in production-ready NestJS applications. Combine with Winston logging for comprehensive error tracking.

## Global Exception Filter

```typescript
import { ExceptionFilter, Catch, ArgumentsHost, HttpException, HttpStatus, Logger } from '@nestjs/common';
import { Request, Response } from 'express';

@Catch()
export class GlobalFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const res = ctx.getResponse<Response>();
    const req = ctx.getRequest<Request>();

    let status = HttpStatus.INTERNAL_SERVER_ERROR;
    let message = 'Internal server error';

    if (exception instanceof HttpException) {
      status = exception.getStatus();
      const exceptionResponse = exception.getResponse();
      message = typeof exceptionResponse === 'string' 
        ? exceptionResponse 
        : (exceptionResponse as any).message || message;
    }

    const logLevel = status >= 500 ? 'error' : 'warn';
    this.logger[logLevel](`${req.method} ${req.url} - Status: ${status}`, exception);

    res.status(status).json({
      statusCode: status,
      timestamp: new Date().toISOString(),
      path: req.url,
      message,
    });
  }
}
```

## Custom Exceptions

```typescript
import { HttpException, HttpStatus } from '@nestjs/common';

export class UserNotFoundException extends HttpException {
  constructor(id?: string) {
    super(
      `User ${id ? `with ID ${id}` : ''} not found`,
      HttpStatus.NOT_FOUND,
    );
  }
}

export class InvalidPasswordEmailException extends HttpException {
  constructor() {
    super('Invalid email or password', HttpStatus.UNAUTHORIZED);
  }
}

export class UniqueConstraintException extends HttpException {
  constructor(field: string) {
    super(`${field} already exists`, HttpStatus.BAD_REQUEST);
  }
}
```

## Register Global Filter

```typescript
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';
import { GlobalFilter } from './filters/globalFilter.filter';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalFilters(new GlobalFilter());
  
  await app.listen(3000);
}
bootstrap();
```

## Using Custom Exceptions

```typescript
import { Injectable } from '@nestjs/common';
import { Inject } from '@nestjs/common';
import { UserNotFoundException } from 'src/exceptions/UserNotFound.exception';
import { usersRepositoryToken } from './users.providers';
import { User } from './user.entity';

@Injectable()
export class UsersService {
  constructor(
    @Inject(usersRepositoryToken) private usersRepository: typeof User,
  ) {}

  async findOne(id: string): Promise<User> {
    const user = await this.usersRepository.findByPk(id);
    if (!user) {
      throw new UserNotFoundException(id);
    }
    return user;
  }

  async findByEmail(email: string): Promise<User | null> {
    return this.usersRepository.findOne({ where: { email } });
  }
}
```

## Common HttpStatus Codes

| Code | Name | Use Case |
|------|------|----------|
| 400 | BAD_REQUEST | Validation errors |
| 401 | UNAUTHORIZED | Missing/invalid auth |
| 403 | FORBIDDEN | Insufficient permissions |
| 404 | NOT_FOUND | Resource not found |
| 409 | CONFLICT | Duplicate resource |
| 500 | INTERNAL_SERVER_ERROR | Unexpected errors |
