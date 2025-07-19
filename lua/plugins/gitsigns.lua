-- lazy.nvim 示例
return {
  'lewis6991/gitsigns.nvim',
  event = { "BufReadPre", "BufNewFile" }, -- 延迟加载
  opts = { ... }                          -- 直接传入配置（见下文）
}
