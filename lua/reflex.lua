local _2afile_2a = "fnl/reflex.fnl"
local _0_
do
  local name_0_ = "reflex"
  local module_0_
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  do end (module_0_)["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  do end (package.loaded)[name_0_] = module_0_
  _0_ = module_0_
end
local autoload
local function _1_(...)
  return (require("aniseed.autoload")).autoload(...)
end
autoload = _1_
local function _2_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _2_()
    return {require("aniseed.core"), (_0_)["aniseed/locals"].api, (_0_)["aniseed/locals"].call, (_0_)["aniseed/locals"].cmd, (_0_)["aniseed/locals"]["complete-rename"], (_0_)["aniseed/locals"]["delete-buffer-and-file"], (_0_)["aniseed/locals"]["delete-file"], (_0_)["aniseed/locals"].delimiter, (_0_)["aniseed/locals"]["mkdir-if-needed"], (_0_)["aniseed/locals"]["move-to"], (_0_)["aniseed/locals"]["new-path-in-writable-location"], (_0_)["aniseed/locals"]["rename-to"], (_0_)["aniseed/locals"]["show-error"]}
  end
  ok_3f_0_, val_0_ = pcall(_2_)
  if ok_3f_0_ then
    _0_["aniseed/local-fns"] = {require = {a = "aniseed.core"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _2_(...)
local a = _local_0_[1]
local move_to = _local_0_[10]
local new_path_in_writable_location = _local_0_[11]
local rename_to = _local_0_[12]
local show_error = _local_0_[13]
local api = _local_0_[2]
local call = _local_0_[3]
local cmd = _local_0_[4]
local complete_rename = _local_0_[5]
local delete_buffer_and_file = _local_0_[6]
local delete_file = _local_0_[7]
local delimiter = _local_0_[8]
local mkdir_if_needed = _local_0_[9]
local _2amodule_2a = _0_
local _2amodule_name_2a = "reflex"
do local _ = ({nil, _0_, nil, {{}, nil, nil, nil}})[2] end
local api0
do
  local v_0_ = vim.api
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["api"] = v_0_
  api0 = v_0_
end
local call0
do
  local v_0_ = api0.nvim_call_function
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["call"] = v_0_
  call0 = v_0_
end
local cmd0
do
  local v_0_ = api0.nvim_command
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["cmd"] = v_0_
  cmd0 = v_0_
end
local show_error0
do
  local v_0_
  local function show_error1(e)
    cmd0("echohl ErrorMsg")
    cmd0(("echo \"" .. e .. "\n\""))
    return cmd0("echohl None")
  end
  v_0_ = show_error1
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["show-error"] = v_0_
  show_error0 = v_0_
end
local mkdir_if_needed0
do
  local v_0_
  do
    local v_0_0
    local function mkdir_if_needed1()
      local path_head = call0("expand", {"%:h"})
      if ((call0("isdirectory", {path_head}) == 0) and (call0("confirm", {(path_head .. " doesn't exist. Create it?")}) == 1)) then
        local success, e = nil, nil
        local function _3_()
          return call0("mkdir", {path_head, "p"})
        end
        success, e = pcall(_3_)
        if not success then
          return show_error0((e .. "\n"))
        end
      end
    end
    v_0_0 = mkdir_if_needed1
    _0_["mkdir-if-needed"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["mkdir-if-needed"] = v_0_
  mkdir_if_needed0 = v_0_
end
cmd0("augroup MkdirIfNeeded")
cmd0("autocmd!")
cmd0("autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
cmd0("augroup END")
local delete_file0
do
  local v_0_
  local function delete_file1(file_name)
    local exists, cmd1 = nil, nil
    local function _3_()
      return api0.nvim_get_var("reflex_delete_cmd")
    end
    exists, cmd1 = pcall(_3_)
    local _4_
    if exists then
      _4_ = os.execute((cmd1 .. " " .. file_name))
    else
      _4_ = call0("delete", {file_name})
    end
    return (_4_ == 0)
  end
  v_0_ = delete_file1
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["delete-file"] = v_0_
  delete_file0 = v_0_
end
local wipe_buffer
do
  local v_0_
  local function wipe_buffer0(name)
    local exists, command = nil, nil
    local function _3_()
      return api0.nvim_get_var("reflex_delete_buffer_cmd")
    end
    exists, command = pcall(_3_)
    local _4_
    if exists then
      _4_ = command
    else
      _4_ = "bwipeout!"
    end
    return cmd0((_4_ .. " " .. name))
  end
  v_0_ = wipe_buffer0
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["wipe-buffer"] = v_0_
  wipe_buffer = v_0_
end
local delete_buffer_and_file0
do
  local v_0_
  do
    local v_0_0
    local function delete_buffer_and_file1()
      local buffer_name = call0("expand", {"%"})
      if ((call0("getbufvar", {buffer_name, "&mod"}) == 0) or (call0("confirm", {"There are unsaved changes. Delete anyway?"}) == 1)) then
        if (call0("glob", {buffer_name}) ~= "") then
          if delete_file0(buffer_name) then
            return wipe_buffer(buffer_name)
          else
            return show_error0("Can't delete asociated file")
          end
        else
          return wipe_buffer(buffer_name)
        end
      end
    end
    v_0_0 = delete_buffer_and_file1
    _0_["delete-buffer-and-file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["delete-buffer-and-file"] = v_0_
  delete_buffer_and_file0 = v_0_
end
local new_path_in_writable_location0
do
  local v_0_
  local function new_path_in_writable_location1(path)
    local part = path
    while (call0("glob", {part}) == "") do
      part = call0("fnamemodify", {part, ":h"})
    end
    if (call0("filewritable", {part}) > 0) then
      return true
    else
      return false
    end
  end
  v_0_ = new_path_in_writable_location1
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["new-path-in-writable-location"] = v_0_
  new_path_in_writable_location0 = v_0_
end
local move_to0
do
  local v_0_
  do
    local v_0_0
    local function move_to1(new_path)
      local current_path = call0("expand", {"%"})
      if ((call0("glob", {new_path}) == "") or (call0("confirm", {(new_path .. " already exists. Overwrite it?")}) == 1)) then
        local containing_directory = call0("fnamemodify", {current_path, ":h"})
        if (call0("filewritable", {containing_directory}) == 2) then
          if new_path_in_writable_location0(new_path) then
            cmd0(("keepalt saveas! " .. new_path))
            if (current_path ~= "") then
              wipe_buffer(current_path)
              return call0("delete", {current_path})
            end
          else
            return show_error0(("Cannot write to " .. new_path))
          end
        else
          return show_error0(("Cannot move " .. current_path))
        end
      end
    end
    v_0_0 = move_to1
    _0_["move-to"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["move-to"] = v_0_
  move_to0 = v_0_
end
local delimiter0
do
  local v_0_
  local function delimiter1()
    if ((call0("exists", {"+shellslash"}) == 0) or (api0.nvim_get_option({"&shellslash"}) == 1)) then
      return "/"
    else
      return "\\"
    end
  end
  v_0_ = delimiter1
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["delimiter"] = v_0_
  delimiter0 = v_0_
end
local complete_rename0
do
  local v_0_
  do
    local v_0_0
    local function complete_rename1(prefix, cmd1, cursor_position)
      local root = (call0("expand", {"%:p:h"}) .. delimiter0())
      local function _3_(_241)
        return call0("substitute", {_241, root, "", ""})
      end
      return a.map(_3_, call0("glob", {(root .. prefix .. "*"), false, true}))
    end
    v_0_0 = complete_rename1
    _0_["complete-rename"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["complete-rename"] = v_0_
  complete_rename0 = v_0_
end
local rename_to0
do
  local v_0_
  do
    local v_0_0
    local function rename_to1(input)
      local current_directory = call0("expand", {"%:h"})
      local new_partial_path
      if (current_directory == "") then
        new_partial_path = call0("getcwd", {})
      else
        new_partial_path = current_directory
      end
      return move_to0((new_partial_path .. delimiter0() .. input))
    end
    v_0_0 = rename_to1
    _0_["rename-to"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_)["aniseed/locals"]
  t_0_["rename-to"] = v_0_
  rename_to0 = v_0_
end
return nil