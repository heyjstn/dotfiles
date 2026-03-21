return {
  "echasnovski/mini.nvim",
  version = false,
  config = function()
    require("mini.ai").setup({
      n_lines = 500,
    })
    require("mini.comment").setup()
    require("mini.surround").setup()
  end,
}
