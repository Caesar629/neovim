-- ~/.config/nvim/lua/config/lsp.lua

return {
  {
    'neovim/nvim-lspconfig',
    dependencies = {
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
      'p00f/clangd_extensions.nvim',
      'hrsh7th/nvim-cmp',
    },
    config = function()
      -- 初始化 Mason
      require('mason').setup()
      require('mason-lspconfig').setup({
        ensure_installed = { 'clangd', 'cmake', 'bashls', 'pyright', 'lua_ls' },
        automatic_installation = true,
      })

      local lspconfig = require('lspconfig')
      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      -- 设置诊断
      vim.diagnostic.config({
        virtual_text = { prefix = '●', spacing = 4 },
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = { border = 'rounded' },
      })

      -- 定义诊断符号
      local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
      for type, icon in pairs(signs) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
      end

      -- 通用 on_attach 函数
      local on_attach = function(client, bufnr)
        -- 启用 omnifunc
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- 安全地检查客户端名称
        local client_name = client and client.name or "unknown"

        -- 本地键位映射
        local bufopts = { noremap=true, silent=true, buffer=bufnr }
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, bufopts)
        vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        
        -- 特定客户端功能
        if client_name == 'clangd' then
          vim.keymap.set('n', '<leader>h', ':ClangdSwitchSourceHeader<CR>', bufopts)
          require('clangd_extensions.inlay_hints').setup_autocmd()
          require('clangd_extensions.inlay_hints').set_inlay_hints()
        end
      end

      -- 配置语言服务器
      local servers = {
        lua_ls = {
          settings = {
            Lua = {
              runtime = { version = 'LuaJIT' },
              diagnostics = { globals = { 'vim' } },
              workspace = { library = vim.api.nvim_get_runtime_file("", true), checkThirdParty = false },
              telemetry = { enable = false },
            }
          }
        },
        clangd = {
          cmd = {
            "clangd",
            "--background-index",
            "--clang-tidy",
            "--header-insertion=iwyu",
            "--completion-style=detailed",
            "--function-arg-placeholders",
            "--fallback-style=llvm",
          },
          init_options = {
            clangdFileStatus = true,
            usePlaceholders = true,
            semanticHighlighting = true,
          }
        },
        pyright = {},
        bashls = {},
        cmake = {}
      }

      for server, config in pairs(servers) do
        config.capabilities = capabilities
        config.on_attach = on_attach
        lspconfig[server].setup(config)
      end

      -- 特殊处理 clangd 扩展
      require('clangd_extensions').setup({
        server = servers.clangd,
        extensions = {
          inlay_hints = {
            inline = true,
            only_current_line = false,
            show_parameter_hints = true,
            parameter_hints_prefix = " ← ",
            other_hints_prefix = " → ",
          }
        }
      })

      -- 自动生成 compile_commands.json
      local function setup_compile_commands()
        local patterns = { '*.cpp', '*.h', '*.hpp', '*.c' }
        if not vim.tbl_contains(patterns, vim.fn.expand('%:t')) then return end
        
        if vim.fn.filereadable('compile_commands.json') == 0 then
          local commands = {
            { cmd = 'bear -- make -j8', name = 'bear' },
            { cmd = 'compiledb -n make', name = 'compiledb' },
            { cmd = 'cmake -DCMAKE_EXPORT_COMPILE_COMMANDS=1 .', name = 'cmake' }
          }
          
          for _, tool in ipairs(commands) do
            if vim.fn.executable(tool.name) == 1 then
              vim.notify("Generating compile_commands.json with "..tool.name, vim.log.levels.INFO)
              vim.fn.system(tool.cmd)
              break
            end
          end
        end
      end

      vim.api.nvim_create_autocmd({'VimEnter', 'DirChanged'}, {
        callback = setup_compile_commands,
        desc = "Generate compile_commands.json",
      })
    end
  }
}