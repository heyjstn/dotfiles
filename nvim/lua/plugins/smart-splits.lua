return {
  "mrjones2014/smart-splits.nvim",
  lazy = false,
  init = function()
    vim.g.smart_splits_multiplexer_integration = "wezterm"
  end,
  config = function()
    local smart_splits = require("smart-splits")

    smart_splits.setup({
      ignored_buftypes = { "nofile", "quickfix", "prompt" },
      ignored_filetypes = { "neo-tree", "TheovimDashboard" },
      resize_mode = {
        quit_key = "<ESC>",
      },
      at_edge = function(ctx)
        local mux = ctx.mux
        if mux and mux.is_in_session and mux.is_in_session() then
          local ok_at_edge, pane_at_edge = pcall(mux.current_pane_at_edge, ctx.direction)
          if ok_at_edge and not pane_at_edge then
            local ok_move, moved = pcall(mux.next_pane, ctx.direction)
            if ok_move and moved ~= false then
              return
            end
          end
        end
        ctx.split()
      end,
    })

    vim.keymap.set("n", "<M-h>", smart_splits.move_cursor_left,
      { desc = "Move left across Neovim and WezTerm panes" })
    vim.keymap.set("n", "<M-j>", smart_splits.move_cursor_down,
      { desc = "Move down across Neovim and WezTerm panes" })
    vim.keymap.set("n", "<M-k>", smart_splits.move_cursor_up,
      { desc = "Move up across Neovim and WezTerm panes" })
    vim.keymap.set("n", "<M-l>", smart_splits.move_cursor_right,
      { desc = "Move right across Neovim and WezTerm panes" })

    vim.keymap.set("n", "<M-Left>", smart_splits.resize_left, { desc = "Resize pane left" })
    vim.keymap.set("n", "<M-Down>", smart_splits.resize_down, { desc = "Resize pane down" })
    vim.keymap.set("n", "<M-Up>", smart_splits.resize_up, { desc = "Resize pane up" })
    vim.keymap.set("n", "<M-Right>", smart_splits.resize_right, { desc = "Resize pane right" })
  end,
}
