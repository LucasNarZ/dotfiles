---
name: sequelize-nestjs-model
description: Create Sequelize models with sequelize-typescript decorators, UUID primary keys, and data types
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create Sequelize models with TypeScript decorators
- Define UUID primary keys
- Configure data types and constraints
- Support PostgreSQL ARRAY types
- Register models in feature modules

## When to use me

Use this for defining database entities. Combine with nestjs-feature-module for complete module setup.

## Basic Model

```typescript
import { Model, Table, Column, DataType, Default, PrimaryKey } from 'sequelize-typescript';

@Table
export class {Module} extends Model {
  @PrimaryKey
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4 })
  id: string;

  @Column({ type: DataType.STRING, allowNull: false })
  name: string;

  @Default(false)
  @Column({ type: DataType.BOOLEAN, allowNull: false })
  isActive: boolean;

  @Column({ type: DataType.INTEGER, allowNull: false, defaultValue: 0 })
  count: number;

  @Column({ type: DataType.TEXT })
  description: string;

  @Column({ type: DataType.DATE, allowNull: false })
  createdAt: Date;

  @Column({ type: DataType.DATE })
  updatedAt: Date;
}
```

## Model with Unique Constraints

```typescript
import { Unique, Table, Column, DataType } from 'sequelize-typescript';

@Table
@Unique('unique_slug')
export class Post extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.STRING, allowNull: false, unique: true })
  slug: string;

  @Column({ type: DataType.STRING, allowNull: false })
  title: string;

  @Column({ type: DataType.TEXT, allowNull: false })
  content: string;
}
```

## PostgreSQL ARRAY Types

```typescript
@Column({ type: DataType.ARRAY(DataType.STRING), allowNull: false, defaultValue: [] })
tags: string[];

@Column({ type: DataType.ARRAY(DataType.UUID), allowNull: true })
commentIds: string[];
```

## Common Data Types

| Type | Usage |
|------|-------|
| `DataType.UUID` | UUID primary keys |
| `DataType.STRING` | VARCHAR |
| `DataType.TEXT` | TEXT |
| `DataType.INTEGER` | Integer numbers |
| `DataType.FLOAT` | Decimal numbers |
| `DataType.BOOLEAN` | True/false |
| `DataType.DATE` | Date/time |
| `DataType.JSON` | JSON data |
| `DataType.ARRAY(type)` | PostgreSQL arrays |
| `DataType.ENUM(...)` | Enum values |

## Module Registration

```typescript
import { Module } from '@nestjs/common';
import { DatabaseModule } from 'src/database/database.module';

@Module({
  imports: [DatabaseModule],
})
export class {Module}Module {}
```

## Database Module

```typescript
import { Module } from '@nestjs/common';
import { databaseProvider } from './database.provider';

@Module({
  providers: [databaseProvider],
  exports: [databaseProvider],
})
export class DatabaseModule {}
```

## Installation

```bash
npm install sequelize sequelize-typescript
```
