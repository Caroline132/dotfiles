local wk = require("which-key")
local setup = {
	preset = "helix",
}
wk.setup(setup)
require("which-key").add({
	{ "<localleader>d", group = "[D]iff" },
	{ "<localleader>d_", hidden = true },
	{ "<leader>c", group = "[C]ode" },
	{ "<leader>c_", hidden = true },
	{ "<leader>d", group = "[D]ocument" },
	{ "<leader>d_", hidden = true },
	{ "<leader>g", group = "[G]it" },
	{ "<leader>g_", hidden = true },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>h_", hidden = true },
	{ "<leader>r", group = "[R]ename" },
	{ "<leader>r_", hidden = true },
	{ "<leader>s", group = "[S]earch" },
	{ "<leader>s_", hidden = true },
	{ "<leader>t", group = "[T]oggle" },
	{ "<leader>t_", hidden = true },
	{ "<leader>w", group = "[W]orkspace" },
	{ "<leader>w_", hidden = true },
	-- register which-key VISUAL mode
	-- required for visual <leader>hs (hunk stage) to work
	{ "<leader>", group = "VISUAL <leader>", mode = "v" },
	{ "<leader>h", desc = "Git [H]unk", mode = "v" },
	{ "<leader>n", group = "[N]eotree" },
	{ "<leader>n_", hidden = true },
	{ "<localleader>g", group = "[D]iffview" },
	{ "<localleader>g_", hidden = true },
	{ "<leader>b", group = "[B]ufferline" },
	{ "<leader>b_", hidden = true },
	{ "<leader>h", group = "Git [H]unk" },
	{ "<leader>h_", hidden = true },
	{ "<leader>o", group = "[O]bsidian" },
	{ "<leader>o_", hidden = true },
	{ "<localleader>c", group = "[C]omment box", mode = "v" },
	{ "<localleader>c_", hidden = true, mode = "v" },
	{ "<localleader>r", group = "[K]ustomize", mode = "v" },
	{ "<localleader>r_", hidden = true, mode = "v" },
})
