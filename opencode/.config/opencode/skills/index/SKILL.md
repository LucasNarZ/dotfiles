---
name: opencode-skills-index
description: Index of all available OpenCode skills for NestJS development, observability, and workflow automation
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## Available Skills

### NestJS Core

| Skill | Description |
|-------|-------------|
| [nestjs-feature-module](nestjs-feature-module/) | Create complete NestJS feature modules with entity, service, controller, providers, and DTOs |
| [nestjs-dto-validation](nestjs-dto-validation/) | DTOs with class-validator decorators and global ValidationPipe |
| [nestjs-authentication](nestjs-authentication/) | JWT + refresh token auth with HTTP-only cookies, guards, decorators |
| [nestjs-error-handling](nestjs-error-handling/) | Global exception filters, custom HTTP exceptions |
| [nestjs-guards](nestjs-guards/) | AuthGuard, AdminGuard, RolesGuard for access control |
| [nestjs-swagger-docs](nestjs-swagger-docs/) | OpenAPI/Swagger documentation in NestJS with annotations |
| [nestjs-google-oauth](nestjs-google-oauth/) | Google OAuth authentication using google-auth-library |
| [nestjs-email-service](nestjs-email-service/) | Email sending with Nodemailer for transactional emails |
| [nestjs-rabbitmq-worker](nestjs-rabbitmq-worker/) | RabbitMQ consumer for background job processing |
| [nestjs-unit-testing](nestjs-unit-testing/) | Jest testing with mocked repositories and testing module |

### Observability

| Skill | Description |
|-------|-------------|
| [nestjs-prometheus-metrics](nestjs-prometheus-metrics/) | Prometheus metrics: HTTP requests, DB queries, connections via prom-client |
| [nestjs-winston-logging](nestjs-winston-logging/) | Winston JSON structured logging with timestamps |
| [nestjs-metrics-interceptor](nestjs-metrics-interceptor/) | HTTP metrics interceptor for request duration, size, status |
| [docker-compose-observability](docker-compose-observability/) | Prometheus, Grafana, Loki, Promtail setup in Docker Compose |

### Infrastructure

| Skill | Description |
|-------|-------------|
| [docker-compose-nestjs](docker-compose-nestjs/) | NestJS + PostgreSQL + Redis multi-container setup |

### Sequelize ORM

| Skill | Description |
|-------|-------------|
| [sequelize-nestjs-model](sequelize-nestjs-model/) | Sequelize models with sequelize-typescript decorators, UUID PKs |
| [sequelize-nestjs-repository](sequelize-nestjs-repository/) | Repository pattern with DI tokens and providers |
| [sequelize-nestjs-migrations](sequelize-nestjs-migrations/) | Sequelize CLI migrations with up/down pattern |
| [sequelize-nestjs-associations](sequelize-nestjs-associations/) | HasMany, BelongsTo, BelongsToMany relationships |

### Workflow

| Skill | Description |
|-------|-------------|
| [pr-description-generator](pr-description-generator/) | Generate structured PR descriptions with context, changelog, validation criteria |
| [changelog-generator](changelog-generator/) | Generate and manage changelog following Keep a Changelog format |
| [adr-generator](adr-generator/) | Create Architecture Decision Records (ADR) following Michael Nygard template |

## Categories

| Category | Description |
|----------|-------------|
| **nestjs** | Core NestJS patterns and best practices |
| **sequelize** | Sequelize ORM specific implementations |
| **observability** | Monitoring, logging, and metrics |
| **infrastructure** | Docker and deployment configurations |
| **testing** | Unit and integration testing |
| **workflow** | Development workflow and PR management |

## Usage

To use a skill, invoke it by name when working on related tasks. For example:

- Working on authentication → Use `nestjs-authentication`
- Setting up database models → Use `sequelize-nestjs-model`
- Preparing a release → Use `changelog-generator`
