---
name: pr-generator
description: Create GitHub pull requests from the current branch using a target-branch diff, documentation and changelog preparation, optional MCP task context, and GitHub CLI verification. Use whenever the user asks to create, open, or make a PR to another branch.
---

# PR Generator

Create a GitHub pull request from the current branch to a user-provided target branch. Use one branch diff as the primary source of truth across documentation, changelog, and PR generation.

## Workflow

### 1. Resolve the branches

Run:

```bash
git branch --show-current
```

Use the result as `SOURCE_BRANCH` and the branch named by the user as `TARGET_BRANCH`. If the user did not provide a target branch, ask for one before proceeding.

### 2. Ask about a related task

Ask whether a relevant task is related to the pull request unless the user already provided a task ID or explicitly said there is no task.

If the user provides a task ID:

- Use the connected task-management MCP tools to retrieve the task. Prefer an exact-ID lookup; use MCP search when the provider does not support direct lookup.
- If multiple task providers are available and the ID does not identify one clearly, ask which provider contains the task.
- Retrieve the task ID, title, URL, and the description, acceptance criteria, or status needed to explain its relationship to the pull request.
- If the task cannot be found, ask the user to verify the ID. Never invent task details.
- Use the task only as supporting context. The git diff remains the source of truth for claims about the implementation.

If there is no related task, continue without a task section.

### 3. Capture the full branch diff once

If the current session already captured the branch diff for the same target branch, reuse it. Otherwise, run:

```bash
git log --oneline {TARGET_BRANCH}..HEAD
git diff {TARGET_BRANCH}...HEAD --stat
git diff {TARGET_BRANCH}...HEAD
```

Read the complete output and reuse it across every remaining step. Do not switch to `gh pr diff` as the primary analysis source.

### 4. Prepare repository documentation

- Invoke `update-docs` with the captured diff before generating the pull request.
- Let `update-docs` invoke `write-doc` when documentation changes are needed.
- If the repository uses a `CHANGELOG.md` workflow, invoke `changelog-generator` with the same diff.
- Run these preparations in this order: `update-docs`, `changelog-generator` when applicable, then PR generation.

### 5. Draft the pull request

Analyze the captured diff and prepare the final title and body before calling GitHub.

Use this title format:

`[type]: [brief description]`

| Type | When to use |
|------|-------------|
| `feat` | New feature |
| `fix` | Bug fix |
| `refactor` | Code restructuring without behavior changes |
| `docs` | Documentation only |
| `chore` | Tooling, dependencies, or configuration |
| `perf` | Performance improvement |

Use the following body structure, including only sections with real content:

```markdown
## Summary
[Explain what the pull request does and why in one or two sentences.]

## Related task
[TASK-123: Task title](task URL)

[Summarize the relevant task context and explain how this pull request relates to it.]

## Changes
- [Key change]
- [Key change]

## Implementation notes
[Explain non-obvious decisions, trade-offs, or alternatives.]

## Testing
- [Verification actually performed]
- [Edge cases actually covered]

## Notes for reviewers
[Call out areas needing attention, uncertainties, or intentionally excluded scope.]
```

Include `Closes TASK-123` only when the retrieved task context and the diff show that the pull request completes the task. Otherwise, use a neutral task reference.

### 6. Create the pull request

Ask for the user's permission immediately before running the non-read-only GitHub command. After approval, run:

```bash
gh pr create --base {TARGET_BRANCH} --title "{TYPE}: {brief description}" --body "$(cat <<'EOF'
{DESCRIPTION}
EOF
)"
```

Save the PR URL from the output.

### 7. Verify the created pull request

```bash
gh pr view --json number,url,headRefName,baseRefName,changedFiles,additions,deletions
```

Use the response to confirm the PR was created against the intended target branch.

## Rules

- Always write titles and descriptions in English.
- Base implementation claims on the actual git diff, not assumptions or task descriptions.
- Reuse the same captured diff across documentation, changelog, and PR generation.
- Never use `gh pr diff` as the primary analysis source when the branch diff is available.
- Omit placeholders and sections without real content.
- Skip `Added`, `Modified`, or `Removed` subsections when they have no content.
- Skip the `Files Changed` table when fewer than three files changed.
- Never invent tests, validation criteria, task details, or task relationships.
