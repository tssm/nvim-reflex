(module init {require {util reflex.aniseed.nvim.util}})

(def- cmd vim.api.nvim_command)

(cmd "command! Delete lua require'reflex'['delete-buffer-and-file']()")

(util.fn-bridge :MoveTo :reflex :move-to)
(cmd "command! -nargs=1 -complete=file MoveTo call MoveTo(<f-args>)")

(util.fn-bridge :CompleteRename :reflex :complete-rename)
(util.fn-bridge :RenameTo :reflex :rename-to)
(cmd "command! -nargs=1 -complete=customlist,CompleteRename RenameTo call RenameTo(<f-args>)")

(when vim.g.reflex_delete_cmd
  (vim.api.nvim_echo
    [[
      "reflex_delete_cmd will be removed, use reflex_delete_file_cmd instead"
      :WarningMsg]]
    true
    {})
  (set vim.g.reflex_delete_file_cmd vim.g.reflex_delete_cmd))
