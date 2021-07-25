local _2afile_2a = "plugin/reflex.fnl"
local cmd = vim.api.nvim_command
local util = require("aniseed.nvim.util")
cmd("command! Delete lua require'reflex'['delete-buffer-and-file']()")
util["fn-bridge"]("MoveTo", "reflex", "move-to")
cmd("command! -nargs=1 -complete=file MoveTo call MoveTo(<f-args>)")
util["fn-bridge"]("CompleteRename", "reflex", "complete-rename")
util["fn-bridge"]("RenameTo", "reflex", "rename-to")
return cmd("command! -nargs=1 -complete=customlist,CompleteRename RenameTo call RenameTo(<f-args>)")