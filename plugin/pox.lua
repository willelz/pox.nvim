local api = vim.api

vim.g.pox_stand_by_key = vim.g.pox_stand_by_key or "j"
vim.g.pox_turn_off_key = vim.g.pox_turn_off_key or "k"
vim.g.pox_restart_key = vim.g.pox_restart_key or "l"

local standByKey = string.upper(vim.g.pox_stand_by_key)
local turnOffKey = string.upper(vim.g.pox_turn_off_key)
local restartKey = string.upper(vim.g.pox_restart_key)

function Pox()
	local mainBuf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(mainBuf, 0, -1, true, {
		"Turn off compuer                             ",
		"                                             ",
		"                                             ",
		"                                             ",
		"                                             ",
		"                                             ",
		"                                             ",
		"                                             ",
		"  Stand By(" .. standByKey .. ")    Turn Off(" .. turnOffKey .. ")    Restart(" .. restartKey .. ")   ",
		"                                             ",
		"                                   Cancel(Q) ",
	})

	local standByBuf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(standByBuf, 0, -1, true, {
		"  _|_  ",
		" / | \\ ",
		"|  |  |",
		"|     |",
		" \\___/ ",
	})

	local turnOffBuf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(turnOffBuf, 0, -1, true, {
		"  ___  ",
		" /   \\ ",
		"|  |  |",
		"|  |  |",
		" \\___/ ",
	})

	local restartBuf = api.nvim_create_buf(false, true)
	api.nvim_buf_set_lines(restartBuf, 0, -1, true, {
		" \\  |  / ",
		"  \\ | /  ",
		"---   ---",
		"  / | \\  ",
		" /  |  \\ ",
	})

	local winRow = vim.o.lines / 2 - 11 / 2
	local winCol = vim.o.columns / 2 - 45 / 2
	local mainOpts = {
		relative = "editor",
		width = 45,
		height = 11,
		row = winRow,
		col = winCol,
		zindex = 300,
		style = "minimal",
	}

	local standByOpts = {
		relative = "editor",
		width = 7,
		height = 5,
		row = winRow + 2,
		col = winCol + 4,
		focusable = false,
		zindex = 320,
		style = "minimal",
	}

	local turnoffOpts = {
		relative = "editor",
		width = 7,
		height = 5,
		row = winRow + 2,
		col = winCol + 19,
		focusable = false,
		zindex = 320,
		style = "minimal",
	}

	local restartOpts = {
		relative = "editor",
		width = 9,
		height = 5,
		row = winRow + 2,
		col = winCol + 33,
		focusable = false,
		zindex = 320,
		style = "minimal",
	}

	local mainWin = api.nvim_open_win(mainBuf, 1, mainOpts)
	local standByWin = api.nvim_open_win(standByBuf, 0, standByOpts)
	local turnOffWin = api.nvim_open_win(turnOffBuf, 0, turnoffOpts)
	local restartWin = api.nvim_open_win(restartBuf, 0, restartOpts)

	local namespace = api.nvim_create_namespace("pox")
	api.nvim_exec(
		[[
highlight PoxTitle ctermfg=white ctermbg=darkblue guifg=white guibg=#000087
highlight PoxBG ctermfg=NONE ctermbg=darkblue guifg=NONE guibg=#000087
highlight PoxLightBG ctermfg=white ctermbg=lightblue guifg=white guibg=#0087ff
highlight PoxCancel ctermfg=black ctermbg=gray guifg=black  guibg=gray
highlight PoxStandBy ctermfg=white ctermbg=yellow guifg=white guibg=#d75f00
highlight PoxTurnOff ctermfg=white ctermbg=red guifg=white guibg=#ff0000
highlight PoxRestart ctermfg=white ctermbg=green guifg=white guibg=#00af00
highlight PoxPushed ctermfg=white ctermbg=gray guifg=white guibg=#808080
]],
		false
	)

	api.nvim_buf_add_highlight(mainBuf, namespace, "PoxTitle", 0, 0, -1)
	vim.highlight.range(mainBuf, namespace, "PoxLightBG", { 1, 0 }, { 9, 45 })
	api.nvim_buf_add_highlight(mainBuf, namespace, "PoxBG", 10, 0, -1)
	api.nvim_buf_add_highlight(mainBuf, namespace, "PoxCancel", 10, 35, 44)
	vim.highlight.range(standByBuf, namespace, "PoxStandBy", { 0, 0 }, { 5, 7 })
	vim.highlight.range(turnOffBuf, namespace, "PoxTurnOff", { 0, 0 }, { 5, 7 })
	vim.highlight.range(restartBuf, namespace, "PoxRestart", { 0, 0 }, { 5, 9 })

	api.nvim_set_current_win(mainWin)

	function PoxStandBy()
		vim.highlight.range(standByBuf, namespace, "PoxPushed", { 0, 0 }, { 5, 7 })
		vim.defer_fn(function()
			os.execute("systemctl suspend")
			PoxCancel()
		end, 500)
	end

	function PoxTurnOff()
		vim.highlight.range(turnOffBuf, namespace, "PoxPushed", { 0, 0 }, { 5, 7 })
		vim.defer_fn(function()
			os.execute("systemctl poweroff")
		end, 800)
	end

	function PoxRestart()
		vim.highlight.range(restartBuf, namespace, "PoxPushed", { 0, 0 }, { 5, 9 })
		vim.defer_fn(function()
			os.execute("systemctl reboot")
		end, 800)
	end

	function PoxCancel()
		api.nvim_win_close(mainWin, true)
		api.nvim_win_close(standByWin, true)
		api.nvim_win_close(turnOffWin, true)
		api.nvim_win_close(restartWin, true)
	end

	api.nvim_buf_set_keymap(
		mainBuf,
		"n",
		vim.g.pox_stand_by_key,
		"<cmd>call v:lua.PoxStandBy()<CR>",
		{ noremap = true }
	)
	api.nvim_buf_set_keymap(
		mainBuf,
		"n",
		vim.g.pox_turn_off_key,
		"<cmd>call v:lua.PoxTurnOff()<CR>",
		{ noremap = true }
	)
	api.nvim_buf_set_keymap(mainBuf, "n", vim.g.pox_restart_key, "<cmd>call v:lua.PoxRestart()<CR>", { noremap = true })
	api.nvim_buf_set_keymap(mainBuf, "n", "<Esc>", "<cmd>call v:lua.PoxCancel()<CR>", { noremap = true })
	api.nvim_buf_set_keymap(mainBuf, "n", "q", "<cmd>call v:lua.PoxCancel()<CR>", { noremap = true })
end

vim.cmd([[command! Pox call v:lua.Pox()]])

