---
name: sequelize-nestjs-associations
description: Define Sequelize model associations: HasMany, BelongsTo, BelongsToMany with proper relationship types
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Define HasMany (one-to-many) relationships
- Create BelongsTo (many-to-one) relationships
- Implement BelongsToMany (many-to-many) with junction tables
- Handle self-referencing relationships
- Query with included relations

## When to use me

Use this when defining relationships between Sequelize models. Combine with nestjs-feature-module for complete module setup.

## HasMany (One-to-Many)

```typescript
import { HasMany, Table, Column, DataType } from 'sequelize-typescript';
import { Post } from 'src/post/post.entity';

@Table
export class User extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.STRING, allowNull: false })
  name: string;

  @HasMany(() => Post, { foreignKey: 'userId', as: 'posts' })
  posts: Post[];
}
```

## BelongsTo (Many-to-One)

```typescript
import { BelongsTo, ForeignKey, Table, Column, DataType } from 'sequelize-typescript';
import { User } from 'src/user/user.entity';

@Table
export class Post extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.STRING, allowNull: false })
  title: string;

  @ForeignKey(() => User)
  @Column({ type: DataType.UUID, allowNull: false })
  userId: string;

  @BelongsTo(() => User, { foreignKey: 'userId', as: 'author' })
  author: User;
}
```

## Self-Referencing

```typescript
import { HasMany, ForeignKey, Table, Column, DataType } from 'sequelize-typescript';

@Table
export class Comment extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.TEXT, allowNull: false })
  content: string;

  @ForeignKey(() => Comment)
  @Column({ type: DataType.UUID, allowNull: true })
  commentParentId: string;

  @HasMany(() => Comment, { foreignKey: 'commentParentId', as: 'replies' })
  replies: Comment[];

  @BelongsTo(() => Comment, { foreignKey: 'commentParentId', as: 'parent' })
  parent: Comment;
}
```

## BelongsToMany (Many-to-Many)

```typescript
import { BelongsToMany, Table, Column, DataType } from 'sequelize-typescript';
import { Role } from 'src/role/role.entity';
import { UserRole } from 'src/user-role/user-role.entity';

@Table
export class User extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @BelongsToMany(() => Role, () => UserRole, 'userId', 'roleId')
  roles: Role[];
}

@Table
export class Role extends Model {
  @Column({ type: DataType.UUID, defaultValue: DataType.UUIDV4, primaryKey: true })
  id: string;

  @Column({ type: DataType.STRING, unique: true })
  name: string;

  @BelongsToMany(() => User, () => UserRole, 'roleId', 'userId')
  users: User[];
}

@Table
export class UserRole extends Model {
  @Column({ type: DataType.UUID, primaryKey: true, defaultValue: DataType.UUIDV4 })
  userId: string;

  @Column({ type: DataType.UUID, primaryKey: true, defaultValue: DataType.UUIDV4 })
  roleId: string;
}
```

## Querying with Relations

```typescript
async getUserWithPosts(userId: string): Promise<User> {
  return this.usersRepository.findByPk(userId, {
    include: [
      { model: Post, as: 'posts' },
    ],
  });
}

async getPostWithAuthor(postId: string): Promise<Post> {
  return this.postsRepository.findByPk(postId, {
    include: [
      { model: User, as: 'author', attributes: ['id', 'name', 'email'] },
    ],
  });
}
```
