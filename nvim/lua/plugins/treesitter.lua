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
  local treesitter = require("nvim-treesitter")
  treesitter.setup(opts)

  if #vim.api.nvim_list_uis() > 0 then
    treesitter.install(parser_languages)
  end

  vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("TheovimTreesitter", { clear = true }),
    pattern = treesitter_filetypes,
    callback = function()
      if pcall(vim.treesitter.start) then
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
      end
    end,
  })
end

return M
