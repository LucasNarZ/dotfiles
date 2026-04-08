---
name: fastapi-create-integration-test
description: Create a FastAPI integration test that matches the project's existing test client, fixture, and dependency override patterns. Trigger when the user asks to add or scaffold an integration test for an endpoint or flow.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: testing
---

## What I do

Create a new FastAPI integration test file by following the patterns already used in `src/handlers/api/function/tests/integration`, including shared fixtures from `conftest.py`, seeded database records, dependency overrides, and HTTP-level assertions.

## Trigger

Any message like:
- "Create an integration test for the environment endpoints"
- "Add a FastAPI integration test for this route"
- "Make an endpoint integration test following the current test suite"

Ask for the target endpoint or handler if the user only says they want an integration test without naming the behavior to cover.

## Workflow

### Step 1: Inspect the existing test setup

Read `src/handlers/api/function/tests/integration/conftest.py` and the closest `test_*_endpoints.py` file. Reuse existing fixtures before creating new ones, especially `client`, `client_with_s3`, and the seed fixtures that populate users, locals, environments, devices, or external integrations.

### Step 2: Create the test file around the endpoint behavior

Create or extend a file under `src/handlers/api/function/tests/integration/` using the existing naming pattern. Group tests by endpoint behavior in `Test...` classes, make real HTTP calls with `TestClient`, seed only the data required for the scenario, and assert status codes plus the response body fields that define the contract.

### Step 3: Cover the project-specific integration paths

Add at least the main success path and the most relevant failure path. If the endpoint depends on an external service, override that dependency using the established fixture pattern instead of hitting the real service. Keep assertions focused on observable API behavior, not internal implementation details.

## Rules

- Follow the fixture and dependency override patterns already defined in `conftest.py`
- Prefer extending an existing integration test module instead of creating a duplicate one for the same handler
- Test HTTP behavior, seeded persistence effects, and serialized response fields without mocking the application layer
