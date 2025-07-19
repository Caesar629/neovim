return {
  "folke/noice.nvim",
  event = "VeryLazy",
  opts = function()
    -- noice.nvim 的透明背景配置
    require("noice").setup({
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
      views = {
        cmdline_popup = {
          win_options = {
            winblend = 10,  -- 设置窗口混合效果
          },
        },
      },
    })

    -- 设置 noice 相关高亮组透明
    vim.api.nvim_set_hl(0, "NoicePopup", { bg = "none" })
    vim.api.nvim_set_hl(0, "NoicePopupBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopup", { bg = "none" })
    vim.api.nvim_set_hl(0, "NoiceCmdlinePopupBorder", { bg = "none" })
  end,
  dependencies = {
    "MunifTanjim/nui.nvim",
    {
      "rcarriga/nvim-notify",
      config = function()
        -- nvim-notify 的透明背景配置
        require("notify").setup({
          background_colour = "#00000000",  -- 完全透明
          stages = "fade",                 -- 使用淡入淡出动画
          timeout = 3000,
          render = "minimal",
        })

        -- 设置所有通知相关的高亮组为透明
        local notify_hlgroups = {
          "NotifyBackground",
          "NotifyINFOBorder", "NotifyINFOTitle", "NotifyINFOIcon", "NotifyINFOBody",
          "NotifyWARNBorder", "NotifyWARNTitle", "NotifyWARNIcon", "NotifyWARNBody",
          "NotifyERRORBorder", "NotifyERRORTitle", "NotifyERRORIcon", "NotifyERRORBody",
          "NotifyDEBUGBorder", "NotifyDEBUGTitle", "NotifyDEBUGIcon", "NotifyDEBUGBody",
          "NotifyTRACEBorder", "NotifyTRACETitle", "NotifyTRACEIcon", "NotifyTRACEBody",
        }

        for _, hl in ipairs(notify_hlgroups) do
          vim.api.nvim_set_hl(0, hl, { bg = "none" })
        end
      end
    },
  },
  config = function(_, opts)
    -- 基础透明设置（适用于所有窗口）
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    
    -- 应用 noice 配置
    require("noice").setup(opts)
  end
}
