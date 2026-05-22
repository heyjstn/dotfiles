local mason_version = "1.11.0"  -- Last v1 version
local mason_lspconfig_version = "1.32.0"  -- Last v1 version

local M = { "neovim/nvim-lspconfig", }

M.dependencies = {
  { "williamboman/mason.nvim", version = mason_version, config = true, }, --> LSP server manager
  { "williamboman/mason-lspconfig.nvim", version = mason_lspconfig_version },
  { "j-hui/fidget.nvim",       opts = {}, },     --> LSP status indicator
  {
    "folke/lazydev.nvim",                        --> Neovim dev environment
    ft = "lua",
    opts = {
      library = {
        { path = "luvit-meta/library", words = { "vim%.uv" }, },
      },
    },
  },
  { 'Bilal2453/luvit-meta', lazy = true }, --> vim.uv support
}

M.config = function()
  -- Sets the LSP UI look
  vim.lsp.handlers["textDocument/hover"] = function(err, result, ctx, config)
    vim.lsp.handlers.hover(err, result, ctx, vim.tbl_deep_extend("force", config or {}, { border = "rounded", title = "Hover" }))
  end
  vim.lsp.handlers["textDocument/signatureHelp"] = function(err, result, ctx, config)
    vim.lsp.handlers.signature_help(err, result, ctx, vim.tbl_deep_extend("force", config or {}, { border = "rounded", title = "Signature Help" }))
  end

  -- Makes autocmd for LSP functionalities
  local theovim_lsp_config_group = vim.api.nvim_create_augroup("TheovimLspConfig", { clear = true, })

  vim.api.nvim_create_autocmd("LspAttach", {
    group = theovim_lsp_config_group,
    callback = function(event)
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
      end

      -- Sets the default values for LSP functions with Telescope counterparts
      local status, builtin = pcall(require, "telescope.builtin")
      local telescope_opt = { jump_type = "tab" } --> spawns selection in a new tab
      local telescope_or = function(picker, fallback, opts)
        if status and builtin[picker] then
          return function() builtin[picker](opts or {}) end
        end
        return fallback
      end
      -- Sets the navigation keymaps
      map("gd", telescope_or("lsp_definitions", vim.lsp.buf.definition, telescope_opt),
        "[G]oto [D]efinition")
      map("gr", telescope_or("lsp_references", vim.lsp.buf.references), "[G]oto [R]eferences")
      map("gI", telescope_or("lsp_implementations", vim.lsp.buf.implementation), "[G]oto [I]mplementation")
      map("<leader>D",
        telescope_or("lsp_type_definitions", vim.lsp.buf.type_definition, telescope_opt),
        "Type [D]efinition")
      -- Sets the symbol keymaps
      map("<leader>ds", telescope_or("lsp_document_symbols", vim.lsp.buf.document_symbol), "[D]ocument [S]ymbols")
      map("<leader>ws", telescope_or("lsp_dynamic_workspace_symbols", vim.lsp.buf.workspace_symbol),
        "[W]orkspace [S]ymbols")

      -- Sets the functiosn with no Telescope counterparts
      map("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
      map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
      map("gD", vim.lsp.buf.declaration, "[G]o [D]eclaration")

      -- Creates an autocmd to highlight the symbol under the cursor
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
        local theovim_lsp_hl_group = vim.api.nvim_create_augroup("TheovimLspHl", { clear = false, })
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = event.buf,
          group = theovim_lsp_hl_group,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
          buffer = event.buf,
          group = theovim_lsp_hl_group,
          callback = vim.lsp.buf.clear_references,
        })

        local theovim_lsp_detach_group = vim.api.nvim_create_augroup("TheovimLspHlDetach", { clear = true, })
        vim.api.nvim_create_autocmd("LspDetach", {
          group = theovim_lsp_detach_group,
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds({ group = "TheovimLspHl", buffer = event2.buf })
          end
        })
      end

      -- Creates a keybinding to toggle inlay hints, as hints can displace some of the code
      if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
        map("<leader>th", function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
        end, "[T]oggle Inlay [H]ints")
      end
    end,
  })

  -- Gets nvim-cmp capabilities
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

  -- Calls Mason
  require("mason").setup()

  -- Defines a list of servers and server-specific config
  local servers = {
    bashls = {},
    clangd = {
      cmd = {
        "clangd",
        "--background-index",
        "--clang-tidy",
        "--completion-style=detailed",
        "--header-insertion=iwyu",
      },
      filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
      root_markers = {
        ".clangd",
        ".clang-tidy",
        "compile_commands.json",
        "compile_flags.txt",
      },
    },
    metals = {
      root_markers = { "build.sbt", "build.sc", "build.mill", "pom.xml", ".git" },
    },
    pyright = {
      settings = {
        python = {
          analysis = {
            autoImportCompletions = true,
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
          },
        },
      },
    },
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
    texlab = {},
    -- html = { filetypes = { "html", "twig", "hbs"} },
    gopls = {
      filetypes = {"go", "gomod", "gowork", "gotmpl"},
      root_markers = { "go.work", "go.mod", ".git" },
      settings = {
        gopls = {
          -- Enable auto imports
          gofumpt = true, 
          usePlaceholders = true,
          completeUnimported = true,
          staticcheck = true,
          matcher = "fuzzy",
          
          -- Enable documentation features
          hints = {
            assignVariableTypes = true,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = true,
            rangeVariableTypes = true,
          },
          
          analyses = {
            unusedparams = true,
            shadow = true,
            nilness = true,
            unusedwrite = true,
            useany = true,
          },
          
          -- Enable codelens for better documentation
          codelenses = {
            generate = true,
            gc_details = true,
            test = true,
            tidy = true,
            upgradeDeprecatedLints = true,
          },
        },
      },
    },
    lua_ls = {
      settings = {
        Lua = {
          telemetry = { enable = false },
        },
      },
    },
  }

  -- Ensure Mason-backed servers are installed.
  -- Some servers in `servers` (for example `metals`) are not provided by Mason
  -- and must still be set up explicitly below.
  require("mason-lspconfig").setup({
    ensure_installed = {
      "bashls",
      "clangd",
      "gopls",
      "lua_ls",
      "pyright",
      "rust_analyzer",
      "texlab",
    },
  })

  for server_name, server in pairs(servers) do
    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
    vim.lsp.config(server_name, server)
    vim.lsp.enable(server_name)
  end
end

return M
