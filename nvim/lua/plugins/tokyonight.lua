local theme = require("config.theme")

local styles = {
  night = true,
  storm = true,
  moon = true,
  day = true,
}

local function fallback_style(mode)
  return mode == "light" and "day" or "night"
end

return {
  "folke/tokyonight.nvim",
  enabled = theme.is_colorscheme("tokyonight"),
  lazy = false,
  priority = 1000,
  config = function()
    local selected_theme = theme.get()
    local style = selected_theme.variant or fallback_style(selected_theme.mode)
    local is_transparent = theme.is_transparent()

    if not styles[style] then
      style = fallback_style(selected_theme.mode)
    end

    vim.o.background = selected_theme.mode

    require("tokyonight").setup({
      style = style,
      transparent = is_transparent,
      terminal_colors = true,
      styles = {
        sidebars = is_transparent and "transparent" or "normal",
        floats = is_transparent and "transparent" or "normal",
      },
    })

    vim.cmd.colorscheme("tokyonight")
  end,
}
