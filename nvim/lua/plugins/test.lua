return {
  "vim-test/vim-test",
  cmd = { "TestNearest", "TestFile", "TestSuite", "TestLast", "TestVisit" },
  init = function()
    vim.g["test#strategy"] = "neovim"
    vim.g["test#neovim#start_normal"] = 1
    vim.g["test#neovim#term_position"] = "botright 15split"
  end,
  keys = {
    { "<leader>tn", "<CMD>TestNearest<CR>", desc = "Run [T]est [N]earest" },
    { "<leader>tf", "<CMD>TestFile<CR>", desc = "Run [T]est [F]ile" },
    { "<leader>ts", "<CMD>TestSuite<CR>", desc = "Run [T]est [S]uite" },
    { "<leader>tl", "<CMD>TestLast<CR>", desc = "Run [T]est [L]ast" },
    { "<leader>tv", "<CMD>TestVisit<CR>", desc = "[T]est [V]isit output" },
  },
}
