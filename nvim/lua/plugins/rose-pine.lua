local is_transparent = true --> To disable transparency, set this to false

return {
  "rose-pine/neovim",
  enabled = false,
  name = "rose-pine",
  lazy = false,
  priority = 1000, --> Higher priority over other plugins
  config = function()
    require("rose-pine").setup({
      variant = "moon",
      dark_variant = "moon",
      styles = {
        transparency = is_transparent,
      },
    })
    vim.cmd.colorscheme("rose-pine-moon")
  end,
}
