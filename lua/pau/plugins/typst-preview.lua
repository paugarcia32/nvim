return{
		"chomosuke/typst-preview.nvim",
		ft = "typst",
		-- dev= true,
		version = "0.1.*",
    build = function() require 'typst-preview'.update() end,
	}