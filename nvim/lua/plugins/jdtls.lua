return {
  "mfussenegger/nvim-jdtls",
  ft = "java",
  dependencies = {
    "mfussenegger/nvim-dap",
    "williamboman/mason.nvim",
  },
  config = function()
    local jdtls = require("jdtls")
    local jdtls_dap = require("jdtls.dap")
    local setup = require("jdtls.setup")
    local registry_ok, mason_registry = pcall(require, "mason-registry")

    -- One-time: ensure mason packages are installed
    if registry_ok then
      for _, package_name in ipairs({ "java-debug-adapter", "java-test" }) do
        local ok, package = pcall(mason_registry.get_package, package_name)
        if ok and not package:is_installed() then
          package:install()
        end
      end
    end

    local data_dir = vim.fn.stdpath("data")
    local bundles = {}

    local function extend_bundles(glob_pattern)
      local matches = vim.split(vim.fn.glob(glob_pattern), "\n", { trimempty = true })
      vim.list_extend(bundles, matches)
    end

    extend_bundles(data_dir .. "/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar")
    extend_bundles(data_dir .. "/mason/packages/java-test/extension/server/*.jar")

    -- Resolve Java 21+ for running jdtls itself (independent of JAVA_HOME)
    local java_21_home = vim.fn.system("/usr/libexec/java_home -v 21 2>/dev/null"):gsub("\n", "")
    local java_executable = java_21_home ~= "" and (java_21_home .. "/bin/java") or "java"

    -- Configure available JDK runtimes for project compilation
    local runtimes = {}
    if java_21_home ~= "" then
      table.insert(runtimes, {
        name = "JavaSE-21",
        path = java_21_home,
        default = true,
      })
    end
    -- Add Java 8 runtime if available
    local java_8_home = vim.fn.system("/usr/libexec/java_home -v 1.8 2>/dev/null"):gsub("\n", "")
    if java_8_home ~= "" then
      table.insert(runtimes, {
        name = "JavaSE-1.8",
        path = java_8_home,
      })
    end

    -- Per-buffer: find root and start/attach jdtls
    local function start_jdtls()
      local root_dir = setup.find_root({
        ".git",
        "mvnw",
        "gradlew",
        "pom.xml",
        "build.gradle",
        "build.gradle.kts",
        "settings.gradle",
        "settings.gradle.kts",
        "build.sbt",
      })

      if root_dir == "" then
        return
      end

      local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
      local workspace_dir = data_dir .. "/jdtls-workspace/" .. project_name

      jdtls.start_or_attach({
        cmd = { "jdtls", "--java-executable", java_executable, "-data", workspace_dir },
        root_dir = root_dir,
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
        init_options = {
          bundles = bundles,
        },
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
            configuration = {
              runtimes = runtimes,
            },
          },
        },
        on_attach = function(_, bufnr)
          jdtls_dap.setup_dap({ hotcodereplace = "auto" })
          if vim.startswith(vim.uri_from_bufnr(bufnr), "file://") then
            jdtls_dap.setup_dap_main_class_configs()
          end

          vim.keymap.set("n", "<leader>dn", jdtls.test_nearest_method,
            { buffer = bufnr, desc = "[D]ebug Java [N]earest test" })
          vim.keymap.set("n", "<leader>df", jdtls.test_class,
            { buffer = bufnr, desc = "[D]ebug Java test [F]ile" })
        end,
      })
    end

    -- Start for current buffer and ensure future Java buffers also get jdtls attached
    start_jdtls()
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "java",
      callback = start_jdtls,
    })
  end,
}
