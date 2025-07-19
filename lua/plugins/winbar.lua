return {
  'Bekaboo/dropbar.nvim',
  -- optional, but required for fuzzy finder support
  dependencies = {
    'nvim-telescope/telescope-fzf-native.nvim'
  },
  config = function()
    require("dropbar").setup({
      highlights = {
        -- 直接链接到主题内置的高亮组
        path = { link = "Directory" },       -- 继承文件目录色
        symbol = { link = "Identifier" },    -- 继承标识符颜色
        separator = { link = "Comment" },    -- 继承注释色
        indicator = { link = "SpecialKey" }, -- 继承特殊键颜色
        -- 悬停菜单样式同步
        menu = {
          normal = { link = "NormalFloat" },
          border = { link = "FloatBorder" },
        }
      }
    })
  end
}
