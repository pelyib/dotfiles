" Load VIM configurations
" source /nvim/.vimrc
source ~/.vimrc

set runtimepath+=/nvim

" Required plugins
call plug#begin('~/.vim/plugged')
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'
    Plug 'tpope/vim-fugitive'
    Plug 'scrooloose/nerdcommenter'
    Plug 'scrooloose/nerdtree'
    Plug 'tpope/vim-surround'
    Plug 'morhetz/gruvbox'
    Plug 'jiangmiao/auto-pairs'
    Plug 'Xuyuanp/nerdtree-git-plugin'
    Plug 'ryanoasis/vim-devicons'
    Plug 'airblade/vim-gitgutter'
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'elzr/vim-json'
    Plug 'airblade/vim-rooter'
    Plug 'aklt/plantuml-syntax'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
    Plug 'tjdevries/coc-zsh'
    Plug 'vim-vdebug/vdebug'
    Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
    Plug 'stephpy/vim-php-cs-fixer'
call plug#end()

" Autostart NerdTree
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd VimEnter * if !argc() | NERDTree | endif

" Keep NerdTree open always
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinSize = 45
let g:NERDTreeShowHidden=1

map <Leader>nf :NERDTreeFind<CR>
map <Leader>nt :NERDTreeToggle<CR>

" Use gruvbox colorscheme
let g:airline_theme='gruvbox'
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox

" Set COC extensions
let g:coc_global_extensions = [
      \'coc-json',
      \'coc-phpls',
      \'coc-go',
      \'coc-markdownlint',
      \'coc-pyright',
      \'coc-tsserver',
      \'coc-html',
      \]

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Symbol renaming.
nmap <leader>rn <Plug>(coc-rename)

" fzf.vim find files
nnoremap <silent> <C-f> :Files<CR>
" fzf.vim find in files
nnoremap <silent> <Leader>f :Rg<CR>
" fzf is on the bottom of the window
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.2, 'yoffset': 1, 'border': 'none' } }

" vim-go settings
let g:go_highlight_functions = 1
let g:go_highlight_function_parameters = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_format_strings = 1
let g:go_highlight_variable_declarations = 1
let g:go_highlight_variable_assignments = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1

" SirVer/ultisnips
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" php-cs-fixer
let g:php_cs_fixer_allow_risky = 'yes'
function! CodingStandardsFixer ()
  if &filetype == 'php' 
    call PhpCsFixerFixFile() 
  endif 
endfunction
nmap <silent> csf :call CodingStandardsFixer()<cr>

" Refresh NerdTree and Intelephense db
function! RefreshAfterGitChange ()
  " TODO: it is not working, fix it [botond.pelyi]
  silent! NERDTreeRefreshRoot()
  if &filetype == "php"
    silent! call coc#rpc#notify('runCommand', ['intelephense.index.workspace'])
  endif

  echo "Refresh is done..."
endfunction
nmap <leader>rf :call RefreshAfterGitChange()<cr>

" Phpactor
" TODO: use one mapping and decide the variant based on the file name [botond.pelyi]
nmap pnc :call PelyibPhpCreateNew("default")<cr>
nmap pni :call PelyibPhpCreateNew("interface")<cr>
nmap pntu :call PelyibPhpCreateNew("default")<cr>
function! PelyibPhpCreateNew(variant)
  if &filetype != "php"
    echo "It is not a PHP file"
    return
  endif
  call phpactor#rpc("class_new", { "current_path": phpactor#_path(), "variant": a:variant})
  silent! write
  call CodingStandardsFixer()
  silent! write
endfunction

nmap <leader>pi :call phpactor#ImportMissingClasses()<cr>

" Load local config file
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif

let project_local_vim_config = getcwd() . "/.local.vim"
if filereadable(expand(project_local_vim_config))
  exec printf('source %s', project_local_vim_config)
endif

" ============ DO NOT PUT ANYTHING HERE, local.vim MUST BE THE LAST! =========
