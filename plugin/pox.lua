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

	local winRow = vim.o.lines / 2 - 12 / 2
	local winCol = vim.o.columns / 2 - 45 / 2
	local mainOpts = {
		relative = "editor",
		width = 45,
		height = 12,
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
highlight poxTitle ctermfg=white ctermbg=darkblue guifg=white guibg=#000087
highlight poxBG ctermfg=NONE ctermbg=darkblue guifg=NONE guibg=#000087
highlight poxLightBG ctermfg=white ctermbg=lightblue guifg=white guibg=#0087ff
highlight poxCancel ctermfg=black ctermbg=gray guifg=black  guibg=gray
highlight poxStandBy ctermfg=white ctermbg=yellow guifg=white guibg=#d75f00
highlight poxTurnOff ctermfg=white ctermbg=red guifg=white guibg=#ff0000
highlight poxRestart ctermfg=white ctermbg=green guifg=white guibg=#00af00
highlight poxPushed ctermfg=white ctermbg=gray guifg=white guibg=#808080
]],
		false
	)

	api.nvim_buf_add_highlight(mainBuf, namespace, "poxTitle", 0, 0, -1)
	for i = 1, 10, 1 do
		api.nvim_buf_add_highlight(mainBuf, namespace, "poxLightBG", i, 0, -1)
	end
	api.nvim_buf_add_highlight(mainBuf, namespace, "poxBG", 11, 0, -1)
	api.nvim_buf_add_highlight(mainBuf, namespace, "poxCancel", 11, 35, 44)
	for i = 0, 5, 1 do
		api.nvim_buf_add_highlight(standByBuf, namespace, "poxStandBy", i, 0, -1)
	end

	for i = 0, 5, 1 do
		api.nvim_buf_add_highlight(turnOffBuf, namespace, "poxTurnOff", i, 0, -1)
	end

	for i = 0, 5, 1 do
		api.nvim_buf_add_highlight(restartBuf, namespace, "poxRestart", i, 0, -1)
	end

	api.nvim_set_current_win(mainWin)

	local function setTimeout(timeout, callback)
		local timer = vim.loop.new_timer()
		timer:start(timeout, 0, callback)
	end

	function PoxStandBy()
		for i = 0, 5, 1 do
			api.nvim_buf_add_highlight(standByBuf, namespace, "poxPushed", i, 0, -1)
		end
		os.execute("systemctl suspend")
		PoxCancel()
	end

	function PoxTurnOff()
		for i = 0, 5, 1 do
			api.nvim_buf_add_highlight(turnOffBuf, namespace, "poxPushed", i, 0, -1)
		end
		setTimeout(800, function()
			os.execute("systemctl poweroff")
		end)
	end

	function PoxRestart()
		for i = 0, 5, 1 do
			api.nvim_buf_add_highlight(restartBuf, namespace, "poxPushed", i, 0, -1)
		end
		setTimeout(800, function()
			os.execute("systemctl reboot")
		end)
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

