# Skill: fastapi_write_unit_test_for_service

## Description
Write unit tests for business logic in isolation.

## Instructions
This skill guides you through writing effective unit tests for your FastAPI service layer. The goal is to test business logic in isolation, ensuring tests are fast, deterministic, and easy to maintain by mocking external dependencies like repositories and integrations.

### Workflow

1.  **Create a test file**: Create a new test file for your service under `tests/unit/services/` (e.g., `tests/unit/services/test_environment_service.py`).
2.  **Mock dependencies using `create_autospec`**:
    *   Use `unittest.mock.create_autospec` to create mock objects for your service's dependencies (e.g., `EnvironmentRepository`, `S3Service`).
    *   Use `@pytest.fixture` to provide these mock objects to your tests.
    *   `instance=True` is important for mocking instances of classes.
3.  **Mock domain models with simple Python classes**:
    *   Instead of using SQLAlchemy models directly, create simple Python classes that mimic the structure of your domain models (e.g., `MockEnvironment`). This avoids SQLAlchemy complexity and lazy loading issues in unit tests.
4.  **Create a service fixture**:
    *   Create a `@pytest.fixture` that instantiates your service under test, injecting the mocked dependencies.
5.  **Write test cases**:
    *   **Test success scenarios**: Verify that the service method returns the correct value and interacts with its dependencies as expected (e.g., `assert_called_once_with`).
    *   **Test error scenarios**: Use `pytest.raises` to assert that the service raises the correct domain-specific exceptions under expected error conditions.
    *   **Test external integration usage**: Verify that the service correctly calls methods on its mocked integration dependencies with the expected arguments.
6.  **Avoid testing private methods directly**: Focus on testing the public interface of your service.
7.  **Add necessary imports**: Ensure all required modules (e.g., `pytest`, `create_autospec`, service under test, mock models, exceptions) are imported.

### Example

```python
# tests/unit/services/test_environment_service.py
import pytest
from unittest.mock import create_autospec

from app.services import EnvironmentService
from app.repositories import EnvironmentRepository
from app.integrations.s3 import S3Service
from app.core.exceptions import NotFoundError
from app.schemas import EnvironmentUpdate, EnvironmentResponseSchema

# Mock Domain Model
class MockEnvironment:
    def __init__(self, environment_id, local_id, name, order=1, url_image=None):
        self.environment_id = environment_id
        self.local_id = local_id
        self.name = name
        self.order = order
        self.url_image = url_image
        self.devices = []
        self.devices_count = 0

# Fixtures for mocked dependencies
@pytest.fixture
def mock_repo():
    return create_autospec(EnvironmentRepository, instance=True)

@pytest.fixture
def mock_s3():
    return create_autospec(S3Service, instance=True)

# Fixture for the service under test
@pytest.fixture
def service(mock_repo, mock_s3):
    return EnvironmentService(mock_repo, mock_s3)

# Test cases
def test_get_success(service, mock_repo):
    mock_env = MockEnvironment(1, 1, "Living Room")
    mock_repo.find_by_id_and_owner.return_value = mock_env

    result = service.get(environment_id=1, user_id="123")

    assert result.environment_id == 1
    mock_repo.find_by_id_and_owner.assert_called_once_with(1, "123")

def test_get_not_found(service, mock_repo):
    mock_repo.find_by_id_and_owner.return_value = None

    with pytest.raises(NotFoundError, match="Environment not found"):
        service.get(environment_id=1, user_id="123")

def test_update_with_image(service, mock_repo, mock_s3):
    mock_env = MockEnvironment(1, 1, "Living Room")
    mock_repo.find_by_id_and_owner.return_value = mock_env
    mock_repo.update.return_value = mock_env
    mock_s3.upload_environment_image.return_value = "https://example.com/image.jpg"

    body = EnvironmentUpdate(name="New Name", image="base64image", localId=1)

    service.update(environment_id=1, user_id="123", local_id=1, body=body)

    mock_s3.upload_environment_image.assert_called_once_with(
        user_id=123,
        local_id=1,
        environment_id=1,
        image_b64="base64image",
    )
```

### Checklist
- [ ] Created a dedicated test file for the service.
- [ ] Used `create_autospec` to mock all service dependencies.
- [ ] Created simple Python classes to mock domain models.
- [ ] Created a `pytest` fixture for the service under test.
- [ ] Wrote test cases for success scenarios, verifying return values and dependency interactions.
- [ ] Wrote test cases for error scenarios using `pytest.raises`.
- [ ] Wrote test cases for external integration usage, asserting calls to mocked integration methods.
- [ ] Avoided testing private methods.
- [ ] Added all required imports.
