local M = {}

M.config = {
	save_dir = vim.fn.expand("$HOME/memos"),
	width = 150,
	height = 50,
}

M.memo = require("memo.memo")

function M.setup(opts)
	opts = opts or {}

	for k, v in pairs(opts) do
		M.config[k] = v
	end

	M.memo.default_save_dir = M.config.save_dir
	M.memo.width = M.config.width
	M.memo.height = M.config.height

	M.create_commands()
	return M
end

function M.create_commands()
	vim.api.nvim_create_user_command("MemoNew", function(opts)
		local filename = opts.args
		if filename and filename ~= "" then
			if vim.fn.fnamemodify(filename, ":p") ~= filename then
				filename = M.config.save_dir .. "/" .. filename
				if not string.match(filename, "%.[^/]+$") then
					filename = filename .. ".md"
				end
			end
		end
		M.memo.open_with_filename(filename)
	end, {
		nargs = "?",
		desc = "Create a new memo, optionally with specified filename"
	})

	vim.api.nvim_create_user_command("MemoOpen", function(opts)
		local filename = opts.args
		if filename and filename ~= "" then
			if vim.fn.fnamemodify(filename, ":p") ~= filename then
				filename = M.config.save_dir .. "/" .. filename
				if not string.match(filename, "%.[^/]+$") then
					filename = filename .. ".md"
				end
			end
			M.memo.open_with_filename(filename)
		else
			vim.api.nvim_err_writeln("Please specify a filename")
		end
	end, {
		nargs = 1,
		complete = function(ArgLead, CmdLine, CursorPos)
			local files = vim.fn.glob(M.config.save_dir .. "/*" .. ArgLead .. "*.md", false, true)
			local result = {}
			for _, file in ipairs(files) do
				table.insert(result, vim.fn.fnamemodify(file, ":t"))
			end
			return result
		end,
		desc = "Open an existing memo file"
	})
end

return M
