return {
  "folke/which-key.nvim",
  event = "VimEnter",
  config = function()
    require("which-key").setup()
    require("which-key").add({
        { "<leader>c",  group = "[C]ode" },
        { "<leader>d",  group = "[D]ebug / [D]ocument" },
        { "<leader>f",  group = "[F]ile" },
        { "<leader>g",  group = "[G]it" },
        { "<leader>o",  group = "[O]bsidian Vault" },
        { "<leader>r",  group = "[R]ename" },
        { "<leader>s",  group = "[S]earch" },
        { "<leader>w",  group = "[W]orkspace" },
        { "<leader>t",  group = "[T]est / [T]erminal" },
      })
  end
}
