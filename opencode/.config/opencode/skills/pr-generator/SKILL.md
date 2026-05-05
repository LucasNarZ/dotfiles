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

Create a GitHub PR from the current branch to a target branch by analyzing the git diff first, then generating an accurate title and description automatically.

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

### Step 2: Get the full branch diff

If the current session already captured the branch diff for the same target branch, reuse it.

Otherwise, run:

```bash
git log --oneline {TARGET_BRANCH}..HEAD
git diff {TARGET_BRANCH}...HEAD --stat
git diff {TARGET_BRANCH}...HEAD
```

Read the diff output fully. This is the primary source of truth for what changed.

### Step 3: Draft the PR from the git diff

Analyze the diff and prepare the final PR title and body before calling GitHub.

### Step 4: Create the PR

```bash
gh pr create --base {TARGET_BRANCH} --title "{TYPE}: {brief description}" --body "$(cat <<'EOF'
{DESCRIPTION}
EOF
)"
```

Save the PR URL from the output.

### Step 5: Verify the created PR

```bash
gh pr view --json number,url,headRefName,baseRefName,changedFiles,additions,deletions
```

Use the response to confirm the PR was created against the intended target branch.

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
- Base everything on the actual git diff, not assumptions about project structure
- Do not rely on `gh pr diff` as the primary analysis source when the branch git diff is already available
- Skip "Added", "Modified", or "Removed" subsections if they have no content
- Skip the "Files Changed" table if there are fewer than 3 files (already covered by the diff analysis)
- Never invent test steps or validation criteria — omit those sections entirely
