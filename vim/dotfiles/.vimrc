set number
set visualbell
set wrap
set textwidth=120
set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set listchars=eol:$,tab:>-,trail:~,extends:>,precedes:<
set list
set colorcolumn=121
set spell
let g:html_indent_script1="zero"
let g:html_indent_style1="zero"

syntax on

autocmd FileType javascript setlocal shiftwidth=2 tabstop=2
autocmd FileType html       setlocal shiftwidth=2 tabstop=2
autocmd FileType php        setlocal shiftwidth=4 tabstop=4
