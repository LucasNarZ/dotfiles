---
name: nestjs-core
description: Comprehensive NestJS skill covering all core patterns - authentication, guards, DTOs, error handling, Swagger, email, RabbitMQ, testing, logging, metrics, and Sequelize ORM
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: nestjs
---

## Overview

This is a comprehensive NestJS skill that references all available NestJS-related skills for building production-ready applications.

## Included Skills

### Core Features

| Skill | Description |
|-------|-------------|
| [nestjs-feature-module](nestjs-feature-module/) | Complete feature modules with entity, service, controller, providers, DTOs |
| [nestjs-dto-validation](nestjs-dto-validation/) | DTOs with class-validator and global ValidationPipe |
| [nestjs-authentication](nestjs-authentication/) | JWT + refresh token auth with HTTP-only cookies |
| [nestjs-guards](nestjs-guards/) | AuthGuard, AdminGuard, RolesGuard for RBAC |
| [nestjs-error-handling](nestjs-error-handling/) | Global exception filters and custom exceptions |
| [nestjs-swagger-docs](nestjs-swagger-docs/) | OpenAPI/Swagger documentation |
| [nestjs-google-oauth](nestjs-google-oauth/) | Google OAuth authentication |
| [nestjs-email-service](nestjs-email-service/) | Transactional emails with Nodemailer |
| [nestjs-rabbitmq-worker](nestjs-rabbitmq-worker/) | RabbitMQ background job processing |

### Observability

| Skill | Description |
|-------|-------------|
| [nestjs-prometheus-metrics](nestjs-prometheus-metrics/) | Prometheus metrics via prom-client |
| [nestjs-winston-logging](nestjs-winston-logging/) | Winston structured JSON logging |
| [nestjs-metrics-interceptor](nestjs-metrics-interceptor/) | HTTP request metrics interceptor |

### Testing

| Skill | Description |
|-------|-------------|
| [nestjs-unit-testing](nestjs-unit-testing/) | Jest unit tests with mocked repositories |

### Database (Sequelize ORM)

| Skill | Description |
|-------|-------------|
| [sequelize-nestjs-model](sequelize-nestjs-model/) | Models with sequelize-typescript decorators |
| [sequelize-nestjs-repository](sequelize-nestjs-repository/) | Repository pattern with DI tokens |
| [sequelize-nestjs-migrations](sequelize-nestjs-migrations/) | CLI migrations with up/down |
| [sequelize-nestjs-associations](sequelize-nestjs-associations/) | HasMany, BelongsTo, BelongsToMany |

### Infrastructure

| Skill | Description |
|-------|-------------|
| [docker-compose-nestjs](docker-compose-nestjs/) | NestJS + PostgreSQL + Redis setup |
| [docker-compose-observability](docker-compose-observability/) | Prometheus, Grafana, Loki, Promtail |

## Usage

When working on a NestJS project, use the appropriate skill based on your needs:

```bash
# Load a specific skill when needed
/skill nestjs-authentication
/skill nestjs-feature-module
/skill sequelize-nestjs-model
```

This skill serves as a quick reference to all available NestJS patterns and can be used to explore what's available.
