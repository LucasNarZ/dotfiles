---
name: create-skill
description: Create a new OpenCode skill by defining its name, trigger, workflow, and rules in a repo-local SKILL.md. Trigger when user says things like "create a skill", "add a new skill", or "make a skill called [name]".
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: documentation
---

## What I do

Create a new skill under `opencode/.config/opencode/skills/{skill-name}/SKILL.md` using the same structure and tone as the existing compact skills in this repository.

## Trigger

Any message like:
- "Create a skill for generating changelogs"
- "Add a new skill called api-review"
- "Make a skill to scaffold CRUD handlers"

Ask the user for the skill name and purpose if either is missing.

## Workflow

### Step 1: Define the skill contract

Capture the following before writing:
- `SKILL_NAME`: kebab-case name used for the directory and frontmatter `name`
- `DESCRIPTION`: one sentence that says what the skill does and when it should trigger
- `WORKFLOW_TYPE`: a short category such as `documentation`, `github`, `nestjs`, or `feature-development`

### Step 2: Create the file

Create:

```text
opencode/.config/opencode/skills/{SKILL_NAME}/SKILL.md
```

### Step 3: Write the skill

Use this structure:

```markdown
---
name: {SKILL_NAME}
description: {DESCRIPTION}
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: {WORKFLOW_TYPE}
---

## What I do

[One short paragraph describing the outcome of the skill]

## Trigger

Any message like:
- "[example trigger 1]"
- "[example trigger 2]"
- "[example trigger 3]"

[Add one short clarification if the skill needs user input before it can proceed]

## Workflow

### Step 1: [First action]

[Concrete instruction]

### Step 2: [Second action]

[Concrete instruction]

### Step 3: [Third action]

[Concrete instruction]

## Rules

- [Rule 1]
- [Rule 2]
- [Rule 3]
```

### Step 4: Register the skill

Add the new skill to `opencode/.config/opencode/skills/index/SKILL.md` in the most appropriate category.

## Rules

- Always write the skill in English
- Prefer short, executable instructions over broad guidance
- Match existing repository conventions for headings and frontmatter
- Use concrete trigger examples that mirror how a user would actually ask
- Avoid duplicating an existing skill when extending one would be clearer
- Keep the skill focused on one job; split it if the scope becomes broad
