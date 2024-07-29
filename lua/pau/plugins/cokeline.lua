return {
	"willothy/nvim-cokeline",
	dependencies = {
		"nvim-lua/plenary.nvim", -- Required for v0.4.0+
		"nvim-tree/nvim-web-devicons", -- If you want devicons
		"stevearc/resession.nvim", -- Optional, for persistent history
	},
	event = { "VeryLazy" },

	config = function()
		local hlgroups = require("cokeline.hlgroups")
		local hl_attr = hlgroups.get_hl_attr
		require("cokeline").setup({
			show_if_buffers_are_at_least = 2,

			default_hl = {
				fg = function(buffer)
					return buffer.is_focused and hl_attr("Normal", "fg") or hl_attr("Comment", "fg")
				end,
				bg = hl_attr("ColorColumn", "bg"),
			},

			components = {
				{
					text = " ",
					bg = hl_attr("Normal", "bg"),
				},
				{
					text = "",
					fg = hl_attr("ColorColumn", "bg"),
					bg = hl_attr("Normal", "bg"),
				},
				{
					text = function(buffer)
						return buffer.devicon.icon
					end,
					fg = function(buffer)
						return buffer.devicon.color
					end,
				},
				{
					text = " ",
				},
				{
					text = function(buffer)
						return buffer.filename .. "  "
					end,
					style = function(buffer)
						return buffer.is_focused and "bold" or nil
					end,
				},
				{
					text = "",
					delete_buffer_on_left_click = true,
				},
				{
					text = "",
					fg = hl_attr("ColorColumn", "bg"),
					bg = hl_attr("Normal", "bg"),
				},
			},
		})

		-- local map = vim.api.nvim_set_keymap

		vim.keymap.set("n", "<S-Tab>", "<Plug>(cokeline-focus-prev)", { silent = true })
		vim.keymap.set("n", "<Tab>", "<Plug>(cokeline-focus-next)", { silent = true })
		vim.keymap.set("n", "<Leader>p", "<Plug>(cokeline-switch-prev)", { silent = true })
		vim.keymap.set("n", "<Leader>n", "<Plug>(cokeline-switch-next)", { silent = true })

		for i = 1, 9 do
			vim.keymap.set("n", ("<F%s>"):format(i), ("<Plug>(cokeline-focus-%s)"):format(i), { silent = true })
			vim.keymap.set("n", ("<Leader>%s"):format(i), ("<Plug>(cokeline-switch-%s)"):format(i), { silent = true })
		end
	end,
}
