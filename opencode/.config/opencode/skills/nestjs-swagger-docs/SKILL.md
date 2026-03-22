---
name: nestjs-swagger-docs
description: Set up OpenAPI/Swagger documentation in NestJS with annotations
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Configure Swagger/OpenAPI documentation
- Add decorators to controllers for endpoint documentation
- Document request/response DTOs with examples
- Support JWT Bearer authentication in docs

## When to use me

Use this when building APIs that need documentation. Combine with DTO validation for complete API spec.

## Swagger Setup

```typescript
import { SwaggerModule, DocumentBuilder } from '@nestjs/swagger';
import { NestFactory } from '@nestjs/core';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create(AppModule);

  app.enableCors();

  const config = new DocumentBuilder()
    .setTitle('API Title')
    .setDescription('The API description')
    .setVersion('1.0')
    .addBearerAuth(
      {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
        name: 'JWT',
        description: 'Enter JWT token',
        in: 'header',
      },
      'JWT-auth',
    )
    .addTag('users', 'User management endpoints')
    .addTag('auth', 'Authentication endpoints')
    .build();

  const document = SwaggerModule.createDocument(app, config);
  SwaggerModule.setup('api/docs', app, document);

  await app.listen(3000);
}
bootstrap();
```

## Controller Documentation

```typescript
import { Controller, Get, Post, Body, Param, UseGuards } from '@nestjs/common';
import {
  ApiTags,
  ApiOperation,
  ApiResponse,
  ApiBearerAuth,
  ApiParam,
} from '@nestjs/swagger';
import { UsersService } from './users.service';
import { CreateUserDto } from './dtos/createUser.dto';
import { UserResponseDto } from './dtos/user-response.dto';
import { AuthGuard } from 'src/auth/guards/auth.guard';

@ApiTags('users')
@Controller('users')
export class UsersController {
  constructor(private readonly usersService: UsersService) {}

  @Post()
  @ApiOperation({ summary: 'Create a new user' })
  @ApiResponse({
    status: 201,
    description: 'User created successfully',
    type: UserResponseDto,
  })
  @ApiResponse({ status: 400, description: 'Bad request' })
  @ApiResponse({ status: 409, description: 'User already exists' })
  async create(@Body() createUserDto: CreateUserDto): Promise<UserResponseDto> {
    const user = await this.usersService.create(createUserDto);
    return new UserResponseDto(user);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Get user by ID' })
  @ApiParam({ name: 'id', description: 'User UUID', type: String })
  @ApiResponse({
    status: 200,
    description: 'User found',
    type: UserResponseDto,
  })
  @ApiResponse({ status: 404, description: 'User not found' })
  async findOne(@Param('id') id: string): Promise<UserResponseDto> {
    const user = await this.usersService.findOne(id);
    return new UserResponseDto(user);
  }

  @Get()
  @UseGuards(AuthGuard)
  @ApiBearerAuth('JWT-auth')
  @ApiOperation({ summary: 'Get all users (authenticated)' })
  @ApiResponse({
    status: 200,
    description: 'List of users',
    type: [UserResponseDto],
  })
  @ApiResponse({ status: 401, description: 'Unauthorized' })
  async findAll(): Promise<UserResponseDto[]> {
    const users = await this.usersService.findAll();
    return users.map(user => new UserResponseDto(user));
  }
}
```

## Response DTO

```typescript
import { ApiProperty } from '@nestjs/swagger';

export class UserResponseDto {
  @ApiProperty({ example: '123e4567-e89b-12d3-a456-426614174000' })
  id: string;

  @ApiProperty({ example: 'John Doe' })
  name: string;

  @ApiProperty({ example: 'john-doe' })
  slug: string;

  @ApiProperty({ example: 'john@example.com' })
  email: string;

  @ApiProperty({ example: 'https://example.com/avatar.png' })
  profileImgUrl: string;

  @ApiProperty({ example: 0 })
  followersNumber: number;

  @ApiProperty({ example: '2024-01-01T00:00:00.000Z' })
  createdAt: Date;

  constructor(partial: Partial<UserResponseDto>) {
    Object.assign(this, partial);
  }
}
```

## Request DTO with Swagger

```typescript
import { IsString, IsNotEmpty, IsEmail, MinLength } from 'class-validator';
import { ApiProperty, ApiPropertyOptional } from '@nestjs/swagger';

export class CreateUserDto {
  @ApiProperty({ example: 'John Doe', description: 'User full name' })
  @IsString()
  @IsNotEmpty()
  name: string;

  @ApiProperty({ example: 'john@example.com', description: 'User email' })
  @IsEmail()
  @IsNotEmpty()
  email: string;

  @ApiProperty({ example: 'password123', description: 'User password' })
  @IsString()
  @IsNotEmpty()
  @MinLength(8)
  password: string;

  @ApiPropertyOptional({ example: 'Software developer', description: 'User bio' })
  @IsString()
  bio?: string;
}
```

## Error Response Documentation

```typescript
import { ApiResponse, ApiResponseOptions } from '@nestjs/swagger';

const NotFoundResponse: ApiResponseOptions = {
  status: 404,
  description: 'Resource not found',
  schema: {
    example: {
      statusCode: 404,
      timestamp: '2024-01-01T00:00:00.000Z',
      path: '/api/users/123',
      message: 'User not found',
    },
  },
};

const UnauthorizedResponse: ApiResponseOptions = {
  status: 401,
  description: 'Unauthorized - Invalid or missing token',
  schema: {
    example: {
      statusCode: 401,
      message: 'Invalid token',
    },
  },
};
```

## Access Swagger

- **Swagger UI:** http://localhost:3000/api/docs
- **JSON Schema:** http://localhost:3000/api/docs-json

## Installation

```bash
npm install @nestjs/swagger swagger-ui-express
```
