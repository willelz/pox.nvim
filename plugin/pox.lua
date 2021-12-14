local api = vim.api
local mainBuf = api.nvim_create_buf(false, true)
api.nvim_buf_set_lines(
	mainBuf,
	0,
	-1,
	true,
	{ "Turn off compuer", "", "", "", "", "", "", "", "", "", "", "                                    Cancel(C)" }
)

local winRow = api.nvim_get_option("lines") / 2 - 12 / 2
local winCol = api.nvim_get_option("columns") / 2 - 45 / 2
local mainOpts = {
	relative = "editor",
	width = 45,
	height = 12,
	row = winRow,
	col = winCol,
	style = "minimal",
}

local mainWin = api.nvim_open_win(mainBuf, 1, mainOpts)

api.nvim_set_current_win(mainWin)

