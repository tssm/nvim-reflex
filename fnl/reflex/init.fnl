(module reflex {
	require {
		a reflex.aniseed.core
		util reflex.aniseed.nvim.util}})

(def- api vim.api)
(def- call api.nvim_call_function)
(def- cmd api.nvim_command)

(defn- show-error [e]
	(cmd "echohl ErrorMsg")
	(cmd (.. "echo \"" e "\n\""))
	(cmd "echohl None"))

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
		(when (not success) (show-error (.. e "\n")))))

(defn- delete-file [file-name]
	(local (exists cmd) (pcall #(api.nvim_get_var "reflex_delete_file_cmd")))
	(= (if exists
		; There's an external command
		(os.execute (.. cmd " " file-name))
		; There's no external commad
		(call :delete [file-name])) 0))

(defn- wipe-buffer-if-exists [name]
	(when (= (call :bufexists [name]) 1)
		(local (exists command) (pcall #(api.nvim_get_var "reflex_delete_buffer_cmd")))
		(cmd (.. (if exists command "bwipeout!") " " name))))

(defn delete-buffer-and-file [name]
	"Wipeout the current buffer and delete its associated file if it exists"
	(when (or
		; The buffer doesn't exist
		(= (call :bufexists [name]) 0)
		; The buffer hasn't change
		(= (call :getbufvar [name "&mod"]) 0)
		; The user confirms to delete it
		(= (call :confirm ["There are unsaved changes. Delete anyway?"]) 1))
		; There's a file for the buffer
		(if (not= (call :glob [name]) "")
			(if (delete-file name)
				; The file was deleted
				(wipe-buffer-if-exists name)
				; The file wasn't deleted
				(show-error "Can't delete asociated file"))
			; There's no file for the buffer
			(wipe-buffer-if-exists name))))

; Determines if the new path or its existent part is writable
(defn- new-path-in-writable-location [path]
	(var part path)
	(while (= (call :glob [part]) "")
		(set part (call :fnamemodify [part ":h"])))
	(if (> (call :filewritable [part]) 0) true false))

(defn move [source target]
	"Move file asociated with the current buffer to a new location"
	(when (or
		; The new file doesn't exists
		(= (call :glob [target]) "")
		; User accepts to overwrite it if it exists
		(= (call :confirm [(.. target " already exists. Overwrite it?")]) 1))
		(local containing-directory (call :fnamemodify [source ":h"]))
		(if (or
			; Ensure the original file can be removed from its original directory...
			(= (call :filewritable [containing-directory]) 2)
			; ...or avoid raising an error if the containing directory doesn't exists
			(= (call :filereadable [containing-directory]) 0))
			; Ensure the new path can be writen
			(if (new-path-in-writable-location target)
				(do
					(local (success e) (pcall #(cmd (.. "silent keepalt saveas! " target))))
					(if success
						; Only try to delete current file and buffer if they have a name
						(when (not= source "")
							(wipe-buffer-if-exists source)
							(call :delete [source]))
						; Revert buffer name if the user canceled the directory creation in mkdir-if-needed
						(cmd (.. "silent keepalt saveas! " source))))
				(show-error (.. "Cannot write to " target)))
			; Current file is not writable
			(show-error (.. "Cannot move " source)))))

; Because the user can set shellslash at run-time a function is used instead of
; a local variable
(defn- delimiter []
	(if (or
		(= (call :exists ["+shellslash"]) 0)
		(= (api.nvim_get_option ["&shellslash"]) 1))
		"/"
		"\\"))

(defn complete-rename [prefix cmd cursor-position]
	"Complete paths relative to current buffer location"
	(local root (.. (call :expand ["%:p:h"]) (delimiter)))
	(a.map
		#(call :substitute [$1 root "" ""])
		; Two last arguments: espect suffixes and wildignore (default), and return
		; a list
		(call :glob [(.. root prefix "*") false true])))

(defn rename [source target]
	"Move file asociated with the current to a new location relative to the
	current one"
	(local current-directory (call :fnamemodify [source ":h"]))
	(local new-partial-path (if (= current-directory "")
		(call :getcwd [])
		current-directory))
	(move source (.. new-partial-path (delimiter) target)))

(defn set-up []
	; Create the commands only for normal buffers
	(when (= (vim.opt.buftype:get) "")
		(cmd "augroup MkdirIfNeeded")
		(cmd "autocmd!")
		(cmd "autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
		(cmd "augroup END")

		(util.fn-bridge :Delete :reflex :delete-buffer-and-file)
		(cmd "command! -buffer Delete call Delete(expand('%'))")

		(util.fn-bridge :MoveTo :reflex :move)
		(cmd "command! -nargs=1 -complete=file -buffer MoveTo call MoveTo(expand('%'), <f-args>)")

		(util.fn-bridge :CompleteRename :reflex :complete-rename)
		(util.fn-bridge :RenameTo :reflex :rename)
		(cmd "command! -nargs=1 -complete=customlist,CompleteRename -buffer RenameTo call RenameTo(expand('%'), <f-args>)")))
