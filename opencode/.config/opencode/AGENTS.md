# Guidelines

These guidelines are general instructions on how to act. These rules take precedence over any other instruction.

## rules

- Always check available skills and MCP tools before answering.
- Respond in the same language the user writes in.
- Ask for permission before running non-readonly(git diff for example is permitted) git, GitHub, package install, or any destructive commands (delete, drop, truncate).
- Be direct and precise. Only go into detail if the user asks for it.
- When uncertain about intent, ask before assuming.
- Never modify files outside the current project scope without explicit permission.
- By default, all docs are in english.
- If some doc, is in portuguese, use accents correctly

## skills

- Always read the relevant SKILL.md before starting any task that matches a skill domain.
- Skills take precedence over general knowledge for their domain.
- Available skills: docx, pdf, pdf-reading, pptx, xlsx, frontend-design, file-reading.
- When a task involves file creation or manipulation, check skills first — do not improvise.

## mcps

- Prefer MCP tools over web search or bash for their specific domain.
- Connected MCPs: Google Calendar, Gmail.
- Never expose MCP credentials or tokens in output.
- Always ask before sending emails or creating/modifying calendar events — these are irreversible actions.
- Read-only MCP queries (listing, fetching) can proceed without asking.

## permissions

### always ask before:

- Running git command (commit, push, merge, branch operations).
- Installing or removing packages.
- Sending emails or creating calendar events via MCP.
- Any destructive operation (delete, drop, truncate, overwrite).
- Creating files outside the current project directory.

### proceed without asking:

- Reading files or listing directories.
- Readonly git commands(git diff, git status).
- Running lint, typecheck, or test commands.
- Fetching or listing data via MCP (read-only queries).

## coding-standards

- Follow existing code style in the codebase — consistency beats personal preference.
- Prefer boring, proven solutions over trendy ones.
- Avoid comments in code.
- Write tests only when explicitly requested.
- If a new dependency is the best solution, suggest it and ask for permission before installing it. Do not avoid that option by default.
- When showing code changes, prefer diffs over full file rewrites.

## git-standards

- Use conventional commits: `feat:`, `fix:`, `chore:`, `refactor:`, `docs:`, `test:`.
- Keep commits atomic — one logical change per commit.
- Never force push to main/master.
- Always ask before creating, deleting, or merging branches.

