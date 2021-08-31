(module reflex {require {a reflex.aniseed.core}})

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

(cmd "augroup MkdirIfNeeded")
(cmd "autocmd!")
(cmd "autocmd BufWritePre * lua require'reflex'['mkdir-if-needed']()")
(cmd "augroup END")

(defn- delete-file [file-name]
	(local (exists cmd) (pcall #(api.nvim_get_var "reflex_delete_file_cmd")))
	(= (if exists
		; There's an external command
		(os.execute (.. cmd " " file-name))
		; There's no external commad
		(call :delete [file-name])) 0))

(defn- wipe-buffer [name]
	(local (exists command) (pcall #(api.nvim_get_var "reflex_delete_buffer_cmd")))
	(cmd (.. (if exists command "bwipeout!") " " name)))

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
			(if (delete-file buffer-name)
				; The file was deleted
				(wipe-buffer buffer-name)
				; The file wasn't deleted
				(show-error "Can't delete asociated file"))
			; There's no file for the buffer
			(wipe-buffer buffer-name))))

; Determines if the new path or its existent part is writable
(defn- new-path-in-writable-location [path]
	(var part path)
	(while (= (call :glob [part]) "")
		(set part (call :fnamemodify [part ":h"])))
	(if (> (call :filewritable [part]) 0) true false))

(defn move-to [new-path]
	"Move file asociated with the current buffer to a new location"
	(local current-path (call :expand ["%"]))
	(when (or
		; The new file doesn't exists
		(= (call :glob [new-path]) "")
		; User accepts to overwrite it if it exists
		(= (call :confirm [(.. new-path " already exists. Overwrite it?")]) 1))
		(local containing-directory (call :fnamemodify [current-path ":h"]))
		; Ensure the original file can be deleted
		(if (= (call :filewritable [containing-directory]) 2)
			; Ensure the new path can be writen
			(if (new-path-in-writable-location new-path)
				(do
					(cmd (.. "keepalt saveas! " new-path))
					; Only try to delete current file and buffer if they have a name
					(when (not= current-path "")
						(wipe-buffer current-path)
						(call :delete [current-path])))
				(show-error (.. "Cannot write to " new-path)))
			; Current file is not writable
			(show-error (.. "Cannot move " current-path)))))

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

(defn rename-to [input]
	"Move file asociated with the current to a new location relative to the
	current one"
	(local current-directory (call :expand ["%:h"]))
	(local new-partial-path (if (= current-directory "")
		(call :getcwd [])
		current-directory))
	(move-to (.. new-partial-path (delimiter) input)))

