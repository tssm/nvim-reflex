local _2afile_2a = "fnl/reflex/init.fnl"
local _1_
do
  local name_4_auto = "reflex"
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
    return {require("reflex.aniseed.core"), (_1_)["aniseed/locals"].api, (_1_)["aniseed/locals"].call, (_1_)["aniseed/locals"].cmd, (_1_)["aniseed/locals"]["complete-rename"], (_1_)["aniseed/locals"]["delete-buffer-and-file"], (_1_)["aniseed/locals"]["delete-file"], (_1_)["aniseed/locals"].delimiter, (_1_)["aniseed/locals"]["mkdir-if-needed"], (_1_)["aniseed/locals"]["move-to"], (_1_)["aniseed/locals"]["new-path-in-writable-location"], (_1_)["aniseed/locals"]["rename-to"], (_1_)["aniseed/locals"]["show-error"], (_1_)["aniseed/locals"]["wipe-buffer"]}
  end
  ok_3f_21_auto, val_22_auto = pcall(_5_)
  if ok_3f_21_auto then
    _1_["aniseed/local-fns"] = {require = {a = "reflex.aniseed.core"}}
    return val_22_auto
  else
    return print(val_22_auto)
  end
end
local _local_4_ = _6_(...)
local a = _local_4_[1]
local move_to = _local_4_[10]
local new_path_in_writable_location = _local_4_[11]
local rename_to = _local_4_[12]
local show_error = _local_4_[13]
local wipe_buffer = _local_4_[14]
local api = _local_4_[2]
local call = _local_4_[3]
local cmd = _local_4_[4]
local complete_rename = _local_4_[5]
local delete_buffer_and_file = _local_4_[6]
local delete_file = _local_4_[7]
local delimiter = _local_4_[8]
local mkdir_if_needed = _local_4_[9]
local _2amodule_2a = _1_
local _2amodule_name_2a = "reflex"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local api0
do
  local v_23_auto = vim.api
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["api"] = v_23_auto
  api0 = v_23_auto
end
local call0
do
  local v_23_auto = api0.nvim_call_function
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["call"] = v_23_auto
  call0 = v_23_auto
end
local cmd0
do
  local v_23_auto = api0.nvim_command
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["cmd"] = v_23_auto
  cmd0 = v_23_auto
end
local show_error0
do
  local v_23_auto
  local function show_error1(e)
    cmd0("echohl ErrorMsg")
    cmd0(("echo \"" .. e .. "\n\""))
    return cmd0("echohl None")
  end
  v_23_auto = show_error1
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["show-error"] = v_23_auto
  show_error0 = v_23_auto
end
local mkdir_if_needed0
do
  local v_23_auto
  do
    local v_25_auto
    local function mkdir_if_needed1()
      local path_head = call0("expand", {"%:h"})
      if ((call0("isdirectory", {path_head}) == 0) and (call0("confirm", {(path_head .. " doesn't exist. Create it?")}) == 1)) then
        local success, e = nil, nil
        local function _8_()
          return call0("mkdir", {path_head, "p"})
        end
        success, e = pcall(_8_)
        if not success then
          return show_error0((e .. "\n"))
        end
      end
    end
    v_25_auto = mkdir_if_needed1
    _1_["mkdir-if-needed"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["mkdir-if-needed"] = v_23_auto
  mkdir_if_needed0 = v_23_auto
end
cmd0("augroup MkdirIfNeeded")
cmd0("autocmd!")
cmd0("autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
cmd0("augroup END")
local delete_file0
do
  local v_23_auto
  local function delete_file1(file_name)
    local exists, cmd1 = nil, nil
    local function _11_()
      return api0.nvim_get_var("reflex_delete_file_cmd")
    end
    exists, cmd1 = pcall(_11_)
    local _12_
    if exists then
      _12_ = os.execute((cmd1 .. " " .. file_name))
    else
      _12_ = call0("delete", {file_name})
    end
    return (_12_ == 0)
  end
  v_23_auto = delete_file1
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delete-file"] = v_23_auto
  delete_file0 = v_23_auto
end
local wipe_buffer0
do
  local v_23_auto
  local function wipe_buffer1(name)
    local exists, command = nil, nil
    local function _14_()
      return api0.nvim_get_var("reflex_delete_buffer_cmd")
    end
    exists, command = pcall(_14_)
    local _15_
    if exists then
      _15_ = command
    else
      _15_ = "bwipeout!"
    end
    return cmd0((_15_ .. " " .. name))
  end
  v_23_auto = wipe_buffer1
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["wipe-buffer"] = v_23_auto
  wipe_buffer0 = v_23_auto
end
local delete_buffer_and_file0
do
  local v_23_auto
  do
    local v_25_auto
    local function delete_buffer_and_file1()
      local buffer_name = call0("expand", {"%"})
      if ((call0("getbufvar", {buffer_name, "&mod"}) == 0) or (call0("confirm", {"There are unsaved changes. Delete anyway?"}) == 1)) then
        if (call0("glob", {buffer_name}) ~= "") then
          if delete_file0(buffer_name) then
            return wipe_buffer0(buffer_name)
          else
            return show_error0("Can't delete asociated file")
          end
        else
          return wipe_buffer0(buffer_name)
        end
      end
    end
    v_25_auto = delete_buffer_and_file1
    _1_["delete-buffer-and-file"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delete-buffer-and-file"] = v_23_auto
  delete_buffer_and_file0 = v_23_auto
end
local new_path_in_writable_location0
do
  local v_23_auto
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
  v_23_auto = new_path_in_writable_location1
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["new-path-in-writable-location"] = v_23_auto
  new_path_in_writable_location0 = v_23_auto
end
local move_to0
do
  local v_23_auto
  do
    local v_25_auto
    local function move_to1(new_path)
      local current_path = call0("expand", {"%"})
      if ((call0("glob", {new_path}) == "") or (call0("confirm", {(new_path .. " already exists. Overwrite it?")}) == 1)) then
        local containing_directory = call0("fnamemodify", {current_path, ":h"})
        if ((call0("filewritable", {containing_directory}) == 2) or (call0("filereadable", {containing_directory}) == 0)) then
          if new_path_in_writable_location0(new_path) then
            cmd0(("keepalt saveas! " .. new_path))
            if (current_path ~= "") then
              wipe_buffer0(current_path)
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
    v_25_auto = move_to1
    _1_["move-to"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["move-to"] = v_23_auto
  move_to0 = v_23_auto
end
local delimiter0
do
  local v_23_auto
  local function delimiter1()
    if ((call0("exists", {"+shellslash"}) == 0) or (api0.nvim_get_option({"&shellslash"}) == 1)) then
      return "/"
    else
      return "\\"
    end
  end
  v_23_auto = delimiter1
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delimiter"] = v_23_auto
  delimiter0 = v_23_auto
end
local complete_rename0
do
  local v_23_auto
  do
    local v_25_auto
    local function complete_rename1(prefix, cmd1, cursor_position)
      local root = (call0("expand", {"%:p:h"}) .. delimiter0())
      local function _26_(_241)
        return call0("substitute", {_241, root, "", ""})
      end
      return a.map(_26_, call0("glob", {(root .. prefix .. "*"), false, true}))
    end
    v_25_auto = complete_rename1
    _1_["complete-rename"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["complete-rename"] = v_23_auto
  complete_rename0 = v_23_auto
end
local rename_to0
do
  local v_23_auto
  do
    local v_25_auto
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
    v_25_auto = rename_to1
    _1_["rename-to"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["rename-to"] = v_23_auto
  rename_to0 = v_23_auto
end
return nil