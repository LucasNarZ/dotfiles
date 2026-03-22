---
name: changelog-generator
description: Generate and manage changelog following Keep a Changelog format with Semantic Versioning
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do

- Generate CHANGELOG.md following Keep a Changelog format
- Manage [Unreleased] section for dev branch development
- Promote unreleased changes to versioned releases when merging to hml
- Apply Semantic Versioning rules (MAJOR.MINOR.PATCH)

## When to use me

Use this when preparing releases or merging to main/hml branches. Ask for clarification on version bump type if needed.

## Workflow

1. **Dev branch**: Add changes under `## [Unreleased]` at the TOP of the file
2. **Merge to hml**: Replace `[Unreleased]` with `[X.Y.Z] - YYYY-MM-DD`

## Complete Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Fixed
- [Bug fix 1]
- [Bug fix 2]

### Added
- [New feature 1]

### Changed
- [Change 1]

### Removed
- [Removed item 1]

## [0.1.36] - 2026-03-16

### Fixed
- Previous version fix

### Added
- Previous feature
```

## Adding New Changes

```markdown
## [Unreleased]

### Added
- New endpoint for user profile
- Authentication middleware

### Fixed
- Validation error on login endpoint
- Memory leak in background worker

### Changed
- Updated database schema for performance

### Removed
- Deprecated /api/v1/auth/login endpoint
```

## Promoting Unreleased to Version

When merging from dev to hml:

1. Take all content from [Unreleased]
2. Replace `## [Unreleased]` with `## [X.Y.Z] - YYYY-MM-DD`
3. Move content under appropriate subsections
4. Add new empty [Unreleased] section at top for next release

**Example transformation:**

```markdown
## [Unreleased]
### Fixed
- Bug fix

<!-- becomes -->

## [0.1.37] - 2026-03-22
### Fixed
- Bug fix

## [Unreleased]
```

## Semantic Versioning Rules

| Change Type | Version Bump | Example |
|-------------|-------------|---------|
| Breaking/incompatible API | MAJOR (X.0.0) | 1.0.0 → 2.0.0 |
| New backward-compatible feature | MINOR (0.Y.0) | 1.0.0 → 1.1.0 |
| Backward-compatible bug fix | PATCH (0.0.Z) | 1.0.0 → 1.0.1 |
| Deprecation | MINOR | Mark deprecated, remove in next MAJOR |

## Entry Style Guidelines

- Use imperative mood: add, fix, remove, change
- Be specific: include file/function/endpoint names when relevant
- Group related changes together
- One entry per line
- Reference issues/PRs if applicable (#123, !456)
- Keep concise but informative
- Capitalize first letter

## Standard Sections (in order)

1. Added - new features
2. Changed - changes in existing functionality
3. Deprecated - soon-to-be removed features
4. Removed - removed features
5. Fixed - bug fixes
6. Security - security fixes
