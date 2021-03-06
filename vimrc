set nocompatible
source $VIMRUNTIME/mswin.vim

call pathogen#infect()

filetype plugin indent on
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
set expandtab
set tabstop=2
set shiftwidth=2
set nobackup
set nowritebackup
set autoread
set listchars=eol:\ ,tab:>-,trail:.,extends:>,nbsp:_ 
set nowrap
"http://stackoverflow.com/questions/63104/smarter-vim-recovery"
set directory=~/.vim/swap//

if has('mac')
  set clipboard=unnamed " won't clobber clipboard unnecessarily
else
  if has('autoselect')
    set clipboard=unnamedplus,autoselect " Use + register (X Window clipboard) as unnamed register
  else 
    set clipboard=unnamedplus
  endif
endif
" change cwd to root NERDTree directory
let NERDTreeChDirMode=2
" ignore pyc files
let NERDTreeIgnore=['\.pyc$','\~$','\~$']

" Inspired by http://github.com/ciaranm/dotfiles-ciaranm/tree/master
set statusline=%f\ %2*%m\ %1*%h%r%=[%{&encoding}\ %{&fileformat}\ %{strlen(&ft)?&ft:'none'}\ %{getfperm(@%)}]\ 0x%B\ %12.(%c:%l/%L%)

" vim airline
set laststatus=2

" vim-taskwarrior

let g:task_default_prompt  = ['project', 'description']

" Uncomment the following to have Vim jump to the last position when
" reopening a file
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal g'\"" | endif
endif

"************************* Styles *************************
if has('gui_running')
  colorscheme kellys
  set lines=55 columns=125
  if has('mac')
    set guifont=Menlo
  else
    set guifont=Monospace\ 9
  endif
  set guioptions-=T " remove toolbar
else
  colorscheme winter
endif

function! DisplayColorSchemes()
   let currDir = getcwd()
   exec "cd $VIMRUNTIME/colors"
   for myCol in split(glob("*"), '\n')
      if myCol =~ '\.vim'
         let mycol = substitute(myCol, '\.vim', '', '')
         exec "colorscheme " . mycol
         exec "redraw!"
         echo "colorscheme = ". myCol
         sleep 2
      endif
   endfor
   exec "cd " . currDir
endfunction

"************************* NeoVIM *************************
if has('nvim')
  colorscheme slate
endif

"************************* Python *************************
let $DJANGO_SETTINGS_MODULE='settings'

if has('python') "requires inline python
  " Open NERDTree to the home directory for a python module
  function! Ntpy(module)
  
python << ____EOF
import vim, os.path
module = __import__(vim.eval('a:module'))
path = os.path.dirname(os.path.realpath(module.__file__[:-1]))
vim.command("let l:pymod_path='NERDTree %s'" % path)

____EOF

  exec l:pymod_path
  endfunction

  " Python tweaks
  " http://sontek.net/python-with-a-modular-ide-vim

python << ____EOF

import os
import sys
import vim
for p in sys.path:
  if os.path.isdir(p):
    vim.command(r"set path+=%s" % (p.replace(" ", r"\ ")))

____EOF

  " run this first:
  " $ ctags -R -f ~/.vim/tags/python.ctags /usr/lib/python2.6/
  set tags+=$HOME/.vim/tags/python.ctags
endif "has python

set tags=tags;/

" Use CTRL + Left and CTRL + Right to move between ctagged files
noremap <silent><C-Left> <C-T>
noremap <silent><C-Right> <C-]>

"************************ Mappings ************************
"CTags
"--------------------
" Function: Open tag under cursor in new tab
" Source:   http://stackoverflow.com/questions/563616/vimctags-tips-and-tricks
"--------------------
noremap <C-\> :tab split<CR>:exec("tag ".expand("<cword>"))<CR>
"--------------------
" Function: Open tag in a vertical split
" Source:   http://stackoverflow.com/questions/563616/vimctags-tips-and-tricks
"--------------------
noremap <A-]> :vsp <CR>:exec("tag ".expand("<cword>"))<CR> 
" Function: we are about to remap the C-T tag pop command
" so let's remap it to something else

noremap <C-Y> :pop<CR>

"--------------------
" Function: Remap keys to make it more similar to firefox tab functionality
" Purpose:  Because I am familiar with firefox tab functionality
"--------------------
noremap     <C-T>       :tabnew<CR>
noremap     <C-N>       :!gvim &<CR><CR>
"map     <C-W>       :confirm bdelete<CR>

noremap nt :NERDTree
noremap tbn :tabnew
noremap bt :browse tabnew

" remap Ctrl-Space to autocomplete (normally Ctrl+X Ctrl+O)
inoremap <Nul> <C-x><C-o>

command! -nargs=* Ntp call Ntpy(<f-args>)
command! Q q

let g:user_emmet_expandabbr_key = '<c-e>'
let g:use_emmet_complete_tag = 1

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

function! Pwd()
    let path=expand('%:h')
    return system('cd "' . path . '"; pwd -L')
endfunction! 

" Indent fun
vnoremap > >gv
vnoremap < <gv
vnoremap <Tab> >
vnoremap <S-Tab> <

" add a disable/enable flag
" verify that that file is present in the url or as a resource on the page etc. 
" expand("%:t") returns the filename
"
" for now this is disabled, it was nice to use but quite a pain to setup
" both firefox and this setting
""autocmd BufWriteCmd *.html,*.css,*.jss :call Refresh_firefox()
function! Refresh_firefox()
  ""if &modified
    ""write
    silent !echo  'vimYo = content.window.pageYOffset;
          \ vimXo = content.window.pageXOffset;
          \ BrowserReload();
          \ content.window.scrollTo(vimXo,vimYo);
          \ repl.quit();'  |
          \ nc -w 1 localhost 4242 2>&1 > /dev/null
  ""endif
endfunction
nnoremap <silent> <leader>r :call Refresh_firefox()<CR>

command! -nargs=1 Repl silent !echo
      \ "repl.home();
      \ content.location.href = '<args>';
      \ repl.enter(content);
      \ repl.quit();" |
      \ nc localhost 4242

nnoremap <leader>mh :Repl http://
" mnemonic is MozRepl Http
nnoremap <silent> <leader>ml :Repl file:///%:p<CR>
" mnemonic is MozRepl Local
nnoremap <silent> <leader>md :Repl http://localhost/
" mnemonic is MozRepl Development

" pasting into from an external source can cause funky formatting
" call :set paste first, then :set nopaste after pasting
" toggle case
nnoremap <C-u> g~iw
inoremap <C-u> <esc>g~iwea

" edit and source vimrc
nnoremap <silent> <leader>ev :e $MYVIMRC<CR>
nnoremap <silent> <leader>sv :so $MYVIMRC<CR>

" some strategy with this would be nice: http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
"cd %:p:h " cd to the directory of the current file

nnoremap <silent> <leader>tomap :%!~/scripts/tomap.py<CR>

nnoremap <leader>j :%!python -m json.tool<CR>

au BufNewFile,BufRead *.gradle set filetype=groovy

" add fzf fuzzy search plugin
set rtp+=/usr/local/opt/fzf

" sql format plugin

vmap <silent>sf        <Plug>SQLU_Formatter<CR>
nmap <silent>scl       <Plug>SQLU_CreateColumnList<CR>
nmap <silent>scd       <Plug>SQLU_GetColumnDef<CR>
nmap <silent>scdt      <Plug>SQLU_GetColumnDataType<CR>
nmap <silent>scp       <Plug>SQLU_CreateProcedure<CR>

" xml format
au FileType xml setlocal equalprg=xmllint\ --format\ --recover\ -\ 2>/dev/null


" quote lines for sql

nnoremap <F2> :%s/^\([a-zA-Z0-9\-]\+\)$/'\1',/g<CR>G$x`'

" tabularize tsv

nnoremap <F5> {:Tabularize /\t<CR>
inoremap <F5> <esc>{:Tabularize /\t<CR>

" vimwiki configuration
let g:vimwiki_list = [{'path': '~/vimwiki/', 'syntax': 'markdown', 'ext': '.md'}]

" number list update: let i=1 | g/^\d\+/s//\=''.i/ | let i=i+1

