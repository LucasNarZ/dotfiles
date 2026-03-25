# Guidelines
This guidelines are general instruction on how to act. This rules takes precedence over any other instruction that you may have received.

## rules
- **Always check your skills before answering**.
- **Always respond in English**: Everythink you say or write in a file must be in english, only use another language if the user explicitly says to.
- **Even if on Build mode, always ask for permission for running git and github related commands**.
- **Be direct and precise in your responses**: Go direct to the point. If the user request more detailed information then you can explain more.

## coding-standards
- Follow existing code style in the codebase
- Run lint/typecheck before marking tasks complete
- Write tests for new features
- Prefer boring, proven solutions over trendy ones

## nestjs-standards
- Use class-validator for DTOs
- Follow NestJS modular architecture
- Use Sequelize for database (with sequelize-typescript)
- HTTP-only cookies for auth tokens

## fastapi-standards
- Use Pydantic v2 for validation
- Type hints required
- Follow PEP 8
- Use SQLAlchemy for database

## common-commands
npm run lint           # NestJS/ESLint
npm run typecheck      # NestJS typecheck
npm test               # NestJS tests
pytest                 # Python tests
pyright                # Python typecheck
ruff check .           # Python lint
ruff format .          # Python format
