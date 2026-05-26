local M = {}

local default_theme = "melange"

local themes = {
  melange = {
    mode = "dark",
    colorscheme = "melange",
  },
  ["melange-light"] = {
    mode = "light",
    colorscheme = "melange",
  },
  evergarden = {
    mode = "dark",
    colorscheme = "evergarden",
    variant = "fall",
    accent = "green",
  },
  oxocarbon = {
    mode = "dark",
    colorscheme = "oxocarbon",
  },
  gruvbox = {
    mode = "dark",
    colorscheme = "gruvbox",
  },
  ["gruvbox-light"] = {
    mode = "light",
    colorscheme = "gruvbox",
  },
  darcula = {
    mode = "dark",
    colorscheme = "darcula",
  },
}

local selected_theme = nil

local function normalize_mode(mode)
  if mode == "light" then
    return "light"
  end
  if mode == "dark" then
    return "dark"
  end
  return nil
end

local function normalize_theme_name(name)
  if type(name) ~= "string" then
    return nil
  end

  local normalized = name:gsub("^%s+", ""):gsub("%s+$", "")
  if themes[normalized] then
    return normalized
  end

  return nil
end

local function read_theme_name_from_wezterm_config()
  local uv = vim.uv or vim.loop
  local config_dir = uv.fs_realpath(vim.fn.stdpath("config")) or vim.fn.stdpath("config")
  local candidates = {
    vim.fn.fnamemodify(config_dir, ":h") .. "/.wezterm.lua",
    vim.env.HOME .. "/dotfiles/.wezterm.lua",
    vim.env.HOME .. "/.wezterm.lua",
  }

  for _, path in ipairs(candidates) do
    if vim.fn.filereadable(path) == 1 then
      local content = table.concat(vim.fn.readfile(path), "\n")
      local name = content:match("local%s+theme_name%s*=%s*['\"]([%w%-%_]+)['\"]")
        or content:match("config%.theme_name%s*=%s*['\"]([%w%-%_]+)['\"]")

      name = normalize_theme_name(name)
      if name then
        return name
      end
    end
  end

  return nil
end

local function resolve_theme()
  local name = normalize_theme_name(vim.env.THEME_NAME)
    or read_theme_name_from_wezterm_config()
    or default_theme
  local theme = vim.deepcopy(themes[name])

  theme.name = name
  theme.mode = normalize_mode(vim.env.THEME_MODE) or theme.mode

  if vim.env.NVIM_COLORSCHEME and vim.env.NVIM_COLORSCHEME ~= "" then
    theme.colorscheme = vim.env.NVIM_COLORSCHEME
  end

  return theme
end

function M.get()
  if not selected_theme then
    selected_theme = resolve_theme()
  end

  return selected_theme
end

function M.name()
  return M.get().name
end

function M.mode()
  return M.get().mode
end

function M.colorscheme()
  return M.get().colorscheme
end

function M.is(name)
  return M.name() == name
end

function M.is_colorscheme(colorscheme)
  return M.colorscheme() == colorscheme
end

return M
