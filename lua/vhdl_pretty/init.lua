local M = {}

M.setup = function()
	-- Setup Tree-sitter highlights safely
	local ts_ok, ts = pcall(require, "nvim-treesitter.configs")
	if ts_ok then
		ts.setup({
			ensure_installed = { "vhdl" },
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
		})
	end

	-- FileType autocmd for VHDL
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vhdl",
		callback = function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			-- Check if Tree-sitter highlighter is attached
			local buf = vim.api.nvim_get_current_buf()
			local active = vim.treesitter and vim.treesitter.highlighter.active
			local hl_ok = active and active[buf] ~= nil

			if not hl_ok then
				-- Terminal fallback
				vim.fn.matchadd("Conceal", "<=", 10, -1, { conceal = "⇐" })
				vim.fn.matchadd("Conceal", ":=", 10, -1, { conceal = "≔" })
				vim.fn.matchadd("Conceal", "=>", 10, -1, { conceal = "⇒" })
				vim.fn.matchadd("Conceal", "<=", 10, -1, { conceal = "≤" })
				vim.fn.matchadd("Conceal", ">=", 10, -1, { conceal = "≥" })
				vim.fn.matchadd("Conceal", "/=", 10, -1, { conceal = "≠" })
			end
		end,
	})
end

return M
