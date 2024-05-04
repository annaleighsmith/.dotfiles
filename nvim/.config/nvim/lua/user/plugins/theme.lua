local colors = {
	fg = "#C8D0E0",
	fg_light = "#E5E9F0",
	bg = "#2E3440",
	gray = "#646A76",
	light_gray = "#6C7A96",
	cyan = "#88C0D0",
	blue = "#81A1C1",
	dark_blue = "#5E81AC",
	green = "#A3BE8C",
	light_green = "#8FBCBB",
	dark_red = "#BF616A",
	red = "#D57780",
	light_red = "#DE878F",
	pink = "#E85B7A",
	dark_pink = "#E44675",
	orange = "#D08F70",
	yellow = "#EBCB8B",
	purple = "#B988B0",
	light_purple = "#B48EAD",
	none = "NONE",
	bg_light = "#434c5e",
}

return {
	"rmehri01/onenord.nvim",
	priority = 100,
	init = function()
		require("onenord").setup({
			custom_highlights = {
				RainbowDelimiterRed = { fg = colors.red },
				RainbowDelimiterOrange = { fg = colors.orange },
				RainbowDelimiterYellow = { fg = colors.yellow },
				RainbowDelimiterBlue = { fg = colors.blue },
				RainbowDelimiterGreen = { fg = colors.green },
				RainbowDelimiterCyan = { fg = colors.cyan },
				RainbowDelimiterViolet = { fg = colors.purple },

				WhichKey = { fg = colors.green, bold = true },
				WhichKeyGroup = { fg = colors.purple },
				WhichKeyDesc = { fg = colors.fg_light },
				WhichKeyFloat = { bg = colors.bg },
			},
		})
	end,
}
