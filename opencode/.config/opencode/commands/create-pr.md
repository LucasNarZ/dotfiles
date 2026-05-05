---
description: Create a PR targeting the given branch
---

Create a pull request from the current branch to the target branch provided in `$ARGUMENTS`.

Before invoking any workflow skill, collect the branch diff once against `$ARGUMENTS` and treat it as the primary source of truth for everything that follows.

Use these commands:

```bash
git log --oneline $ARGUMENTS..HEAD
git diff $ARGUMENTS...HEAD --stat
git diff $ARGUMENTS...HEAD
```

After that:

1. Invoke the `update-docs` skill and update any repository docs affected by that diff.
2. If the repository has a `CHANGELOG.md` workflow, invoke the `changelog-generator` skill and update the changelog from that same diff.
3. Invoke the `pr-generator` skill and create the PR using that same diff as the source of truth.

Do not switch to `gh pr diff` as the primary analysis source when the git diff already covers the branch changes.

Rules:
- Treat the current branch as the source branch.
- Treat `$ARGUMENTS` as the target branch.
- If `$ARGUMENTS` is empty, ask the user which target branch should be used before proceeding.
- Reuse the same branch diff across docs, changelog, and PR generation.
- Run `update-docs` before `pr-generator`.
- Keep the pull request title and body in English, as required by the skill.
