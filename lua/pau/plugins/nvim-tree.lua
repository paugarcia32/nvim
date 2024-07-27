return {
	"nvim-tree/nvim-tree.lua",
	dependencies = "nvim-tree/nvim-web-devicons",
	lazy = true,
	-- event = { "VeryLazy" },
	cmd = {
		"NvimTreeToggle",
		"NvimTreeOpen",
		"NvimTreeFindFile",
		"NvimTreeFindFileToggle",
		"NvimTreeRefresh",
	},
	config = function()
		local nvimtree = require("nvim-tree")

		-- recommended settings from nvim-tree documentation
		vim.g.loaded_netrw = 1
		vim.g.loaded_netrwPlugin = 1

		local function root_label(path)
			path = path:gsub("/home/Pau", " ")
			path = path:gsub("/Users/Pau", " ")
			path = path:gsub("/Usuarios/Pau", " ")
			path = path:gsub("C:\\Users\\Pau", " ")
			path = path:gsub("E:\\", " -> ")
			-- path = path:gsub("C:\Users\Pau", " ")
			path = path .. "/"
			local path_len = path:len()
			local win_nr = require("nvim-tree.view").get_winnr()
			print(win_nr)
			local win_width = vim.fn.winwidth(win_nr)
			if path_len > (win_width - 2) then
				local max_str = path:sub(path_len - win_width + 5)
				local pos = max_str:find("/")
				if pos then
					return "󰉒 " .. max_str:sub(pos)
				else
					return "󰉒 " .. max_str
				end
			end
			return path
		end

		local icons = {
			git_placement = "after",
			modified_placement = "after",
			padding = " ",
			glyphs = {
				default = "󰈔",
				folder = {
					arrow_closed = "",
					arrow_open = "",
					default = " ",
					open = " ",
					empty = " ",
					empty_open = " ",
					symlink = "󰉒 ",
					symlink_open = "󰉒 ",
				},
				git = {
					deleted = "",
					unstaged = "",
					untracked = "",
					staged = "",
					unmerged = "",
				},
			},
		}

		local renderer = {
			root_folder_label = root_label,
			indent_width = 2,
			indent_markers = {
				enable = true,
				inline_arrows = true,
				icons = { corner = "╰" },
			},
			icons = icons,
		}

		local system_open = { cmd = "zathura" }

		local view = {
			cursorline = false,
			signcolumn = "no",
			width = { max = 38, min = 38 },
		}

		nvimtree.setup({
			hijack_cursor = true,
			sync_root_with_cwd = true,
			view = view,
			system_open = system_open,
			renderer = renderer,
			git = { ignore = false },
			-- disable window_picker for
			-- explorer to work well with
			-- window splits
			actions = {
				open_file = {
					window_picker = {
						enable = false,
					},
				},
			},
			filters = {
				custom = { ".DS_Store" },
			},
		})

		-- set keymaps
		local keymap = vim.keymap -- for conciseness

		keymap.set("n", "<A-q>", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file explorer" }) -- toggle file explorer
		keymap.set(
			"n",
			"<leader>ef",
			"<cmd>NvimTreeFindFileToggle<CR>",
			{ desc = "Toggle file explorer on current file" }
		) -- toggle file explorer on current file
		keymap.set("n", "<leader>ec", "<cmd>NvimTreeCollapse<CR>", { desc = "Collapse file explorer" }) -- collapse file explorer
		keymap.set("n", "<leader>er", "<cmd>NvimTreeRefresh<CR>", { desc = "Refresh file explorer" }) -- refresh file explorer
	end,
}
