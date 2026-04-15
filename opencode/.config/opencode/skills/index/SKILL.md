---
name: opencode-skills-index
description: Index of available OpenCode and bundled superpowers skills for backend development, frontend work, testing, review, and workflow automation
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## Available Skills

### Frontend

| Skill | Description |
|-------|-------------|
| [frontend-design](frontend-design/) | Create distinctive, production-grade frontend interfaces with high design quality |

### NestJS Core

| Skill | Description |
|-------|-------------|
| [nestjs-core](nestjs-core/) | Comprehensive reference to all NestJS skills |
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
| [nestjs-create-endpoint](nestjs-create-endpoint/) | Guides through the process of creating a new REST endpoint in a NestJS application by orchestrating existing granular skills |

### FastAPI

| Skill | Description |
|-------|-------------|
| [fastapi_create_endpoint](fastapi_create_endpoint/) | Create a new REST endpoint following the project architecture |
| [fastapi_add_router_endpoint](fastapi_add_router_endpoint/) | Expose a service method via HTTP |
| [fastapi_add_service_method](fastapi_add_service_method/) | Implement business logic and orchestration within a service method |
| [fastapi_add_repository_method](fastapi_add_repository_method/) | Implement a new database operation within a repository |
| [fastapi_add_integration_usage](fastapi_add_integration_usage/) | Integrate external services (e.g., S3) into the application |
| [fastapi_apply_dependency_injection](fastapi_apply_dependency_injection/) | Ensure proper wiring of components using FastAPI's dependency injection |
| [fastapi_enforce_permissions](fastapi_enforce_permissions/) | Ensure access control based on user role/permissions |
| [fastapi_handle_exceptions](fastapi_handle_exceptions/) | Ensure consistent error handling using global exception filters and custom exceptions |
| [fastapi_follow_import_convention](fastapi_follow_import_convention/) | Maintain clean and consistent imports across the codebase |

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

### Testing

| Skill | Description |
|-------|-------------|
| [fastapi_write_unit_test_for_service](fastapi_write_unit_test_for_service/) | Write unit tests for FastAPI service logic in isolation |
| [fastapi-create-integration-test](fastapi-create-integration-test/) | Create FastAPI integration tests using the existing fixture, seed, and dependency override patterns |

### Quality And Review

| Skill | Description |
|-------|-------------|
| [automated-code-review](automated-code-review/) | Automates code review by analyzing code for best practices, potential bugs, stylistic issues, and suggesting improvements |

### Workflow

| Skill | Description |
|-------|-------------|
| [pr-generator](pr-generator/) | Generate structured PR descriptions using GitHub CLI |
| [create-skill](create-skill/) | Create a new OpenCode skill with consistent frontmatter, triggers, workflow, and rules |
| [changelog-generator](changelog-generator/) | Generate and manage changelog following Keep a Changelog format |
| [adr-generator](adr-generator/) | Create Architecture Decision Records (ADR) following Michael Nygard template |

### Superpowers Skills

These skills are bundled from the superpowers package rather than this local skills directory.

| Skill | Description |
|-------|-------------|
| `brainstorming` | You MUST use this before any creative work - creating features, building components, adding functionality, or modifying behavior. Explores user intent, requirements and design before implementation. |
| `dispatching-parallel-agents` | Use when facing 2+ independent tasks that can be worked on without shared state or sequential dependencies |
| `executing-plans` | Use when you have a written implementation plan to execute in a separate session with review checkpoints |
| `finishing-a-development-branch` | Use when implementation is complete, all tests pass, and you need to decide how to integrate the work - guides completion of development work by presenting structured options for merge, PR, or cleanup |
| `receiving-code-review` | Use when receiving code review feedback, before implementing suggestions, especially if feedback seems unclear or technically questionable - requires technical rigor and verification, not performative agreement or blind implementation |
| `requesting-code-review` | Use when completing tasks, implementing major features, or before merging to verify work meets requirements |
| `subagent-driven-development` | Use when executing implementation plans with independent tasks in the current session |
| `systematic-debugging` | Use when encountering any bug, test failure, or unexpected behavior, before proposing fixes |
| `test-driven-development` | Use when implementing any feature or bugfix, before writing implementation code |
| `using-git-worktrees` | Use when starting feature work that needs isolation from current workspace or before executing implementation plans - creates isolated git worktrees with smart directory selection and safety verification |
| `using-superpowers` | Use when starting any conversation - establishes how to find and use skills, requiring Skill tool invocation before ANY response including clarifying questions |
| `verification-before-completion` | Use when about to claim work is complete, fixed, or passing, before committing or creating PRs - requires running verification commands and confirming output before making any success claims; evidence before assertions always |
| `writing-plans` | Use when you have a spec or requirements for a multi-step task, before touching code |
| `writing-skills` | Use when creating new skills, editing existing skills, or verifying skills work before deployment |

## Categories

| Category | Description |
|----------|-------------|
| **frontend** | UI and frontend interface design |
| **nestjs** | Core NestJS patterns and best practices |
| **fastapi** | FastAPI architecture, endpoints, services, repositories, and API conventions |
| **sequelize** | Sequelize ORM specific implementations |
| **observability** | Monitoring, logging, and metrics |
| **infrastructure** | Docker and deployment configurations |
| **testing** | Unit and integration testing |
| **quality** | Code review and implementation quality workflows |
| **workflow** | Development workflow and PR management |
| **superpowers** | Process and execution disciplines loaded from the bundled superpowers package |

## Usage

To use a skill, invoke it by name when working on related tasks. For example:

- Building a UI → Use `frontend-design`
- Working on authentication → Use `nestjs-authentication`
- Adding a FastAPI route → Use `fastapi_create_endpoint`
- Setting up database models → Use `sequelize-nestjs-model`
- Debugging a failure → Use `systematic-debugging`
- Preparing a release → Use `changelog-generator`
