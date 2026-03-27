---
name: fastapi_add_router_endpoint
description: Expose a service method via HTTP
license: MIT
compatibility: opencode
metadata:
  audience: developers
  framework: fastapi
---

## Goal

Expose a service method via HTTP.

## When to use

* Making a service accessible through API

## Steps

1. Define route path and method (`GET`, `POST`, etc.)
2. Declare path parameters
3. Declare request body (Pydantic model)
4. Inject dependencies:
   * `user_id`
   * `permission` (if needed)
   * `service`
5. Call service method
6. Return result

## Constraints

* MUST NOT contain business logic
* MUST NOT call repository directly
* MUST use `Depends` for dependencies