# Dotfiles Guide

This repository contains two main user-facing configurations:

- [`.wezterm.lua`](.wezterm.lua): terminal workflow, panes, tabs, and workspaces.
- [`nvim/`](nvim): Neovim editor, plugins, keymaps, LSP, search, and UI.

Both are currently themed with Rose Pine Moon.

## Repository Layout

```text
.
├── .wezterm.lua
└── nvim
    ├── init.lua
    ├── lua
    │   ├── plugins
    │   └── ui
    ├── after
    │   └── ftplugin
    └── doc
```

## WezTerm Guide

### What this WezTerm config does

The WezTerm setup is defined in [`.wezterm.lua`](.wezterm.lua). It is configured around a tmux-like leader workflow:

- Shell: starts `zsh` as a login shell.
- Theme: `rose-pine-moon`.
- Window style:
  - 95% background opacity
  - macOS blur enabled
  - resize-only window decorations
  - close confirmation prompt enabled
- Navigation:
  - leader-based pane and tab control
  - workspaces enabled
  - custom status bar on the left and right
- Inactive panes are dimmed to make the active pane clearer.

### Leader key

The WezTerm leader key is `Ctrl+a`.

Press `Ctrl+a`, then press a second key within 1000 ms to trigger a command.

Examples:

- `Ctrl+a`, then `s`: split vertically
- `Ctrl+a`, then `v`: split horizontally
- `Ctrl+a`, then `t`: open a new tab

### Pane management

Pane navigation and layout are the core of this config.

| Key | Action |
| --- | --- |
| `Ctrl+a`, `s` | Split the current pane vertically |
| `Ctrl+a`, `v` | Split the current pane horizontally |
| `Ctrl+a`, `h` | Move to left pane |
| `Ctrl+a`, `j` | Move to pane below |
| `Ctrl+a`, `k` | Move to pane above |
| `Ctrl+a`, `l` | Move to right pane |
| `Ctrl+a`, `q` | Close current pane with confirmation |
| `Ctrl+a`, `z` | Toggle pane zoom |
| `Ctrl+a`, `o` | Rotate panes clockwise |
| `Ctrl+a`, `r` | Enter pane resize mode |

#### Resize mode

After pressing `Ctrl+a`, `r`, the terminal enters a key table for pane resizing.

Use:

- `h`: shrink left
- `j`: shrink down
- `k`: shrink up
- `l`: shrink right
- `Esc` or `Enter`: exit resize mode

### Tab management

Tabs are managed with leader shortcuts.

| Key | Action |
| --- | --- |
| `Ctrl+a`, `t` | Open a new tab |
| `Ctrl+a`, `[` | Go to previous tab |
| `Ctrl+a`, `]` | Go to next tab |
| `Ctrl+a`, `n` | Open tab navigator |
| `Ctrl+a`, `e` | Rename current tab |
| `Ctrl+a`, `m` | Enter tab move mode |
| `Ctrl+a`, `Shift+{` | Move tab left |
| `Ctrl+a`, `Shift+}` | Move tab right |
| `Ctrl+a`, `1` to `9` | Jump directly to tab 1 through 9 |

#### Tab move mode

After pressing `Ctrl+a`, `m`:

- `h` or `j`: move tab left
- `k` or `l`: move tab right
- `Esc` or `Enter`: exit tab move mode

### Workspaces

This config enables WezTerm workspaces and sets the default workspace to `main`.

| Key | Action |
| --- | --- |
| `Ctrl+a`, `w` | Open the workspace launcher |

Use workspaces when you want separate terminal contexts for different projects or tasks without mixing panes and tabs into one giant window state.

### Copy mode and command palette

| Key | Action |
| --- | --- |
| `Ctrl+a`, `c` | Activate copy mode |
| `Ctrl+a`, `Space` | Open command palette |

### Status bar

This config updates status once per second and shows different data on the left and right sides.

Left status:

- Current workspace name
- Current key table name when a special mode is active
- `LDR` when the leader key is active

Right status:

- Current working directory of the active pane
- Foreground process name
- Current time

This means you can tell at a glance:

- where the active shell is
- what command is running
- whether you are in a resize or move mode

### Appearance notes

Important UI settings:

- fancy tab bar is disabled
- tab bar stays at the top
- background opacity changes slightly when the window loses focus
- inactive panes are desaturated and dimmed

### Practical WezTerm workflow

A typical session might look like this:

1. Open WezTerm.
2. Use `Ctrl+a`, `w` to pick or create a workspace.
3. Split panes with `Ctrl+a`, `s` and `Ctrl+a`, `v`.
4. Move around with `Ctrl+a`, `h/j/k/l`.
5. Open more tabs with `Ctrl+a`, `t`.
6. Rename a tab with `Ctrl+a`, `e` when a tab gets a specific role such as `server`, `tests`, or `git`.

### Reloading WezTerm config

If WezTerm is installed normally, you can reload the config from WezTerm itself through the command palette or by restarting the app. The config file to edit is [`.wezterm.lua`](.wezterm.lua).

## Neovim Guide

### What this Neovim config does

The main Neovim entry point is [`nvim/init.lua`](nvim/init.lua). It bootstraps `lazy.nvim`, loads plugins from [`nvim/lua/plugins`](nvim/lua/plugins), and enables custom UI modules from [`nvim/lua/ui`](nvim/lua/ui).

This configuration focuses on:

- keyboard-driven navigation
- built-in LSP with Mason-managed servers
- Telescope-powered search
- persistent terminal workflows
- a custom statusline, tabline, and startup dashboard
- Treesitter highlighting and selection
- filetype-specific editing helpers

### Theme

Neovim uses Rose Pine Moon through [ `nvim/lua/plugins/rose-pine.lua` ](nvim/lua/plugins/rose-pine.lua).

Transparency is enabled, so floating windows and editor surfaces keep a translucent look when your terminal supports it.

### Leader key

The Neovim leader key is `Space`.

When this README says `<leader>x`, read it as:

- press `Space`
- then press `x`

Examples:

- `<leader>n`: toggle file explorer
- `<leader>sf`: find files
- `<leader>tt`: open the floating terminal

### Core editor behavior

Out of the box, this config changes several defaults:

- line numbers and relative numbers are enabled
- both cursor line and cursor column are enabled
- search is case-insensitive unless you use uppercase characters
- substitution preview opens in a split via `inccommand=split`
- vertical splits open to the right
- horizontal splits open below
- 24-bit color is enabled
- wrapped lines keep indentation
- special whitespace characters are shown
- mouse support is enabled
- unsaved changes trigger confirmation prompts

Movement and search refinements:

- `j` and `k` move by screen line when no count is provided
- `n` and `N` keep the match centered
- `Ctrl+d` and `Ctrl+u` keep the cursor centered
- `Esc` clears search highlighting

### Startup UI

When Neovim opens without a file, or with a directory like `nvim .`, it shows a custom dashboard from [`nvim/lua/ui/dashboard.lua`](nvim/lua/ui/dashboard.lua).

The dashboard:

- displays a random cat-themed ASCII header
- shows the current date and time
- respects the startup directory when opened on a folder
- re-renders on terminal resize

### Custom tabline and statusline

The UI modules live in:

- [`nvim/lua/ui/statusline.lua`](nvim/lua/ui/statusline.lua)
- [`nvim/lua/ui/tabline.lua`](nvim/lua/ui/tabline.lua)

The statusline shows:

- current mode
- current file name
- modified and read-only markers
- diagnostics
- Git branch and change summary
- filetype, file format, encoding
- cursor position

The tabline shows:

- a custom label/logo on the left
- all tabs as clickable entries
- file icon when Nerd Font devicons are available
- file name per tab
- modified marker or close button
- tab and buffer counts on the far right

### Keymap reference

#### General editing

| Key | Mode | Action |
| --- | --- | --- |
| `jk` | Insert | Exit insert mode |
| `Esc` | Normal | Clear search highlight |
| `Esc Esc` | Terminal | Exit terminal mode |
| `Ctrl+s` | Insert | Fix nearest spelling suggestion and return to insert mode |

#### Copy, paste, registers, and selection

| Key | Mode | Action |
| --- | --- | --- |
| `<leader>a` | Normal, Visual | Select entire buffer |
| `<leader>y` | Visual | Yank to system clipboard |
| `<leader>p` | Normal | Show registers and prepare `:normal "` for manual register paste |
| `<leader>p` | Visual | Replace selection without overwriting the unnamed register |

Notes:

- Normal-mode `<leader>p` is a register picker helper, not a direct paste command.
- After pressing it, choose a register and a put command manually, such as `+p`.

#### Buffer navigation

| Key | Action |
| --- | --- |
| `[b` | Previous buffer |
| `]b` | Next buffer |
| `<leader>b` | Show buffer list and prepare `:b` |
| `<leader>k` | Show buffer list and prepare `:bdelete` |

#### Window navigation and auto-splitting

This config overloads directional window movement so that moving into a missing window creates the split automatically.

| Key | Action |
| --- | --- |
| `Ctrl+h` | Move left, or create a vertical split if needed |
| `Ctrl+j` | Move down, or create a horizontal split if needed |
| `Ctrl+k` | Move up, or create a horizontal split if needed |
| `Ctrl+l` | Move right, or create a vertical split if needed |

#### Window resizing

| Key | Action |
| --- | --- |
| `Ctrl+w` `+` | Increase window height and keep resize-repeat primed |
| `Ctrl+w` `-` | Decrease window height and keep resize-repeat primed |
| `Ctrl+w` `>` | Increase window width and keep resize-repeat primed |
| `Ctrl+w` `<` | Decrease window width and keep resize-repeat primed |

### Terminal workflow inside Neovim

There are three terminal entry points.

#### Floating terminal

| Key | Action |
| --- | --- |
| `<leader>tt` | Toggle floating terminal |
| `:Floaterminal` | Toggle floating terminal by command |

Behavior:

- opens in a rounded floating window
- reuses the same terminal buffer between toggles
- hides instead of destroying the window

#### Split terminals

| Key | Action |
| --- | --- |
| `<leader>tb` | Open terminal in bottom split |
| `<leader>tr` | Open terminal in right split |

### Built-in commands

The core config defines these custom commands:

| Command | Purpose |
| --- | --- |
| `:TrimWhitespace` | Remove trailing whitespace without moving your view |
| `:CD` | Set local working directory to the current file's directory |
| `:Floaterminal` | Toggle the reusable floating terminal |

Additional filetype-specific commands are defined later in this README.

### File explorer and file browsing

#### Neo-tree

Configured in [`nvim/lua/plugins/neo-tree.lua`](nvim/lua/plugins/neo-tree.lua).

| Key | Action |
| --- | --- |
| `<leader>n` | Toggle Neo-tree and reveal current file |

Neo-tree behavior in this setup:

- appears on the left
- width is set to 32 columns
- follows the current file
- dotfiles are visible
- Git-ignored files are visible
- closes if it becomes the last window

#### Telescope file browser

| Key | Action |
| --- | --- |
| `<leader>fb` | Open Telescope file browser |

### Search and navigation with Telescope

Configured in [`nvim/lua/plugins/telescope.lua`](nvim/lua/plugins/telescope.lua).

#### Search shortcuts

| Key | Action |
| --- | --- |
| `<leader>sh` | Search help tags |
| `<leader>sk` | Search keymaps |
| `<leader>sf` | Find files |
| `<leader>ss` | Search Telescope pickers |
| `<leader>sw` | Search current word |
| `<leader>sg` | Live grep across files |
| `<leader>sd` | Search diagnostics |
| `<leader>sr` | Resume last Telescope picker |
| `<leader>s.` | Search recently opened files |
| `<leader><leader>` | Search open buffers |
| `<leader>/` | Fuzzy search within current buffer |
| `<leader>s/` | Live grep only in open files |
| `<leader>sn` | Search Neovim config files |

#### Git-related Telescope shortcuts

| Key | Action |
| --- | --- |
| `<leader>gf` | Search Git files |
| `<leader>gc` | Search Git commits |
| `<leader>gs` | Search Git status |

#### Telescope picker controls

Inside Telescope insert mode:

| Key | Action |
| --- | --- |
| `Ctrl+j` | Move selection down |
| `Ctrl+k` | Move selection up |

### LSP and code navigation

Configured in [`nvim/lua/plugins/lsp.lua`](nvim/lua/plugins/lsp.lua).

This setup uses:

- `mason.nvim` for LSP server installation
- `mason-lspconfig.nvim` for bridging Mason and `lspconfig`
- `fidget.nvim` for LSP status feedback
- `lazydev.nvim` for better Lua/Neovim development

#### Installed/managed language servers

The config ensures these servers are installed:

- `bashls`
- `clangd`
- `pylsp`
- `texlab`
- `gopls`
- `lua_ls`

#### LSP keymaps

These keymaps are attached when an LSP client connects to a buffer.

| Key | Action |
| --- | --- |
| `gd` | Go to definition |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gD` | Go to declaration |
| `<leader>D` | Go to type definition |
| `<leader>ds` | Search document symbols |
| `<leader>ws` | Search workspace symbols |
| `<leader>rn` | Rename symbol |
| `<leader>ca` | Code action |
| `<leader>F` | Format current buffer |
| `<leader>th` | Toggle inlay hints when supported |

Notes:

- Definitions and type definitions prefer Telescope when available.
- Definitions are configured to open results in a new tab.
- Hover and signature help use rounded borders.

### Completion and snippets

Configured in [`nvim/lua/plugins/cmp.lua`](nvim/lua/plugins/cmp.lua).

This setup uses:

- `nvim-cmp` for completion
- `LuaSnip` for snippets
- `friendly-snippets` for snippet collections
- LSP, path, buffer, and command-line completion sources

#### Completion keys

| Key | Action |
| --- | --- |
| `Ctrl+n` or `Ctrl+j` | Select next completion item |
| `Ctrl+p` or `Ctrl+k` | Select previous completion item |
| `Ctrl+e` | Abort completion |
| `Ctrl+b` | Scroll docs up |
| `Ctrl+f` | Scroll docs down |
| `Ctrl+y` or `Enter` | Confirm selected completion item |
| `Ctrl+Space` | Trigger completion menu |
| `Tab` | Next completion item, next snippet jump, or literal tab |
| `Shift+Tab` | Previous completion item or previous snippet jump |
| `Ctrl+l` | Expand snippet or jump forward |
| `Ctrl+h` | Jump backward in snippet |

Command-line completion is also enabled for:

- `/` and `?` using buffer content
- `:` using path and command-line sources

### Git integration

Configured in [`nvim/lua/plugins/git.lua`](nvim/lua/plugins/git.lua).

This setup uses `gitsigns.nvim` with custom sign characters:

- `+` for additions
- `~` for changes
- `_` for deletions
- `‾` for top deletions

Git keymap:

| Key | Action |
| --- | --- |
| `<leader>gd` | Diff current buffer |

Git information is also integrated into the custom statusline.

### Diagnostics and TODO navigation

#### Diagnostics

The diagnostic list can be opened with:

| Key | Action |
| --- | --- |
| `<leader>q` | Open location list with diagnostics |

Diagnostics are configured to:

- avoid updating during insert mode
- show rounded floating windows
- include severity and line number in the float text

#### TODO comments

Configured in [`nvim/lua/plugins/todo-comment.lua`](nvim/lua/plugins/todo-comment.lua).

| Key | Action |
| --- | --- |
| `]t` | Jump to next TODO-style comment |
| `[t` | Jump to previous TODO-style comment |

### Treesitter and syntax behavior

Configured in [`nvim/lua/plugins/treesitter.lua`](nvim/lua/plugins/treesitter.lua).

Treesitter is enabled for:

- `bash`
- `c`
- `cpp`
- `latex`
- `lua`
- `markdown`
- `python`

Features enabled:

- syntax highlighting
- indentation
- incremental selection

#### Treesitter incremental selection keys

| Key | Action |
| --- | --- |
| `Ctrl+Space` | Start selection / expand to next node |
| `Ctrl+s` | Expand to scope |
| `Alt+Space` | Shrink selection |

### Other quality-of-life plugins

#### which-key

Configured in [`nvim/lua/plugins/which-key.lua`](nvim/lua/plugins/which-key.lua).

This displays available key groups after you press `Space`, helping you discover mappings such as:

- code
- document
- file
- Git
- rename
- search
- workspace
- toggle / terminal

#### autopairs

Configured in [`nvim/lua/plugins/autopairs.lua`](nvim/lua/plugins/autopairs.lua).

Automatically inserts matching pairs such as:

- `()`
- `[]`
- `{}`
- quotes

#### colorizer

Configured in [`nvim/lua/plugins/colorizer.lua`](nvim/lua/plugins/colorizer.lua).

Shows inline previews for color values in files that contain them.

#### markdown preview

Configured in [`nvim/lua/plugins/markdown.lua`](nvim/lua/plugins/markdown.lua).

When editing Markdown, the config loads `markdown-preview.nvim` so you can preview documents in the browser using the plugin's commands.

#### VimTeX

Configured in [`nvim/lua/plugins/latex.lua`](nvim/lua/plugins/latex.lua).

This setup:

- enables LaTeX support through `vimtex`
- sets the TeX flavor to `latex`
- uses Skim as the PDF viewer on macOS

### Filetype-specific behavior

The directory [`nvim/after/ftplugin`](nvim/after/ftplugin) applies per-language settings.

#### Markdown

File: [`nvim/after/ftplugin/markdown.vim`](nvim/after/ftplugin/markdown.vim)

- 4-space indentation
- spell check enabled

#### TeX

File: [`nvim/after/ftplugin/tex.vim`](nvim/after/ftplugin/tex.vim)

- spell check enabled

#### Plain text

File: [`nvim/after/ftplugin/text.vim`](nvim/after/ftplugin/text.vim)

- spell check enabled

#### Python

File: [`nvim/after/ftplugin/python.vim`](nvim/after/ftplugin/python.vim)

- 4-space indentation
- color column at 80
- text width at 79
- command: `:RunPython` runs the current file with `python3`

#### C

File: [`nvim/after/ftplugin/c.vim`](nvim/after/ftplugin/c.vim)

- 2-space indentation
- color column at 80
- text width at 79
- `matchpairs` includes `= : ;`
- command: `:RunC` compiles and runs the current file with `gcc`

#### C++

File: [`nvim/after/ftplugin/cpp.vim`](nvim/after/ftplugin/cpp.vim)

- 2-space indentation
- color column at 80
- text width at 79
- `matchpairs` includes `= : ;`
- command: `:RunCpp` compiles and runs the current file with `g++`

#### Java

File: [`nvim/after/ftplugin/java.vim`](nvim/after/ftplugin/java.vim)

- 4-space indentation
- color column at 120
- text width at 120
- `matchpairs` includes `= : ;`

#### Lua

File: [`nvim/after/ftplugin/lua.lua`](nvim/after/ftplugin/lua.lua)

- 2-space indentation
- color column at 120
- text width at 119
- command: `:RunLua` runs the current file in a floating terminal window

#### Makefiles

File: [`nvim/after/ftplugin/make.vim`](nvim/after/ftplugin/make.vim)

- tabs preserved
- no space expansion

#### Git config files

File: [`nvim/after/ftplugin/gitconfig.vim`](nvim/after/ftplugin/gitconfig.vim)

- tabs preserved
- no forced shift width

### Practical Neovim workflow

A typical editing session in this setup looks like this:

1. Open a project with `nvim .`.
2. Use `<leader>n` to inspect the file tree.
3. Use `<leader>sf` or `<leader>sg` to jump to files or text quickly.
4. Open a floating terminal with `<leader>tt` for shell work.
5. Use `gd`, `gr`, `<leader>ca`, and `<leader>rn` once the language server attaches.
6. Use `<leader>F` to format the current buffer.
7. Use `<leader>gd` to inspect Git changes in the current file.
8. Use `:TrimWhitespace` before saving if needed.

### Dependencies and assumptions

This config expects or benefits from the following tools:

- `zsh` for WezTerm's default shell
- a Nerd Font for the best icon experience
- `git` for plugin installation and Git integrations
- `ripgrep` for fast Telescope grep searches
- `make` and a C compiler for `telescope-fzf-native.nvim`
- language servers supported by Mason
- `python3` for `:RunPython`
- `gcc` for `:RunC`
- `g++` for `:RunCpp`
- Skim on macOS for the VimTeX PDF viewer

### Files to edit when customizing

If you want to extend or change behavior later, these are the main entry points:

- [`.wezterm.lua`](.wezterm.lua)
- [`nvim/init.lua`](nvim/init.lua)
- [`nvim/lua/plugins/`](nvim/lua/plugins)
- [`nvim/lua/ui/`](nvim/lua/ui)
- [`nvim/after/ftplugin/`](nvim/after/ftplugin)

## Summary

This dotfiles repo gives you:

- a leader-driven WezTerm workflow built around panes, tabs, and workspaces
- a keyboard-centric Neovim setup with Telescope, LSP, Treesitter, Git, and terminals
- filetype-specific commands for common languages
- a consistent Rose Pine Moon visual theme across both terminal and editor

If you want, the next useful step is generating a shorter cheat sheet from this README with only the daily-use keybindings.
