# Skill: fastapi_apply_dependency_injection

## Description
Ensure proper wiring of components using FastAPI's dependency injection.

## Instructions
This skill guides you on how to effectively use FastAPI's dependency injection system to wire components like database sessions, services, and external clients. Proper dependency injection ensures modularity, testability, and efficient resource management.

### Workflow

1.  **Define dependencies in `app/core/dependencies.py`**:
    *   For database sessions, create a `get_db` function that yields a `Session` instance, ensuring it's closed after the request.
    *   For external clients (e.g., `boto3` clients), create functions that return the client instance. Use `@lru_cache` to ensure the client is created only once per Lambda container and reused across warm invocations.
    *   For services, create functions that instantiate the service, injecting its required repositories and integration clients using `Depends()`.
2.  **Inject dependencies into routers and other dependencies**:
    *   In your FastAPI router endpoints, use `Depends()` to inject services, `AccessContext`, or any other dependency defined in `app/core/dependencies.py`.
    *   Dependencies can also depend on other dependencies, and FastAPI will resolve the dependency tree automatically.
3.  **Understand the dependency resolution order**:
    *   FastAPI ensures that a dependency (e.g., `get_db`) is called only once per request, even if multiple other dependencies declare it. The instance is shared across all dependencies within the same request.
4.  **Add necessary imports**: Ensure all required modules (e.g., `Depends`, `Session`, `lru_cache`, services, repositories, integrations) are imported.

### Example

```python
# app/core/dependencies.py
from functools import lru_cache
import boto3
from sqlalchemy.orm import Session
from app.core.database import SessionLocal
from app.repositories import EnvironmentRepository
from app.integrations.s3 import S3Service
from app.services import EnvironmentService

def get_db() -> Session:
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

@lru_cache()
def get_s3_client():
    return boto3.client("s3")

def get_s3_service(s3_client = Depends(get_s3_client)) -> S3Service:
    return S3Service(s3_client)

def get_environment_service(
    db: Session = Depends(get_db),
    s3: S3Service = Depends(get_s3_service),
) -> EnvironmentService:
    repo = EnvironmentRepository(db)
    return EnvironmentService(repo, s3)
```

```python
# app/routers/environment.py
from fastapi import APIRouter, Depends
from app.schemas.environment import EnvironmentResponseSchema
from app.core.security import AccessContext, get_current_access_context
from app.core.dependencies import get_environment_service
from app.services import EnvironmentService

router = APIRouter()

@router.get("/locals/{local_id}/environments", response_model=list[EnvironmentResponseSchema])
def list_environments(
    local_id: int,
    access_context: AccessContext = Depends(get_current_access_context), # Inject AccessContext
    service: EnvironmentService = Depends(get_environment_service), # Inject EnvironmentService
):
    return service.list(local_id, access_context.user_id, access_context.permissions)
```

### Checklist
- [ ] Defined all necessary dependencies in `app/core/dependencies.py`.
- [ ] Used `yield` for database sessions to ensure proper closing.
- [ ] Applied `@lru_cache` for external clients where appropriate.
- [ ] Injected dependencies into router endpoints or other dependencies using `Depends()`.
- [ ] Ensured all required imports are present.
