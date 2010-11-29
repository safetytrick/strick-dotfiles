set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim

filetype plugin on
set ofu=syntaxcomplete#Complete
"*********************** Preferences **********************
set nu
set vb t_vb=
set lbr
set history=100
syn on
set incsearch
set smartcase
set scrolloff=2
set wildmode=longest,list
set mouse=a
set autoindent
set smartindent
set showmatch
set ruler
set tabstop=4
set shiftwidth=4
set nobackup
set nowritebackup
set noswapfile

" change cwd to root NERDTree directory
let NERDTreeChDirMode=2
" ignore pyc files
let NERDTreeIgnore=['\.pyc$','\~$']

" Inspired by http://github.com/ciaranm/dotfiles-ciaranm/tree/master
set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)


"*********************** Completion ***********************
let g:SuperTabDefaultCompletionType = 'context'
autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
au BufRead,BufNewFile jquery.*.js set ft=javascript syntax=jquery
"************************* Styles *************************
colorscheme rdark
if has('gui_running')
	set lines=55 columns=125
endif
"************************* Python *************************
let $DJANGO_SETTINGS_MODULE='settings'
autocmd FileType python set list

" Open NERDTree to the home directory for a python module
function! Ntpy(module)
python << EOF
import vim, os.path
module = __import__(vim.eval('a:module'))
path = os.path.dirname(os.path.realpath(module.__file__[:-1]))
vim.command("let l:pymod_path='NERDTree %s'" % path)
EOF
exec l:pymod_path
endfunction
"************************ Mappings ************************
map nt :NERDTree
map tbn :tabnew
map bt :browse tabnew

command -nargs=* Ntp call Ntpy(<f-args>)

"Zen coding keys
let g:user_zen_expandabbr_key = '<c-e>'
let g:use_zen_complete_tag = 1

"Pydiction - disabled for omnicompletion
"let g:pydiction_location = '~/.vim/pydiction/complete-dict' 

"**********************************************************
" Use Caps_Lock as Escape
" --- add to ~/.Xmodmap: ---
" remove Lock = Caps_Lock
" keysym Caps_Lock = Escape
"********************** Vim Sessions **********************

" http://github.com/briancarper/dotfiles/blob/master/.vimrc
" Use `:match none` to turn off the matches afterwards.
function! CountLines()
	let i = 0
	let s:regex = input("Regex>")
	execute('silent g/' . s:regex . '/let i = i + 1')
	execute("match Search /^.*" . s:regex . ".*$/")
	echo i . " lines match."
	norm ''
endfunction

" Indent fun
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >
vnoremap <S-Tab> <
