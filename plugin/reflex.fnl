(module init)

(def- cmd vim.api.nvim_command)

(cmd "augroup Reflex")
(cmd "autocmd!")
(cmd "autocmd BufNewFile,BufReadPost * lua require'reflex'['set-up']()")
(cmd "augroup END")
