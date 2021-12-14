if exists('b:current_syntax')
  finish
endif

syntax match poxTitle 'Turn off computer'
syntax match poxIcon /[\/|_-]/
syntax keyword poxCancel 'Cancel'

highlight default poxTitle ctermfg=white ctermbg=darkblue 
highlight default poxIcon ctermfg=white ctermbg=blue guifg=blue
highlight default poxCancel ctermfg=black ctermbg=gray guifg=black guibg=gray

let b:current_syntax = 'pox'
