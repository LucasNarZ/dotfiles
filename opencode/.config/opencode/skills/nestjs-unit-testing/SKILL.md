---
name: nestjs-unit-testing
description: Write unit tests for NestJS services using Jest with mocked repositories
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## What I do

- Create unit tests for NestJS services
- Mock repositories and dependencies
- Use TestingModule for dependency injection
- Run tests with coverage reports

## When to use me

Use this when writing unit tests for NestJS services. Follow the mocking pattern for consistency.

## Jest Configuration

```javascript
// jest.config.js
module.exports = {
  moduleFileExtensions: ['js', 'json', 'ts'],
  rootDir: 'src',
  testRegex: '.*\\.spec\\.ts$',
  transform: {
    '^.+\\.(t|j)s$': 'ts-jest',
  },
  collectCoverageFrom: ['**/*.(t|j)s'],
  coverageDirectory: '../coverage',
  testEnvironment: 'node',
  moduleNameMapper: {
    '^src/(.*)$': '<rootDir>/$1',
  },
};
```

## Service Unit Test

```typescript
import { Test, TestingModule } from '@nestjs/testing';
import { {Module}Service } from '../{module}.service';
import { {Module} } from '../{module}.entity';

const {module}RepositoryToken = '{MODULE}_REPOSITORY';

describe('{Module}Service', () => {
  let service: {Module}Service;
  let {module}Repository: any;

  const mock{Module}: {Module} = {
    id: '123e4567-e89b-12d3-a456-426614174000',
    name: 'Test {Module}',
    createdAt: new Date(),
  };

  beforeEach(async () => {
    {module}Repository = {
      findAll: jest.fn(),
      findByPk: jest.fn(),
      create: jest.fn(),
      update: jest.fn(),
      destroy: jest.fn(),
    };

    const module: TestingModule = await Test.createTestingModule({
      providers: [
        {Module}Service,
        { provide: {module}RepositoryToken, useValue: {module}Repository },
      ],
    }).compile();

    service = module.get<{Module}Service>({Module}Service);
  });

  it('should be defined', () => {
    expect(service).toBeDefined();
  });

  describe('findAll', () => {
    it('should return an array of {module}s', async () => {
      {module}Repository.findAll.mockResolvedValue([mock{Module}]);
      const result = await service.findAll();
      expect(result).toEqual([mock{Module}]);
      expect({module}Repository.findAll).toHaveBeenCalled();
    });
  });

  describe('findOne', () => {
    it('should return a single {module}', async () => {
      {module}Repository.findByPk.mockResolvedValue(mock{Module});
      const result = await service.findOne(mock{Module}.id);
      expect(result).toEqual(mock{Module});
      expect({module}Repository.findByPk).toHaveBeenCalledWith(mock{Module}.id);
    });

    it('should return null if {module} not found', async () => {
      {module}Repository.findByPk.mockResolvedValue(null);
      const result = await service.findOne('non-existent-id');
      expect(result).toBeNull();
    });
  });

  describe('create', () => {
    it('should create a new {module}', async () => {
      const createData = { name: 'New {Module}' };
      {module}Repository.create.mockResolvedValue({ ...mock{Module}, ...createData });
      
      const result = await service.create(createData);
      expect(result).toBeDefined();
      expect({module}Repository.create).toHaveBeenCalledWith(createData);
    });
  });

  describe('delete', () => {
    it('should delete a {module}', async () => {
      {module}Repository.destroy.mockResolvedValue(1);
      await service.delete(mock{Module}.id);
      expect({module}Repository.destroy).toHaveBeenCalledWith({ 
        where: { id: mock{Module}.id } 
      });
    });
  });
});
```

## Running Tests

```bash
# Run all tests
npm test

# Run with coverage
npm test -- --coverage

# Run specific test file
npm test -- {module}.service.spec.ts

# Watch mode
npm test -- --watch
```

## Installation

```bash
npm install --save-dev jest @types/jest ts-jest @nestjs/testing
```
