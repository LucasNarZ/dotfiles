---
name: update-docs
description: Use when preparing branch changes for review or PR creation and documentation impact must be identified from the git diff against a target branch.
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## What I do

Review the git diff between the current branch and a target branch, identify documentation impact, and hand off documentation writing standards to `write-doc`.

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

### Step 3: Identify documentation impact

Use the diff to identify changed behavior, files, commands, workflows, public contracts, architecture, or standards that may need documentation.

Report the documentation areas that appear affected, such as README content, module docs, architecture docs, standards docs, local skills, or release-facing docs.

Do not apply documentation standards in this skill. Invoke `write-doc` to create or update the actual documentation using the repository documentation patterns.

### Step 4: Hand off to write-doc

If documentation changes are needed, invoke `write-doc` with the relevant diff context, affected files, and target documentation areas.

If no documentation changes are needed, say that explicitly and explain which diff facts led to that conclusion.

### Step 5: Report the result

Summarize the diff scope, the documentation areas identified, and whether `write-doc` was invoked.

If no doc changes are needed, say that explicitly.

## Rules

- Always base documentation updates on the actual git diff, not assumptions
- Use this skill to identify documentation impact, not to define documentation structure or prose standards
- Delegate module docs, architecture docs, and standards docs to `write-doc`
- If the diff is docs-only, still verify whether existing docs now need consistency updates elsewhere
- If the changes are ambiguous and documentation impact is unclear, ask the user instead of guessing
