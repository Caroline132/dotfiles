local wk = require("which-key")
local setup = {
	preset = "helix",
}
wk.setup(setup)
require("which-key").add({
	{ "<localleader>d", group = "[D]iff" },
	{ "<leader>c", group = "[C]ode" },
	{ "<leader>d", group = "[D]ocument" },
	{ "<leader>g", group = "[G]it" },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>k", group = "[K]ustomize" },
	{ "<leader>r", group = "[R]ename" },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>t", group = "[T]oggle" },
	{ "<leader>w", group = "[W]orkspace" },
	-- register which-key VISUAL mode
	-- required for visual <leader>hs (hunk stage) to work
	{ "<leader>", group = "VISUAL <leader>", mode = "v" },
	{ "<leader>h", desc = "Git [H]unk", mode = "v" },
	{ "<leader>n", group = "[N]eotree" },
	{ "<localleader>g", group = "[D]iffview" },
	{ "<leader>b", group = "[B]ufferline" },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>o", group = "[O]bsidian" },
	{ "<localleader>c", group = "[C]omment box"},
	{ "<localleader>c", group = "[C]omment box", mode = "v" },
	{ "<localleader>r", group = "[K]ustomize", mode = "v" },
	{ "<localleader>p", group = "[P]omodoro" },
	{ "<localleader>a", group = "[A]I" },
	{ "<localleader>o", group = "[O]pencode" },
	{ "<leader>y", group = "[Y]aml" },
})
