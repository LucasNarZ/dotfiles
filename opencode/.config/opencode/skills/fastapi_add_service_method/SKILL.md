# Skill: fastapi_add_service_method

## Description
Implement business logic and orchestration within a service method.

## Instructions
This skill guides you through adding a new method to an existing service in your FastAPI application. Service methods are responsible for encapsulating business logic, performing validations, and orchestrating interactions with repositories and external integrations.

### Workflow

1.  **Identify the target service file**: Locate the service file where the new method should be added (e.g., `app/services/environment.py`).
2.  **Define the new method**:
    *   Add a new method to the service class.
    *   Define its parameters, including any input DTOs (Pydantic models) and necessary context (e.g., `user_id`, `permissions`).
    *   Specify the return type, which should typically be a Pydantic response schema or a list of them.
3.  **Implement business logic**:
    *   Interact with the repository to fetch or persist data. Remember that the service never interacts with the database directly.
    *   Perform any necessary data transformations or validations.
    *   Orchestrate calls to external integrations (e.g., S3Service) if required.
    *   Handle domain-specific exceptions (e.g., `NotFoundError`, `BadRequestError`) by raising them.
4.  **Convert repository output to Pydantic schemas**:
    *   After receiving SQLAlchemy models or `RowMapping` objects from the repository, convert them into appropriate Pydantic response schemas using `.model_validate()`.
5.  **Add necessary imports**: Ensure all required modules (e.g., repositories, integrations, schemas, exceptions) are imported.

### Example

```python
# app/services/environment.py
from app.core.exceptions import NotFoundError
from app.models.environment import Environment
from app.repositories import EnvironmentRepository
from app.integrations.s3 import S3Service
from app.schemas import (
    EnvironmentCreate,
    EnvironmentUpdate,
    EnvironmentResponseSchema,
)


class EnvironmentService:
    def __init__(
        self,
        repo: EnvironmentRepository,
        s3: S3Service,
    ) -> None:
        self.repo = repo
        self.s3 = s3

    def create(
        self, local_id: int, user_id: str, body: EnvironmentCreate
    ) -> EnvironmentResponseSchema:
        # Business logic: create environment in repository
        environment = self.repo.create(
            local_id=local_id,
            user_id=user_id,
            name=body.name,
        )
        # Convert SQLAlchemy model to Pydantic response schema
        return EnvironmentResponseSchema.model_validate(environment)

    def update(
        self, environment_id: int, user_id: str, local_id: int, body: EnvironmentUpdate
    ) -> EnvironmentResponseSchema:
        environment = self.repo.find_by_id_and_owner(environment_id, user_id)
        if not environment:
            raise NotFoundError("Environment not found")

        image_url = None
        if body.image is not None:
            # Orchestration: interact with S3 integration
            image_url = self.s3.upload_environment_image(
                user_id=int(user_id),
                local_id=local_id,
                environment_id=environment_id,
                image_b64=body.image,
            )

        updated_environment = self.repo.update(environment, body.name, image_url)
        return EnvironmentResponseSchema.model_validate(updated_environment)

    def get(self, environment_id: int, user_id: str) -> EnvironmentResponseSchema:
        environment = self.repo.find_by_id_and_owner(environment_id, user_id)
        if not environment:
            raise NotFoundError("Environment not found")
        return EnvironmentResponseSchema.model_validate(environment)
```

### Checklist
- [ ] Identified the correct service file.
- [ ] Defined the new method with appropriate parameters and return type.
- [ ] Implemented business logic, interacting with repositories and integrations.
- [ ] Converted repository output to Pydantic response schemas.
- [ ] Added all required imports.
