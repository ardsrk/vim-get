" -----------------------------------------------------------------------------
" | VIM Settings |
" | (see gvimrc for gui vim settings) |
" -----------------------------------------------------------------------------

let mapleader = ","
set wildmenu
set wildmode=list:longest,full
set autowriteall

" Show syntax highlighting groups for word under cursor
nmap <C-S-S> :call <SID>SynStack()<CR>
function! <SID>SynStack()
  if !exists("*synstack")
    return
  endif
  echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
endfunc

function! <SID>StripTrailingWhitespaces()
  " Preparation: save last search, and cursor position.
  let _s=@/
  let l = line(".")
  let c = col(".")
  " Do the business:
  %s/\s\+$//e
  " Clean up: restore previous search history, and cursor position
  let @/=_s
  call cursor(l, c)
endfunction

if has('autocmd')
  autocmd FileType html let g:html_indent_strict=1
  autocmd BufNewFile,BufRead {Gemfile,Rakefile,Vagrantfile,Thorfile,config.ru} setfiletype ruby
  autocmd BufNewFile,BufRead *.j setfiletype objc
  autocmd BufWritePre *.haml,*.erb,*.css,*.scss,*.sass,*.coffee,*.rb,*.py,*.js,Rakefile,Gemfile,*.md :call <SID>StripTrailingWhitespaces()
endif

set nocompatible  " We don't want vi compatibility.

" Shortcuts********************************************************************
nmap <silent> <unique> <leader>w :w<CR>
nmap <silent> <unique> <leader>W :wa<CR>
nmap <silent> <unique> <leader>x "*x
nmap <silent> <unique> <leader>p "*p
nmap <silent> <unique> <C-S-Down> :A<CR>
nmap <silent> <unique> <Space> <PageDown>
nmap <silent> <unique> <S-Space> <PageUp>
nmap <silent> <unique> <C-S-Left> <C-o>
nmap <silent> <unique> <C-S-Right> <C-i>
cnoremap %% <C-R>=expand('%:h').'/'<cr>
nmap <unique> <leader>ew :e %%
nmap <unique> <leader>es :sp %%
nmap <unique> <leader>ev :vsp %%
nmap <unique> <leader>et :tabe %%

nmap <unique> <s-tab> <c-o>

" Emacs style ctrl-a & ctrl-e in insert mode
inoremap <c-e> <c-r>=InsCtrlE()<cr>
function! InsCtrlE()
    try
        norm! i
        return "\<c-o>A"
    catch
        return "\<c-e>"
    endtry
endfunction
imap <C-a> <C-o>I

" Tabs ************************************************************************
"set sta " a <Tab> in an indent inserts 'shiftwidth' spaces

" Files, backups and undo******************************************************
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

"Persistent undo
try
  if MySys() == "windows"
    set undodir=C:\Windows\Temp
  else
    set undodir=~expand('$HOME/.vim/tmp')
  endif

  set undofile
catch
endtry

function! Tabstyle_tabs()
  " Using 4 column tabs
  set softtabstop=4
  set shiftwidth=4
  set tabstop=4
  set noexpandtab
  autocmd User Rails set softtabstop=4
  autocmd User Rails set shiftwidth=4
  autocmd User Rails set tabstop=4
  autocmd User Rails set noexpandtab
endfunction

function! Tabstyle_spaces()
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

if hostname() == "Laptop.local"
  call Tabstyle_tabs()
else
  call Tabstyle_spaces()
endif

" Indenting *******************************************************************
set ai " Automatically set the indent of a new line (local to buffer)
set si " smartindent  (local to buffer)

" Scrollbars ******************************************************************
set sidescrolloff=2
set numberwidth=4

" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

"Vertical split then hop to new buffer
noremap <leader>v :vsp<CR>
noremap <leader>h :split<CR>

" Cursor highlights ***********************************************************
set cursorline
"set cursorcolumn

" Searching *******************************************************************
set hlsearch " highlight search
set incsearch " incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase

" Colors **********************************************************************
"set t_Co=256 " 256 colors
syntax on " syntax highlighting
colorscheme camouflage

" Status Line *****************************************************************
set showcmd
set ruler " Show ruler
"set ch=2 " Make command line two lines high
set statusline=%<%F%h%m%r%h%w%y\ %{&ff}\ %{strftime(\"%d/%m/%Y-%H:%M\")}\ %{exists('g:loaded_rvm')?rvm#statusline():''}%=\ %l:%c%V\ %L\ %P
set laststatus=2

" Line Wrapping ***************************************************************
set nowrap
set linebreak " Wrap at word
set showbreak=…

" Mappings ********************************************************************
" Professor VIM says '87% of users prefer jj over esc', jj abrams strongly disagrees
imap jj <Esc>
imap uu _
imap hh =>
imap aa @

" Directories *****************************************************************
" Setup backup location and enable
"set backupdir=~/backup/vim
"set backup

" Set Swap directory
"set directory=~/backup/vim/swap

" Sets path to directory buffer was loaded from
"autocmd BufEnter * lcd %:p:h

" File Stuff ******************************************************************
filetype plugin indent on
" To show current filetype use: set filetype

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

autocmd FileType html set filetype=xhtml " we couldn't care less about html

" Inser New Line **************************************************************
map <S-Enter> O<ESC> " awesome, inserts new line without going into insert mode
map <Enter> o<ESC>
set fo-=r " do not insert a comment leader after an enter, (no work, fix!!)

" Sessions ********************************************************************
" Sets what is saved when you save a session
set sessionoptions=blank,buffers,curdir,folds,help,resize,tabpages,winsize

" Misc ************************************************************************
set backspace=indent,eol,start
set number " Show line numbers
set matchpairs+=<:>
set vb t_vb= " Turn off the bell, this could be more annoying, but I'm not sure how

" Set list Chars - for showing characters that are not
" normally displayed i.e. whitespace, tabs, EOL
nmap <unique><silent><leader>l :set list!<CR>
set listchars=tab:▸\ ,eol:¬

" Mouse ***********************************************************************
"set mouse=a " Enable the mouse
"behave xterm
"set selectmode=mouse

" " Cursor Movement *************************************************************
" " Make cursor move by visual lines instead of file lines (when wrapping)
" map <up> gk
" map k gk
" imap <up> <C-o>gk
" map <down> gj
" map j gj
" imap <down> <C-o>gj
" map E ge

" Ruby stuff ******************************************************************
compiler ruby " Enable compiler support for ruby
map <F5> :!ruby %<CR>

" Omni Completion *************************************************************
if has('autocmd')
  autocmd FileType html :set omnifunc=htmlcomplete#CompleteTags
  autocmd FileType python set omnifunc=pythoncomplete#Complete
  autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
  autocmd FileType css set omnifunc=csscomplete#CompleteCSS
  autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
  autocmd FileType php set omnifunc=phpcomplete#CompletePHP
  autocmd FileType c set omnifunc=ccomplete#Complete
  autocmd FileType ruby,eruby set omnifunc=rubycomplete#Complete " may require ruby compiled in
  autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1
  autocmd FileType ruby,eruby let g:rubycomplete_rails = 1
  autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
endif

" -----------------------------------------------------------------------------
" | Plugins |
" -----------------------------------------------------------------------------

" NERDTree ********************************************************************
nmap <silent> <unique> <leader>n :NERDTreeToggle<CR>
nmap <silent> <unique> <leader>/ :NERDTreeFind<CR>

" User instead of Netrw when doing an edit /foobar
let NERDTreeHijackNetrw=1

" Single click for everything
let NERDTreeMouseMode=1

" Ignoring java class files
let NERDTreeIgnore=['.class$', '\~$', '^cscope', 'tags']

" fuzzyfinder_textmate ********************************************************
nmap <silent> <leader>f :FufFile<CR>
nmap <silent> <leader>b :FufBuffer<CR>
let g:fuzzy_ignore = '.o;.obj;.bak;.exe;.pyc;.pyo;.DS_Store;.db'

" Rails.vim shortcuts *********************************************************
nmap <silent> <unique> <leader>s :.Rake<CR>
nmap <silent> <unique> <leader>S :Rake<CR>
nmap <silent> <unique> <leader>- :Rake -<CR>

" Fugitive ********************************************************************
autocmd BufReadPost fugitive://* set bufhidden=delete
autocmd BufReadPost *.fugitiveblame set bufhidden=delete
autocmd BufReadPost .git/* set bufhidden=delete

" yankring*********************************************************************
let g:yankring_history_dir = expand('$HOME/.vim/tmp')

" Command-T *******************************************************************
let g:CommandTMatchWindowAtTop = 1
set wildignore+=*~,.DS_Store,*.class,*.gif,*.png,*.sqlite3,cscope.*,tags

" Gundo ***********************************************************************
nmap <silent> <unique> <leader>u :GundoToggle<CR>

" autocomplpop ****************************************************************
" complete option
"set complete=.,w,b,u,t,k
"let g:AutoComplPop_CompleteOption = '.,w,b,u,t,k'
"set complete=.
let g:AutoComplPop_IgnoreCaseOption = 0
let g:AutoComplPop_BehaviorKeywordLength = 2

" Unimpaired configuration ****************************************************
" Bubble single lines
nmap <C-Up> [e
nmap <C-Down> ]e
" Bubble multiple lines
vmap <C-Up> [egv
vmap <C-Down> ]egv

" -----------------------------------------------------------------------------
" | OS Specific |
" | (GUI stuff goes in gvimrc) |
" -----------------------------------------------------------------------------

" Mac *************************************************************************
if has("mac")
endif

" Windows *********************************************************************
"if has("gui_win32")
""
"endif

" -----------------------------------------------------------------------------
" | Startup |
" -----------------------------------------------------------------------------
" Open NERDTree on start
"autocmd VimEnter * exe 'NERDTree' | wincmd l 

" Add recently accessed projects menu (project plugin)
filetype on  " Automatically detect file types.

" Minibuffer Explorer Settings
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1

set hid

" alt+n or alt+p to navigate between entries in QuickFix
map <silent><m-p> :cp <CR>
map <silent><m-n> :cn <CR>

" Change which file opens after executing :Rails command
let g:rails_default_file='config/database.yml'

syntax enable

filetype plugin on
set ofu=syntaxcomplete#Complete

