local M = {}

local FONT_FILE = "VhdlPrettyArrow.ttf"
local root = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h:h:h")

M.opts = { font = nil }

local function font_dir()
	if vim.fn.has("mac") == 1 then
		return vim.fn.expand("~/Library/Fonts")
	end
	return (vim.env.XDG_DATA_HOME or vim.fn.expand("~/.local/share")) .. "/fonts"
end

local function font_path()
	return font_dir() .. "/" .. FONT_FILE
end

local function font_built()
	return vim.uv.fs_stat(font_path()) ~= nil
end

local function attach(bufnr)
	local winid = vim.fn.bufwinid(bufnr)
	if winid ~= -1 then
		vim.api.nvim_set_option_value("conceallevel", 2, { scope = "local", win = winid })
		vim.api.nvim_set_option_value("concealcursor", "nc", { scope = "local", win = winid })
	end
	pcall(vim.treesitter.start, bufnr, "vhdl")
end

-- query.get() memoizes, and an after/ query only extends the base query if
-- it is on 'runtimepath' first, so build the combined query ourselves.
local function set_query()
	local parts = {}
	for _, file in ipairs(vim.treesitter.query.get_files("vhdl", "highlights")) do
		parts[#parts + 1] = table.concat(vim.fn.readfile(file), "\n")
	end
	parts[#parts + 1] = table.concat(vim.fn.readfile(root .. "/queries_extra/vhdl/signal_arrow.scm"), "\n")
	vim.treesitter.query.set("vhdl", "highlights", table.concat(parts, "\n"))
end

local function apply()
	set_query()
	for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
		if vim.bo[bufnr].filetype == "vhdl" then
			attach(bufnr)
		end
	end
end

local function resolve_font()
	local f = M.opts.font
	if not f then
		return nil, 'set `font` in setup(), e.g. setup({ font = "JetBrainsMono Nerd Font Mono" })'
	end
	if vim.uv.fs_stat(vim.fn.expand(f)) then
		return vim.fn.expand(f)
	end
	local path = vim.fn.system({ "fc-match", "-f", "%{file}", f .. ":style=Regular" })
	if vim.v.shell_error ~= 0 or path == "" then
		return nil, "fc-match could not find a font named " .. f
	end
	return path
end

local function python_cmd(args)
	local script = root .. "/scripts/build_font.py"
	local py = { "python3", script, unpack(args) }
	local probe = vim.fn.system({ "python3", "-c", "import fontTools, uharfbuzz" })
	if vim.v.shell_error == 0 then
		return py
	end
	if vim.fn.executable("nix-shell") == 1 then
		local quoted = table.concat(vim.tbl_map(vim.fn.shellescape, vim.list_slice(py, 1)), " ")
		return {
			"nix-shell", "-p", "python3.withPackages (ps: [ ps.fonttools ps.uharfbuzz ])",
			"--run", quoted,
		}
	end
	return nil
end

function M.build_font()
	local src, err = resolve_font()
	if not src then
		return vim.notify("vhdl-pretty: " .. err, vim.log.levels.ERROR)
	end
	vim.fn.mkdir(font_dir(), "p")
	local cmd = python_cmd({ "--font", src, "--out", font_path(), "--family", "VhdlPrettyArrow" })
	if not cmd then
		return vim.notify(
			"vhdl-pretty: needs python3 with fonttools and uharfbuzz: pip install fonttools uharfbuzz",
			vim.log.levels.ERROR
		)
	end
	local out = vim.fn.system(cmd)
	if vim.v.shell_error ~= 0 then
		pcall(vim.uv.fs_unlink, font_path())
		return vim.notify("vhdl-pretty: font build failed:\n" .. out, vim.log.levels.ERROR)
	end
	vim.fn.system({ "fc-cache", "-f", font_dir() })
	vim.notify("vhdl-pretty: built " .. font_path() .. " from " .. src
		.. "\nRestart your terminal if the arrow does not appear.")
	apply()
end

M.setup = function(opts)
	M.opts = vim.tbl_extend("force", M.opts, opts or {})

	vim.api.nvim_create_user_command("VhdlPrettyBuildFont", M.build_font, {})

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

	-- Do nothing until the arrow font exists: without it the plain query
	-- would be the worse look, not a fallback.
	if not font_built() then
		vim.notify_once("vhdl-pretty: run :VhdlPrettyBuildFont once to enable the signal-assignment arrow")
		return
	end

	vim.api.nvim_create_autocmd("FileType", {
		pattern = "vhdl",
		callback = function(args)
			attach(args.buf)
		end,
	})

	-- When lazy-loaded on `ft = "vhdl"`, the FileType event for the buffer
	-- that triggered setup() has already fired; apply() attaches to it.
	apply()
end

return M
