local is_transparent = true

return {
  "doums/darcula",
  enabled = false,
  lazy = false,
  priority = 1000,
  config = function()
    local function apply_transparency()
      if not is_transparent then
        return
      end

      local transparent_groups = {
        "Normal",
        "NormalNC",
        "SignColumn",
        "EndOfBuffer",
        "FoldColumn",
        "LineNr",
        "CursorLineNr",
        "StatusLine",
        "StatusLineNC",
        "TabLine",
        "TabLineFill",
        "NormalFloat",
        "FloatBorder",
        "Pmenu",
      }

      for _, group in ipairs(transparent_groups) do
        local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
        if ok then
          hl.bg = "NONE"
          hl.ctermbg = "NONE"
          vim.api.nvim_set_hl(0, group, hl)
        end
      end
    end

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "darcula",
      callback = apply_transparency,
    })

    vim.cmd.colorscheme("darcula")
    apply_transparency()
  end,
}
