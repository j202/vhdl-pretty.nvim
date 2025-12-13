local M = {}

function M.setup()
	-- Enable conceal globally (safe defaults)
	vim.opt.conceallevel = vim.opt.conceallevel:get() > 0 and vim.opt.conceallevel or 2
	vim.opt.concealcursor = vim.opt.concealcursor:get() ~= "" and vim.opt.concealcursor or "nc"

	-- Define highlight groups (user can override)
	local hl = vim.api.nvim_set_hl
	hl(0, "@vhdl.assign.signal", { bold = true })
	hl(0, "@vhdl.assign.variable", { bold = true })
	hl(0, "@vhdl.assoc", { bold = true })
	hl(0, "@vhdl.compare", { bold = true })

	-- Neovim 0.11+ needs explicit Tree-sitter start
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vhdl",
		callback = function()
			if vim.treesitter and vim.treesitter.start then
				pcall(vim.treesitter.start, 0, "vhdl")
			end
		end,
	})
end

return M
