---
description: Create a PR targeting the given branch
---

Create a pull request from the current branch to the target branch provided in `$ARGUMENTS`.

Before doing anything else, invoke the `pr-generator` skill and follow it exactly.

Rules:
- Treat the current branch as the source branch.
- Treat `$ARGUMENTS` as the target branch.
- If `$ARGUMENTS` is empty, ask the user which target branch should be used before proceeding.
- Keep the pull request title and body in English, as required by the skill.
