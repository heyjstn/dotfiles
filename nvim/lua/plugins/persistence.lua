return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  opts = {},
  keys = {
    {
      "<leader>wr",
      function()
        require("persistence").load()
      end,
      desc = "[W]orkspace [R]estore",
    },
    {
      "<leader>wl",
      function()
        require("persistence").load({ last = true })
      end,
      desc = "[W]orkspace restore [L]ast",
    },
    {
      "<leader>wd",
      function()
        require("persistence").stop()
      end,
      desc = "[W]orkspace [D]isable session save",
    },
  },
}
