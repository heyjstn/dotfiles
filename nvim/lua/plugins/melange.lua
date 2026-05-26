local is_transparent = true
local theme = require("config.theme")

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

return {
  "savq/melange-nvim",
  enabled = theme.is_colorscheme("melange"),
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = theme.mode()

    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "melange",
      callback = apply_transparency,
    })

    vim.cmd.colorscheme("melange")
    apply_transparency()
  end,
}
