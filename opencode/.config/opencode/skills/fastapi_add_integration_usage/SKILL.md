# Skill: fastapi_add_integration_usage

## Description
Integrate external services (e.g., S3) into the application.

## Instructions
This skill guides you through the process of integrating an external service (like AWS S3, DynamoDB, etc.) into your FastAPI application. This involves creating an integration class to encapsulate the external service's logic and then using it within your services.

### Workflow

1.  **Create the integration file**: If a new external service is being integrated, create a new Python file under `app/integrations/` (e.g., `app/integrations/s3.py`). If an integration already exists, proceed to step 3.
2.  **Define the integration class**:
    *   Create a class that encapsulates all interactions with the external service.
    *   The `__init__` method should accept the external client (e.g., `boto3` client) as a dependency.
    *   Implement methods that perform specific business operations related to the external service (e.g., `upload_environment_image` for S3).
    *   Handle any service-specific logic like file validation, serialization, or API call details within this class.
    *   Raise domain-specific exceptions (e.g., `BadRequestError`) for integration-related errors.
3.  **Define the dependency in `dependencies.py`**:
    *   Add a new function in `app/core/dependencies.py` to provide an instance of your integration class.
    *   This function should create and return an instance of your integration class, injecting its own dependencies (e.g., `boto3` client).
    *   For external clients that can be reused across warm invocations (like `boto3` clients), use `@lru_cache` to cache the client instance.
4.  **Inject and use the integration in a service**:
    *   Modify the `__init__` method of the relevant service (e.g., `EnvironmentService`) to accept an instance of your integration class as a dependency.
    *   Use the injected integration instance within the service methods to perform external service operations. The service should only know the business intent, not the underlying infrastructure details.
5.  **Add necessary imports**: Ensure all required modules (e.g., `boto3`, `lru_cache`, integration class, exceptions) are imported.

### Example

```python
# app/integrations/s3.py
import base64
from app.core.exceptions import BadRequestError
import magic


class S3Service:
    def __init__(self, s3_client):
        self.s3_client = s3_client

    def upload_environment_image(
        self, user_id: int, local_id: int, environment_id: int, image_b64: str
    ) -> str:
        content = base64.b64decode(image_b64)
        mime = magic.from_buffer(content, mime=True)
        extension = mime.split("/")[1]

        if not extension:
            raise BadRequestError("Invalid image format.")

        key = f"images/{user_id}/{local_id}-{environment_id}.{extension}"
        self.s3_client.put_object(
            Bucket="smartlybrasil_app",
            Key=key,
            Body=content,
        )

        return f"https://smartlybrasil-app.s3.amazonaws.com/{key}"
```

```python
# app/core/dependencies.py
from functools import lru_cache
import boto3
from app.integrations.s3 import S3Service

@lru_cache()
def get_s3_client():
    return boto3.client("s3")

def get_s3_service(s3_client = Depends(get_s3_client)) -> S3Service:
    return S3Service(s3_client)
```

```python
# app/services/environment.py
from app.repositories import EnvironmentRepository
from app.integrations.s3 import S3Service
# ... other imports

class EnvironmentService:
    def __init__(
        self,
        repo: EnvironmentRepository,
        s3: S3Service, # S3Service is injected here
    ) -> None:
        self.repo = repo
        self.s3 = s3

    def update(
        self, environment_id: int, user_id: str, local_id: int, body: EnvironmentUpdate
    ) -> EnvironmentResponseSchema:
        # ... other logic

        image_url = None
        if body.image is not None:
            image_url = self.s3.upload_environment_image( # Usage of S3Service
                user_id=int(user_id),
                local_id=local_id,
                environment_id=environment_id,
                image_b64=body.image,
            )

        # ... other logic
```

### Checklist
- [ ] Created the integration file under `app/integrations/` if it's a new service.
- [ ] Defined the integration class with methods encapsulating external service logic.
- [ ] Added a dependency function in `app/core/dependencies.py` for the integration class.
- [ ] Used `@lru_cache` for external clients where appropriate.
- [ ] Injected the integration into the relevant service's `__init__` method.
- [ ] Used the integration instance within the service methods.
- [ ] Added all required imports.
