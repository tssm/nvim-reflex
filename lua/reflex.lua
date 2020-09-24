local _0_0 = nil
do
  local name_0_ = "reflex"
  local loaded_0_ = package.loaded[name_0_]
  local module_0_ = nil
  if ("table" == type(loaded_0_)) then
    module_0_ = loaded_0_
  else
    module_0_ = {}
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = (module_0_["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = (module_0_["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _2_(...)
  _0_0["aniseed/local-fns"] = {}
  return {}
end
local _1_ = _2_(...)
do local _ = ({nil, _0_0, {{}, nil}})[2] end
local api = nil
do
  local v_0_ = vim.api
  _0_0["aniseed/locals"]["api"] = v_0_
  api = v_0_
end
local call = nil
do
  local v_0_ = api.nvim_call_function
  _0_0["aniseed/locals"]["call"] = v_0_
  call = v_0_
end
local cmd = nil
do
  local v_0_ = api.nvim_command
  _0_0["aniseed/locals"]["cmd"] = v_0_
  cmd = v_0_
end
local mkdir_if_needed = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function mkdir_if_needed0()
      local path_head = call("expand", {"%:h"})
      if ((call("isdirectory", {path_head}) == 0) and (call("confirm", {(path_head .. " doesn't exist. Create it?")}) == 1)) then
        local success, e = nil, nil
        local function _3_()
          return call("mkdir", {path_head, "p"})
        end
        success, e = pcall(_3_)
        if not success then
          cmd("echohl ErrorMsg")
          cmd(("echo \"" .. e .. "\n\n\""))
          return cmd("echohl None")
        end
      end
    end
    v_0_0 = mkdir_if_needed0
    _0_0["mkdir-if-needed"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["mkdir-if-needed"] = v_0_
  mkdir_if_needed = v_0_
end
cmd("augroup MkdirIfNeeded")
cmd("autocmd!")
cmd("autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
return cmd("augroup END")