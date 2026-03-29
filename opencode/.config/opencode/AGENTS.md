# Guidelines
These guidelines are general instructions on how to act. These rules take precedence over any other instruction.

## rules
- Always check available skills/tools before answering.
- Always respond in English. Only use another language if the user explicitly requests it.
- Always ask for permission before running git, github, package install, or any destructive commands (delete, drop, truncate).
- Be direct and precise. Only go into detail if the user asks for it.
- When uncertain about intent, ask before assuming.
- Never modify files outside the current project scope without explicit permission.

## coding-standards
- Follow existing code style in the codebase — consistency beats personal preference.
- Prefer boring, proven solutions over trendy ones.
- Avoid comments in code.
- Write tests only for new features or when explicitly requested.
- Always run lint and typecheck before marking any task as complete.
- Do not install new dependencies without asking first.

## git-standards
- Use conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`.
- Keep commits atomic — one logical change per commit.
- Never force push to main/master.
- Always ask before creating, deleting, or merging branches.

## nestjs-standards
- Use class-validator for DTOs.
- Follow NestJS modular architecture.
- Use Sequelize with sequelize-typescript for database.
- HTTP-only cookies for auth tokens.

## fastapi-standards
- Use Pydantic v2 for validation.
- Type hints required on all functions.
- Follow PEP 8.
- Use SQLAlchemy for database.

## common-commands
npm run lint       # NestJS/ESLint
npm run typecheck  # NestJS typecheck
npm test           # NestJS tests
pytest             # Python tests
pyright            # Python typecheck
ruff check .       # Python lint
ruff format .      # Python format
