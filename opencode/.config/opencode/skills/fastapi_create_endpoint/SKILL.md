# Skill: fastapi_create_endpoint

## Description
Create a new REST endpoint following the project architecture.

## Instructions
This skill helps you create a new REST API endpoint in a FastAPI application, adhering to the project's established architecture. This includes defining the router, path, HTTP method, request/response models, and dependencies.

### Workflow

1.  **Identify the appropriate router file**: New endpoints should be added to existing router files (e.g., `app/routers/environment.py`) or a new one created if a new resource is being exposed.
2.  **Define the endpoint**:
    *   Use `@router.<http_method>("<path>", response_model=<ResponseSchema>, status_code=<status_code>)` decorator.
    *   Specify the HTTP method (e.g., `get`, `post`, `put`, `delete`).
    *   Define the path, including path parameters if necessary (e.g., `"/items/{item_id}"`).
    *   Set `response_model` to the appropriate Pydantic schema for the response.
    *   Set `status_code` for successful responses.
3.  **Define function parameters and dependencies**:
    *   Include path and query parameters as function arguments.
    *   Inject necessary dependencies using `Depends()`, such as `AccessContext` for authentication/authorization, and the relevant service (e.g., `EnvironmentService`).
    *   Example: `access_context: AccessContext = Depends(get_current_access_context)`
    *   Example: `service: EnvironmentService = Depends(get_environment_service)`
4.  **Implement the endpoint logic**:
    *   Call the appropriate service method to perform the business logic.
    *   Return the result, which should be an instance of the `response_model`.
5.  **Add necessary imports**: Ensure all required modules (e.g., `APIRouter`, `Depends`, schemas, services, security context) are imported.

### Example

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
    _: None = Depends(require_owner), # Example of permission enforcement
):
    return service.create(access_context.local_id, access_context.user_id, body)

@router.get("/locals/{local_id}/environments", response_model=list[EnvironmentResponseSchema])
def list_environments(
    local_id: int,
    access_context: AccessContext = Depends(get_current_access_context),
    service: EnvironmentService = Depends(get_environment_service),
):
    return service.list(local_id, access_context.user_id, access_context.permissions)
```

### Checklist
- [ ] Identified or created the appropriate router file.
- [ ] Defined the endpoint with the correct HTTP method, path, `response_model`, and `status_code`.
- [ ] Included all necessary path/query parameters and dependencies.
- [ ] Implemented the endpoint logic by calling the relevant service method.
- [ ] Added all required imports.
