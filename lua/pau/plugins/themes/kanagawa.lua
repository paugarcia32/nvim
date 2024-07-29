return {
	"rebelot/kanagawa.nvim",
	lazy = false,
	priority = 1000,
	config = function()
		-- require("kanagawa").load()
		local kanagawa = require("kanagawa")
		kanagawa.setup({
			colors = {
				theme = {
					all = {
						ui = {
							bg_gutter = "none",
						},
					},
				},
			},
		})
	end,
}
