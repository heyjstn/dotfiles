# Dependency Manifest

This repo targets macOS and assumes Homebrew is the primary system package
manager. Use this file to understand what must be installed on a new computer,
what is installed automatically by the repo, and what each tool supports.

## Bootstrap Order

1. Install Apple Command Line Tools:

   ```sh
   xcode-select --install
   ```

2. Install Homebrew from https://brew.sh.

3. Install the required Homebrew packages:

   ```sh
   brew install git curl neovim fzf zoxide eza git-delta ripgrep fd tree-sitter node python go rustup-init llvm shellcheck shfmt stylua luacheck ruff markdownlint-cli google-java-format
   brew install --cask wezterm font-libertinus font-jetbrains-mono-nerd-font font-iosevka-term-nerd-font font-symbols-only-nerd-font
   ```

4. Run the repo installer:

   ```sh
   ./install.sh
   ```

5. Sync Neovim plugins:

   ```sh
   nvim --headless "+Lazy! sync" "+qa"
   ```

6. Open Neovim normally once so Mason can install LSP and DAP tools.

## Dependency Graph

```text
install.sh
  -> Homebrew
  -> curl
  -> git
  -> Oh My Zsh
     -> zsh-syntax-highlighting
  -> fzf
  -> zoxide
  -> eza
  -> local font assets
  -> font-libertinus

.zshrc
  -> Oh My Zsh
     -> git, brew, colored-man-pages, fzf, zoxide, eza plugins
     -> optional kubectl, helm, fluxcd, bun, golang, nvm, sdk plugins
  -> optional oh-my-posh
  -> optional kubecolor
  -> optional xan

.gitconfig
  -> git-delta

.wezterm.lua
  -> WezTerm
  -> /bin/zsh
  -> JetBrains Mono Nerd Font
  -> IosevkaTerm Nerd Font
  -> Symbols Nerd Font Mono
  -> wezterm/colors/*.toml

nvim/init.lua
  -> git
  -> lazy.nvim
     -> nvim/lazy-lock.json
     -> nvim/lua/plugins/*.lua
  -> Mason
     -> LSP servers
     -> DAP adapters
     -> selected formatters
  -> external CLI tools for search, build, format, lint, test, and debug
```

## Required System Tools

| Tool | Package manager entry | Used by | Why it matters |
| --- | --- | --- | --- |
| Homebrew | manual install | `install.sh`, `.zshrc` | Main macOS package manager. |
| Apple Command Line Tools | `xcode-select --install` | Neovim plugins, Treesitter, C/C++ tooling | Provides `make`, `clang`, headers, and core build tools. |
| Git | `brew install git` | `install.sh`, lazy.nvim, Git plugins | Clones Oh My Zsh plugins and Neovim plugins. |
| curl | `brew install curl` or macOS system curl | `install.sh` | Downloads the Oh My Zsh installer. |
| zsh | macOS `/bin/zsh` | `.zshrc`, `.wezterm.lua` | Default login shell. |
| Neovim | `brew install neovim` | `nvim/` | Editor runtime for the tracked config. |
| WezTerm | `brew install --cask wezterm` | `.wezterm.lua` | Terminal runtime for the tracked config. |
| fzf | `brew install fzf` | `install.sh`, `.zshrc`, `nvim/dev-tool.sh` | Fuzzy shell widgets and commit picker. |
| zoxide | `brew install zoxide` | `.zshrc` | Frecent directory jumping. |
| eza | `brew install eza` | `.zshrc` | Directory listing aliases and Oh My Zsh plugin. |
| git-delta | `brew install git-delta` | `.gitconfig` | Git pager and side-by-side diffs. |
| ripgrep | `brew install ripgrep` | Telescope | Required for fast live grep search. |
| fd | `brew install fd` | Telescope | Preferred file finder backend. |
| tree-sitter | `brew install tree-sitter` | nvim-treesitter | Parser CLI for Treesitter workflows. |
| node/npm | `brew install node` | Mason, markdown-preview, JS-based tools | Installs and runs JS language servers and Markdown preview tooling. |
| python3 | `brew install python` | Mason, DAP, Python tooling | Runtime for Python tooling and debugpy. |
| Go | `brew install go` | `.zshrc`, Go LSP/debug/test tools | Provides `go`, `gofmt`, and install target for Go tools. |
| Rust/Cargo | `brew install rustup-init` | Rust LSP config, Cargo workspace detection | Provides `cargo`; run `rustup default stable` after installing. |
| LLVM | `brew install llvm` | C/C++ formatting | Provides `clang-format`; Mason can manage `clangd` separately. |

## Fonts

| Font | Package manager entry | Used by |
| --- | --- | --- |
| Libertinus | `brew install --cask font-libertinus` | LaTeX/text rendering fallback. |
| JetBrains Mono Nerd Font | `brew install --cask font-jetbrains-mono-nerd-font` | Primary WezTerm font. |
| IosevkaTerm Nerd Font | `brew install --cask font-iosevka-term-nerd-font` | WezTerm fallback font. |
| Symbols Nerd Font Mono | `brew install --cask font-symbols-only-nerd-font` | WezTerm icon fallback. |
| `assets/anthropic.otf` | installed by `./install.sh` | Local custom font asset. |

## Neovim Plugin Management

Neovim plugins are not installed with Homebrew. They are managed by lazy.nvim.

| Source | Purpose |
| --- | --- |
| `nvim/init.lua` | Bootstraps lazy.nvim from GitHub if missing. |
| `nvim/lua/plugins/*.lua` | Declares plugin dependencies and plugin configuration. |
| `nvim/lazy-lock.json` | Locks plugin versions to known commits. |

Install or sync plugins with:

```sh
nvim --headless "+Lazy! sync" "+qa"
```

## Mason Managed Tools

These are installed by Mason from inside Neovim, not directly by Homebrew.

| Mason package | Declared in | Used for |
| --- | --- | --- |
| `bashls` | `nvim/lua/plugins/lsp.lua` | Bash language server. |
| `clangd` | `nvim/lua/plugins/lsp.lua` | C/C++ language server. |
| `gopls` | `nvim/lua/plugins/lsp.lua` | Go language server. |
| `helm_ls` | `nvim/lua/plugins/lsp.lua` | Helm language server. |
| `lua_ls` | `nvim/lua/plugins/lsp.lua` | Lua language server. |
| `pyright` | `nvim/lua/plugins/lsp.lua` | Python language server. |
| `rust_analyzer` | `nvim/lua/plugins/lsp.lua` | Rust language server. |
| `taplo` | `nvim/lua/plugins/lsp.lua` | TOML language server and formatter. |
| `texlab` | `nvim/lua/plugins/lsp.lua` | LaTeX language server. |
| `yamlls` | `nvim/lua/plugins/lsp.lua` | YAML language server. |
| `prettier` | `nvim/lua/plugins/lsp.lua` | Markdown and YAML formatting. |
| `codelldb` | `nvim/lua/plugins/dap.lua` | C/C++/Rust debugging. |
| `delve` | `nvim/lua/plugins/dap.lua` | Go debugging. |
| `debugpy` | `nvim/lua/plugins/dap.lua` | Python debugging. |

Java support is configured by `nvim/lua/plugins/jdtls.lua` through
`nvim-java`. It still needs a local Java runtime.

## External Formatters And Linters

These are called by `conform.nvim` or `nvim-lint`. Install them with Homebrew
or the language package manager shown below.

| Tool | Install | Used by | Filetypes |
| --- | --- | --- | --- |
| `clang-format` | `brew install llvm` | conform.nvim | C, C++ |
| `gofmt` | `brew install go` | conform.nvim | Go |
| `gofumpt` | `go install mvdan.cc/gofumpt@latest` | conform.nvim | Go |
| `goimports` | `go install golang.org/x/tools/cmd/goimports@latest` | conform.nvim | Go |
| `google-java-format` | `brew install google-java-format` | conform.nvim | Java |
| `stylua` | `brew install stylua` | conform.nvim | Lua |
| `prettier` | Mason or `npm install -g prettier` | conform.nvim | Markdown, YAML |
| `ruff` | `brew install ruff` | conform.nvim, nvim-lint | Python |
| `rustfmt` | `rustup component add rustfmt` | conform.nvim | Rust |
| `shfmt` | `brew install shfmt` | conform.nvim | Shell |
| `latexindent` | MacTeX or TeX Live | conform.nvim | TeX |
| `taplo` | Mason or `brew install taplo` | conform.nvim | TOML |
| `shellcheck` | `brew install shellcheck` | nvim-lint | Bash, sh, zsh |
| `luacheck` | `brew install luacheck` | nvim-lint | Lua |
| `markdownlint` | `brew install markdownlint-cli` or `npm install -g markdownlint-cli` | nvim-lint | Markdown |

## Language And Workflow Optional Tools

These are referenced by `.zshrc` or specific Neovim features. They are useful
if you use the matching workflow, but the core shell/editor config can start
without them.

| Tool | Install | Used by |
| --- | --- | --- |
| `kubectl` | `brew install kubectl` | `.zshrc` aliases and Oh My Zsh kubectl plugin. |
| `helm` | `brew install helm` | `.zshrc`, Helm files, Helm LSP workflows. |
| `flux` | `brew install fluxcd/tap/flux` | `.zshrc` alias and Oh My Zsh fluxcd plugin. |
| `bun` | `brew install bun` | `.zshrc` Bun plugin. |
| `nvm` | `brew install nvm` | `.zshrc` Oh My Zsh nvm plugin. |
| `sdkman-cli` | `brew install sdkman-cli` | `.zshrc` SDKMAN setup and Java management. |
| `oh-my-posh` | `brew install oh-my-posh` | Optional prompt theme in `.zshrc`. |
| `kubecolor` | `brew install kubecolor` | Optional `kubectl` color alias. |
| `xan` | `brew install xan` | Optional completion setup in `.zshrc`. |
| `Skim` | `brew install --cask skim` | VimTeX PDF viewer on macOS. |
| MacTeX | `brew install --cask mactex-no-gui` | LaTeX compiler and `latexindent`. |

## Post Install Commands

Some tools need a second step after Homebrew:

```sh
rustup default stable
rustup component add rustfmt

go install mvdan.cc/gofumpt@latest
go install golang.org/x/tools/cmd/goimports@latest
```

If SDKMAN is installed and Java development is needed:

```sh
sdk install java
```

## Minimal Brewfile Equivalent

If you want a machine-readable Homebrew file later, copy this section into a
file named `Brewfile` and run `brew bundle`.

```ruby
tap "fluxcd/tap"

brew "git"
brew "curl"
brew "neovim"
brew "fzf"
brew "zoxide"
brew "eza"
brew "git-delta"
brew "ripgrep"
brew "fd"
brew "tree-sitter"
brew "node"
brew "python"
brew "go"
brew "rustup-init"
brew "llvm"
brew "shellcheck"
brew "shfmt"
brew "stylua"
brew "luacheck"
brew "ruff"
brew "markdownlint-cli"
brew "google-java-format"

cask "wezterm"
cask "font-libertinus"
cask "font-jetbrains-mono-nerd-font"
cask "font-iosevka-term-nerd-font"
cask "font-symbols-only-nerd-font"

# Optional workflows:
brew "kubectl"
brew "helm"
brew "fluxcd/tap/flux"
brew "bun"
brew "nvm"
brew "sdkman-cli"
brew "oh-my-posh"
brew "kubecolor"
brew "xan"
cask "skim"
cask "mactex-no-gui"
```

