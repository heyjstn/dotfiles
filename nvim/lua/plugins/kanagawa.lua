local is_transparent = true
local theme = require("config.theme")

local variants = {
  wave = true,
  dragon = true,
  lotus = true,
}

local function fallback_variant(mode)
  return mode == "light" and "lotus" or "wave"
end

return {
  "rebelot/kanagawa.nvim",
  enabled = theme.is_colorscheme("kanagawa"),
  lazy = false,
  priority = 1000,
  config = function()
    local selected_theme = theme.get()
    local variant = selected_theme.variant or fallback_variant(selected_theme.mode)

    if not variants[variant] then
      variant = fallback_variant(selected_theme.mode)
    end

    vim.o.background = selected_theme.mode

    require("kanagawa").setup({
      transparent = is_transparent,
      terminalColors = true,
      theme = variant,
      background = {
        dark = variant == "dragon" and "dragon" or "wave",
        light = "lotus",
      },
      colors = {
        theme = {
          all = {
            ui = {
              bg_gutter = "none",
            },
          },
        },
      },
    })

    vim.cmd.colorscheme("kanagawa-" .. variant)
  end,
}
