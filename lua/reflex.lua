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
  _0_0["aniseed/local-fns"] = {require = {util = "aniseed.nvim.util"}}
  return {require("aniseed.nvim.util")}
end
local _1_ = _2_(...)
local util = _1_[1]
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
local show_error = nil
do
  local v_0_ = nil
  local function show_error0(e)
    cmd("echohl ErrorMsg")
    cmd(("echo \"" .. e .. "\n\""))
    return cmd("echohl None")
  end
  v_0_ = show_error0
  _0_0["aniseed/locals"]["show-error"] = v_0_
  show_error = v_0_
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
          return show_error((e .. "\n"))
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
cmd("augroup END")
local delete_buffer_and_file = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function delete_buffer_and_file0()
      local buffer_name = call("expand", {"%"})
      if ((call("getbufvar", {buffer_name, "&mod"}) == 0) or (call("confirm", {"There are unsaved changes. Delete anyway?"}) == 1)) then
        if (call("glob", {buffer_name}) ~= "") then
          if (call("delete", {buffer_name}) == 0) then
            return cmd(("bwipeout! " .. buffer_name))
          else
            return show_error("Can't delete asociated file")
          end
        else
          return cmd(("bwipeout! " .. buffer_name))
        end
      end
    end
    v_0_0 = delete_buffer_and_file0
    _0_0["delete-buffer-and-file"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["delete-buffer-and-file"] = v_0_
  delete_buffer_and_file = v_0_
end
cmd("command! Delete lua require'reflex'['delete-buffer-and-file']()")
local new_path_in_writable_location = nil
do
  local v_0_ = nil
  local function new_path_in_writable_location0(path)
    local part = path
    while (call("glob", {part}) == "") do
      part = call("fnamemodify", {part, ":h"})
    end
    if (call("filewritable", {part}) > 0) then
      return true
    else
      return false
    end
  end
  v_0_ = new_path_in_writable_location0
  _0_0["aniseed/locals"]["new-path-in-writable-location"] = v_0_
  new_path_in_writable_location = v_0_
end
local move_to = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function move_to0(new_path)
      local current_path = call("expand", {"%"})
      if ((call("glob", {new_path}) == "") or (call("confirm", {(new_path .. " already exists. Overwrite it?")}) == 1)) then
        local containing_directory = call("fnamemodify", {current_path, ":h"})
        if (call("filewritable", {containing_directory}) == 2) then
          if new_path_in_writable_location(new_path) then
            cmd(("keepalt saveas! " .. new_path))
            if (current_path ~= "") then
              cmd(("bwipeout! " .. current_path))
              return call("delete", {current_path})
            end
          else
            return show_error(("Cannot write to " .. new_path))
          end
        else
          return show_error(("Cannot move " .. current_path))
        end
      end
    end
    v_0_0 = move_to0
    _0_0["move-to"] = v_0_0
    v_0_ = v_0_0
  end
  _0_0["aniseed/locals"]["move-to"] = v_0_
  move_to = v_0_
end
util["fn-bridge"]("MoveTo", "reflex", "move-to")
return cmd("command! -nargs=1 -complete=file MoveTo call MoveTo(<f-args>)")