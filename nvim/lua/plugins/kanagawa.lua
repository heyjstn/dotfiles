local is_transparent = true

return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    require("kanagawa").setup({
      transparent = is_transparent,
      theme = "wave",
      background = {
        dark = "wave",
        light = "lotus",
      },
    })
    vim.cmd.colorscheme("kanagawa")
  end,
}
