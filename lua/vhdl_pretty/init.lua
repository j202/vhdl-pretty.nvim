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
			-- Buffer-local conceal options
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			-- Defer execution slightly to ensure buffer/window is ready
			vim.defer_fn(function()
				if vim.fn.has("gui_running") == 1 then
				-- GUI: Tree-sitter conceal applies automatically from highlights.scm
				else
					-- Terminal fallback using matchadd()
					vim.fn.matchadd("Conceal", "<=", 10, -1, { conceal = "⇐" })
					vim.fn.matchadd("Conceal", ":=", 10, -1, { conceal = "≔" })
					vim.fn.matchadd("Conceal", "=>", 10, -1, { conceal = "⇒" })
					vim.fn.matchadd("Conceal", "<=", 10, -1, { conceal = "≤" })
					vim.fn.matchadd("Conceal", ">=", 10, -1, { conceal = "≥" })
					vim.fn.matchadd("Conceal", "/=", 10, -1, { conceal = "≠" })
				end
			end, 50) -- 50ms delay
		end,
	})
end

return M
