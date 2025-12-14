-- Main plugin entry
local M = {}

M.setup = function()
	-- Safe Tree-sitter setup
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

	-- FileType autocmd for VHDL buffers
	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vhdl",
		callback = function()
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			-- Tree-sitter active check
			local active = vim.treesitter and vim.treesitter.highlighter.active
			local hl_ok = active and active[vim.api.nvim_get_current_buf()] ~= nil

			if not hl_ok then
				-- Terminal fallback: matchadd
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
