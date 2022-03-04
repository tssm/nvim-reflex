local _2afile_2a = "plugin/reflex.fnl"
local _2amodule_name_2a = "init"
local _2amodule_2a
do
  package.loaded[_2amodule_name_2a] = {}
  _2amodule_2a = package.loaded[_2amodule_name_2a]
end
local _2amodule_locals_2a
do
  _2amodule_2a["aniseed/locals"] = {}
  _2amodule_locals_2a = (_2amodule_2a)["aniseed/locals"]
end
local util = require("reflex.aniseed.nvim.util")
do end (_2amodule_locals_2a)["util"] = util
local cmd = vim.api.nvim_command
_2amodule_locals_2a["cmd"] = cmd
util["fn-bridge"]("Delete", "reflex", "delete-buffer-and-file")
cmd("command! Delete call Delete(expand('%'))")
util["fn-bridge"]("MoveTo", "reflex", "move")
cmd("command! -nargs=1 -complete=file MoveTo call MoveTo(expand('%'), <f-args>)")
util["fn-bridge"]("CompleteRename", "reflex", "complete-rename")
util["fn-bridge"]("RenameTo", "reflex", "rename")
cmd("command! -nargs=1 -complete=customlist,CompleteRename RenameTo call RenameTo(expand('%'), <f-args>)")
if vim.g.reflex_delete_cmd then
  vim.api.nvim_echo({{"reflex_delete_cmd will be removed, use reflex_delete_file_cmd instead", "WarningMsg"}}, true, {})
  vim.g.reflex_delete_file_cmd = vim.g.reflex_delete_cmd
else
end
return _2amodule_2a