---
name: sequelize-nestjs-repository
description: Implement repository pattern with dependency injection tokens in NestJS
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Define repository DI tokens for clean dependency injection
- Inject Sequelize models into services
- Provide CRUD operations with repository pattern
- Support pagination and search queries

## When to use me

Use this for data access layer abstraction. Combine with nestjs-feature-module for complete module setup.

## Repository Providers

```typescript
import { Provider } from '@nestjs/common';
import { {Module} } from './{module}.entity';

export const {module}RepositoryToken = '{MODULE}_REPOSITORY';

export const {module}Providers: Provider[] = [
  { provide: {module}RepositoryToken, useValue: {Module} },
];
```

## Service with Repository

```typescript
import { Injectable } from '@nestjs/common';
import { Inject } from '@nestjs/common';
import { {Module} } from './{module}.entity';
import { Op } from 'sequelize';

@Injectable()
export class {Module}Service {
  constructor(
    @Inject('{MODULE}_REPOSITORY') private {module}Repository: typeof {Module},
  ) {}

  async findAll(options?: { limit?: number; offset?: number }): Promise<{Module}[]> {
    return this.{module}Repository.findAll({
      limit: options?.limit,
      offset: options?.offset,
    });
  }

  async findById(id: string): Promise<{Module} | null> {
    return this.{module}Repository.findByPk(id);
  }

  async findOne(where: Partial<{Module}>): Promise<{Module} | null> {
    return this.{module}Repository.findOne({ where });
  }

  async create(data: Partial<{Module}>): Promise<{Module}> {
    return this.{module}Repository.create(data);
  }

  async update(id: string, data: Partial<{Module}>): Promise<{Module}> {
    const [updated] = await this.{module}Repository.update(data, { where: { id } });
    return this.findById(id);
  }

  async delete(id: string): Promise<void> {
    await this.{module}Repository.destroy({ where: { id } });
  }

  async search(query: string): Promise<{Module}[]> {
    return this.{module}Repository.findAll({
      where: {
        name: { [Op.iLike]: `%${query}%` },
      },
    });
  }
}
```

## Module Registration

```typescript
import { Module } from '@nestjs/common';
import { DatabaseModule } from 'src/database/database.module';
import { {Module}Service } from './{module}.service';
import { {module}Providers } from './{module}.providers';

@Module({
  imports: [DatabaseModule],
  providers: [{Module}Service, ...{module}Providers],
  exports: [{Module}Service],
})
export class {Module}Module {}
```

## Centralized Constants

```typescript
// src/constants.ts
export const usersRepositoryToken = 'USERS_REPOSITORY';
export const devlogEventRepositoryToken = 'DEVLOGEVENT_REPOSITORY';
export const projectRepositoryToken = 'PROJECT_REPOSITORY';
export const followRepositoryToken = 'FOLLOW_REPOSITORY';
export const likeRepositoryToken = 'LIKE_REPOSITORY';
```

## Common Query Operators

| Operator | Usage |
|----------|-------|
| `[Op.eq]` | Equal |
| `[Op.ne]` | Not equal |
| `[Op.gt]` | Greater than |
| `[Op.lt]` | Less than |
| `[Op.gte]` | Greater than or equal |
| `[Op.lte]` | Less than or equal |
| `[Op.like]` | LIKE pattern |
| `[Op.iLike]` | Case-insensitive LIKE |
| `[Op.in]` | IN array |
| `[Op.notIn]` | NOT IN array |
| `[Op.between]` | Between range |
