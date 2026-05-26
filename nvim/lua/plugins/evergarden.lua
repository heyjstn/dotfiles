local is_transparent = true
local theme = require("config.theme")

return {
  "everviolet/nvim",
  name = "evergarden",
  enabled = theme.is_colorscheme("evergarden"),
  lazy = false,
  priority = 1000,
  config = function()
    local selected_theme = theme.get()

    vim.o.background = selected_theme.mode
    require("evergarden").setup({
      theme = {
        variant = selected_theme.variant or "fall",
        accent = selected_theme.accent or "green",
      },
      editor = {
        transparent_background = is_transparent,
        override_terminal = true,
        sign = { color = "none" },
        float = {
          color = "mantle",
          solid_border = false,
        },
        completion = {
          color = "surface0",
        },
      },
      integrations = {
        cmp = true,
        gitsigns = true,
        mini = { enable = true },
        neotree = true,
        telescope = true,
        which_key = true,
      },
    })

    vim.cmd.colorscheme("evergarden")
  end,
}
