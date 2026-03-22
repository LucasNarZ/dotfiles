---
name: pr-generator
description: Generate structured PR descriptions using GitHub CLI workflow
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: github
---

## What I do

- Create PRs with placeholder title initially
- Use `gh` CLI to get actual diff and file information from the PR
- Analyze changed files by reading key source files
- Update PR with accurate title and detailed description
- Use English for all descriptions and titles regardless of the project type

## When to use me

Use this when drafting a pull request. The workflow:
1. Create PR with placeholder
2. Analyze changes via gh
3. Update with detailed description

## Workflow

### Step 1: Create PR with Placeholder

First, create the PR with a placeholder title to establish the PR number:

```bash
gh pr create --title "WIP" --body "Work in progress"
```

### Step 2: Get PR Details via gh

Use `gh pr view` to get the actual changes:

```bash
gh pr view [PR_NUMBER] --json title,body,changedFiles,additions,deletions,files
```

This returns:
- List of changed files with additions/deletions per file
- Total changed files, additions, deletions
- Current title and body

### Step 3: Analyze Changes

Based on the file list from `gh pr view`, read key files to understand what changed:

**For backend changes:**
- `app/main.py` - Entry point changes
- `app/routers/*.py` - API endpoints
- `app/services/**/*.py` - Business logic
- `app/models/*.py` - Database models
- `app/schemas/*.py` - API schemas
- `app/tests/**/*.py` - Tests

**For frontend changes:**
- `src/App.tsx` - Main component
- `src/components/*.tsx` - UI components
- `src/types/*.ts` - TypeScript types
- `src/context/*.ts` - React context

**For infrastructure:**
- `docker-compose*.yml` - Docker services
- `infra/**/*.yml` - Config files
- `nginx*.conf` - Web server config

Read 3-6 key files to understand the scope and purpose of changes.

### Step 4: Update PR with Full Description

Use `gh pr edit` to update the PR:

```bash
gh pr edit [PR_NUMBER] \
  --title "[type]: [brief description]" \
  --body "$(cat <<'EOF'
[Full PR description]
EOF
)"
```

## PR Title Format

Format: `[type]: [brief description]`

| Type | Description |
|------|-------------|
| feat | new feature |
| fix | bug fix |
| refactor | code refactoring |
| docs | documentation |
| chore | maintenance |
| perf | performance |

## PR Description Template

```markdown
## Task
N/A (or task ID if available)

---

## Branches
- Source: [source-branch]
- Target: [target-branch]

---

## Context
[Description of the problem/need]

---

## Objective
- [Main objective 1]
- [Main objective 2]

---

## Changes Made

### Added
- [New features - be specific]

### Modified
- [Existing changes - what changed]

### Fixed
- [Bug fixes]

### Removed
- [Removed items]

---

## Files Changed

| File | Change Type | Purpose |
|------|-------------|---------|
| path/to/file | added/modified | brief purpose |

---

## How to Test

### Backend
```bash
cd backend
[test command]
```

### Frontend
```bash
[test command]
```

### Manual
1. [Step 1]
2. [Step 2]

---

## Validation Criteria
- [ ] [Criteria 1]
- [ ] [Criteria 2]
- [ ] [Criteria 3]

---

## Technical Notes (optional)
- [Additional info]
```

## Handling Missing Information

If any information is not provided by the user and cannot be inferred from the context or code analysis, use "N/A" for that field.

## Example

```
User: Create a PR from dev to main

Assistant:
1. gh pr create --title "WIP" --body "Work in progress"
2. gh pr view [NUMBER] --json files,changedFiles
3. Read key files (main.py, services, routers, etc.)
4. gh pr edit [NUMBER] --title "feat: ..." --body "..."
```
