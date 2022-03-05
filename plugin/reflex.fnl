(module init)

(def- cmd vim.api.nvim_command)

(cmd "augroup Reflex")
(cmd "autocmd!")
(cmd "autocmd BufReadPost * lua require'reflex'['set-up']()")
(cmd "augroup END")

(when vim.g.reflex_delete_cmd
  (vim.api.nvim_echo
    [[
      "reflex_delete_cmd will be removed, use reflex_delete_file_cmd instead"
      :WarningMsg]]
    true
    {})
  (set vim.g.reflex_delete_file_cmd vim.g.reflex_delete_cmd))
