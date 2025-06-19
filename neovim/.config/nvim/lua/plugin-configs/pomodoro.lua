require("pomodoro").setup({
	start_at_launch = false,
	work_duration = 25,
	break_duration = 5,
	delay_duration = 1,
	long_break_duration = 15,
	breaks_before_long = 3,
})

vim.keymap.set("n", "<localleader>ps", "<cmd>PomodoroStart<cr>", { desc = "Start Pomodoro" })
vim.keymap.set("n", "<localleader>px", "<cmd>PomodoroStop<cr>", { desc = "Stop Pomodoro" })
vim.keymap.set("n", "<localleader>pu", "<cmd>PomodoroUI<cr>", { desc = "Pomodoro UI" })
vim.keymap.set("n", "<localleader>pl", "<cmd>PomodoroSkipBreak<cr>", { desc = "Skip Break" })
vim.keymap.set("n", "<localleader>pt", "<cmd>PomodoroForceBreak<cr>", { desc = "Force Break" })
vim.keymap.set("n", "<localleader>pd", "<cmd>PomodoroDelayBreak<cr>", { desc = "Delay Break" })

