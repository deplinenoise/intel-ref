" vim script to lookup the intel instructions in the reference manual

if exists("g:loaded_intel_ref")
  finish
endif
let g:loaded_intel_ref = 1

let s:save_cpo = &cpo
set cpo&vim

let s:basedir = "~/.vim/plugin/" " FIXME
let s:tool = s:basedir . "intel-ref/intel-ref.py"
let s:index = s:basedir . "intel-ref/intel-ref.txt"

if !hasmapto('<Plug>IntelrefLookup')
  map <unique> <Leader>i  <Plug>IntelrefLookup
endif

noremap <unique> <script> <Plug>IntelrefLookup  <SID>Lookup

noremenu <script> Plugin.Lookup\ Intel\ Instruction      <SID>Lookup

noremap <SID>Lookup  :call <SID>Lookup(expand("<cword>"))<CR>

function s:Lookup(id)
	let s:cmd = s:tool . " " . s:index . " " . a:id
	call system(s:cmd)
endfunction

if !exists(":IntelrefLookup")
  command -nargs=1  IntelrefLookup  :call s:Lookup(<q-args>)
endif

let &cpo = s:save_cpo

