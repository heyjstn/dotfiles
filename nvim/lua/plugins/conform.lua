return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>F",
      function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end,
      desc = "[F]ormat buffer",
    },
    {
      "<leader>cf",
      function()
        require("conform").format({
          async = true,
          lsp_format = "fallback",
        })
      end,
      desc = "[C]ode [F]ormat",
    },
  },
  opts = {
    notify_on_error = true,
    format_on_save = function()
      return {
        timeout_ms = 500,
        lsp_format = "fallback",
      }
    end,
    formatters_by_ft = {
      c = { "clang_format" },
      cpp = { "clang_format" },
      go = { "gofumpt", "goimports", "gofmt" },
      java = { "google_java_format" },
      lua = { "stylua" },
      markdown = { "prettier" },
      python = { "ruff_organize_imports", "ruff_format" },
      sh = { "shfmt" },
      tex = { "latexindent" },
      toml = { "taplo" },
      yaml = { "prettier" },
    },
  },
}
