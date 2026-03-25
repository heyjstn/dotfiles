return {
  "obsidian-nvim/obsidian.nvim",
  version = "*",
  cmd = { "Obsidian" },
  event = {
    "BufReadPre " .. vim.fn.expand("~") .. "/Documents/notes/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/Documents/notes/**.md",
  },
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "hrsh7th/nvim-cmp",
  },
  opts = {
    legacy_commands = false,
    workspaces = {
      {
        name = "notes",
        path = "~/Documents/notes",
      },
    },
  },
  config = function(_, opts)
    require("obsidian").setup(opts)

    local map = function(lhs, rhs, desc)
      vim.keymap.set("n", lhs, rhs, { silent = true, noremap = true, desc = desc })
    end

    map("<leader>oo", "<Cmd>Obsidian quick_switch<CR>", "[O]bsidian [O]pen note picker")
    map("<leader>on", "<Cmd>Obsidian new<CR>", "[O]bsidian [N]ew note")
    map("<leader>os", "<Cmd>Obsidian search<CR>", "[O]bsidian [S]earch vault notes")
    map("<leader>ot", "<Cmd>Obsidian today<CR>", "[O]bsidian [T]oday's note")
    map("<leader>ob", "<Cmd>Obsidian backlinks<CR>", "[O]bsidian [B]acklinks")
  end,
}
