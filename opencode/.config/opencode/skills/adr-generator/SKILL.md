---
name: adr-generator
description: Create Architecture Decision Records (ADR) following Michael Nygard template format
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Generate ADR documents following Michael Nygard template
- Support all ADR statuses: Proposed, Accepted, Deprecated, Superseded
- Create ADR index README for project documentation
- Provide best practices for writing effective ADRs

## When to use me

Use this when recording significant architectural decisions that affect the project direction. Ask clarifying questions if the ADR numbering scheme is unclear.

## ADR Structure

```
# ADR-XXXX: Title

## Status
[Proposed | Accepted | Deprecated | Superseded by ADR-YYYY]

## Context
[Describe the issue motivating this decision. Include relevant constraints, requirements, and any alternatives considered.]

## Decision
[Describe the change being proposed/decided. Use active voice: "We will...", "We have decided to..."].

## Consequences

### Positive
- [Benefit 1]
- [Benefit 2]

### Negative
- [Drawback 1]
- [Drawback 2]

### Neutral
- [Impact that is neither positive nor negative]

## Related ADRs
- [ADR-001: Related decision]
- [ADR-002: Another related]

## Notes
[Any additional notes, links to discussions, or references]
```

## Example: Proposed ADR

```markdown
# ADR-0001: Use PostgreSQL as Primary Database

## Status
Proposed

## Context
We need to choose a database for our application. The requirements are:
- Support for JSON data types
- ACID compliance
- Good performance with complex queries
- Active community and support

We evaluated:
- PostgreSQL
- MySQL
- MongoDB

## Decision
We will use PostgreSQL as the primary database.

## Consequences

### Positive
- Strong ACID compliance
- Excellent JSON support with JSONB
- Rich ecosystem and extensions
- Great performance for complex queries

### Negative
- More complex setup than SQLite
- Higher resource requirements

### Neutral
- Requires learning SQL nuances for JSON operations

## Related ADRs
N/A - First ADR

## Notes
- Initial discussion: https://github.com/org/repo/discussions/123
```

## ADR Index Template

```markdown
# Architecture Decision Records (ADR)

This directory contains the ADRs for this project.

## Index

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [0001](0001-use-postgres-database.md) | Use PostgreSQL as Primary Database | Accepted | 2024-01-20 |
| [0002](0002-adopt-nestjs-framework.md) | Adopt NestJS Framework | Accepted | 2024-02-15 |

## Creating a new ADR

1. Copy the template: `cp adr-template.md doc/adr/XXXX-title.md`
2. Fill in the sections
3. Set status to "Proposed"
4. Update this README with the new ADR
```

## Best Practices

- Use imperative mood in Decision section
- Be specific and concise
- Include both positive and negative consequences
- Link related ADRs
- Include dates for status changes
- Use consistent numbering (0001, 0002, etc.)
- Write in English (or project language)
- Review and discuss before accepting
