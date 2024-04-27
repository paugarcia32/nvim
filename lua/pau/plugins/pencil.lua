return {
	"preservim/vim-pencil",
	ft = { "markdown" },
	init = function()
		vim.g["pencil#wrapModeDefault"] = "soft"
	end,
}
