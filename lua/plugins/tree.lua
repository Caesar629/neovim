return {
  {
    "nvim-tree/nvim-tree.lua",
    version = "*", -- 自动使用最新稳定版
    dependencies = {
      "nvim-tree/nvim-web-devicons",
    },
    config = function()
      -- 先配置图标系统
      require("nvim-web-devicons").setup({
        override = {
          [".gitignore"] = { icon = "", color = "#f1502f", name = "GitIgnore" },
          ["package.json"] = { icon = "", color = "#e8274b", name = "PackageJson" },
        },
        default = true,
      })

      -- 正确的配置结构
      require("nvim-tree").setup({
        sort_by = "case_sensitive",
        view = {
          adaptive_size = true,
        },
        renderer = {
          group_empty = true,
          indent_markers = {
            enable = true,
            inline_arrows = true,
            icons = {
              corner = "└",
              edge = "│",
              none = " ",
            },
          },
          icons = {
            git_placement = "before",
            glyphs = {
              default = "",
              symlink = "",
              folder = {
                arrow_closed = "",
                arrow_open = "",
                default = "",
                open = "",
                empty = "",
                empty_open = "",
              },
            },
            show = {
              file = true,
              folder = true,
              folder_arrow = true,
              git = true,
            },
          },
          highlight_git = true,
        },
        filters = {
          dotfiles = false,
        },
      })
    end,
  }
}
