---
name: nestjs-dto-validation
description: Create DTOs with class-validator decorators and set up global ValidationPipe
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create DTOs with class-validator decorators for input validation
- Configure global ValidationPipe with whitelist and transform options
- Support query parameters, body, and path validation
- Use class-transformer for object transformation

## When to use me

Use this when validating user input in NestJS controllers. Combine with swagger-docs for API documentation.

## DTO with Validation

```typescript
import { IsString, IsNotEmpty, IsEmail, IsOptional, IsUUID, MinLength, MaxLength, IsInt } from 'class-validator';
import { Expose } from 'class-transformer';

export class Create{Module}Dto {
  @IsString()
  @IsNotEmpty()
  @MinLength(2)
  @MaxLength(100)
  name: string;

  @IsEmail()
  @IsNotEmpty()
  email: string;

  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;
}

export class Update{Module}Dto {
  @IsOptional()
  @IsString()
  @MinLength(2)
  @MaxLength(100)
  name?: string;

  @IsOptional()
  @IsString()
  @MaxLength(500)
  bio?: string;
}

export class {Module}QueryDto {
  @IsOptional()
  @IsString()
  search?: string;

  @IsOptional()
  @IsInt()
  @Min(1)
  page?: number;

  @IsOptional()
  @IsInt()
  @Min(1)
  @Max(100)
  limit?: number;
}
```

## Global ValidationPipe

```typescript
import { ValidationPipe } from '@nestjs/common';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);
  
  app.useGlobalPipes(
    new ValidationPipe({
      whitelist: true,           // Strip properties not in DTO
      forbidNonWhitelisted: true, // Throw error on unknown properties
      transform: true,            // Transform payload to DTO instances
      transformOptions: {
        enableImplicitConversion: true,
      },
    }),
  );
  
  await app.listen(3000);
}
bootstrap();
```

## Common Validators

| Decorator | Purpose |
|-----------|---------|
| `@IsString()` | Value must be a string |
| `@IsNumber()` | Value must be a number |
| `@IsEmail()` | Valid email format |
| `@IsUUID()` | Valid UUID format |
| `@IsNotEmpty()` | Value cannot be empty |
| `@IsOptional()` | Field can be undefined |
| `@MinLength(n)` | Minimum string length |
| `@MaxLength(n)` | Maximum string length |
| `@Min(n)` | Minimum number value |
| `@Max(n)` | Maximum number value |
| `@IsEnum()` | Must be a valid enum value |
| `@IsArray()` | Must be an array |
| `@IsBoolean()` | Must be boolean |

## Installation

```bash
npm install class-validator class-transformer
```
