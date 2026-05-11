local is_transparent = true

local function normalize_theme_mode(mode)
  if mode == "light" then
    return "light"
  end
  if mode == "dark" then
    return "dark"
  end
  return nil
end

local function read_theme_mode_from_wezterm_config()
  local uv = vim.uv or vim.loop
  local config_dir = uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
  local candidates = {
    vim.fn.fnamemodify(config_dir, ":h") .. "/.wezterm.lua",
    vim.env.HOME .. "/dotfiles/.wezterm.lua",
    vim.env.HOME .. "/.wezterm.lua",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      local lines = vim.fn.readfile(path)
      local content = table.concat(lines, "\n")
      local mode = content:match("local%s+theme_mode%s*=%s*['\"]([%a_]+)['\"]")
        or content:match("config%.theme_mode%s*=%s*['\"]([%a_]+)['\"]")

      if mode then
        return normalize_theme_mode(mode)
      end
    end
  end

  return "dark"
end

local function get_theme_mode()
  return normalize_theme_mode(vim.env.THEME_MODE) or read_theme_mode_from_wezterm_config()
end

return {
  "ellisonleao/gruvbox.nvim",
  lazy = false,
  priority = 1000,
  config = function()
    vim.o.background = get_theme_mode()
    require("gruvbox").setup({
      transparent_mode = is_transparent,
    })
    vim.cmd.colorscheme("gruvbox")
  end,
}
