" -----------------------------------------------------------------------------
" | VIM Settings |
" | (see gvimrc for gui vim settings) |
" -----------------------------------------------------------------------------

set nocompatible  " We don't want vi compatibility.

let mapleader = ","
let maplocalleader = "\\"
set wildmenu
set wildmode=list:longest,full
set autowriteall
set autoread

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
  augroup buffer_filetype_autocmds
    au!
    autocmd FileType html let g:html_indent_strict=1
    autocmd FileType xml exe ":silent %!xmllint --format --recover - 2>/dev/null"
    autocmd BufEnter {Gemfile,Rakefile,Guardfile,Capfile,Vagrantfile,Thorfile,config.ru,*.rabl} setfiletype ruby
    autocmd BufEnter *.md setfiletype markdown
    autocmd BufWritePre ?* :call <SID>StripTrailingWhitespaces()
    autocmd BufLeave,FocusLost ?* nested :wa
    autocmd BufReadPost #* set bufhidden=delete
  augroup END
endif

" Shortcuts********************************************************************
nmap <silent> <unique> <leader>w :wa<CR>
nmap <silent> <unique> <leader>W :wa<CR>
nmap <silent> <unique> <Space> <PageDown>
nmap <silent> <unique> <S-Space> <PageUp>
nmap <silent> <unique> <C-S-Left> <C-o>
nmap <silent> <unique> <C-S-Right> <C-i>

nnoremap <unique> <C-h> <C-w>h
nnoremap <unique> <C-j> <C-w>j
nnoremap <unique> <C-k> <C-w>k
nnoremap <unique> <C-l> <C-w>l

" Help
autocmd FileType help :nmap <silent> q :q<cr>

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

" Files, backups and undo******************************************************
" Turn backup off, since most stuff is in SVN, git anyway...
set nobackup
set nowb
set noswapfile

" Highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

nnoremap <C-u> gUiw
inoremap <C-u> <esc>gUiwea

" Split line (sister to [J]oin lines)
" The normal use of S is covered by cc, so don't worry about shadowing it.
nnoremap S i<cr><esc><right>

" Better Completion
set completeopt=menu,longest,preview

function! Tabstyle_spaces()
  " Use 2 spaces
  set softtabstop=2
  set shiftwidth=2
  set tabstop=2
  set expandtab
endfunction

call Tabstyle_spaces()

" Windows *********************************************************************
set equalalways " Multiple windows, when created, are equal in size
set splitbelow splitright

" Indenting *******************************************************************
set autoindent " Automatically set the indent of a new line (local to buffer)
set smartindent " smartindent  (local to buffer)

" Scrollbars ******************************************************************
set sidescrolloff=2
set numberwidth=4

" Cursor highlights ***********************************************************
au WinLeave * set nocursorline nocursorcolumn
au WinEnter * set cursorline cursorcolumn
set cursorline cursorcolumn

" Searching *******************************************************************
set hlsearch " highlight search
nmap <silent><unique> <C-esc> :nohl<cr>
set incsearch " incremental search, search as you type
set ignorecase " Ignore case when searching
set smartcase " Ignore case when searching lowercase

" Colors **********************************************************************
"set t_Co=256 " 256 colors
syntax on " syntax highlighting
colorscheme camouflage

" Status Line *****************************************************************
set showcmd
set laststatus=2

" Line Wrapping ***************************************************************
set nowrap
set linebreak " Wrap at word
set showbreak=…

" Mappings ********************************************************************
imap hh =>

" File Stuff ******************************************************************
filetype plugin indent on
" To show current filetype use: set filetype

" Remember last location in file
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif
endif

autocmd FileType html set filetype=xhtml " we couldn't care less about html

" Insert New Line **************************************************************
map <Enter> o<ESC>

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

" " Cursor Movement *************************************************************
" " Make cursor move by visual lines instead of file lines (when wrapping)
map <up> gk
map k gk
" imap <up> <C-o>gk # uncomment at your own risk. it interferes with Fuf.
map <down> gj
map j gj

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

" Rails.vim shortcuts *********************************************************
nmap <silent> <unique> <leader>s :.Rake<CR>
nmap <silent> <unique> <leader>S :Rake<CR>
nmap <silent> <unique> <leader>- :Rake -<CR>

" Ctrl-P **********************************************************************
let g:ctrlp_dont_split = 'NERD_tree_2'
let g:ctrlp_jump_to_buffer = 0
let g:ctrlp_map = '<leader>p'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_match_window_reversed = 1
let g:ctrlp_split_window = 0
let g:ctrlp_max_height = 20
let g:ctrlp_extensions = ['tag']

let g:ctrlp_prompt_mappings = {
\ 'PrtSelectMove("j")':   ['<c-j>', '<down>', '<s-tab>'],
\ 'PrtSelectMove("k")':   ['<c-k>', '<up>', '<tab>'],
\ 'PrtHistory(-1)':       ['<c-n>'],
\ 'PrtHistory(1)':        ['<c-p>'],
\ 'ToggleFocus()':        ['<c-tab>'],
\ }

let ctrlp_filter_greps = "".
    \ "egrep -iv '\\.(" .
    \ "swp|swo|log|so|o|pyc|jpe?g|png|gif|mo|po" .
    \ ")$' | " .
    \ "egrep -v '^(\\./)?(" .
    \ "libs/|deploy/vendor/|.git/|.hg/|.svn/|.*migrations/" .
    \ ")'"

let my_ctrlp_user_command = "" .
    \ "find %s '(' -type f -or -type l ')' -maxdepth 15 -not -path '*/\\.*/*' | " .
    \ ctrlp_filter_greps

let my_ctrlp_git_command = "" .
    \ "cd %s && git ls-files && git ls-files -o | " .
    \ ctrlp_filter_greps

let g:ctrlp_user_command = ['.git/', my_ctrlp_git_command, my_ctrlp_user_command]

nnoremap <leader>t :CtrlPTag<cr>
nnoremap <leader>b :CtrlPBuffer<cr>

" Ack *************************************************************************
map <leader>a :Ack!

" autocomplpop ****************************************************************
let g:AutoComplPop_IgnoreCaseOption = 0
let g:AutoComplPop_BehaviorKeywordLength = 2

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
