return {
  'neovim/nvim-lspconfig',
  config = function()
    local lspconfig = require 'lspconfig'
    -- Setup language servers.
    lspconfig.lua_ls.setup {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' }
          }
        }
      }
    }
    lspconfig.clangd.setup {}
    lspconfig.cmake.setup {}
    lspconfig.bashls.setup {}

    vim.keymap.set('n', '<LEADER>=', vim.diagnostic.goto_next)
    vim.keymap.set('n', '<LEADER>-', vim.diagnostic.goto_prev)

    vim.api.nvim_create_autocmd('LspAttach', {
      group = vim.api.nvim_create_augroup('UserLspConfig', {}),
      callback = function(ev)
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'
        local opts = { buffer = ev.buf }
        --
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      end,
    })
  end,
}
