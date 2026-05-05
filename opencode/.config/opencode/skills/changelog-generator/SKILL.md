---
name: changelog-generator
description: Generate and manage CHANGELOG.md following Keep a Changelog format with Semantic Versioning. Use this skill whenever the user mentions changelog, release notes, versioning, wants to document changes between branches, asks to "add changes to changelog", "update changelog for branch X", "promote unreleased to version", or any task involving tracking what changed between dev/hml/main branches. Always use this skill for git diff analysis + changelog authoring workflows.
license: MIT
compatibility: opencode
metadata:
  audience: maintainers
  workflow: github
---

## What I do
- Generate CHANGELOG.md following Keep a Changelog format
- Analyze git diffs between branches to extract meaningful changes
- Manage `[Unreleased]` section for active development
- Promote unreleased changes to versioned releases when merging to hml/main
- Apply Semantic Versioning rules (MAJOR.MINOR.PATCH)

## When to use me
- "Adicione no changelog as modificações da branch dev"
- "Update changelog with changes from feature/X"
- "Promote unreleased to version 1.2.0"
- Any time someone wants to document what changed between two git refs

---

## Workflow

### 1. Dev branch — Adding changes from a branch diff

When the user says something like **"add changes from branch X to changelog"**:

**Step 1 — Identify the target branch**
Extract the branch name from the user's message. If not specified, ask for clarification.

**Step 2 — Get the diff**
If the current session already captured the diff for the same target branch, reuse that output.

Otherwise, run the following commands to capture the diff between the current branch and the target:

```bash
git fetch --all --quiet

git log --oneline <target-branch>..HEAD
git diff <target-branch>...HEAD --stat
git diff <target-branch>...HEAD
```

If the user specifies a base branch explicitly (e.g., "diff against main"), use that instead of HEAD:
```bash
git diff <base-branch>...<target-branch> --stat
git diff <base-branch>...<target-branch>
```

**Step 3 — Analyze the diff**
From the diff output, identify:
- New files added → likely `Added`
- Deleted files → likely `Removed`
- Modified files → inspect changes to classify as `Fixed`, `Changed`, `Added`, or `Security`
- Breaking interface changes (API, public contracts) → flag for MAJOR bump consideration
- Dependency changes (package.json, go.mod, requirements.txt, etc.) → note if relevant to users

**Step 4 — Write changelog entries**
Translate the technical diff into human-readable entries following the Entry Style Guidelines below. Place them under `## [Unreleased]` at the top of CHANGELOG.md.

---

### 2. Merge to hml — Promoting [Unreleased] to a version

When the user wants to release:

1. Read the current `[Unreleased]` section
2. Determine the version bump based on Semantic Versioning Rules below
3. Replace `## [Unreleased]` with `## [X.Y.Z] - YYYY-MM-DD`
4. Add a fresh empty `## [Unreleased]` section above it

---

## Git Diff Commands Reference

| Goal | Command |
|------|---------|
| Commits not yet in base | `git log --oneline <base>..<head>` |
| File-level summary | `git diff <base>...<head> --stat` |
| Full diff | `git diff <base>...<head>` |
| Only staged changes | `git diff --cached` |
| Since last tag | `git diff $(git describe --tags --abbrev=0)...HEAD` |

> Use `...` (three dots) for symmetric diff (changes introduced by HEAD relative to the merge-base with base). Use `..` (two dots) for direct range.

---

## CHANGELOG.md Template

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- [New feature 1]

### Changed
- [Change 1]

### Deprecated
- [Soon-to-be removed feature]

### Removed
- [Removed item 1]

### Fixed
- [Bug fix 1]

### Security
- [Security fix 1]

## [0.1.36] - 2026-03-16

### Fixed
- Previous version fix

### Added
- Previous feature
```

---

## Promoting Unreleased to Version

**Example transformation:**

```markdown
## [Unreleased]
### Fixed
- Null pointer on empty user list

## [0.1.36] - 2026-03-16
...
```

becomes:

```markdown
## [Unreleased]

## [0.1.37] - 2026-03-22
### Fixed
- Null pointer on empty user list

## [0.1.36] - 2026-03-16
...
```

---

## Semantic Versioning Rules

| Change Type | Version Bump | Example |
|-------------|-------------|---------|
| Breaking / incompatible API change | MAJOR (X.0.0) | 1.0.0 → 2.0.0 |
| New backward-compatible feature | MINOR (0.Y.0) | 1.0.0 → 1.1.0 |
| Backward-compatible bug fix | PATCH (0.0.Z) | 1.0.0 → 1.0.1 |
| Deprecation (still works) | MINOR | Mark deprecated |
| Security fix (no API change) | PATCH | 1.0.0 → 1.0.1 |

When in doubt about bump type, ask the user.

---

## Entry Style Guidelines

- **Imperative mood**: Add, Fix, Remove, Change, Update, Deprecate
- **Be specific**: include endpoint names, function names, file paths when relevant
- **One entry per change**, not per file
- **Group related changes** into a single entry if they belong together
- **Reference issues/PRs** when available: `Fix login redirect loop (#312)`
- **Capitalize first letter**, no trailing period
- **Omit internal/dev-only changes** (linting config, test setup, CI tweaks) unless they affect consumers
- **Dependency bumps**: only include if they affect runtime behavior or fix a vulnerability

### Section order in each version block
1. Added
2. Changed
3. Deprecated
4. Removed
5. Fixed
6. Security

Omit empty sections entirely.

---

## Reading Diff Output — Classification Heuristics

| Signal in diff | Likely section |
|----------------|----------------|
| New route / endpoint / exported function | Added |
| New config option | Added |
| Error message / status code fix | Fixed |
| Null/undefined guard | Fixed |
| Renamed field in response body | Changed (potential MAJOR if breaking) |
| Removed exported symbol | Removed (potential MAJOR) |
| Dependency CVE patch | Security |
| Interface/type signature change | Changed or MAJOR |
| Feature flag removed, feature now always on | Changed |
