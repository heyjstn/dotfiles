local theme = require("config.theme")

return {
  "ellisonleao/gruvbox.nvim",
  enabled = theme.is_colorscheme("gruvbox"),
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = theme.mode()
    require("gruvbox").setup({
      transparent_mode = theme.is_transparent(),
    })
    vim.cmd.colorscheme("gruvbox")
  end,
}
