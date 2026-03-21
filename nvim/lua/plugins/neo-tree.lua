return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-tree/nvim-web-devicons",
  },
  lazy = false,
  opts = {
    close_if_last_window = true,
    popup_border_style = "rounded",
    filesystem = {
      hijack_netrw_behavior = "disabled",
      follow_current_file = {
        enabled = true,
      },
      filtered_items = {
        visible = true,
        hide_dotfiles = false,
        hide_gitignored = false,
      },
    },
    window = {
      position = "left",
      width = 32,
      mappings = {
        ["<space>"] = "none",
      },
    },
  },
  config = function(_, opts)
    require("neo-tree").setup(opts)

    vim.keymap.set("n", "<leader>n", "<Cmd>Neotree toggle reveal_force_cwd<CR>",
      { silent = true, noremap = true, desc = "Toggle [N]eo-tree" })
  end,
}
