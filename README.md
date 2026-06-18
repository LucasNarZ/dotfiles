# Lucas' Dotfiles

> A compact, keyboard-first development environment built around Neovim, Zsh, tmux, OpenCode, Codex, and Claude.

These dotfiles focus on a fast terminal workflow: fuzzy finding, project navigation, LSP-powered editing, persistent tmux sessions, useful shell plugins, and a clean dark aesthetic.

## What's Inside

| Area | Stack |
| --- | --- |
| Editor | Neovim + lazy.nvim |
| Shell | Zsh + Oh My Zsh + Powerlevel10k |
| Terminal multiplexer | tmux + TPM |
| Theme | Tokyo Night / Catppuccin-inspired dark colors |
| AI workflow | OpenCode commands, agents, and shared Codex/Claude links |

## Repository Layout

```text
.
+-- nvim/       # Neovim configuration
+-- claude/     # Claude config links backed by OpenCode files
+-- codex/      # Codex config links backed by OpenCode files
+-- opencode/   # OpenCode commands, agents, and package config
+-- tmux/       # tmux configuration
`-- zsh/        # Zsh, Oh My Zsh plugins, and Powerlevel10k config
```

## Neovim

The Neovim setup is managed with `lazy.nvim` and uses `<Space>` as the leader key. It is tuned for project navigation, LSP support, completion, Git workflows, and terminal integration.

### Plugins

| Plugin | Purpose |
| --- | --- |
| `lazy.nvim` | Plugin manager |
| `tokyonight.nvim` | Main colorscheme |
| `telescope.nvim` + `telescope-fzf-native.nvim` | Fuzzy finding with native FZF sorting |
| `nvim-tree.lua` | File explorer |
| `nvim-treesitter` | Better syntax parsing and highlighting |
| `mason.nvim` + `mason-lspconfig.nvim` | LSP server management |
| `nvim-lspconfig` | Language server setup |
| `nvim-cmp` + LuaSnip | Completion and snippets |
| `harpoon` | Fast file bookmarking and switching |
| `toggleterm.nvim` | Integrated terminal toggles |
| `vim-tmux-navigator` | Seamless navigation between Neovim and tmux panes |
| `gitsigns.nvim` | Git signs in the gutter |
| `vim-fugitive` | Git commands from inside Neovim |
| `Comment.nvim` | Fast code commenting |
| `nvim-autopairs` + `nvim-ts-autotag` | Pair and tag automation |
| `lualine.nvim` | Statusline |
| `undotree` | Undo history browser |
| `which-key.nvim` | Keybinding hints |
| `auto-save.nvim` | Automatic file saving |

### Keybinds

| Keybind | Mode | Action |
| --- | --- | --- |
| `<leader>ff` | Normal | Find files with Telescope |
| `<leader>fg` | Normal | Live grep with Telescope |
| `<leader>fb` | Normal | List open buffers |
| `<leader>fh` | Normal | Search help tags |
| `<leader>a` | Normal | Add current file to Harpoon |
| `<leader>h` | Normal | Open Harpoon quick menu |
| `<leader>1` - `<leader>5` | Normal | Jump to Harpoon files |
| `<leader>+` / `<leader>-` | Normal | Resize `nvim-tree` width |
| `<leader>o` | Normal | Open `nvim-tree` |
| `<leader>c` | Normal | Close `nvim-tree` |
| `<leader>y` | Normal / Visual | Copy selection or motion to system clipboard |
| `<leader>Y` | Normal | Copy current line to system clipboard |
| `<leader>yG` | Normal | Copy from cursor to end of file |
| `<leader>=` | Normal | Reindent the whole file |
| `<leader>s` | Normal | Substitute word under cursor |
| `<Esc><Esc>` | Normal | Clear search highlights |
| `<leader>e` | Normal | Open diagnostic float |
| `<leader>E` | Normal | Copy diagnostics from current line |
| `<leader>gs` | Normal | Open Fugitive Git status |
| `<leader>gc` | Normal | Create a Git commit with Fugitive |
| `<leader>gp` | Normal | Push with Fugitive |
| `gd` | Normal | Go to definition |
| `K` | Normal | Show hover documentation |
| `gr` | Normal | Find references |
| `<Tab>` / `<S-Tab>` | Insert | Navigate completion items |
| `<C-Space>` | Insert | Trigger completion |
| `<C-x>` | Terminal | Leave terminal mode and toggle terminal |
| `<A-j>` / `<A-k>` | Visual | Move selected lines down/up |

### Language Tooling

Configured LSP servers include:

| Server | Use |
| --- | --- |
| `ts_ls` | JavaScript and TypeScript |
| `pyright` | Python |
| `html` | HTML |
| `tailwindcss` | Tailwind CSS |
| `prettier` | Formatting integration |
| `emmet_ls` | HTML/CSS/React abbreviation expansion |

Diagnostics use floating windows with rounded borders, virtual text disabled, and sorted severity.

## Zsh

The shell setup uses Oh My Zsh with the Powerlevel10k theme and a small set of productivity plugins.

### Plugins

| Plugin | Purpose |
| --- | --- |
| `git` | Git aliases and helpers from Oh My Zsh |
| `zsh-autosuggestions` | Inline command suggestions from history |
| `zsh-syntax-highlighting` | Command syntax highlighting |
| `zsh-history-substring-search` | Search history by typed substring |

### Shell Features

| Feature | Description |
| --- | --- |
| Powerlevel10k | Fast, information-rich prompt |
| `direnv` hook | Automatic per-project environment loading |
| `~/.env` loading | Local environment variables when present |
| `$HOME/.local/bin` | Added to `PATH` for local user binaries |
| `$HOME/.opencode/bin` | Added to `PATH` for OpenCode tools |

## tmux

tmux is configured for vi-style copy mode, mouse support, clipboard integration, session persistence, and smooth Neovim navigation.

### Plugins

| Plugin | Purpose |
| --- | --- |
| `tmux-plugins/tpm` | tmux plugin manager |
| `tmux-resurrect` | Restore tmux sessions |
| `tmux-continuum` | Automatic session save and restore |
| `tmux-prefix-highlight` | Show prefix/copy-mode state in the statusline |
| `tmux-yank` | Clipboard-friendly copy workflow |
| `vim-tmux-navigator` | Move between tmux panes and Vim splits naturally |

### tmux Details

| Setting | Value |
| --- | --- |
| Default shell | `/usr/bin/zsh` |
| Copy mode | vi keys |
| Mouse | Enabled |
| Clipboard | `xclip` through `copy-pipe-and-cancel` |
| Session restore | Enabled through tmux-continuum |
| Status colors | Tokyo Night-style dark palette |

## AI Tools

The `opencode` directory contains local OpenCode configuration, reusable commands, and specialized agents for development workflows.

The `codex` and `claude` directories expose the same shared OpenCode commands, agents, skills, and instructions through tool-specific config paths using symlinks. MCP server definitions are kept as tool-specific config files because Codex and Claude use different config schemas.

### Commands

| Command file | Purpose |
| --- | --- |
| `quick-task.md` | Lightweight task workflow |
| `execute-task.md` | Execute planned implementation work |
| `create-pr.md` | Pull request creation workflow |
| `create-resume.md` | Resume generation workflow |

### Agents

| Agent | Focus |
| --- | --- |
| `architect` | Architecture and design guidance |
| `feature-implementation` | Feature development |
| `bug-fixer` | Debugging and fixes |
| `refactoring` | Code improvement |
| `security-review` | Security analysis |
| `pr-review` | Pull request review |
| `release-engineer` | Release support |
| `teacher` | Explanations and learning support |

## Installation Notes

This repository is designed to be used with GNU Stow. Each top-level directory is a package that can be symlinked into the matching location in `$HOME`. Review the files before applying them on a new machine, especially shell paths and tmux clipboard behavior.

Example:

```sh
stow nvim zsh tmux opencode codex claude
```

Common targets:

| Source | Target |
| --- | --- |
| `nvim/.config/nvim` | `~/.config/nvim` |
| `zsh/.zshrc` | `~/.zshrc` |
| `zsh/.p10k.zsh` | `~/.p10k.zsh` |
| `tmux/.tmux.conf` | `~/.tmux.conf` |
| `opencode/.config/opencode` | `~/.config/opencode` |
| `codex/.codex` | `~/.codex` |
| `claude/.claude` | `~/.claude` |
| `claude/.claude.json` | `~/.claude.json` |

## Philosophy

- Keep the editor fast and predictable.
- Prefer keyboard-first navigation.
- Make project search and file switching instant.
- Keep shell and tmux state resilient across sessions.
- Document useful workflows close to the configuration that powers them.
