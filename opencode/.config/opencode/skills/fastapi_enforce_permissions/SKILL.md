# Skill: fastapi_enforce_permissions

## Description
Ensure access control based on user role/permissions.

## Instructions
This skill guides you on how to implement access control and permission enforcement in your FastAPI application using a centralized `AccessContext` model and dependency injection. This approach ensures that user authentication and authorization logic is consistently applied across your API endpoints.

### Workflow

1.  **Define `AccessContext` in `app/core/security.py`**:
    *   Create a Pydantic model `AccessContext` that encapsulates user-related information necessary for authorization, such as `user_id`, `is_owner`, and `permissions`.
2.  **Implement `get_current_access_context` in `app/core/security.py`**:
    *   This function should extract claims from the authentication token (or use a fixed `userId` in local development environments).
    *   It constructs and returns an `AccessContext` object based on the extracted information.
    *   This function will be used as a dependency to inject the `AccessContext` into your endpoints.
3.  **Implement permission checks (e.g., `require_owner`) in `app/core/security.py`**:
    *   Create functions that act as FastAPI dependencies to enforce specific permissions.
    *   These functions should accept an `AccessContext` as a dependency and raise an appropriate `ForbiddenError` if the required permission is not met.
4.  **Apply permission dependencies in router endpoints**:
    *   In your FastAPI router endpoints, use `Depends()` to inject `get_current_access_context` to get the user's context.
    *   For endpoints requiring specific permissions, use `Depends()` with your permission enforcement functions (e.g., `Depends(require_owner)`).
5.  **Use `AccessContext` in services for fine-grained control**:
    *   Pass the `AccessContext` (or relevant parts like `user_id` and `permissions`) to your service methods to implement fine-grained, business-logic-level access control.

### Example

```python
# app/core/security.py
from typing import Optional
from pydantic import BaseModel
from fastapi import Request, Depends
from app.core.exceptions import ForbiddenError

class AccessContext(BaseModel):
    user_id: str
    is_owner: bool
    permissions: Optional[dict] = None

def get_current_access_context(request: Request) -> AccessContext:
    # Placeholder for actual token validation and context extraction
    # In a real application, this would involve decoding JWT, fetching user roles/permissions, etc.
    # For local development, you might bypass this or use a fixed user_id
    if request.headers.get("X-User-Id"):
        return AccessContext(user_id=request.headers["X-User-Id"], is_owner=True, permissions={"locals": []})
    return AccessContext(user_id="default_user", is_owner=False, permissions={"locals": []})

def require_owner(access_context: AccessContext = Depends(get_current_access_context)) -> None:
    if not access_context.is_owner:
        raise ForbiddenError("Only owners can perform this action")
```

```python
# app/routers/environment.py
from fastapi import APIRouter, Depends
from app.schemas.environment import EnvironmentResponseSchema, EnvironmentCreate
from app.core.security import AccessContext, get_current_access_context, require_owner
from app.core.dependencies import get_environment_service
from app.services import EnvironmentService

router = APIRouter()

@router.post("/environments", response_model=EnvironmentResponseSchema, status_code=201)
def create_environment(
    body: EnvironmentCreate,
    access_context: AccessContext = Depends(get_current_access_context),
    service: EnvironmentService = Depends(get_environment_service),
    _: None = Depends(require_owner),  # Enforce owner permission
):
    return service.create(access_context.local_id, access_context.user_id, body)

@router.get("/locals/{local_id}/environments", response_model=list[EnvironmentResponseSchema])
def list_environments(
    local_id: int,
    access_context: AccessContext = Depends(get_current_access_context),
    service: EnvironmentService = Depends(get_environment_service),
):
    # Service method uses user_id and permissions for internal logic
    return service.list(local_id, access_context.user_id, access_context.permissions)
```

### Checklist
- [ ] Defined the `AccessContext` Pydantic model in `app/core/security.py`.
- [ ] Implemented `get_current_access_context` to extract user context.
- [ ] Implemented permission enforcement functions (e.g., `require_owner`) that raise `ForbiddenError`.
- [ ] Applied `Depends(get_current_access_context)` and permission dependencies in router endpoints.
- [ ] Passed `AccessContext` (or parts of it) to service methods for fine-grained control.
- [ ] Added all required imports.
