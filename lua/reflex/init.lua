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
    return {require("reflex.aniseed.core")}
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
local _2amodule_2a = _1_
local _2amodule_name_2a = "reflex"
do local _ = ({nil, _1_, nil, {{}, nil, nil, nil}})[2] end
local api
do
  local v_23_auto = vim.api
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["api"] = v_23_auto
  api = v_23_auto
end
local call
do
  local v_23_auto = api.nvim_call_function
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["call"] = v_23_auto
  call = v_23_auto
end
local cmd
do
  local v_23_auto = api.nvim_command
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["cmd"] = v_23_auto
  cmd = v_23_auto
end
local show_error
do
  local v_23_auto
  local function show_error0(e)
    cmd("echohl ErrorMsg")
    cmd(("echo \"" .. e .. "\n\""))
    return cmd("echohl None")
  end
  v_23_auto = show_error0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["show-error"] = v_23_auto
  show_error = v_23_auto
end
local mkdir_if_needed
do
  local v_23_auto
  do
    local v_25_auto
    local function mkdir_if_needed0()
      local path_head = call("expand", {"%:h"})
      if ((call("isdirectory", {path_head}) == 0) and (call("confirm", {(path_head .. " doesn't exist. Create it?")}) == 1)) then
        local success, e = nil, nil
        local function _8_()
          return call("mkdir", {path_head, "p"})
        end
        success, e = pcall(_8_)
        if not success then
          return show_error((e .. "\n"))
        end
      end
    end
    v_25_auto = mkdir_if_needed0
    _1_["mkdir-if-needed"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["mkdir-if-needed"] = v_23_auto
  mkdir_if_needed = v_23_auto
end
cmd("augroup MkdirIfNeeded")
cmd("autocmd!")
cmd("autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
cmd("augroup END")
local delete_file
do
  local v_23_auto
  local function delete_file0(file_name)
    local exists, cmd0 = nil, nil
    local function _11_()
      return api.nvim_get_var("reflex_delete_file_cmd")
    end
    exists, cmd0 = pcall(_11_)
    local _12_
    if exists then
      _12_ = os.execute((cmd0 .. " " .. file_name))
    else
      _12_ = call("delete", {file_name})
    end
    return (_12_ == 0)
  end
  v_23_auto = delete_file0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delete-file"] = v_23_auto
  delete_file = v_23_auto
end
local wipe_buffer
do
  local v_23_auto
  local function wipe_buffer0(name)
    local exists, command = nil, nil
    local function _14_()
      return api.nvim_get_var("reflex_delete_buffer_cmd")
    end
    exists, command = pcall(_14_)
    local _15_
    if exists then
      _15_ = command
    else
      _15_ = "bwipeout!"
    end
    return cmd((_15_ .. " " .. name))
  end
  v_23_auto = wipe_buffer0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["wipe-buffer"] = v_23_auto
  wipe_buffer = v_23_auto
end
local delete_buffer_and_file
do
  local v_23_auto
  do
    local v_25_auto
    local function delete_buffer_and_file0()
      local buffer_name = call("expand", {"%"})
      if ((call("getbufvar", {buffer_name, "&mod"}) == 0) or (call("confirm", {"There are unsaved changes. Delete anyway?"}) == 1)) then
        if (call("glob", {buffer_name}) ~= "") then
          if delete_file(buffer_name) then
            return wipe_buffer(buffer_name)
          else
            return show_error("Can't delete asociated file")
          end
        else
          return wipe_buffer(buffer_name)
        end
      end
    end
    v_25_auto = delete_buffer_and_file0
    _1_["delete-buffer-and-file"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delete-buffer-and-file"] = v_23_auto
  delete_buffer_and_file = v_23_auto
end
local new_path_in_writable_location
do
  local v_23_auto
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
  v_23_auto = new_path_in_writable_location0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["new-path-in-writable-location"] = v_23_auto
  new_path_in_writable_location = v_23_auto
end
local move_to
do
  local v_23_auto
  do
    local v_25_auto
    local function move_to0(new_path)
      local current_path = call("expand", {"%"})
      if ((call("glob", {new_path}) == "") or (call("confirm", {(new_path .. " already exists. Overwrite it?")}) == 1)) then
        local containing_directory = call("fnamemodify", {current_path, ":h"})
        if (call("filewritable", {containing_directory}) == 2) then
          if new_path_in_writable_location(new_path) then
            cmd(("keepalt saveas! " .. new_path))
            if (current_path ~= "") then
              wipe_buffer(current_path)
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
    v_25_auto = move_to0
    _1_["move-to"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["move-to"] = v_23_auto
  move_to = v_23_auto
end
local delimiter
do
  local v_23_auto
  local function delimiter0()
    if ((call("exists", {"+shellslash"}) == 0) or (api.nvim_get_option({"&shellslash"}) == 1)) then
      return "/"
    else
      return "\\"
    end
  end
  v_23_auto = delimiter0
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["delimiter"] = v_23_auto
  delimiter = v_23_auto
end
local complete_rename
do
  local v_23_auto
  do
    local v_25_auto
    local function complete_rename0(prefix, cmd0, cursor_position)
      local root = (call("expand", {"%:p:h"}) .. delimiter())
      local function _26_(_241)
        return call("substitute", {_241, root, "", ""})
      end
      return a.map(_26_, call("glob", {(root .. prefix .. "*"), false, true}))
    end
    v_25_auto = complete_rename0
    _1_["complete-rename"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["complete-rename"] = v_23_auto
  complete_rename = v_23_auto
end
local rename_to
do
  local v_23_auto
  do
    local v_25_auto
    local function rename_to0(input)
      local current_directory = call("expand", {"%:h"})
      local new_partial_path
      if (current_directory == "") then
        new_partial_path = call("getcwd", {})
      else
        new_partial_path = current_directory
      end
      return move_to((new_partial_path .. delimiter() .. input))
    end
    v_25_auto = rename_to0
    _1_["rename-to"] = v_25_auto
    v_23_auto = v_25_auto
  end
  local t_24_auto = (_1_)["aniseed/locals"]
  t_24_auto["rename-to"] = v_23_auto
  rename_to = v_23_auto
end
return nil