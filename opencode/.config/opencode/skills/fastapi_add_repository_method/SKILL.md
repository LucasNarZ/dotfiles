# Skill: fastapi_add_repository_method

## Description
Implement a new database operation within a repository.

## Instructions
This skill guides you through adding a new method to an existing repository in your FastAPI application. Repository methods are responsible for all data access logic, interacting directly with the database via SQLAlchemy and returning raw SQLAlchemy models or `RowMapping` objects.

### Workflow

1.  **Identify the target repository file**: Locate the repository file where the new method should be added (e.g., `app/repositories/environment.py`).
2.  **Define the new method**:
    *   Add a new method to the repository class.
    *   Define its parameters, which should include all necessary data to perform the database operation.
    *   Specify the return type, which should be a SQLAlchemy model, a list of models, or `None` for operations that don't return data (e.g., `delete`).
3.  **Implement database interaction**:
    *   Use `self.session` to interact with the SQLAlchemy session.
    *   Write SQLAlchemy queries to perform `CREATE`, `READ`, `UPDATE`, or `DELETE` operations.
    *   Ensure that the method returns raw SQLAlchemy models or `RowMapping` objects. Do not convert to Pydantic schemas here.
    *   For `create` and `update` operations, remember to `self.session.add()`, `self.session.commit()`, and `self.session.refresh()` the object.
    *   Raise domain-specific exceptions (e.g., `NotFoundError`) if a record is not found when expected.
4.  **Add necessary imports**: Ensure all required SQLAlchemy components (e.g., `Session`, `func`), models, and exceptions are imported.

### Example

```python
# app/repositories/environment.py
from sqlalchemy.orm import Session
from sqlalchemy import func
from app.models import Environment
from app.core.exceptions import NotFoundError


class EnvironmentRepository:
    def __init__(self, session: Session) -> None:
        self.session = session

    def find_by_id_and_owner(
        self, environment_id: int, user_id: str
    ) -> Environment | None:
        return (
            self.session.query(Environment)
            .join(Environment.local)
            .filter(
                Environment.environment_id == environment_id,
                Environment.local.has(user_id=user_id),
            )
            .first()
        )

    def create(self, local_id: int, user_id: str, name: str) -> Environment:
        last_order = (
            self.session.query(func.max(Environment.order))
            .filter(Environment.local_id == local_id)
            .scalar()
        ) or 0

        environment = Environment(
            local_id=local_id,
            name=name,
            order=last_order + 1,
        )
        self.session.add(environment)
        self.session.commit()
        self.session.refresh(environment)
        return environment

    def update(
        self, environment: Environment, name: str | None, image_url: str | None
    ) -> Environment:
        if name is not None:
            environment.name = name
        if image_url is not None:
            environment.url_image = image_url
        self.session.commit()
        self.session.refresh(environment)
        return environment

    def delete(self, environment_id: int) -> None:
        environment = self.session.get(Environment, environment_id)
        if not environment:
            raise NotFoundError(f"Environment {environment_id} not found")
        self.session.delete(environment)
        self.session.commit()

    def update_order(self, environment_id: int, order: int) -> None:
        environment = self.session.get(Environment, environment_id)
        if not environment:
            raise NotFoundError(f"Environment {environment_id} not found")
        environment.order = order
        self.session.commit()
```

### Checklist
- [ ] Identified the correct repository file.
- [ ] Defined the new method with appropriate parameters and return type.
- [ ] Implemented database interaction using `self.session` and SQLAlchemy queries.
- [ ] Ensured the method returns raw SQLAlchemy models or `RowMapping` objects.
- [ ] Handled `session.add()`, `session.commit()`, and `session.refresh()` for create/update operations.
- [ ] Added all required imports.
