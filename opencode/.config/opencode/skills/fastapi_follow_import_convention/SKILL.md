# Skill: fastapi_follow_import_convention

## Description
Maintain clean and consistent imports across the codebase.

## Instructions
This skill outlines the import convention for the FastAPI application, ensuring clean, consistent, and maintainable code. Adhering to this convention helps encapsulate internal module structures and prevents unintended side effects during imports.

### Workflow

1.  **Import through `__init__.py` for `services/`, `repositories/`, and `schemas/`**:
    *   For modules within `app/services/`, `app/repositories/`, and `app/schemas/`, always import classes and functions through their respective package's `__init__.py` file.
    *   Ensure that the `__init__.py` file re-exports the necessary components from its sub-modules.
    *   Example: `from app.services import EnvironmentService` (assuming `app/services/__init__.py` re-exports `EnvironmentService`).
2.  **Import directly from files for `core/` and `integrations/`**:
    *   For modules within `app/core/` and `app/integrations/`, import directly from the specific file where the component is defined.
    *   Avoid re-exporting components from `core/` and `integrations/` in their `__init__.py` files to prevent side effects during import (e.g., database connections, environment variable loading).
    *   Example: `from app.core.exceptions import NotFoundError`
    *   Example: `from app.integrations.s3 import S3Service`
3.  **Avoid side effects in `__init__.py`**: Only re-export modules in `__init__.py` if they are safe to import (i.e., they do not execute logic on import).

### Example

```python
# app/services/__init__.py
from .environment import EnvironmentService
```

```python
# app/repositories/__init__.py
from .environment import EnvironmentRepository
```

```python
# app/schemas/__init__.py
from .environment import EnvironmentCreate, EnvironmentUpdate, EnvironmentResponseSchema
```

```python
# Correct usage in another module (e.g., a router or another service)

# Importing from services, repositories, schemas (via __init__.py)
from app.services import EnvironmentService
from app.repositories import EnvironmentRepository
from app.schemas import EnvironmentCreate

# Importing from core, integrations (directly from file)
from app.core.exceptions import NotFoundError
from app.core.database import SessionLocal
from app.integrations.s3 import S3Service
```

```python
# Incorrect usage (avoid this)
# from app.services.environment import EnvironmentService # Avoid direct file import for services
# from app.core import exceptions # Avoid importing core modules via __init__.py if they have side effects
```

### Checklist
- [ ] All imports from `services/`, `repositories/`, and `schemas/` go through their respective `__init__.py`.
- [ ] All imports from `core/` and `integrations/` are direct file imports.
- [ ] `__init__.py` files in `core/` and `integrations/` do not re-export components that cause side effects.
- [ ] `__init__.py` files in `services/`, `repositories/`, and `schemas/` correctly re-export their public interfaces.
