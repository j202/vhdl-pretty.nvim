local M = {}

M.setup = function()
	-- Ensure Tree-sitter configs are loaded
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
			-- Buffer-local conceal options
			vim.opt_local.conceallevel = 2
			vim.opt_local.concealcursor = "nc"

			-- Ensure Tree-sitter highlighter attaches
			local ok, hl = pcall(require, "vim.treesitter.highlighter")
			if ok then
				-- Attach highlighter for this buffer
				hl.new(0, "vhdl")
			end
		end,
	})
end

return M
