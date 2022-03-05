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
local cmd = vim.api.nvim_command
_2amodule_locals_2a["cmd"] = cmd
cmd("augroup Reflex")
cmd("autocmd!")
cmd("autocmd BufReadPost * lua require'reflex'['set-up']()")
cmd("augroup END")
return _2amodule_2a