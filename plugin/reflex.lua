local _2afile_2a = "plugin/reflex.fnl"
local _1_
do
  local name_4_auto = "init"
  local module_5_auto
  do
    local x_6_auto = _G.package.loaded[name_4_auto]
    if ("table" == type(x_6_auto)) then
      module_5_auto = x_6_auto
    else
      module_5_auto = {}
    end
  end
  module_5_auto["aniseed/module"] = name_4_auto
  module_5_auto["aniseed/locals"] = ((module_5_auto)["aniseed/locals"] or {})
  do end (module_5_auto)["aniseed/local-fns"] = ((module_5_auto)["aniseed/local-fns"] or {})
  do end (_G.package.loaded)[name_4_auto] = module_5_auto
  _1_ = module_5_auto
end
local autoload
local function _3_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _3_
local function _6_(...)
  local ok_3f_21_auto, val_22_auto = nil, nil
  local function _5_()
    return {require("reflex.aniseed.nvim.util"), (_1_)["aniseed/locals"].cmd}
  end
  ok_3f_21_auto, val_22_auto = pcall(_5_)
  if ok_3f_21_auto then
    _1_["aniseed/local-fns"] = {require = {util = "reflex.aniseed.nvim.util"}}
    return val_22_auto
  else
    return print(val_22_auto)
  end
end
local _local_4_ = _6_(...)
local util = _local_4_[1]
local cmd = _local_4_[2]
local _2amodule_2a = _1_
local _2amodule_name_2a = "init"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local cmd0
do
  local v_23_auto = vim.api.nvim_command
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["cmd"] = v_23_auto
  cmd0 = v_23_auto
end
cmd0("command! Delete lua require'reflex'['delete-buffer-and-file']()")
util["fn-bridge"]("MoveTo", "reflex", "move-to")
cmd0("command! -nargs=1 -complete=file MoveTo call MoveTo(<f-args>)")
util["fn-bridge"]("CompleteRename", "reflex", "complete-rename")
util["fn-bridge"]("RenameTo", "reflex", "rename-to")
cmd0("command! -nargs=1 -complete=customlist,CompleteRename RenameTo call RenameTo(<f-args>)")
if vim.g.reflex_delete_cmd then
  vim.api.nvim_echo({{"reflex_delete_cmd will be removed, use reflex_delete_file_cmd instead", "WarningMsg"}}, true, {})
  vim.g.reflex_delete_file_cmd = vim.g.reflex_delete_cmd
  return nil
end