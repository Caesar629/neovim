return
{
  "folke/neodev.nvim",
  opts = {
    library = {
      plugins = { "nvim-treesitter", "plenary.nvim" }, -- 可选：指定需要补全的插件
      types = true,                                    -- 启用类型检查
      runtime = true,                                  -- 启用运行时 API 补全
    },
  },

  -- 覆盖根目录检测（适用于符号链接或非标准路径）
  override = function(root_dir, library)
    if root_dir:find("nvim") then
      library.enabled = true
    end
  end,
}
