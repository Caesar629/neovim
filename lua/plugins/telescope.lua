return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    local builtin = require 'telescope.builtin'
    local keymap = vim.keymap
    keymap.set('n', '<leader>f', builtin.find_files, {})
    --安装ripgrep
    keymap.set('n', '<leader>g', builtin.live_grep, {})
  end,
}
