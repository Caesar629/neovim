return {
	-- "theniceboy/nvim-deus",
	-- lazy = false,
	-- priority = 1000,
	-- config = function()
	-- 	vim.cmd([[colorscheme deus]])
	-- end,

	-- {
	--   "sainnhe/sonokai",
	--   priority = 1000,
	--   config = function()
	--     vim.g.sonokai_transparent_background = "1"
	--     vim.g.sonokai_enable_italic = "1"
	--     vim.g.sonokai_style = "andromeda"
	--     vim.cmd.colorscheme("sonokai")
	--   end,
	-- },

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
	-- 	"folke/tokyonight.nvim",
	-- 	lazy = false,
	-- 	priority = 1000,
	-- 	opts = {},
	-- 	config = function()
	-- 		vim.cmd [[colorscheme tokyonight]]
	-- 	end
	-- }
}
