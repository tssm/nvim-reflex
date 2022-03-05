local _2afile_2a = "fnl/reflex/init.fnl"
local _2amodule_name_2a = "reflex"
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
local a, util = require("reflex.aniseed.core"), require("reflex.aniseed.nvim.util")
do end (_2amodule_locals_2a)["a"] = a
_2amodule_locals_2a["util"] = util
local api = vim.api
_2amodule_locals_2a["api"] = api
local call = api.nvim_call_function
_2amodule_locals_2a["call"] = call
local cmd = api.nvim_command
_2amodule_locals_2a["cmd"] = cmd
local function show_error(e)
  cmd("echohl ErrorMsg")
  cmd(("echo \"" .. e .. "\n\""))
  return cmd("echohl None")
end
_2amodule_locals_2a["show-error"] = show_error
local function mkdir_if_needed()
  local path_head = call("expand", {"%:h"})
  if ((call("isdirectory", {path_head}) == 0) and (call("confirm", {(path_head .. " doesn't exist. Create it?")}) == 1)) then
    local success, e = nil, nil
    local function _1_()
      return call("mkdir", {path_head, "p"})
    end
    success, e = pcall(_1_)
    if not success then
      return show_error((e .. "\n"))
    else
      return nil
    end
  else
    return nil
  end
end
_2amodule_2a["mkdir-if-needed"] = mkdir_if_needed
cmd("augroup MkdirIfNeeded")
cmd("autocmd!")
cmd("autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
cmd("augroup END")
local function delete_file(file_name)
  local exists, cmd0 = nil, nil
  local function _4_()
    return api.nvim_get_var("reflex_delete_file_cmd")
  end
  exists, cmd0 = pcall(_4_)
  local _5_
  if exists then
    _5_ = os.execute((cmd0 .. " " .. file_name))
  else
    _5_ = call("delete", {file_name})
  end
  return (_5_ == 0)
end
_2amodule_locals_2a["delete-file"] = delete_file
local function wipe_buffer_if_exists(name)
  if (call("bufexists", {name}) == 1) then
    local exists, command = nil, nil
    local function _7_()
      return api.nvim_get_var("reflex_delete_buffer_cmd")
    end
    exists, command = pcall(_7_)
    local function _8_()
      if exists then
        return command
      else
        return "bwipeout!"
      end
    end
    return cmd((_8_() .. " " .. name))
  else
    return nil
  end
end
_2amodule_locals_2a["wipe-buffer-if-exists"] = wipe_buffer_if_exists
local function delete_buffer_and_file(name)
  if ((call("getbufvar", {name, "&mod"}) == 0) or (call("confirm", {"There are unsaved changes. Delete anyway?"}) == 1)) then
    if (call("glob", {name}) ~= "") then
      if delete_file(name) then
        return wipe_buffer_if_exists(name)
      else
        return show_error("Can't delete asociated file")
      end
    else
      return wipe_buffer_if_exists(name)
    end
  else
    return nil
  end
end
_2amodule_2a["delete-buffer-and-file"] = delete_buffer_and_file
local function new_path_in_writable_location(path)
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
_2amodule_locals_2a["new-path-in-writable-location"] = new_path_in_writable_location
local function move(source, target)
  if ((call("glob", {target}) == "") or (call("confirm", {(target .. " already exists. Overwrite it?")}) == 1)) then
    local containing_directory = call("fnamemodify", {source, ":h"})
    if ((call("filewritable", {containing_directory}) == 2) or (call("filereadable", {containing_directory}) == 0)) then
      if new_path_in_writable_location(target) then
        local success, e = nil, nil
        local function _14_()
          return cmd(("silent keepalt saveas! " .. target))
        end
        success, e = pcall(_14_)
        if success then
          if (source ~= "") then
            wipe_buffer_if_exists(source)
            return call("delete", {source})
          else
            return nil
          end
        else
          return cmd(("silent keepalt saveas! " .. source))
        end
      else
        return show_error(("Cannot write to " .. target))
      end
    else
      return show_error(("Cannot move " .. source))
    end
  else
    return nil
  end
end
_2amodule_2a["move"] = move
local function delimiter()
  if ((call("exists", {"+shellslash"}) == 0) or (api.nvim_get_option({"&shellslash"}) == 1)) then
    return "/"
  else
    return "\\"
  end
end
_2amodule_locals_2a["delimiter"] = delimiter
local function complete_rename(prefix, cmd0, cursor_position)
  local root = (call("expand", {"%:p:h"}) .. delimiter())
  local function _21_(_241)
    return call("substitute", {_241, root, "", ""})
  end
  return a.map(_21_, call("glob", {(root .. prefix .. "*"), false, true}))
end
_2amodule_2a["complete-rename"] = complete_rename
local function rename(source, target)
  local current_directory = call("fnamemodify", {source, ":h"})
  local new_partial_path
  if (current_directory == "") then
    new_partial_path = call("getcwd", {})
  else
    new_partial_path = current_directory
  end
  return move(source, (new_partial_path .. delimiter() .. target))
end
_2amodule_2a["rename"] = rename
local function set_up()
  if ((vim.opt.buftype):get() == "") then
    util["fn-bridge"]("Delete", "reflex", "delete-buffer-and-file")
    cmd("command! -buffer Delete call Delete(expand('%'))")
    util["fn-bridge"]("MoveTo", "reflex", "move")
    cmd("command! -nargs=1 -complete=file -buffer MoveTo call MoveTo(expand('%'), <f-args>)")
    util["fn-bridge"]("CompleteRename", "reflex", "complete-rename")
    util["fn-bridge"]("RenameTo", "reflex", "rename")
    return cmd("command! -nargs=1 -complete=customlist,CompleteRename -buffer RenameTo call RenameTo(expand('%'), <f-args>)")
  else
    return nil
  end
end
_2amodule_2a["set-up"] = set_up
return _2amodule_2a