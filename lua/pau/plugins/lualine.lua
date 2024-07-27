return {
	"nvim-lualine/lualine.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	event = { "BufWinEnter", "WinEnter" },
	config = function()
		local lualine = require("lualine")

		-- Custom mode names.
		local mode_map = {
			["COMMAND"] = "COMMND",
			["V-BLOCK"] = "V-BLCK",
			["TERMINAL"] = "TERMNL",
		}
		local function fmt_mode(s)
			return mode_map[s] or s
		end

		-- Get the current buffer's filetype.
		local function get_current_filetype()
			return vim.api.nvim_buf_get_option(0, "filetype")
		end

		-- Get the current buffer's type.
		local function get_current_buftype()
			return vim.api.nvim_buf_get_option(0, "buftype")
		end

		local function get_current_filename()
			local bufname = vim.api.nvim_buf_get_name(0)
			return bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or ""
		end

		local M = require("lualine.components.filetype"):extend()
		-- Icon_hl_cache = {}
		function M:get_current_filetype_icon()
			-- Get setup.
			local icon, icon_highlight_group
			local _, devicons = pcall(require, "nvim-web-devicons")
			local f_name, f_extension = vim.fn.expand("%:t"), vim.fn.expand("%:e")
			f_extension = f_extension ~= "" and f_extension or vim.bo.filetype
			icon, icon_highlight_group = devicons.get_icon(f_name, f_extension)

			-- Fallback settings.
			if icon == nil and icon_highlight_group == nil then
				icon = ""
				icon_highlight_group = "DevIconDefault"
			end

			-- Return the formatted string.
			return icon
		end

		function M:get_current_filename_with_icon()
			local suffix = ""

			-- Get icon and filename.
			local icon = M.get_current_filetype_icon(self)
			local f_name = get_current_filename()

			-- Add readonly icon.
			local readonly = vim.api.nvim_buf_get_option(0, "readonly")
			local modifiable = vim.api.nvim_buf_get_option(0, "modifiable")
			local nofile = get_current_buftype() == "nofile"
			if readonly or nofile or not modifiable then
				suffix = " "
			end

			-- Return the formatted string.
			return icon .. " " .. f_name .. suffix
		end

		local function parent_folder()
			local current_buffer = vim.api.nvim_get_current_buf()
			local current_file = vim.api.nvim_buf_get_name(current_buffer)
			local parent = vim.fn.fnamemodify(current_file, ":h:t")
			if parent == "." then
				return ""
			end
			return parent .. "/"
		end

		local Job = require("plenary.job")
		local function get_git_compare()
			-- Get the path of the current directory.
			local curr_dir = vim.api.nvim_buf_get_name(0):match("(.*" .. "/" .. ")")

			-- Run job to get git.
			local result = Job:new({
				command = "git",
				cwd = curr_dir,
				args = { "rev-list", "--left-right", "--count", "HEAD...@{upstream}" },
			})
				:sync(100)[1]

			-- Process the result.
			if type(result) ~= "string" then
				return ""
			end
			local ok, ahead, behind = pcall(string.match, result, "(%d+)%s*(%d+)")
			if not ok then
				return ""
			end

			-- No file, so no git.
			if get_current_buftype() == "nofile" then
				return ""
			end
			local string = ""
			if behind ~= "0" then
				string = string .. "󱦳" .. behind
			end
			if ahead ~= "0" then
				string = string .. "󱦲" .. ahead
			end
			return string
		end

		local function get_short_cwd()
			return vim.fn.fnamemodify(vim.fn.getcwd(), ":~")
		end
		local function get_native_lsp()
			local buf_ft = get_current_filetype()
			local clients = vim.lsp.get_active_clients()
			if next(clients) == nil then
				return ""
			end
			local current_clients = ""
			for _, client in ipairs(clients) do
				local filetypes = client.config.filetypes
				if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
					current_clients = current_clients .. client.name .. " "
				end
			end
			return current_clients
		end

		local tree = {
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = fmt_mode,
						icon = { "" },
						separator = { right = " ", left = "" },
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						get_short_cwd,
						padding = 0,
						icon = { "   " },
					},
				},
				lualine_x = {},
				lualine_y = {},

				lualine_z = {
					{
						"location",
						icon = { "", align = "left" },
					},
					{
						"progress",
						icon = { "", align = "left" },
						separator = { right = "", left = "" },
					},
				},
			},
			filetypes = { "NvimTree" },
		}

		local function telescope_text()
			return "Telescope"
		end

		local telescope = {
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = fmt_mode,
						icon = { "" },
						separator = { right = " ", left = "" },
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						telescope_text,
						icon = { "  " },
					},
				},
				lualine_x = {},
				lualine_y = {},
				lualine_z = {
					{
						"location",
						icon = { "", align = "left" },
					},
					{
						"progress",
						icon = { "", align = "left" },
						separator = { right = "", left = "" },
					},
				},
			},
			filetypes = { "TelescopePrompt" },
		}

		-- configure lualine with modified theme
		lualine.setup({
			options = {
				disabled_filetypes = { "dashboard" },
				globalstatus = true,
				section_separators = { left = "", right = "" },
				component_separators = { left = "", right = "" },
				theme = "auto",
				-- ... other configuration
				--   theme = "everforest", -- Can also be "auto" to detect automatically.
			},
			sections = {
				lualine_a = {
					{
						"mode",
						fmt = fmt_mode,
						icon = { "" },
						separator = { right = " ", left = "" },
					},
				},
				lualine_b = {},
				lualine_c = {
					{
						parent_folder,
						icon = { "   " },
						separator = "",
						padding = 0,
					},
					{
						get_current_filename,
						-- color = text_hl,
						separator = " ",
						padding = 0,
					},
					{
						"branch",
						icon = { "   " },
						separator = " ",
						padding = 0,
					},
					{
						get_git_compare,
						separator = " ",
						padding = 0,
					},
					{
						"diff",
						padding = 0,
						icon = { " " },
						symbols = { added = " ", modified = " ", removed = " " },
					},
				},
				lualine_x = {
					{
						"diagnostics",
						sources = { "nvim_diagnostic" },
						symbols = { error = " ", warn = " ", info = " ", hint = "󱤅 ", other = "󰠠 " },
						colored = true,
						padding = 2,
					},
					{
						get_native_lsp,
						padding = 1,
						-- color = text_hl,
						icon = { " " },
					},
				},
				lualine_y = {},
				lualine_z = {
					{
						"location",
						icon = { "", align = "left" },
					},
					{
						"progress",
						icon = { "", align = "left" },
						separator = { right = "", left = "" },
					},
				},
			},
			extensions = {
				telescope,
				["nvim-tree"] = tree,
			},
		})
	end,
}
