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

### Observability

| Skill | Description |
|-------|-------------|
| [docker-compose-observability](docker-compose-observability/) | Prometheus, Grafana, Loki, Promtail setup in Docker Compose |

### Infrastructure

| Skill | Description |
|-------|-------------|
| [docker-compose-nestjs](docker-compose-nestjs/) | NestJS + PostgreSQL + Redis multi-container setup |


### Quality And Review

| Skill | Description |
|-------|-------------|
| [automated-code-review](automated-code-review/) | Automates code review by analyzing code for best practices, potential bugs, stylistic issues, and suggesting improvements |

### Workflow

| Skill | Description |
|-------|-------------|
| [pr-generator](pr-generator/) | Generate structured PR descriptions using GitHub CLI |
| [update-docs](update-docs/) | Review branch diffs and update affected repository documentation before PR creation |
| [create-skill](create-skill/) | Create a new OpenCode skill with consistent frontmatter, triggers, workflow, and rules |
| [quick-task-workflow](quick-task-workflow/) | Lightweight approved workflow for small implementation tasks |
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
| **observability** | Monitoring, logging, and metrics |
| **infrastructure** | Docker and deployment configurations |
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
