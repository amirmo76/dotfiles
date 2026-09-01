return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")
		harpoon:setup()

		local wk = require("which-key")
		wk.add({
			{ "<leader>h", group = "Harpoon" },
			{ "<leader>ha", function() harpoon:list():add() end, desc = "Add File" },
			{ "<leader>he", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end, desc = "Quick Menu" },
			{ "<leader>hp", function() harpoon:list():prev() end, desc = "Prev Mark" },
			{ "<leader>hn", function() harpoon:list():next() end, desc = "Next Mark" },
			{ "<M-h>", function() harpoon:list():select(1) end, desc = "Harpoon 1" },
			{ "<M-t>", function() harpoon:list():select(2) end, desc = "Harpoon 2" },
			{ "<M-n>", function() harpoon:list():select(3) end, desc = "Harpoon 3" },
			{ "<M-s>", function() harpoon:list():select(4) end, desc = "Harpoon 4" },
		})
	end,
}
