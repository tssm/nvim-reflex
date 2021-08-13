Operate in buffers and files at the same time. Three commands are
exposed:

* `:Delete` will delete the buffer and the file on disk. Will ask
	to confirm before deleting a buffer with unsaved changes. Two
	global variables alter its behaviour:
	1. `g:reflex_delete_cmd` allows to use an external command (like
		 [trash][trash] on macOS) to delete the file.
	2. `g:reflex_delete_buffer_cmd` allows to use a plugin command
		 to delete the buffer (like `:Bwipeout!` from [Bbye][bbye] to
		 avoid changing the tab layout). Make sure you pick a command
		 that wipes the buffer (so you don't see it on the old files
		 list) and operates even when there are changes.
* `:Move {filename}` will change the buffer name and the file name
	relative to `:pwd`. Will ask before overwriting an existing
	file.
* `:Rename {filename}` will do the same but relative to the buffer
	directory.

Also when you edit a file in a directory that doesn't exists it
will ask you if you want to create that directory.

[bbye]: https://github.com/moll/vim-bbye
[trash]: http://hasseg.org/trash/

