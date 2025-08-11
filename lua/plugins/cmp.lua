return {
  {
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- 补全源
      'hrsh7th/cmp-buffer',
      'hrsh7th/cmp-path',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-cmdline',

      -- 代码片段
      'L3MON4D3/LuaSnip',
      'saadparwaiz1/cmp_luasnip',

      -- 图标美化
      'onsails/lspkind.nvim',

      -- UI 增强
      'lukas-reineke/cmp-under-comparator', -- 智能排序
    },
    config = function()
      local cmp = require('cmp')
      local lspkind = require('lspkind')
      local luasnip = require('luasnip')

      -- 自定义图标样式
      local kind_icons = {
        Text = "",
        Method = "",
        Function = "",
        Constructor = "",
        Field = "",
        Variable = "",
        Class = "",
        Interface = "",
        Module = "",
        Property = "",
        Unit = "",
        Value = "",
        Enum = "",
        Keyword = "",
        Snippet = "",
        Color = "",
        File = "",
        Reference = "",
        Folder = "",
        EnumMember = "",
        Constant = "",
        Struct = "",
        Event = "",
        Operator = "",
        TypeParameter = "",
      }

      -- 补全菜单边框样式
      local border_opts = {
        border = "single", -- 可选: "single", "double", "rounded", "shadow", "none"
        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
      }

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        window = {
          completion = border_opts,
          documentation = border_opts,
        },
        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "...",
            symbol_map = kind_icons, -- 注入自定义图标
            menu = {
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[Snip]",
              nvim_lua = "[Lua]",
              path = "[Path]",
              cmdline = "[Cmd]",
            },
            -- before = function(entry, vim_item)
            --   -- 优先级调整（LSP 结果置顶）
            --   vim_item.priority = cmp.get_score(entry)
            --   return vim_item
            -- end,
          }),
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<C-Space>'] = cmp.mapping.complete(),
          ['<C-e>'] = cmp.mapping.abort(),
          ['<CR>'] = cmp.mapping.confirm({ select = true }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          ['<S-Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { 'i', 's' }),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 1000 },
          { name = 'luasnip',  priority = 750 },
          { name = 'buffer',   priority = 500 },
          { name = 'path',     priority = 250 },
        }),
        experimental = {
          ghost_text = {
            hl_group = "Comment", -- 半透明预览文本
          },
        },
      })

      -- 增强排序（更智能的补全项排序）
      cmp.setup.filetype({ "markdown", "help" }, {
        sources = cmp.config.sources({
          { name = "buffer" },
        })
      })
    end
  }
}
