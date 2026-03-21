return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")

    lint.linters_by_ft = {
      bash = { "shellcheck" },
      lua = { "luacheck" },
      markdown = { "markdownlint" },
      python = { "ruff" },
      sh = { "shellcheck" },
      zsh = { "shellcheck" },
    }

    local function get_available_linters(filetype)
      local available = {}
      for _, name in ipairs(lint.linters_by_ft[filetype] or {}) do
        local linter = lint.linters[name]
        local cmd = linter and linter.cmd or nil
        if type(cmd) == "function" then
          local ok, resolved = pcall(cmd)
          cmd = ok and resolved or nil
        end
        if type(cmd) == "string" and vim.fn.executable(cmd) == 1 then
          available[#available + 1] = name
        end
      end
      return available
    end

    local function try_lint()
      local linters = get_available_linters(vim.bo.filetype)
      if #linters > 0 then
        lint.try_lint(linters)
      end
    end

    local lint_group = vim.api.nvim_create_augroup("TheovimLint", { clear = true })
    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_group,
      callback = try_lint,
    })

    vim.keymap.set("n", "<leader>cl", try_lint, { desc = "[C]ode [L]int" })
  end,
}
