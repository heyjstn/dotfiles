return {
  "nvim-java/nvim-java",
  ft = "java",
  dependencies = {
    "neovim/nvim-lspconfig",
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
  config = function()
    require("java").setup()
    require("lspconfig").jdtls.setup({
      capabilities = require("cmp_nvim_lsp").default_capabilities(),
      settings = {
        java = {
          eclipse = {
            downloadSources = true,
          },
          maven = {
            downloadSources = true,
          },
          implementationsCodeLens = {
            enabled = true,
          },
          referencesCodeLens = {
            enabled = true,
          },
        },
      },
    })
  end,
}
