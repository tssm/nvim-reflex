if exists('g:reflex_loaded')
	finish
endif
let g:reflex_loaded = 1

lua require('reflex')
