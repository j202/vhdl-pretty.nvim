local M = {}

local function attach(bufnr)
	local winid = vim.fn.bufwinid(bufnr)
	if winid ~= -1 then
		vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local", win = winid })
		vim.api.nvim_set_option_value("concealcursor", "nc", { scope = "local", win = winid })
	end
	pcall(vim.treesitter.start, bufnr, "vhdl")
end

M.setup = function()
	-- vim.treesitter.query.get() caches its result forever once called. If
	-- anything else (e.g. a generic "autostart treesitter for any filetype"
	-- mechanism some configs run) queries vhdl highlights before this
	-- plugin's own after/ directory lands on 'runtimepath', that stale,
	-- conceal-less result stays cached for the rest of the session -
	-- restarting Neovim doesn't help, since the same race just repeats.
	-- Busting it here, now that this plugin is on 'runtimepath', forces a
	-- fresh compile that actually includes our query.
	pcall(function()
		vim.treesitter.query.get:clear("vhdl", "highlights")
	end)

	-- Ensure the vhdl parser is installed, on both the new ("main") and
	-- old ("master") nvim-treesitter APIs.
	local ok_new, nt = pcall(require, "nvim-treesitter")
	if ok_new and nt.install then
		pcall(nt.install, { "vhdl" })
	else
		local ok_old, configs = pcall(require, "nvim-treesitter.configs")
		if ok_old then
			configs.setup({ ensure_installed = { "vhdl" }, highlight = { enable = true } })
		end
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vhdl",
		callback = function(args)
			attach(args.buf)
		end,
	})

	-- When lazy-loaded on `ft = "vhdl"` (e.g. LazyVim), the FileType event
	-- for the buffer that triggered this setup() call has already fired,
	-- so the autocmd above will never see it. Attach to it directly too.
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].filetype == "vhdl" then
			attach(bufnr)
		end
	end
end

return M
