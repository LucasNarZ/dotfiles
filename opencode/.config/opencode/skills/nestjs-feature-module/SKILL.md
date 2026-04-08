---
name: nestjs-feature-module
description: Scaffold a complete NestJS feature module with Sequelize entity, repository providers, service, controller, and DTOs. Trigger when user says things like "create a module", "add a feature module", "scaffold [name] module", or "cria um módulo [name]".
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

Scaffold a complete NestJS feature module following layered architecture with Sequelize-typescript. Creates all files for a given feature name, replacing `{Module}` with PascalCase and `{module}` with camelCase/kebab-case as appropriate.

## Trigger

Any message like:
- "Create a users module"
- "Scaffold a products feature module"
- "Cria um módulo de orders"

Ask the user for the module name if not provided.

## Files to create

Given a feature named `{module}` (e.g. `product`), create the following files inside `src/{module}/`:

```
src/{module}/
├── {module}.entity.ts
├── {module}.providers.ts
├── {module}.service.ts
├── {module}.controller.ts
├── {module}.module.ts
└── dtos/
    ├── create-{module}.dto.ts
    └── update-{module}.dto.ts
```

## Entity

```typescript
import { Model, Table, Column, DataType } from 'sequelize-typescript';

@Table
export class {Module} extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.STRING, allowNull: false })
  name: string;
}
```

> `createdAt` and `updatedAt` are injected automatically by `Model` — never declare them manually.

## Providers

```typescript
import { Provider } from '@nestjs/common';
import { {Module} } from './{module}.entity';

export const {module}RepositoryToken = '{MODULE}_REPOSITORY';

export const {module}Providers: Provider[] = [
  { provide: {module}RepositoryToken, useValue: {Module} },
];
```

## DTOs

**create-{module}.dto.ts**
```typescript
import { IsString, IsNotEmpty } from 'class-validator';

export class Create{Module}Dto {
  @IsString()
  @IsNotEmpty()
  name: string;
}
```

**update-{module}.dto.ts**
```typescript
import { PartialType } from '@nestjs/mapped-types';
import { Create{Module}Dto } from './create-{module}.dto';

export class Update{Module}Dto extends PartialType(Create{Module}Dto) {}
```

## Service

```typescript
import { Injectable, Inject, NotFoundException } from '@nestjs/common';
import { {Module} } from './{module}.entity';
import { {module}RepositoryToken } from './{module}.providers';
import { Create{Module}Dto } from './dtos/create-{module}.dto';
import { Update{Module}Dto } from './dtos/update-{module}.dto';

@Injectable()
export class {Module}Service {
  constructor(
    @Inject({module}RepositoryToken) private readonly repo: typeof {Module},
  ) {}

  async findAll(): Promise<{Module}[]> {
    return await this.repo.findAll();
  }

  async findOne(id: string): Promise<{Module}> {
    const record = await this.repo.findByPk(id);
    if (!record) throw new NotFoundException('{Module} not found');
    return record;
  }

  async create(dto: Create{Module}Dto): Promise<{Module}> {
    return await this.repo.create({ ...dto });
  }

  async update(id: string, dto: Update{Module}Dto): Promise<{Module}> {
    const record = await this.findOne(id);
    return await record.update(dto);
  }

  async remove(id: string): Promise<void> {
    const record = await this.findOne(id);
    await record.destroy();
  }
}
```

## Controller

```typescript
import { Controller, Get, Post, Put, Delete, Body, Param, ParseUUIDPipe, HttpCode, HttpStatus } from '@nestjs/common';
import { {Module}Service } from './{module}.service';
import { Create{Module}Dto } from './dtos/create-{module}.dto';
import { Update{Module}Dto } from './dtos/update-{module}.dto';

@Controller('{module}s')
export class {Module}Controller {
  constructor(private readonly {module}Service: {Module}Service) {}

  @Get()
  async findAll() {
    return await this.{module}Service.findAll();
  }

  @Get(':id')
  async findOne(@Param('id', ParseUUIDPipe) id: string) {
    return await this.{module}Service.findOne(id);
  }

  @Post()
  async create(@Body() dto: Create{Module}Dto) {
    return await this.{module}Service.create(dto);
  }

  @Put(':id')
  async update(@Param('id', ParseUUIDPipe) id: string, @Body() dto: Update{Module}Dto) {
    return await this.{module}Service.update(id, dto);
  }

  @Delete(':id')
  @HttpCode(HttpStatus.NO_CONTENT)
  async remove(@Param('id', ParseUUIDPipe) id: string) {
    return await this.{module}Service.remove(id);
  }
}
```

## Module

```typescript
import { Module } from '@nestjs/common';
import { DatabaseModule } from 'src/database/database.module';
import { {Module}Service } from './{module}.service';
import { {module}Providers } from './{module}.providers';
import { {Module}Controller } from './{module}.controller';

@Module({
  imports: [DatabaseModule],
  controllers: [{Module}Controller],
  providers: [{Module}Service, ...{module}Providers],
  exports: [{Module}Service],
})
export class {Module}Module {}
```

## Rules

- Always use `async/await` on all service and controller methods — never return a bare Promise
- Never touch `app.module.ts` unless the user explicitly asks
- Never declare `createdAt` or `updatedAt` in entities
- Always use the DTO types in service methods — never use `Partial<Entity>`
- Add fields to entity and DTOs based on what the user describes; `name` is just a placeholder
- Use `@nestjs/mapped-types` for `UpdateDto` — do not duplicate field declarations
