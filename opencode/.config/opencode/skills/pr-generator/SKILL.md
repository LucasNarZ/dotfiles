---
name: pr-generator
description: Generate structured PR descriptions using GitHub CLI. Trigger when user says anything like "create a PR", "open a PR", "make a PR to [branch]", or "PR para [branch]".
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: github
---

## What I do

Create a GitHub PR from the current branch to a target branch by analyzing the actual diff, then generating an accurate title and description automatically.

## Trigger

Any message like:
- "Create a PR to dev"
- "Cria um PR para main"
- "Open a PR targeting staging"

The current branch is always the source. The branch mentioned by the user is always the target.

## Workflow

### Step 1: Resolve branches

```bash
git branch --show-current
```

Use the output as `SOURCE_BRANCH`. The branch the user mentioned is `TARGET_BRANCH`.

### Step 2: Create placeholder PR

```bash
gh pr create --base {TARGET_BRANCH} --title "WIP" --body "Work in progress"
```

Save the PR number from the output.

### Step 3: Get the full diff

```bash
gh pr diff {PR_NUMBER}
```

Read the entire diff output. This is the primary source of truth for what changed — do not read individual files unless the diff is insufficient to understand context.

### Step 4: Get metadata

```bash
gh pr view {PR_NUMBER} --json number,headRefName,baseRefName,changedFiles,additions,deletions,files
```

### Step 5: Update PR

Analyze the diff and generate the final PR. Then run:

```bash
gh pr edit {PR_NUMBER} \
  --title "{TYPE}: {brief description}" \
  --body "$(cat <<'EOF'
{DESCRIPTION}
EOF
)"
```

## Title format

`[type]: [brief description]`

| Type | When to use |
|------|-------------|
| feat | new feature |
| fix | bug fix |
| refactor | code restructuring without behavior change |
| docs | documentation only |
| chore | tooling, deps, config |
| perf | performance improvement |

## Description template

Only include sections that have real content. Omit any section that would be N/A or a placeholder.

```markdown
## Context
[What problem this solves or what need it addresses]

---

## Changes Made

### Added
- [New things]

### Modified
- [What changed and why]

### Removed
- [What was deleted]

---

## Files Changed

| File | Change Type | Purpose |
|------|-------------|---------|
| path/to/file | added/modified/deleted | what it does |
```

## Rules

- Always write titles and descriptions in English
- Base everything on the actual diff, not assumptions about project structure
- Skip "Added", "Modified", or "Removed" subsections if they have no content
- Skip the "Files Changed" table if there are fewer than 3 files (already covered by the diff analysis)
- Never invent test steps or validation criteria — omit those sections entirely
