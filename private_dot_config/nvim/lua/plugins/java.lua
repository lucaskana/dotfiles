return {
  -- LSP Java
  {
    "mfussenegger/nvim-jdtls",
    ft = { "java" },
    config = function()
      local jdtls = require("jdtls")
      local home = os.getenv("HOME")
      local mason = home .. "/.local/share/nvim/mason"
      local jdtls_path = mason .. "/packages/jdtls"
      local lombok_jar = mason .. "/packages/lombok-nightly/lombok.jar"
      if vim.fn.filereadable(lombok_jar) == 0 then
        -- fallback caso pacote seja "lombok" (não nightly)
        lombok_jar = mason .. "/packages/lombok/lombok.jar"
      end

      -- bundles do debug e test (DAP + JUnit)
      local bundles = {
        vim.fn.glob(mason .. "/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar", 1),
      }
      vim.list_extend(bundles, vim.split(vim.fn.glob(mason .. "/packages/java-test/extension/server/*.jar", 1), "\n"))

      -- Descobrir root do projeto (Gradle/Maven/git)
      local root_markers = { ".git", "mvnw", "pom.xml", "gradlew", "build.gradle", "settings.gradle" }
      local root_dir = require("jdtls.setup").find_root(root_markers)
      if root_dir == "" then
        return
      end

      local workspace_dir = home .. "/.local/share/jdtls/workspaces/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")

      local config = {
        cmd = {
          "jdtls",
          "-configuration",
          jdtls_path .. "/config_linux",
          "-data",
          workspace_dir,
          -- Habilitar Lombok
          "--jvm-arg="
            .. "-javaagent:"
            .. lombok_jar,
          "--jvm-arg=" .. "-Xbootclasspath/a:" .. lombok_jar,
        },
        root_dir = root_dir,
        settings = {
          java = {
            signatureHelp = { enabled = true },
            contentProvider = { preferred = "fernflower" }, -- decompiler melhor
            completion = { favoriteStaticMembers = { "org.mockito.Mockito.*", "org.junit.jupiter.api.Assertions.*" } },
            format = { enabled = false }, -- vamos formatar com conform/google-java-format
            configuration = {
              runtimes = {
                -- ajuste conforme seus JDKs instalados
                { name = "JavaSE-17", path = os.getenv("JAVA_HOME") or "/usr/lib/jvm/java-17" },
              },
            },
          },
        },
        init_options = {
          bundles = bundles,
        },
        on_attach = function(client, bufnr)
          -- keymaps úteis do jdtls
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          jdtls.setup_dap({ hotcodereplace = "auto" })
          jdtls.setup.add_commands()

          map("n", "<leader>jo", jdtls.organize_imports, "Java: Organize Imports")
          map("n", "<leader>jt", jdtls.test_nearest_method, "Java: Test Method")
          map("n", "<leader>jT", jdtls.test_class, "Java: Test Class")
          map("n", "<leader>jr", jdtls.code_action, "Java: Code Action")
          map("v", "<leader>je", jdtls.extract_variable, "Java: Extract Variable")
          map("v", "<leader>jm", jdtls.extract_method, "Java: Extract Method")
          map("n", "<leader>jR", jdtls.extract_constant, "Java: Extract Constant")
        end,
      }

      -- inicia/reatacha jdtls para o buffer Java
      jdtls.start_or_attach(config)
    end,
  },

  -- DAP UI (visual para debugging)
  -- {
  --   "rcarriga/nvim-dap-ui",
  --   dependencies = { "mfussenegger/nvim-dap" },
  --   config = function()
  --     local dap = require("dap")
  --     local dapui = require("dapui")
  --     dapui.setup()
  --     dap.listeners.after.event_initialized["dapui_config"] = function()
  --       dapui.open()
  --     end
  --     dap.listeners.before.event_terminated["dapui_config"] = function()
  --       dapui.close()
  --     end
  --     dap.listeners.before.event_exited["dapui_config"] = function()
  --       dapui.close()
  --     end
  --   end,
  -- },

  -- Testes com neotest + JUnit (via jdtls)
  -- {
  --   "nvim-neotest/neotest",
  --   dependencies = {
  --     "nvim-lua/plenary.nvim",
  --     "antoinemadec/FixCursorHold.nvim",
  --     "nvim-neotest/neotest-jdtls",
  --   },
  --   config = function()
  --     require("neotest").setup({
  --       adapters = {
  --         require("neotest-jdtls")({}),
  --       },
  --     })
  --   end,
  -- },

  -- Treesitter para Java
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "java", "xml", "json", "bash", "lua" },
    },
  },

  -- Formatação com google-java-format via conform.nvim
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
      format_on_save = {
        lsp_fallback = false,
        timeout_ms = 3000,
      },
    },
  },
}
