" Load VIM configurations
source ~/.vimrc

set runtimepath+=/nvim

<<<<<<< HEAD:vim/dotfiles/.nvim.vim
" Required plugins
call plug#begin('~/.vim/plugged')
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
    Plug 'vim-vdebug/vdebug'
    Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
    Plug 'stephpy/vim-php-cs-fixer'
    Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

=======
>>>>>>> f7e1b6dca2d24cc9d25c2dd78dbccb72a36970ef:vim/dotfiles/.config/nvim/init.vim
" Autostart NerdTree
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd VimEnter * if !argc() | NERDTree | endif

" Keep NerdTree open always
let g:NERDTreeQuitOnOpen = 0
let g:NERDTreeWinSize = 45
let g:NERDTreeShowHidden=1

map <Leader>nf :NERDTreeFind<CR>

" Use gruvbox colorscheme
let g:airline_theme='gruvbox'
let g:gruvbox_contrast_dark='soft'
colorscheme gruvbox

" fzf.vim find files
nnoremap <silent> <C-f> :Files<CR>
" fzf.vim find in files
nnoremap <silent> <Leader>f :Rg<CR>
" fzf is on the bottom of the window
<<<<<<< HEAD:vim/dotfiles/.nvim.vim
let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.2, 'yoffset': 1, 'border': 'none' } }
=======
"let g:fzf_layout = { 'window': { 'width': 1, 'height': 0.2, 'yoffset': 1, 'border': 'none' } }
>>>>>>> f7e1b6dca2d24cc9d25c2dd78dbccb72a36970ef:vim/dotfiles/.config/nvim/init.vim

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

<<<<<<< HEAD:vim/dotfiles/.nvim.vim
lua require('config')
=======
lua require('pelyib')
>>>>>>> f7e1b6dca2d24cc9d25c2dd78dbccb72a36970ef:vim/dotfiles/.config/nvim/init.vim

" Load local config file
if filereadable(expand('~/.config/nvim/local.vim'))
  source ~/.config/nvim/local.vim
endif

let project_local_vim_config = getcwd() . "/.local.vim"
if filereadable(expand(project_local_vim_config))
  exec printf('source %s', project_local_vim_config)
endif

" ============ DO NOT PUT ANYTHING HERE, local.vim MUST BE THE LAST! =========
