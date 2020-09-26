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

(defn delete-buffer-and-file []
	"Wipeout the current buffer and delete its associated file if it exists"
	(local buffer-name (call :expand ["%"]))
	(when (or
		; The buffer hasn't change
		(= (call :getbufvar [buffer-name "&mod"]) 0)
		; The user confirms to delete it
		(= (call :confirm ["There are unsaved changes. Delete anyway?"]) 1))
		; There's a file for the buffer
		(if (not= (call :glob [buffer-name]) "")
			(if (= (call :delete [buffer-name]) 0)
				; The file was deleted
				(cmd (.. "bwipeout! " buffer-name))
				; The file wasn't deleted
				(do
					(cmd "echohl ErrorMsg")
					(cmd (.. "echo \"Can't delete asociated file\n\""))
					(cmd "echohl None")))
			; There's no file for the buffer
			(cmd (.. "bwipeout! " buffer-name)))))

(cmd "command! Delete lua require'reflex'['delete-buffer-and-file']()")
