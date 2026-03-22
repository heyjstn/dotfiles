# Dotfiles Guide

This repository contains two main user-facing configurations:

- [`.wezterm.lua`](.wezterm.lua): terminal workflow, panes, tabs, workspaces, quick-select, and project launch helpers.
- [`nvim/`](nvim): Neovim editor, plugins, diagnostics, formatting, debugging, testing, and custom UI.

Both are currently themed with Rose Pine Moon.

## Repository Layout

```text
.
├── .wezterm.lua
└── nvim
    ├── init.lua
    ├── lazy-lock.json
    ├── lua
    │   ├── plugins
    │   └── ui
    ├── after
    │   └── ftplugin
    └── doc
```

## WezTerm Guide

### What this WezTerm config does

The WezTerm setup is defined in [`.wezterm.lua`](.wezterm.lua). It is built around a tmux-like leader workflow and a second set of Meta-based pane controls that pair well with Neovim.

Key defaults:

- Shell: `zsh -l`
- Theme: `rose-pine-moon`
- Font fallback: JetBrains Mono Nerd Font, IosevkaTerm Nerd Font, Symbols Nerd Font Mono, Menlo
- Window style:
  - 95% background opacity
  - macOS blur enabled
  - resize-only window decorations
  - close confirmation prompt enabled
- Status bar:
  - left: workspace / key table / leader state
  - right: cwd, foreground process, current time
- Inactive panes are dimmed for focus.

### Leader key

The WezTerm leader key is `Ctrl+a`.

Press `Ctrl+a`, then press a second key within 1000 ms to trigger a command.

### Pane management

Leader-based pane controls:

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

Resize mode:

| Key | Action |
| --- | --- |
| `h` | Shrink left |
| `j` | Shrink down |
| `k` | Shrink up |
| `l` | Shrink right |
| `Esc` or `Enter` | Exit resize mode |

Meta-based pane controls:

| Key | Action |
| --- | --- |
| `Alt+h` | Move left across WezTerm panes or hand off to Neovim |
| `Alt+j` | Move down across WezTerm panes or hand off to Neovim |
| `Alt+k` | Move up across WezTerm panes or hand off to Neovim |
| `Alt+l` | Move right across WezTerm panes or hand off to Neovim |
| `Alt+Left` | Resize pane left |
| `Alt+Down` | Resize pane down |
| `Alt+Up` | Resize pane up |
| `Alt+Right` | Resize pane right |

The Meta bindings are the terminal-side half of the Neovim/WezTerm pane workflow.

### Tab management

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

Tab move mode:

| Key | Action |
| --- | --- |
| `h` or `j` | Move tab left |
| `k` or `l` | Move tab right |
| `Esc` or `Enter` | Exit tab move mode |

### Workspaces and project launch

This config keeps `main` as the default workspace and adds project-focused workspace helpers.

| Key | Action |
| --- | --- |
| `Ctrl+a`, `w` | Open the fuzzy launcher for workspaces and launch-menu items |
| `Ctrl+a`, `p` | Switch to or create a workspace named after the current pane cwd |
| `Ctrl+a`, `Shift+p` | Prompt for a workspace name using the current pane cwd |

The launch menu also exposes a few common starting points:

- `Home`
- `Dotfiles`
- `Neovim Config`

### Quick select, search, and command palette

| Key | Action |
| --- | --- |
| `Ctrl+a`, `c` | Activate copy mode |
| `Ctrl+a`, `f` | Enter quick-select mode for paths, hashes, URLs, and other detected tokens |
| `Ctrl+a`, `/` | Search scrollback using the current selection if present |
| `Ctrl+a`, `Space` | Open the command palette |

### Status bar

The status bar updates once per second.

Left status:

- current workspace name
- current key table name when a special mode is active
- `LDR` when the leader key is active

Right status:

- current working directory of the active pane
- foreground process name
- current time

### Practical WezTerm workflow

1. Open WezTerm.
2. Use `Ctrl+a`, `w` to jump to an existing workspace or launch-menu entry.
3. Use `Ctrl+a`, `p` from any project shell to break that cwd into its own workspace.
4. Split panes with `Ctrl+a`, `s` and `Ctrl+a`, `v`.
5. Use `Alt+h/j/k/l` for fast pane movement, especially when hopping between terminal panes and Neovim.
6. Use `Ctrl+a`, `f` to quick-select a path, commit hash, or URL from scrollback.

## Neovim Guide

### What this Neovim config does

The main Neovim entry point is [`nvim/init.lua`](nvim/init.lua). It bootstraps `lazy.nvim`, loads plugins from [`nvim/lua/plugins`](nvim/lua/plugins), and enables custom UI modules from [`nvim/lua/ui`](nvim/lua/ui).

This configuration focuses on:

- keyboard-driven navigation
- built-in LSP with Mason-managed servers
- Telescope-powered search
- Obsidian note navigation for Markdown vaults
- persistent undo and session restore
- automatic formatting and on-demand linting
- DAP-based debugging
- test execution in embedded terminal splits
- custom statusline, tabline, and startup dashboard

### Theme

Neovim uses Rose Pine Moon through [`nvim/lua/plugins/rose-pine.lua`](nvim/lua/plugins/rose-pine.lua).

Transparency is enabled, so floating windows and editor surfaces keep a translucent look when your terminal supports it.

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
- persistent undo is enabled and stored under Neovim state
- sessions can restore buffers, tabs, terminals, folds, and local options

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
- diagnostics with corrected severity labels
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

#### Buffer navigation

| Key | Action |
| --- | --- |
| `[b` | Previous buffer |
| `]b` | Next buffer |
| `<leader>b` | Show buffer list and prepare `:b` |
| `<leader>k` | Show buffer list and prepare `:bdelete` |

#### Tab navigation

These are mostly stock Neovim tab commands, plus the custom clickable tabline.

| Key | Action |
| --- | --- |
| `gt` | Go to the next tab |
| `gT` | Go to the previous tab |
| `{count}gt` | Jump directly to tab number `{count}` |
| `:tabnew` | Open a new tab |
| `:tabclose` | Close the current tab |

Tabline behavior:

- click a tab label to switch to that tab
- click the `X` on a tab to close it when the current buffer is not modified
- modified buffers show `+` instead of a close button

#### Window and pane navigation

Built-in split creation:

| Key | Action |
| --- | --- |
| `Ctrl+h` | Move left, or create a vertical split if needed |
| `Ctrl+j` | Move down, or create a horizontal split if needed |
| `Ctrl+k` | Move up, or create a horizontal split if needed |
| `Ctrl+l` | Move right, or create a vertical split if needed |

Neovim and WezTerm pane handoff:

| Key | Action |
| --- | --- |
| `Alt+h` | Move left across Neovim splits and WezTerm panes |
| `Alt+j` | Move down across Neovim splits and WezTerm panes |
| `Alt+k` | Move up across Neovim splits and WezTerm panes |
| `Alt+l` | Move right across Neovim splits and WezTerm panes |
| `Alt+Left` | Resize pane left |
| `Alt+Down` | Resize pane down |
| `Alt+Up` | Resize pane up |
| `Alt+Right` | Resize pane right |

Classic Vim window resizing:

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

### File explorer and search

#### Neo-tree

Configured in [`nvim/lua/plugins/neo-tree.lua`](nvim/lua/plugins/neo-tree.lua).

| Key | Action |
| --- | --- |
| `<leader>n` | Toggle Neo-tree and reveal current file |

Useful navigation inside Neo-tree:

| Key | Action |
| --- | --- |
| `Enter` | Open the selected file or directory |
| `q` | Close the Neo-tree window |
| `?` | Show Neo-tree help |
| `Ctrl+h` | Move from the editor into the tree if it is on the left |
| `Ctrl+l` | Move from the tree back into the editor |
| `Ctrl+w w` | Cycle between the tree and editor windows |

Neo-tree behavior:

- appears on the left
- width is set to 32 columns
- follows the current file
- dotfiles are visible
- Git-ignored files are visible
- closes if it becomes the last window

#### Telescope

Configured in [`nvim/lua/plugins/telescope.lua`](nvim/lua/plugins/telescope.lua).

Search shortcuts:

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
| `<leader>fb` | Open Telescope file browser |

Git-related Telescope shortcuts:

| Key | Action |
| --- | --- |
| `<leader>gf` | Search Git files |
| `<leader>gc` | Search Git commits |
| `<leader>gs` | Search Git status |

Useful picker navigation:

| Key | Action |
| --- | --- |
| `Ctrl+j` | Move to the next result |
| `Ctrl+k` | Move to the previous result |
| `Enter` | Open the selected result |
| `Esc` | Close the Telescope picker |

If you forget the available mappings in a Telescope picker, press `?` to show them.

### Obsidian notes

Configured in [`nvim/lua/plugins/obsidian.lua`](nvim/lua/plugins/obsidian.lua).

This setup adds [`obsidian.nvim`](https://github.com/obsidian-nvim/obsidian.nvim) for Markdown note workflows.

Defaults:

- loads for Markdown files and the `:Obsidian` command
- uses `~/Documents/notes` as the default vault workspace
- uses your existing Telescope and `nvim-cmp` setup when available
- sets `conceallevel=1` for Markdown buffers so Obsidian UI features render cleanly

Obsidian keymaps:

| Key | Action |
| --- | --- |
| `<leader>oo` | Quick switch to another note |
| `<leader>on` | Create a new note |
| `<leader>os` | Search notes in the vault |
| `<leader>ot` | Open or create today's note |
| `<leader>ob` | Show backlinks for the current note |

Useful Obsidian commands:

| Command | Action |
| --- | --- |
| `:Obsidian` | Show available subcommands |
| `:Obsidian quick_switch` | Fuzzy switch to another note |
| `:Obsidian search` | Search the vault contents |
| `:Obsidian new` | Create a new note |
| `:Obsidian backlinks` | Show references to the current note |
| `:Obsidian open` | Open the current note in the Obsidian app |
| `:checkhealth obsidian` | Check plugin installation and environment |

If your vault lives somewhere else, change the workspace path in [`nvim/lua/plugins/obsidian.lua`](nvim/lua/plugins/obsidian.lua).

### LSP, diagnostics, formatting, and linting

Configured in:

- [`nvim/lua/plugins/lsp.lua`](nvim/lua/plugins/lsp.lua)
- [`nvim/lua/plugins/conform.lua`](nvim/lua/plugins/conform.lua)
- [`nvim/lua/plugins/lint.lua`](nvim/lua/plugins/lint.lua)

This setup uses:

- `mason.nvim` for LSP server installation
- `mason-lspconfig.nvim` for bridging Mason and `lspconfig`
- `fidget.nvim` for LSP status feedback
- `conform.nvim` for formatting and format-on-save
- `nvim-lint` for on-demand and post-save linting when external linters are available

Managed language servers:

- `bashls`
- `clangd`
- `gopls`
- `jdtls`
- `lua_ls`
- `pyright`
- `rust_analyzer`
- `texlab`

Diagnostics:

| Key | Action |
| --- | --- |
| `[d` | Previous diagnostic |
| `]d` | Next diagnostic |
| `<leader>e` | Open diagnostic float |
| `<leader>q` | Populate the location list with diagnostics |

LSP keymaps:

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
| `<leader>th` | Toggle inlay hints when supported |

Formatting:

| Key | Action |
| --- | --- |
| `<leader>F` | Format current buffer |
| `<leader>cf` | Format current buffer through the code group |

Formatting runs automatically on save with LSP fallback when no external formatter is configured.

Linting:

| Key | Action |
| --- | --- |
| `<leader>cl` | Run lint for the current buffer when a configured linter is available |

Configured external linters:

- `shellcheck` for shell buffers
- `ruff` for Python
- `luacheck` for Lua
- `markdownlint` for Markdown

### Debugging

Configured in:

- [`nvim/lua/plugins/dap.lua`](nvim/lua/plugins/dap.lua)
- [`nvim/lua/plugins/jdtls.lua`](nvim/lua/plugins/jdtls.lua)

This setup uses:

- `nvim-dap`
- `nvim-dap-ui`
- `nvim-dap-virtual-text`
- `mason-nvim-dap.nvim`
- `nvim-dap-go`
- `nvim-dap-python`
- `nvim-jdtls` for Java attach/start and Java test debugging

`mason-nvim-dap.nvim` will install:

- `codelldb`
- `delve`
- `debugpy`

Debug keymaps:

| Key | Action |
| --- | --- |
| `<leader>db` | Toggle breakpoint |
| `<leader>dB` | Set conditional breakpoint |
| `<leader>dc` | Continue / start debugging |
| `<leader>di` | Step into |
| `<leader>do` | Step over |
| `<leader>dO` | Step out |
| `<leader>dr` | Open DAP REPL |
| `<leader>dt` | Terminate session |
| `<leader>du` | Toggle DAP UI |
| `<leader>dl` | Run last debug configuration |

Language-specific debug helpers:

- Go:
  - `<leader>dn`: debug nearest Go test
  - `<leader>dN`: debug last Go test
- Java:
  - `<leader>dn`: debug nearest Java test method
  - `<leader>df`: debug Java test class

### Testing

Configured in [`nvim/lua/plugins/test.lua`](nvim/lua/plugins/test.lua).

This setup uses `vim-test` with the Neovim terminal strategy.

| Key | Action |
| --- | --- |
| `<leader>tn` | Run nearest test |
| `<leader>tf` | Run current file |
| `<leader>ts` | Run test suite |
| `<leader>tl` | Re-run last test |
| `<leader>tv` | Jump to the last test output window |

Tests open in a bottom terminal split and start in normal mode so you can inspect failures immediately.

### Sessions and restore

Configured in [`nvim/lua/plugins/persistence.lua`](nvim/lua/plugins/persistence.lua).

Sessions restore buffers, tabs, terminals, folds, and local options.

| Key | Action |
| --- | --- |
| `<leader>wr` | Restore the current cwd session |
| `<leader>wl` | Restore the last session |
| `<leader>wd` | Stop session saving for the current run |

### Completion and snippets

Configured in [`nvim/lua/plugins/cmp.lua`](nvim/lua/plugins/cmp.lua).

This setup uses:

- `nvim-cmp` for completion
- `LuaSnip` for snippets
- `friendly-snippets` for snippet collections
- LSP, path, buffer, and command-line completion sources

Completion keys:

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

### Editing quality-of-life plugins

Configured in:

- [`nvim/lua/plugins/mini.lua`](nvim/lua/plugins/mini.lua)
- [`nvim/lua/plugins/autopairs.lua`](nvim/lua/plugins/autopairs.lua)
- [`nvim/lua/plugins/colorizer.lua`](nvim/lua/plugins/colorizer.lua)
- [`nvim/lua/plugins/todo-comment.lua`](nvim/lua/plugins/todo-comment.lua)

Added editing helpers:

- `mini.comment`: comment toggling with `gc`
- `mini.surround`: add, delete, replace, find, and highlight surrounds with `sa`, `sd`, `sr`, `sf`, `sF`, `sh`, `sn`
- `mini.ai`: richer `a`/`i` textobjects
- `nvim-autopairs`: automatic pair insertion
- `nvim-colorizer.lua`: inline color previews
- `todo-comments.nvim`: TODO navigation

TODO keymaps:

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
- `go`
- `gomod`
- `gosum`
- `gowork`
- `java`
- `json`
- `latex`
- `lua`
- `luadoc`
- `markdown`
- `markdown_inline`
- `python`
- `query`
- `rust`
- `toml`
- `vim`
- `vimdoc`
- `yaml`

Features enabled:

- syntax highlighting
- indentation
- incremental selection

Incremental selection keys:

| Key | Action |
| --- | --- |
| `Ctrl+Space` | Start selection / expand to next node |
| `Ctrl+s` | Expand to scope |
| `Alt+Space` | Shrink selection |

### Filetype-specific behavior

The directory [`nvim/after/ftplugin`](nvim/after/ftplugin) applies per-language settings.

Highlights:

- Markdown, TeX, and plain text enable spell checking
- Python follows 79-column formatting helpers and adds `:RunPython`
- C and C++ define `:RunC` and `:RunCpp`
- Lua defines `:RunLua` in a floating terminal
- Java follows 4-space IntelliJ-style indentation

### Practical Neovim workflow

A typical editing session in this setup looks like this:

1. Open a project with `nvim .`.
2. Restore the last session with `<leader>wl` if you want to continue a previous workspace.
3. Use `<leader>n`, `<leader>sf`, and `<leader>sg` to jump around quickly.
4. Use `gd`, `gr`, `<leader>ca`, and `<leader>rn` once the language server attaches.
5. Save normally and let format-on-save do the default cleanup.
6. Run `<leader>cl` when you want an explicit lint pass.
7. Use `<leader>tn` or `<leader>tf` to run tests in a terminal split.
8. Start a debug session with `<leader>dc` and inspect it with `<leader>du`.
9. Use `Alt+h/j/k/l` when you want to flow between Neovim splits and WezTerm panes.

## Dependencies and assumptions

This config expects or benefits from the following tools:

- `zsh` for WezTerm's default shell
- a Nerd Font for the best icon experience
- `git` for plugin installation and Git integrations
- `ripgrep` for Telescope grep searches
- `make` and a C compiler for `telescope-fzf-native.nvim`
- Neovim 0.11+ is recommended because newer `nvim-lspconfig` releases are dropping 0.10 support
- `pngpaste` on macOS if you want to use `:Obsidian paste_img`
- `python3` for `:RunPython`
- `gcc` for `:RunC`
- `g++` for `:RunCpp`
- Skim on macOS for the VimTeX PDF viewer
- external formatter and linter CLIs if you want those integrations to be active on save:
  - `stylua`
  - `clang-format`
  - `gofumpt`
  - `goimports`
  - `google-java-format`
  - `ruff`
  - `shfmt`
  - `shellcheck`
  - `luacheck`
  - `markdownlint`
  - `prettier`
  - `taplo`
  - `latexindent`
  - `rustfmt`
- the `wezterm` CLI on `PATH` if you want the smoothest Neovim-to-WezTerm pane handoff from `smart-splits.nvim`

Notes:

- Treesitter will download any newly added parsers the first time you start Neovim after updating.
- Java test/debug bundles are installed through Mason when needed. If the first Java debug attempt only installs tools, reopen the project and retry.

## Files to edit when customizing

If you want to extend or change behavior later, these are the main entry points:

- [`.wezterm.lua`](.wezterm.lua)
- [`nvim/init.lua`](nvim/init.lua)
- [`nvim/lua/plugins/`](nvim/lua/plugins)
- [`nvim/lua/ui/`](nvim/lua/ui)
- [`nvim/after/ftplugin/`](nvim/after/ftplugin)

## Summary

This dotfiles repo now gives you:

- a leader-driven WezTerm workflow with workspaces, launch helpers, quick-select, and Neovim-aware pane movement
- a keyboard-centric Neovim setup with LSP, format-on-save, optional linting, DAP debugging, test execution, sessions, and persistent undo
- richer editing primitives through comments, surrounds, textobjects, and better Treesitter coverage
- a consistent Rose Pine Moon visual theme across both terminal and editor
