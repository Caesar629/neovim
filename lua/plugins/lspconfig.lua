return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = {
      { 'williamboman/mason.nvim', cmd = 'Mason' },
      { 'williamboman/mason-lspconfig.nvim', lazy = true },
      { 'p00f/clangd_extensions.nvim', ft = { 'c', 'cpp', 'objc', 'objcpp' } },
      'hrsh7th/nvim-cmp',
      { 'folke/neodev.nvim', opts = {} },
      { 'nvimdev/lspsaga.nvim', dependencies = 'nvim-tree/nvim-web-devicons' },
    },
    config = function()
      --------------------------------------
      -- 初始化核心组件（带错误处理）
      --------------------------------------
      local mason_ok, mason = pcall(require, 'mason')
      if not mason_ok then return end
      mason.setup({ 
        ui = { 
          border = 'rounded',
          icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
          }
        },
        max_concurrent_installers = 4
      })

      local mason_lsp_ok, mason_lsp = pcall(require, 'mason-lspconfig')
      if not mason_lsp_ok then return end
      mason_lsp.setup({
        ensure_installed = { 'lua_ls', 'clangd', 'pyright', 'bashls', 'rust_analyzer' },
        automatic_installation = {
          exclude = {}  -- 排除不需要自动安装的LSP
        },
      })

      --------------------------------------
      -- 公共配置
      --------------------------------------
      local neodev_ok, _ = pcall(require, 'neodev')
      if neodev_ok then require('neodev').setup({}) end

      -- 增强的能力配置
      local capabilities = vim.tbl_deep_extend(
        'force',
        vim.lsp.protocol.make_client_capabilities(),
        require('cmp_nvim_lsp').default_capabilities(),
        {
          textDocument = {
            foldingRange = {
              dynamicRegistration = false,
              lineFoldingOnly = true
            }
          }
        }
      )

      -- 现代化诊断配置
      vim.diagnostic.config({
        virtual_text = {
          prefix = '●',
          spacing = 4,
          severity = { min = vim.diagnostic.severity.WARN }
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN] = "",
            [vim.diagnostic.severity.INFO] = "",
            [vim.diagnostic.severity.HINT] = "",
          },
          texthl = {
            [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
            [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
            [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
            [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
          }
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = 'rounded',
          source = 'always',
          header = '',
          format = function(diagnostic)
            local code = diagnostic.code or (diagnostic.user_data and diagnostic.user_data.lsp.code)
            return string.format(
              "%s [%s] (%s)",
              diagnostic.message,
              diagnostic.source,
              code or ""
            )
          end
        }
      })

      --------------------------------------
      -- LSP 通用附加配置
      --------------------------------------
      local on_attach = function(client, bufnr)
        -- 禁用某些LSP的格式化
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false

        -- 键位映射辅助函数
        local map = function(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, {
            buffer = bufnr,
            desc = 'LSP: ' .. desc,
            noremap = true,
            silent = true
          })
        end

        -- 导航
        map('n', 'gd', vim.lsp.buf.definition, '跳转到定义')
        map('n', 'gD', vim.lsp.buf.declaration, '跳转到声明')
        map('n', 'gi', vim.lsp.buf.implementation, '跳转到实现')
        map('n', 'gr', require('telescope.builtin').lsp_references, '查找引用')
        map('n', 'K', vim.lsp.buf.hover, '悬浮文档')

        -- 代码操作
        map('n', '<leader>rn', vim.lsp.buf.rename, '重命名符号')
        map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, '代码操作')
        map('n', '<leader>f', function()
          vim.lsp.buf.format({ async = true, timeout_ms = 2000 })
        end, '格式化文件')

        -- 内联提示（使用原生LSP实现）
        if client.supports_method('textDocument/inlayHint') then
          local ok, _ = pcall(function()
            if type(vim.lsp.inlay_hint) == 'table' and 
               type(vim.lsp.inlay_hint.enable) == 'function' then
              vim.lsp.inlay_hint.enable(bufnr, true)
            end
          end)
          if not ok then
            vim.notify_once("Failed to setup inlay hints", vim.log.levels.WARN)
          end
        end

        -- clangd特殊处理
        if client.name == 'clangd' then
          map('n', '<leader>h', '<cmd>ClangdSwitchSourceHeader<cr>', '切换头文件')
        end
      end

      --------------------------------------
      -- 语言服务器配置
      --------------------------------------
      -- Lua
      require('lspconfig').lua_ls.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          Lua = {
            runtime = { version = 'LuaJIT' },
            diagnostics = {
              globals = { 'vim' },
              disable = { 'missing-fields' }
            },
            workspace = {
              library = vim.api.nvim_get_runtime_file('', true),
              checkThirdParty = false
            },
            telemetry = { enable = false },
            hint = {
              enable = true,
              arrayIndex = 'Disable',
              paramName = 'Disable',
              paramType = false,
              setType = true
            }
          }
        }
      })

      -- Python
      require('lspconfig').pyright.setup({
        on_attach = on_attach,
        capabilities = capabilities,
        settings = {
          python = {
            analysis = {
              typeCheckingMode = "basic",
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              diagnosticMode = "workspace"
            }
          }
        }
      })

      --------------------------------------
      -- 扩展配置
      --------------------------------------
      -- Clangd扩展（带安全检查和配置复用）
      local clangd_ok, clangd_ext = pcall(require, 'clangd_extensions')
      if clangd_ok then
        clangd_ext.setup({
          server = {
            on_attach = on_attach,
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--header-insertion=iwyu",
              "--completion-style=detailed",
              "--all-scopes-completion",
              "--cross-file-rename"
            }
          },
          extensions = {
            inlay_hints = {
              inline = true,
              only_current_line = false,
              show_parameter_hints = true,
              parameter_hints_prefix = " ← ",
              other_hints_prefix = " → ",
              highlight = "Comment"
            }
          }
        })
      else
        -- 如果clangd_extensions加载失败，回退到原生clangd配置
        require('lspconfig').clangd.setup({
          on_attach = on_attach,
          capabilities = capabilities,
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--all-scopes-completion",
            "--cross-file-rename"
          }
        })
      end

      -- Lspsaga配置（带错误处理）
      local saga_ok, lspsaga = pcall(require, 'lspsaga')
      if saga_ok then
        lspsaga.setup({
          symbol_in_winbar = { enable = true },
          lightbulb = { enable = false },
          outline = { auto_preview = false }
        })
      end

      --------------------------------------
      -- 自动命令（优化版）
      --------------------------------------
      local compile_group = vim.api.nvim_create_augroup('LspCompileCommands', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
        group = compile_group,
        pattern = { '*.c', '*.cpp', '*.h', '*.hpp' },
        callback = function()
          if vim.fn.executable('bear') == 1 and
             vim.fn.empty(vim.fn.glob('compile_commands.json')) == 1 then
            vim.notify('Generating compile_commands.json...')
            local job = vim.system({ 
              'bear', 
              '--', 
              'make', 
              '-j' .. math.min(8, vim.loop.available_parallelism()) 
            }, {
              cwd = vim.fn.getcwd(),
              detach = true
            })
            job:wait()
          end
        end
      })
    end
  }
}