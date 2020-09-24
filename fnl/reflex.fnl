(module reflex)

(def- api vim.api)
(def- call api.nvim_call_function)
(def- cmd api.nvim_command)

(defn mkdir-if-needed []
	"Ask the user if missing directories should be created when attempts to
	write to disk a buffer whose full path doesn't exist"
	(local path-head (call :expand ["%:h"]))
	(when (and
		; Directory doesn't exist
		(= (call :isdirectory [path-head]) 0)
		; User accepted to create missing directories
		(= (call :confirm [(.. path-head " doesn't exist. Create it?")]) 1))
		; Try to create missing directories
		(local (success e) (pcall #(call :mkdir [path-head "p"])))
		(when (not success)
			(cmd "echohl ErrorMsg")
			(cmd (.. "echo \"" e "\n\n\""))
			(cmd "echohl None"))))

(cmd "augroup MkdirIfNeeded")
(cmd "autocmd!")
(cmd "autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
(cmd "augroup END")
