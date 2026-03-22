---
name: nestjs-winston-logging
description: Set up Winston structured JSON logging with timestamps and log levels
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Configure Winston logger with JSON format
- Add timestamps to all log entries
- Support multiple transport targets (console, files)
- Provide colored output for development

## When to use me

Use this for production-ready logging. Combine with nestjs-error-handling for comprehensive error tracking.

## Winston Logger Configuration

```typescript
import { WinstonModule } from 'nest-winston';
import * as winston from 'winston';

export const logger = WinstonModule.createLogger({
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.timestamp(),
        winston.format.json(),
      ),
    }),
  ],
});

export const loggerWithColor = WinstonModule.createLogger({
  transports: [
    new winston.transports.Console({
      format: winston.format.combine(
        winston.format.colorize(),
        winston.format.timestamp({ format: 'YYYY-MM-DD HH:mm:ss' }),
        winston.format.printf(({ timestamp, level, message, context, ...meta }) => {
          return `${timestamp} [${context || 'App'}] ${level}: ${message} ${Object.keys(meta).length ? JSON.stringify(meta) : ''}`;
        }),
      ),
    }),
  ],
});
```

## Logger Module

```typescript
import { Module, Global } from '@nestjs/common';
import { logger, loggerWithColor } from './logger';

@Global()
@Module({
  providers: [
    { provide: 'WINSTON_LOGGER', useValue: logger },
    { provide: 'COLOR_LOGGER', useValue: loggerWithColor },
  ],
  exports: ['WINSTON_LOGGER', 'COLOR_LOGGER'],
})
export class LoggerModule {}
```

## Using Logger in Services

```typescript
import { Injectable, Logger } from '@nestjs/common';

@Injectable()
export class UsersService {
  private readonly logger = new Logger(UsersService.name);

  async findOne(id: string) {
    this.logger.log(`Finding user with id: ${id}`, UsersService.name);
    
    try {
      const user = await this.usersRepository.findByPk(id);
      if (!user) {
        this.logger.warn(`User not found: ${id}`, UsersService.name);
        return null;
      }
      this.logger.log(`User found: ${id}`, UsersService.name);
      return user;
    } catch (error) {
      this.logger.error(`Error finding user: ${error.message}`, error.stack, UsersService.name);
      throw error;
    }
  }
}
```

## Logging in Exception Filters

```typescript
@Catch()
export class GlobalFilter implements ExceptionFilter {
  private readonly logger = new Logger(GlobalFilter.name);

  catch(exception: unknown, host: ArgumentsHost) {
    const ctx = host.switchToHttp();
    const req = ctx.getRequest<Request>();
    const status = exception instanceof HttpException 
      ? exception.getStatus() 
      : HttpStatus.INTERNAL_SERVER_ERROR;

    const logLevel = status >= 500 ? 'error' : 'warn';
    this.logger[logLevel](`${req.method} ${req.url} - ${status}`, exception);
  }
}
```

## Log Levels

| Level | Use Case |
|-------|----------|
| error | Errors requiring immediate attention |
| warn | Potential issues or degraded behavior |
| log | General information |
| debug | Detailed debugging information (development) |

## Installation

```bash
npm install winston nest-winston
```
