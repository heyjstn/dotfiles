--- plugins/treesitter.lua
--- $ figlet -f threepoint theovim
--- _|_|_  _  _   . _ _
---  | | |(/_(_)\/|| | |
---
--- Configure Neovim built-in Treesitter engine

local M = { "nvim-treesitter/nvim-treesitter" }

M.lazy = false
M.build = ":TSUpdate"

local parser_languages = {
  "bash",
  "c",
  "cpp",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "helm",
  "java",
  "json",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "markdown_inline",
  "python",
  "query",
  "rust",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

local treesitter_filetypes = {
  "bash",
  "c",
  "cpp",
  "go",
  "gomod",
  "gosum",
  "gowork",
  "helm",
  "java",
  "json",
  "latex",
  "lua",
  "luadoc",
  "markdown",
  "python",
  "query",
  "rust",
  "sh",
  "tex",
  "toml",
  "vim",
  "vimdoc",
  "yaml",
}

M.opts = {
  install_dir = vim.fn.stdpath("data") .. "/site",
}

M.config = function(_, opts)
  local ok_treesitter, treesitter = pcall(require, "nvim-treesitter")

  if ok_treesitter and type(treesitter.install) == "function" then
    if type(treesitter.setup) == "function" then
      treesitter.setup(opts)
    end

    if #vim.api.nvim_list_uis() > 0 then
      pcall(treesitter.install, parser_languages)
    end

    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TheovimTreesitter", { clear = true }),
      pattern = treesitter_filetypes,
      callback = function()
        if pcall(vim.treesitter.start) and type(treesitter.indentexpr) == "function" then
          vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })

    return
  end

  local ok_configs, configs = pcall(require, "nvim-treesitter.configs")
  if ok_configs then
    local languages = parser_languages
    local ok_parsers, parsers = pcall(require, "nvim-treesitter.parsers")
    if ok_parsers and type(parsers.get_parser_configs) == "function" then
      local available = parsers.get_parser_configs()
      languages = vim.tbl_filter(function(language)
        return available[language] ~= nil
      end, parser_languages)
    end

    configs.setup({
      ensure_installed = languages,
      sync_install = false,
      auto_install = true,
      highlight = {
        enable = true,
      },
      indent = {
        enable = true,
      },
    })

    return
  end

  if ok_treesitter and type(treesitter.setup) == "function" then
    treesitter.setup(opts)
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("TheovimTreesitter", { clear = true }),
      pattern = treesitter_filetypes,
      callback = function()
        pcall(vim.treesitter.start)
      end,
    })
  end
end

return M
