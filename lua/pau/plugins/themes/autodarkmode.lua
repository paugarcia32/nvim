return {
	"f-person/auto-dark-mode.nvim",
	lazy = false,
	priority = 1000,
	config = {
		update_interval = 1000,
		set_dark_mode = function()
			vim.api.nvim_set_option("background", "dark")
			-- vim.cmd("colorscheme onenord")
			vim.cmd("colorscheme tokyonight-night")
			-- vim.cmd("colorscheme kanagawa-wave")
		end,
		set_light_mode = function()
			vim.api.nvim_set_option("background", "light")
			-- vim.cmd("colorscheme melange")
			vim.cmd("colorscheme tokyonight-day")
		end,
	},
}
