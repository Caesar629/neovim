return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.6',
  dependencies = { 'nvim-lua/plenary.nvim' },
  config = function()
    -- 保留主题原有配色，只设置透明背景
    local function apply_transparent_hl()
      -- 获取当前主题的配色并只修改背景为透明
      local get_hl = function(name)
        local hl = vim.api.nvim_get_hl(0, { name = name, link = false })
        hl.bg = "none"  -- 保持其他属性不变，只设置背景透明
        return hl
      end

      local groups = {
        "TelescopeNormal", "TelescopeBorder", "TelescopePromptNormal", "TelescopePromptBorder",
        "TelescopeResultsNormal", "TelescopeResultsBorder", "TelescopePreviewNormal", "TelescopePreviewBorder",
        "TelescopeSelection", "TelescopeSelectionCaret", "TelescopeMatching", "TelescopeTitle"
      }

      for _, group in ipairs(groups) do
        local ok, hl = pcall(get_hl, group)
        if ok then
          vim.api.nvim_set_hl(0, group, hl)
        else
          -- 如果高亮组不存在，创建基本透明设置
          vim.api.nvim_set_hl(0, group, { bg = "none" })
        end
      end
    end

    -- 初始应用透明设置
    apply_transparent_hl()

    -- 主题变化时重新应用设置
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = apply_transparent_hl,
    })

    -- Telescope 基础配置
    local builtin = require 'telescope.builtin'
    local keymap = vim.keymap
    keymap.set('n', '<leader>f', builtin.find_files, {})
    keymap.set('n', '<leader>g', builtin.live_grep, {})

    require('telescope').setup({
      defaults = {
        dynamic_preview_title = true,
        wrap_results = true,
        winblend = 15,  -- 轻微透明效果
        border = true,
        layout_config = {
          width = 0.9,
          height = 0.85,
        },
        -- 保留主题原有的配色行为
        color_devicons = true,
        file_ignore_patterns = { "node_modules", ".git" },
      },
      pickers = {
        find_files = {
          theme = "dropdown",
        },
        live_grep = {
          theme = "ivy",
        },
      },
    })
  end
}