return {
	"williamboman/mason.nvim",
	dependencies = {
		"williamboman/mason-lspconfig.nvim",
		"WhoIsSethDaniel/mason-tool-installer.nvim",
	},
	build = ":MasonUpdate",
	-- cmd = { "Mason", "MasonLog" },
	-- event = { "VeryLazy" },
	lazy = false,
	config = function()
		local mason = require("mason")
		local mason_lspconfig = require("mason-lspconfig")
		local mason_tool_installer = require("mason-tool-installer")
		mason.setup({
			ui = {
				icons = {
					package_installed = "✓",
					package_pending = "➜",
					package_uninstalled = "✗",
				},
			},
		})

		mason_lspconfig.setup({
			lazy = true,
			ensure_installed = {
				"tsserver",
				"html",
				"cssls",
				"tailwindcss",
				-- "svelte",
				"lua_ls",
				"clangd",
				"arduino_language_server",
				"rust_analyzer",
				"jdtls",
			},
		})

		mason_tool_installer.setup({
			lazy = true,
			ensure_installed = {
				"prettier",
				"stylua",
				"isort",
				"black",
				"clang-format",
			},
		})
	end,
}
