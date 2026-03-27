# Skill: fastapi_handle_exceptions

## Description
Ensure consistent error handling using global exception filters and custom exceptions.

## Instructions
This skill guides you on how to implement consistent error handling in your FastAPI application using domain-specific exceptions and a global exception handler. This approach centralizes error management, preventing repetitive `try/except` blocks in your business logic and ensuring standardized API error responses.

### Workflow

1.  **Define domain-specific exceptions in `app/core/exceptions.py`**:
    *   Create simple exception classes for common domain errors (e.g., `NotFoundError`, `ForbiddenError`, `BadRequestError`). These classes should not contain any logic, only serve as markers for different error types.
2.  **Implement the global exception handler in `app/core/exception_handler.py`**:
    *   Define an `ERROR_MAP` dictionary that maps your custom exception class names (as strings) to appropriate HTTP status codes.
    *   Create a function `register_exception_handlers` that takes a FastAPI app instance.
    *   Inside this function, use `@app.exception_handler(Exception)` to catch all unhandled exceptions.
    *   In the handler function, determine the `error_type` from the exception, look up its corresponding `status` in `ERROR_MAP`, defaulting to 500 for unknown exceptions.
    *   Construct a `JSONResponse` with the determined status code and a message. For 5xx errors, return a generic "Internal Server Error" to avoid leaking internal details.
    *   Log 5xx errors for debugging purposes.
3.  **Register the exception handler in `app/main.py`**:
    *   Call `register_exception_handlers(app)` during your FastAPI application initialization.
4.  **Raise exceptions in services and repositories**:
    *   In your service and repository methods, raise the appropriate domain-specific exceptions when an expected error condition occurs. You no longer need `try/except` blocks for these expected errors.

### Example

```python
# app/core/exceptions.py
class NotFoundError(Exception):
    pass

class ForbiddenError(Exception):
    pass

class UnauthorizedError(Exception):
    pass

class ConflictError(Exception):
    pass

class BadRequestError(Exception):
    pass

class UnprocessableEntityError(Exception):
    pass
```

```python
# app/core/exception_handler.py
from fastapi import FastAPI, Request
from fastapi.responses import JSONResponse
from app.core.logging import get_logger

logger = get_logger()

ERROR_MAP = {
    "BadRequestError":          400,
    "UnauthorizedError":        401,
    "ForbiddenError":           403,
    "NotFoundError":            404,
    "ConflictError":            409,
    "UnprocessableEntityError": 422,
}

def register_exception_handlers(app: FastAPI) -> None:
    @app.exception_handler(Exception)
    async def global_exception_handler(request: Request, exc: Exception) -> JSONResponse:
        error_type = type(exc).__name__
        status = ERROR_MAP.get(error_type, 500)
        message = str(exc) if status < 500 else "Internal Server Error"

        if status == 500:
            logger.error("unhandled_exception", error=str(exc), path=str(request.url.path))

        return JSONResponse(status_code=status, content={"error": message})
```

```python
# app/main.py (snippet)
from fastapi import FastAPI
from app.core.exception_handler import register_exception_handlers

app = FastAPI()
register_exception_handlers(app)
# ... other app configurations
```

```python
# app/services/environment.py (snippet)
from app.core.exceptions import NotFoundError
# ... other imports

class EnvironmentService:
    # ...
    def get(self, environment_id: int, user_id: str) -> EnvironmentResponseSchema:
        environment = self.repo.find_by_id_and_owner(environment_id, user_id)
        if not environment:
            raise NotFoundError("Environment not found") # Raise the custom exception
        return EnvironmentResponseSchema.model_validate(environment)
```

### Checklist
- [ ] Defined domain-specific exception classes in `app/core/exceptions.py`.
- [ ] Implemented the global exception handler in `app/core/exception_handler.py` with an `ERROR_MAP`.
- [ ] Registered the exception handler in `app/main.py`.
- [ ] Replaced `try/except` blocks with raising custom exceptions in services and repositories.
- [ ] Ensured 5xx errors return a generic message and are logged.
- [ ] Added all required imports.
