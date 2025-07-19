return {
  -- "theniceboy/nvim-deus",
  -- lazy = false,
  -- priority = 1000,
  -- config = function()
  --   vim.cmd([[colorscheme deus]])
  -- end,

  -- {
  --   "craftzdog/solarized-osaka.nvim",
  --   lazy = false,
  --   priority = 1000,
  --   opts = {},
  --   config = function()
  --     vim.cmd [[colorscheme solarized-osaka]]
  --   end,
  -- }

  'ayu-theme/ayu-vim',
  lazy = false,
  priority = 1000,
  init = function()
    -- 设置 ayu 全局变量
    vim.g.ayu_italic_comment = 1   -- 允许注释使用斜体
    vim.g.ayu_sign_contrast = 1    -- 增强符号对比度
    vim.g.ayu_extended_palette = 1 -- 启用扩展调色板

    -- 可选：指定颜色变体（dark/mirage/light）
    vim.g.ayucolor = 'mirage'
  end,
  config = function()
    vim.cmd('colorscheme ayu') -- 应用主题
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "NoicePopup", { bg = "none" })
    vim.api.nvim_set_hl(0, "NoicePopupBorder", { bg = "none" })
  end
}
