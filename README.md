Operate in buffers and files at the same time. Three commands are
exposed:

* `:Delete` will delete the buffer and the file on disk. Will ask
	to confirm beffore deleting a buffer with unsaved changes.
	`g:reflex_delete_cmd` allows to use an external command (like
	[trash][trash] in macOS).
* `:Move {filename}` will change the buffer name and the file name
	relative to `:pwd`. Will ask before overwriting an existing
	file.
* `:Rename {filename}` will do the same but relative to the buffer
	directory.

Also when you edit a file in a directory that doesn't exists it
will ask you if you want to create that directory.

[trash]: http://hasseg.org/trash/

