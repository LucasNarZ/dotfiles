---
name: update-docs
description: Use when preparing branch changes for review or PR creation and documentation may need to be updated based on the git diff against a target branch.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## What I do

Review the git diff between the current branch and a target branch, identify repository docs affected by those changes, and update the relevant documentation before the PR is created.

## Trigger

Any message like:
- "Update the docs before opening the PR"
- "Check if this branch needs doc updates"
- "Refresh repository docs based on the diff to main"

If the target branch is not provided, ask which branch should be used as the diff base.

## Workflow

### Step 1: Resolve the comparison scope

Use the current branch as the source branch and the user-provided branch as the target branch.

If the target branch is missing, ask for it before proceeding.

### Step 2: Inspect the branch diff

If the current session already gathered the branch diff for the same target branch, reuse it.

Otherwise, run git diff analysis against the target branch to understand what changed.

Use these commands:

```bash
git log --oneline <target-branch>..HEAD
git diff <target-branch>...HEAD --stat
git diff <target-branch>...HEAD
```

Treat the diff as the primary source of truth.

### Step 3: Locate related documentation

Search the repository for documentation that matches the changed behavior, files, commands, workflows, or public contracts.

Check locations such as:
- `README.md`
- `docs/`
- feature-specific markdown files
- local skill docs when the workflow changed

Update only the documentation that is directly affected by the diff.

### Step 4: Apply the documentation updates

Edit the relevant docs to match the current branch behavior.

Prefer concrete updates such as:
- new commands or flags
- changed setup steps
- updated workflow order
- renamed files, paths, or interfaces
- behavior changes that affect users or contributors

### Step 5: Report what changed

Summarize which documentation files were updated and why they were relevant to the branch diff.

If no doc changes are needed, say that explicitly.

## Rules

- Always base documentation updates on the actual git diff, not assumptions
- Update only docs that are directly affected by the branch changes
- Prefer repository docs over adding new docs unless the diff introduces a genuinely undocumented workflow
- If the diff is docs-only, still verify whether existing docs now need consistency updates elsewhere
- If the changes are ambiguous and documentation impact is unclear, ask the user instead of guessing
