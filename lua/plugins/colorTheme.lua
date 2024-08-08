return {
  -- "theniceboy/nvim-deus",
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   vim.cmd([[colorscheme deus]])
  -- end,

  {
    "craftzdog/solarized-osaka.nvim",
    lazy = false,
    priority = 1000,
    opts = {},
    config = function()
      vim.cmd [[colorscheme solarized-osaka]]
    end,
  }

  -- {
  --   "folke/tokyonight.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd [[colorscheme tokyonight]]
  --   end
  -- }
}
