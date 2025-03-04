local M = {}

M.current_buf = nil
M.current_win = nil

function M.create_window(buf, title)
	local col = math.floor((vim.o.columns - M.width) / 2)
	local row = math.floor((vim.o.lines - M.height) / 2)

	if not title then
		title = "Memo"
	end

	local win = vim.api.nvim_open_win(buf, true, {
		relative = "editor",
		title = title,
		width = M.width,
		height = M.height,
		col = col,
		row = row,
		style = "minimal",
		border = "single",
	})
	if not win then
		vim.api.nvim_err_writeln("Failed to create window")
		return nil, nil
	end

	return win
end

function M.open(title)
	local buf = vim.api.nvim_create_buf(false, true)
	if not buf then
		vim.api.nvim_err_writeln("Failed to create buffer")
		return nil, nil
	end

	local win = M.create_window(buf, title)

	M.current_buf = buf
	M.current_win = win

	vim.api.nvim_buf_set_option(buf, 'filetype', 'markdown')
	vim.api.nvim_buf_set_option(buf, 'buftype', '')

	return buf, win
end

function M.open_with_filename(filename)
	local existing_buf = nil
	for _, buf in ipairs(vim.api.nvim_list_bufs()) do
		local buf_name = vim.api.nvim_buf_get_name(buf)
		if buf_name == filename then
			existing_buf = buf
			break
		end
	end

	if existing_buf and vim.api.nvim_buf_is_valid(existing_buf) then
		local existing_win = nil
		for _, win in ipairs(vim.api.nvim_list_wins()) do
			if vim.api.nvim_win_get_buf(win) == existing_buf then
				existing_win = win
				break
			end
		end

		if existing_win and vim.api.nvim_win_is_valid(existing_win) then
			vim.api.nvim_set_current_win(existing_win)
			return existing_buf, existing_win
		else
			local win = M.create_window(existing_buf)

			M.current_buf = existing_buf
			M.current_win = win

			return existing_buf, win
		end
	end

	local file_exists = false
	if filename ~= "" and filename ~= nil then
		file_exists = vim.fn.filereadable(filename) == 1
	end

	if filename == "" then
		if vim.fn.isdirectory(M.default_save_dir) == 0 then
			vim.fn.mkdir(M.default_save_dir, "p")
		end
		filename = M.default_save_dir .. "/" .. os.date("%Y%m%d_%H%M%S") .. ".md"
	end

	local buf, win = M.open(filename)
	if not buf or not win then
		vim.api.nvim_err_writeln("Failed to open memo window")
		return nil, nil
	end
	if not vim.api.nvim_buf_is_valid(buf) then
		vim.api.nvim_err_writeln("Invalid buffer")
		return nil, nil
	end

	if file_exists then
		local lines = {}
		for line in io.lines(filename) do
			table.insert(lines, line)
		end
		if #lines > 0 then
			vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
		end
		vim.api.nvim_buf_set_option(buf, 'modified', false)
	end

	vim.api.nvim_buf_set_name(buf, filename)

	if vim.fn.filereadable(filename) == 1 then
		vim.api.nvim_buf_call(buf, function()
			vim.cmd('silent! edit ' .. vim.fn.fnameescape(filename))
		end)
	end

	return buf, win
end

return M
