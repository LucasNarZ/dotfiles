---
name: sequelize-nestjs-migrations
description: Create Sequelize CLI migrations with up/down pattern for schema changes
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create Sequelize CLI migrations with up/down pattern
- Define tables with UUID primary keys
- Add foreign keys and indexes
- Track schema changes version history

## When to use me

Use this for database schema management. Follow the migration pattern for production deployments.

## Sequelize CLI Configuration

```javascript
// .sequelizerc
const path = require('path');

module.exports = {
  'config': path.resolve('database', 'config.js'),
  'migrations-path': path.resolve('migrations'),
  'seeders-path': path.resolve('seeders'),
  'models-path': path.resolve('src'),
};
```

## Initial Migration

```javascript
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    // Users table
    await queryInterface.createTable('Users', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        allowNull: false,
        primaryKey: true,
      },
      name: { type: Sequelize.STRING, allowNull: false },
      email: { type: Sequelize.STRING, allowNull: false, unique: true },
      password: { type: Sequelize.STRING, allowNull: false },
      createdAt: { type: Sequelize.DATE, allowNull: false },
    });

    // Posts table with foreign key
    await queryInterface.createTable('Posts', {
      id: {
        type: Sequelize.UUID,
        defaultValue: Sequelize.literal('gen_random_uuid()'),
        allowNull: false,
        primaryKey: true,
      },
      title: { type: Sequelize.STRING, allowNull: false },
      content: { type: Sequelize.TEXT, allowNull: false },
      userId: {
        type: Sequelize.UUID,
        allowNull: false,
        references: { model: 'Users', key: 'id' },
        onDelete: 'CASCADE',
      },
      createdAt: { type: Sequelize.DATE, allowNull: false },
    });

    await queryInterface.addIndex('Posts', ['userId']);
    await queryInterface.addIndex('Posts', ['createdAt']);
  },

  async down(queryInterface) {
    await queryInterface.dropTable('Posts');
    await queryInterface.dropTable('Users');
  },
};
```

## Add Column Migration

```javascript
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addColumn('Users', 'bio', {
      type: Sequelize.TEXT,
      allowNull: true,
      defaultValue: '',
    });

    await queryInterface.addColumn('Users', 'isAdmin', {
      type: Sequelize.BOOLEAN,
      allowNull: false,
      defaultValue: false,
    });
  },

  async down(queryInterface) {
    await queryInterface.removeColumn('Users', 'isAdmin');
    await queryInterface.removeColumn('Users', 'bio');
  },
};
```

## Add Foreign Key Migration

```javascript
/** @type {import('sequelize-cli').Migration} */
module.exports = {
  async up(queryInterface, Sequelize) {
    await queryInterface.addConstraint('Posts', {
      fields: ['userId'],
      type: 'foreign key',
      name: 'fk_posts_users',
      references: { table: 'Users', field: 'id' },
      onDelete: 'CASCADE',
      onUpdate: 'CASCADE',
    });
  },

  async down(queryInterface) {
    await queryInterface.removeConstraint('Posts', 'fk_posts_users');
  },
};
```

## Migration Commands

```bash
# Run all pending migrations
npx sequelize-cli db:migrate

# Run migrations for specific environment
NODE_ENV=production npx sequelize-cli db:migrate

# Undo last migration
npx sequelize-cli db:migrate:undo

# Undo all migrations
npx sequelize-cli db:migrate:undo:all
```
