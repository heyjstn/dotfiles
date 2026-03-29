--- wezterm.lua
--- $ figlet -f small Wezterm
--- __      __      _
--- \ \    / /__ __| |_ ___ _ _ _ __
---  \ \/\/ / -_)_ /  _/ -_) '_| '  \
---   \_/\_/\___/__|\__\___|_| |_|_|_| My Wezterm config file
local wezterm = require("wezterm")
local act = wezterm.action

local zsh_path = "/bin/zsh"
local direction_keys = {
  h = "Left",
  j = "Down",
  k = "Up",
  l = "Right",
  LeftArrow = "Left",
  DownArrow = "Down",
  UpArrow = "Up",
  RightArrow = "Right",
}

local function basename(s)
  return string.gsub(s, "(.*[/\\])(.*)", "%2")
end

local function cwd_to_path(cwd)
  if not cwd then
    return wezterm.home_dir
  end
  if type(cwd) == "userdata" then
    return cwd.file_path
  end
  return cwd
end

local function workspace_name_from_cwd(cwd)
  local path = cwd_to_path(cwd)
  local name = basename(path)
  return name ~= "" and name or "main"
end

local function is_nvim(pane)
  local user_vars = pane:get_user_vars() or {}
  if user_vars.IS_NVIM == "true" then
    return true
  end

  local process_name = pane:get_foreground_process_name()
  return process_name and process_name:match("n?vim") ~= nil
end

local function split_nav(mode, key)
  local direction = direction_keys[key]
  return {
    key = key,
    mods = "META",
    action = wezterm.action_callback(function(window, pane)
      if is_nvim(pane) then
        window:perform_action(act.SendKey { key = key, mods = "ALT" }, pane)
        return
      end

      if mode == "resize" then
        window:perform_action(act.AdjustPaneSize { direction, 3 }, pane)
      else
        window:perform_action(act.ActivatePaneDirection(direction), pane)
      end
    end),
  }
end

local function send_if_nvim(key, mods)
  return wezterm.action_callback(function(window, pane)
    if is_nvim(pane) then
      window:perform_action(act.SendKey { key = key, mods = mods }, pane)
    end
  end)
end

local config = {}
-- Use config builder object if possible
if wezterm.config_builder then config = wezterm.config_builder() end

-- Settings
config.default_prog = { zsh_path, "-l" }

config.color_scheme_dirs = { wezterm.home_dir .. "/dotfiles/wezterm/colors" }
config.color_scheme = "Kanagawa"
config.font = wezterm.font_with_fallback({
  { family = "JetBrainsMono Nerd Font", weight = "Medium" },
  { family = "IosevkaTerm Nerd Font",   weight = "Medium" },
  { family = "Symbols Nerd Font Mono" },
  { family = "Menlo" },
})

local opacity = 0.90
config.window_background_opacity = opacity
config.window_decorations = "RESIZE"
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "main"
config.launch_menu = {
  { label = "Home",          cwd = wezterm.home_dir,                     args = { zsh_path, "-l" } },
  { label = "Dotfiles",      cwd = wezterm.home_dir .. "/dotfiles",      args = { zsh_path, "-l" } },
  { label = "Neovim Config", cwd = wezterm.home_dir .. "/dotfiles/nvim", args = { zsh_path, "-l" } },
}
config.macos_window_background_blur = 50

-- Dim inactive panes
config.inactive_pane_hsb = {
  saturation = 0.24,
  brightness = 0.5
}

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }
config.keys = {
  -- Send C-a when pressing C-a twice
  { key = "a",          mods = "LEADER|CTRL", action = act.SendKey { key = "a", mods = "CTRL" } },
  { key = "c",          mods = "LEADER",      action = act.ActivateCopyMode },
  { key = "phys:Space", mods = "LEADER",      action = act.ActivateCommandPalette },
  { key = "f",          mods = "LEADER",      action = act.QuickSelect },
  { key = "/",          mods = "LEADER",      action = act.Search("CurrentSelectionOrEmptyString") },
  { key = "[",          mods = "SUPER",       action = send_if_nvim("[", "ALT") },
  { key = "]",          mods = "SUPER",       action = send_if_nvim("]", "ALT") },

  -- Pane keybindings
  { key = "s",          mods = "LEADER",      action = act.SplitVertical { domain = "CurrentPaneDomain" } },
  { key = "v",          mods = "LEADER",      action = act.SplitHorizontal { domain = "CurrentPaneDomain" } },
  { key = "h",          mods = "LEADER",      action = act.ActivatePaneDirection("Left") },
  { key = "j",          mods = "LEADER",      action = act.ActivatePaneDirection("Down") },
  { key = "k",          mods = "LEADER",      action = act.ActivatePaneDirection("Up") },
  { key = "l",          mods = "LEADER",      action = act.ActivatePaneDirection("Right") },
  { key = "q",          mods = "LEADER",      action = act.CloseCurrentPane { confirm = true } },
  { key = "z",          mods = "LEADER",      action = act.TogglePaneZoomState },
  { key = "o",          mods = "LEADER",      action = act.RotatePanes "Clockwise" },
  -- We can make separate keybindings for resizing panes
  -- But Wezterm offers custom "mode" in the name of "KeyTable"
  { key = "r",          mods = "LEADER",      action = act.ActivateKeyTable { name = "resize_pane", one_shot = false } },

  -- Tab keybindings
  { key = "t",          mods = "LEADER",      action = act.SpawnTab("CurrentPaneDomain") },
  { key = "[",          mods = "LEADER",      action = act.ActivateTabRelative(-1) },
  { key = "]",          mods = "LEADER",      action = act.ActivateTabRelative(1) },
  { key = "n",          mods = "LEADER",      action = act.ShowTabNavigator },
  {
    key = "e",
    mods = "LEADER",
    action = act.PromptInputLine {
      description = wezterm.format {
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Fuchsia" } },
        { Text = "Renaming Tab Title...:" },
      },
      action = wezterm.action_callback(function(window, pane, line)
        if line then
          window:active_tab():set_title(line)
        end
      end)
    }
  },
  -- Key table for moving tabs around
  { key = "m", mods = "LEADER",       action = act.ActivateKeyTable { name = "move_tab", one_shot = false } },
  -- Or shortcuts to move tab w/o move_tab table. SHIFT is for when caps lock is on
  { key = "{", mods = "LEADER|SHIFT", action = act.MoveTabRelative(-1) },
  { key = "}", mods = "LEADER|SHIFT", action = act.MoveTabRelative(1) },

  -- Lastly, workspace
  { key = "w", mods = "LEADER",       action = act.ShowLauncherArgs { flags = "FUZZY|WORKSPACES|LAUNCH_MENU_ITEMS" } },
  {
    key = "p",
    mods = "LEADER",
    action = wezterm.action_callback(function(window, pane)
      local cwd = cwd_to_path(pane:get_current_working_dir())
      window:perform_action(act.SwitchToWorkspace {
        name = workspace_name_from_cwd(cwd),
        spawn = { cwd = cwd },
      }, pane)
    end),
  },
  {
    key = "P",
    mods = "LEADER|SHIFT",
    action = act.PromptInputLine {
      description = wezterm.format({
        { Attribute = { Intensity = "Bold" } },
        { Foreground = { AnsiColor = "Teal" } },
        { Text = "Workspace name (blank uses current directory):" },
      }),
      action = wezterm.action_callback(function(window, pane, line)
        local cwd = cwd_to_path(pane:get_current_working_dir())
        local name = (line and line ~= "") and line or workspace_name_from_cwd(cwd)
        window:perform_action(act.SwitchToWorkspace {
          name = name,
          spawn = { cwd = cwd },
        }, pane)
      end),
    }
  },

  split_nav("move", "h"),
  split_nav("move", "j"),
  split_nav("move", "k"),
  split_nav("move", "l"),
  split_nav("resize", "LeftArrow"),
  split_nav("resize", "DownArrow"),
  split_nav("resize", "UpArrow"),
  split_nav("resize", "RightArrow"),
}
-- I can use the tab navigator (LDR t), but I also want to quickly navigate tabs with index
for i = 1, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "LEADER",
    action = act.ActivateTab(i - 1)
  })
end

config.key_tables = {
  resize_pane = {
    { key = "h",      action = act.AdjustPaneSize { "Left", 1 } },
    { key = "j",      action = act.AdjustPaneSize { "Down", 1 } },
    { key = "k",      action = act.AdjustPaneSize { "Up", 1 } },
    { key = "l",      action = act.AdjustPaneSize { "Right", 1 } },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  },
  move_tab = {
    { key = "h",      action = act.MoveTabRelative(-1) },
    { key = "j",      action = act.MoveTabRelative(-1) },
    { key = "k",      action = act.MoveTabRelative(1) },
    { key = "l",      action = act.MoveTabRelative(1) },
    { key = "Escape", action = "PopKeyTable" },
    { key = "Enter",  action = "PopKeyTable" },
  }
}

-- Tab bar
-- I don't like the look of "fancy" tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
config.tab_bar_at_bottom = false
wezterm.on("update-status", function(window, pane)
  -- Workspace name
  local stat = window:active_workspace()
  local stat_color = "#C34043"
  -- It's a little silly to have workspace name all the time
  -- Utilize this to display LDR or current key table name
  local overrides = window:get_config_overrides() or {}
  if window:is_focused() then
    overrides.window_background_opacity = opacity
  else
    overrides.window_background_opacity = opacity / 1.25
  end
  window:set_config_overrides(overrides)
  if window:active_key_table() then
    stat = window:active_key_table()
    stat_color = "#7FB4CA"
  end
  if window:leader_is_active() then
    stat = "LDR"
    stat_color = "#957FB8"
  end

  -- Current working directory
  local cwd = pane:get_current_working_dir()
  if cwd then
    if type(cwd) == "userdata" then
      -- Wezterm introduced the URL object in 20240127-113634-bbcac864
      cwd = basename(cwd.file_path)
    else
      -- 20230712-072601-f4abf8fd or earlier version
      cwd = basename(cwd)
    end
  else
    cwd = ""
  end

  -- Current command
  local cmd = pane:get_foreground_process_name()
  -- CWD and CMD could be nil (e.g. viewing log using Ctrl-Alt-l)
  cmd = cmd and basename(cmd) or ""

  -- Time
  local time = wezterm.strftime("%H:%M")

  -- Left status (left of the tab line)
  window:set_left_status(wezterm.format({
    { Foreground = { Color = stat_color } },
    { Text = "  " },
    { Text = wezterm.nerdfonts.oct_table .. "  " .. stat },
    { Text = " |" },
  }))

  -- Right status
  window:set_right_status(wezterm.format({
    -- Wezterm has a built-in nerd fonts
    -- https://wezfurlong.org/wezterm/config/lua/wezterm/nerdfonts.html
    { Text = wezterm.nerdfonts.md_folder .. "  " .. cwd },
    { Text = " | " },
    { Foreground = { Color = "#E6C384" } },
    { Text = wezterm.nerdfonts.fa_code .. "  " .. cmd },
    "ResetAttributes",
    { Text = " | " },
    { Text = wezterm.nerdfonts.md_clock .. "  " .. time },
    { Text = "  " },
  }))
end)

--[[ Appearance setting for when I need to take pretty screenshots
config.enable_tab_bar = false
config.window_padding = {
  left = '0.5cell',
  right = '0.5cell',
  top = '0.5cell',
  bottom = '0cell',

}
--]]

return config
