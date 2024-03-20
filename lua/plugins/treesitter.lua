return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require 'nvim-treesitter.configs'.setup {
        -- 添加不同语言
        ensure_installed =
        {
          "vim",
          "vimdoc",
          "bash",
          "c",
          "cpp",
          "json",
          "lua",
          "python",
        },
        -- one of "all" or a list of languages

        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}
