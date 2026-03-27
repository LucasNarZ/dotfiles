---
name: nestjs-create-endpoint
description: Guides through the process of creating a new REST endpoint in a NestJS application by orchestrating existing granular skills.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: feature-development
---

## NestJS Create Endpoint Skill

This skill provides a structured workflow for creating a new REST endpoint in a NestJS application. It serves as an orchestrator, guiding the use of more granular NestJS skills to perform each step of the endpoint creation process.

### Workflow Overview:

Creating a new endpoint typically involves several steps, which can be achieved by combining existing OpenCode NestJS skills:
1.  **Define DTOs (Data Transfer Objects)**: Create request and response DTOs for the endpoint.
    *   **Related Skill**: `nestjs-dto-validation` (for creating DTOs with validation decorators)
2.  **Implement Service Logic**: Add business logic to a service method.
    *   **Related Skill**: This often involves manual coding or can be assisted by specific `fastapi_add_service_method` (though this is for FastAPI, a similar conceptual skill for NestJS might be developed).
3.  **Implement Repository Logic (if database interaction is needed)**: Add database interaction logic to a repository method.
    *   **Related Skills**: `sequelize-nestjs-repository`, `sequelize-nestjs-model`, `sequelize-nestjs-migrations` (for defining models, repositories, and migrations respectively).
4.  **Create Controller Method**: Define the endpoint in a controller, handling request parsing and calling the service.
    *   **Related Skill**: This often involves manual coding, but a skill like `nestjs-feature-module` can scaffold controllers.
5.  **Apply Authentication/Authorization (if needed)**: Secure the endpoint with guards.
    *   **Related Skill**: `nestjs-guards`, `nestjs-authentication`
6.  **Generate Swagger Documentation**: Ensure the new endpoint is documented in Swagger.
    *   **Related Skill**: `nestjs-swagger-docs`
7.  **Write Unit/Integration Tests**: Create tests for the service and controller.
    *   **Related Skill**: `nestjs-unit-testing`

### Usage Guidance:

When invoked, this skill will guide you through the process, prompting you to perform each step using the recommended granular skills or direct code modifications. The typical sequence would be:
1.  **Identify requirements**: Understand what the new endpoint needs to do (e.g., input, output, business logic, database interactions, security).
2.  **Create DTOs**: Use `nestjs-dto-validation` to define the necessary DTOs.
3.  **Develop Service/Repository**: Implement the core logic in service and repository layers. This might involve using `sequelize-nestjs-model` and `sequelize-nestjs-repository` if new database entities are needed.
4.  **Define Controller**: Add the route handler in the appropriate controller.
5.  **Add Guards**: If authentication or authorization is required, apply guards using `nestjs-guards`.
6.  **Document with Swagger**: Update Swagger documentation with `nestjs-swagger-docs`.
7.  **Test**: Write comprehensive tests for the new functionality using `nestjs-unit-testing`.
This skill acts as a checklist and orchestrator, helping ensure all necessary components for a robust NestJS endpoint are created and integrated correctly.
