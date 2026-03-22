---
name: nestjs-feature-module
description: Create a complete NestJS feature module with entity, service, controller, providers, and DTOs
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Scaffold complete NestJS feature modules following layered architecture
- Create Sequelize entities with TypeScript decorators
- Implement repository pattern with DI tokens
- Generate CRUD service and REST controller
- Set up module registration

## When to use me

Use this when creating new NestJS features/modules. Follow the pattern consistently across the codebase.

## Entity

```typescript
import { Model, Table, Column, DataType, Default } from 'sequelize-typescript';

@Table
export class {Module} extends Model {
	@Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
	id: string;

	@Column({ type: DataType.STRING, allowNull: false })
	name: string;

	@Column({ type: DataType.DATE, allowNull: false })
	createdAt: Date;
}
```

## Providers

```typescript
import { Provider } from '@nestjs/common';
import { {Module} } from './{module}.entity';

export const {module}RepositoryToken = '{MODULE}_REPOSITORY';

export const {module}Providers: Provider[] = [
  { provide: {module}RepositoryToken, useValue: {Module} },
];
```

## Service

```typescript
import { Injectable } from '@nestjs/common';
import { Inject } from '@nestjs/common';
import { {Module} } from './{module}.entity';
import { Model } from 'sequelize-typescript';

@Injectable()
export class {Module}Service {
  constructor(
    @Inject('{MODULE}_REPOSITORY') private {module}Repository: typeof {Module},
  ) {}

  async findAll(): Promise<{Module}[]> {
    return this.{module}Repository.findAll();
  }

  async findOne(id: string): Promise<{Module} | null> {
    return this.{module}Repository.findByPk(id);
  }

  async create(data: Partial<{Module}>): Promise<{Module}> {
    return this.{module}Repository.create(data);
  }
}
```

## Controller

```typescript
import { Controller, Get, Post, Body, Param, ParseUUIDPipe } from '@nestjs/common';
import { {Module}Service } from './{module}.service';
import { Create{Module}Dto } from './dtos/create{Module}.dto';

@Controller('{module}s')
export class {Module}Controller {
  constructor(private readonly {module}Service: {Module}Service) {}

  @Get()
  findAll() {
    return this.{module}Service.findAll();
  }

  @Get(':id')
  findOne(@Param('id', ParseUUIDPipe) id: string) {
    return this.{module}Service.findOne(id);
  }

  @Post()
  create(@Body() createDto: Create{Module}Dto) {
    return this.{module}Service.create(createDto);
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

## App Module Registration

```typescript
import { {Module}Module } from './{module}/{module}.module';

@Module({
  imports: [{Module}Module, /* other modules */],
})
export class AppModule {}
```
