"  __   __   __     __    __     ______     ______
" /\ \ / /  /\ \   /\ "-./  \   /\  == \   /\  ___\
" \ \ \'/   \ \ \  \ \ \-./\ \  \ \  __<   \ \ \____
"  \ \__|    \ \_\  \ \_\ \ \_\  \ \_\ \_\  \ \_____\
"   \/_/      \/_/   \/_/  \/_/   \/_/ /_/   \/_____/
"
"█▓▒░       this is Le Hung Thien's .vimrc     ░▒▓█
"
set nocompatible             " be the IMproved
set modelines=0              " security
set hidden                   " hide buffers, not close them
runtime macros/matchit.vim   " enable matchit plugin

"
" ┐ ┬┬ ┐┌┐┐┬─┐┬  ┬─┐
" │┌┘│ │││││ ││  ├─
" └┘ ┆─┘┆└┘┆─┘┆─┘┴─┘
"

" set the runtime path to include Vundle and initialize
if !exists("g:os")
    if has('win64') || has('win32') || has('win16')
        " sometimes you just have to deal with Windows ¯\_(ツ)_/¯
        set rtp+=$HOME/vimfiles/bundle/Vundle.vim/
        call vundle#begin('$USERPROFILE/vimfiles/bundle/')
    else
        " macOS and linux
        set rtp+=~/.vim/bundle/Vundle.vim
        call vundle#begin()
    endif
endif

filetype off " required, will be on again when Vundle is completed

"
" ┬─┐┬  ┬ ┐┌─┐o┌┐┐┐─┐
" │─┘│  │ ││ ┬││││└─┐
" ┆  ┆─┘┆─┘┆─┘┆┆└┘──┘
"

"█▓▒░ let Vundle manage Vundle
Plugin 'VundleVim/Vundle.vim' " required

"█▓▒░ color themes
Plugin 'marfisc/vorange'
Plugin 'NLKNguyen/papercolor-theme'
Plugin 'reedes/vim-colors-pencil'
Plugin 'romainl/apprentice'
Plugin 'tomasr/molokai'
Plugin 'altercation/vim-colors-solarized'
Plugin 'chriskempson/base16-vim'
Plugin 'nanotech/jellybeans.vim'
Plugin 'w0ng/vim-hybrid'
Plugin 'xero/sourcerer.vim'
Plugin 'morhetz/gruvbox'
Plugin 'fcpg/vim-orbital'

" vim airline
Plugin 'itchyny/lightline.vim'

let g:lightline = {
            \ 'colorscheme' : 'darcula',
            \ 'active': {
            \   'left': [ [ 'filename' ],
            \             [ 'readonly', 'fugitive' ] ],
            \   'right': [ [ 'percent', 'lineinfo' ],
            \              [ 'fileencoding', 'filetype' ],
            \              [ 'fileformat', 'syntastic' ] ]
            \ },
            \ 'component_function': {
            \   'modified': 'WizMod',
            \   'readonly': 'WizRO',
            \   'fugitive': 'WizGit',
            \   'filename': 'WizName',
            \   'filetype': 'WizType',
            \   'fileformat' : 'WizFormat',
            \   'fileencoding': 'WizEncoding',
            \   'mode': 'WizMode',
            \ },
            \ 'component_expand': {
            \   'syntastic': 'SyntasticStatuslineFlag',
            \ },
            \ 'component_type': {
            \   'syntastic': 'error',
            \ },
            \ 'separator': { 'left': '▓▒░', 'right': '░▒▓' },
            \ 'subseparator': { 'left': '▒', 'right': '░' }
            \ }

function! WizMod()
    return &ft =~ 'help\|vimfiler' ? '' : &modified ? '»' : &modifiable ? '' : ''
endfunction

function! WizRO()
    return &ft !~? 'help\|vimfiler' && &readonly ? 'x' : ''
endfunction

function! WizGit()
    if &ft !~? 'help\|vimfiler' && exists("*fugitive#head")
        return fugitive#head()
    endif
    return ''
endfunction

function! WizName()
    return ('' != WizMod() ? WizMod() . ' ' : '') .
                \ ('' != expand('%:t') ? expand('%:t') : '[none]')
endfunction

function! WizType()
    return winwidth(0) > 70 ? (strlen(&filetype) ? &filetype : '') : ''
endfunction

function! WizFormat()
    return ''
endfunction

function! WizEncoding()
    return winwidth(0) > 70 ? (strlen(&fenc) ? &enc : &enc) : ''
endfunction

" tree explorer plugin
Plugin 'scrooloose/nerdtree'

" automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'raimondi/delimitmate'

" perform all your vim insert mode completions with <tab>
Bundle 'ervandew/supertab'

" vim suround
Plugin 'tpope/vim-surround'

" comment stuff out.
Plugin 'tpope/vim-commentary'

" visulize vim undo tree
Plugin 'sjl/gundo.vim'
nnoremap <leader>u :GundoToggle<CR>

" a parser for a condensed HTML format
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" 'a git wrapper so awesome, it should be illegal'
Plugin 'tpope/vim-fugitive'

" display the indention levels with thin vertical lines
Plugin 'yggdroot/indentline'
let g:indentLine_char = '.'

" javascript bundle for vim
Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1 " enable JSDoc
let g:javascript_plugin_ngdoc = 1 " enable NGDoc
let g:javascript_plugin_flow = 1  " enable Flow

" vim motions on speed!
Plugin 'easymotion/vim-easymotion'

" active fork of kien/ctrlp
Plugin 'ctrlpvim/ctrlp.vim'

" emmet for vim
Plugin 'mattn/emmet-vim'

" tagbar plugin
Plugin 'majutsushi/tagbar'
nmap <leader>tb :TagbarToggle<CR>

" better syntax highlighting for java
Plugin 'sentientmachine/erics_vim_syntax_and_color_highlighting'

" unix-based only
if !exists("g:os")
    if has('unix')
        " snippets configurations
        Plugin 'sirver/ultisnips'   " the engine
        Plugin 'honza/vim-snippets' " the actual snippets

        " set the tmux status bar color using airline/powerline
        Plugin 'edkolev/tmuxline.vim'

        " ack plugin
        Plugin 'mileszs/ack.vim'
        nnoremap <leader>a :Ack

        " syntax checker
        Plugin 'scrooloose/syntastic'
    elseif has('win32')
        " syntax highlight for powershell
        Plugin 'pprovost/vim-ps1'
    endif
endif

"█▓▒░ all of plugins must be added before the following line
call vundle#end()            " required

" ┬─┐┬─┐┬─┐┐─┐┌─┐┌┐┐┬─┐┬    ┐─┐┬─┐┌┐┐┌┐┐o┌┐┐┌─┐┐─┐
" │─┘├─ │┬┘└─┐│ │││││─┤│    └─┐├─  │  │ │││││ ┬└─┐
" ┆  ┴─┘┆└┘──┘┘─┘┆└┘┘ ┆┆─┘  ──┘┴─┘ ┆  ┆ ┆┆└┘┆─┘──┘

"█▓▒░ interface settings
set encoding=utf-8  " encoding used for displaying file
set ruler           " show the cursor position all the time
set showmatch       " highlight matching braces
set showmode        " show insert/replace/visual mode
set t_Co=256        " capable of displaying 256 colors
set laststatus=2    " always display the statusline in all windows
set wrap            " always wrap long lines
set guioptions-=r   " hide the right scroll bar
set guioptions-=L   " hide the left scroll bar
set foldenable      " enable code folding

"█▓▒░ read/write settings
set confirm                         " confirm :q for unsaved changes
set fileencoding=utf-8              " encoding used when saving file
set undofile                        " keep the undo files
set backup                          " keep the backup~ file
set noswapfile                      " it's <current year>, vim!
set undodir=~/.vim/tmp/undo//       " undo files folder
set backupdir=~/.vim/tmp/backup//   " backups folder
set directory=~/.vim/tmp/swap//     " swap files folder

" make those folders automatically if they don't already exist.
if !isdirectory(expand(&undodir))
    call mkdir(expand(&undodir), "p")
endif
if !isdirectory(expand(&backupdir))
    call mkdir(expand(&backupdir), "p")
endif
if !isdirectory(expand(&directory))
    call mkdir(expand(&directory), "p")
endif

set autoread
set autowrite
" au FocusLost * :wa

"█▓▒░ edit settings
set backspace=indent,eol,start  " backspacing over everything
set expandtab                   " fill tabs with spaces
set nojoinspaces                " no space after '.' when joining
set shiftwidth=4                " set indentation depth to 4 columns
set softtabstop=4               " backspacing over 4 spaces
set tabstop=4                   " set tabulator length to 4 columns
set relativenumber              " show relative line number

"█▓▒░ search settings
set hlsearch    " highlight search results
set incsearch   " do incremental search
set ignorecase  " do case insensitive search...
set smartcase   " ...unless capital letters are used

"█▓▒░ other settings
filetype on         " enable file type detection
filetype plugin on  " load the plugins for specific file types
filetype indent on  " automatically indent code
syntax enable       " enable syntax highlighting
" displaying non-printable characters
set listchars=eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+
" don't try to highlight lines longer than 800 characters.
set synmaxcol=800
" highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'
set wildmode=longest,list,full
set wildignorecase

"█▓▒░ colorscheme and backgroud
colorscheme PaperColor          " colorscheme
set background=dark             " dark background

"█▓▒░ tuning for gvim base on environment
if has('gui_running')
    " if has GUI running
    set number                  " show line numbers

    if has("gui_gtk2")          " linux
        set guifont=Inconsolata:h12
    elseif has("gui_macvim")    " macvim
        set guifont=GohuFont:h14
        colorscheme sourcerer

        let g:lightline = {
                    \ 'colorscheme' : 'sourcerer',
                    \ 'active': {
                    \   'left': [ [ 'filename' ],
                    \             [ 'readonly', 'fugitive' ] ],
                    \   'right': [ [ 'percent', 'lineinfo' ],
                    \              [ 'fileencoding', 'filetype' ],
                    \              [ 'fileformat', 'syntastic' ] ]
                    \ },
                    \ 'component_function': {
                    \   'modified': 'WizMod',
                    \   'readonly': 'WizRO',
                    \   'fugitive': 'WizGit',
                    \   'filename': 'WizName',
                    \   'filetype': 'WizType',
                    \   'fileformat' : 'WizFormat',
                    \   'fileencoding': 'WizEncoding',
                    \   'mode': 'WizMode',
                    \ },
                    \ 'component_expand': {
                    \   'syntastic': 'SyntasticStatuslineFlag',
                    \ },
                    \ 'component_type': {
                    \   'syntastic': 'error',
                    \ },
                    \ 'separator': { 'left': '▓▒░', 'right': '░▒▓' },
                    \ 'subseparator': { 'left': '▒', 'right': '░' }
                    \ }
    elseif has("gui_win32")     " windows
        set guifont=Consolas:h11:cANSI
        colorscheme vorange      " set color scheme
    endif
endif

"█▓▒░ automatic commands
if has('autocmd')
    " don't replace tabs with spaces when editing makefiles
    autocmd Filetype makefile setlocal noexpandtab

    " disable automatic code indentation for TeX and XML files
    autocmd FileType tex,xml setlocal indentexpr=

    " clean-up commands that run automatically on write
    " USE WITH CAUTION
    " delete empty or whitespaces-only lines at the end of file
    autocmd BufWritePre * :%s/\(\s*\n\)\+\%$//ge

    " replace groups of empty or whitespaces-only lines
    " with an empty line
    autocmd BufWritePre * :%s/\(\s*\n\)\{3,}/\r\r/ge

    " delete any trailing whitespaces
    autocmd BufWritePre * :%s/\s\+$//ge
endif

"
" ┬┌ ┬─┐┐ ┬  ┌┌┐┬─┐┬─┐┬─┐o┌┐┐┌─┐┐─┐
" ├┴┐├─ └┌┘  ││││─┤│─┘│─┘│││││ ┬└─┐
" ┆ ┘┴─┘ ┆   ┘ ┆┘ ┆┆  ┆  ┆┆└┘┆─┘──┘
"
" jk is escape
inoremap jk <esc>

" center view on the search result
noremap n nzz
noremap N Nzz

" F4 to fix indentation in whole file
noremap <F4> mqgg=G`qzz
" overwrites marker 'q' position
inoremap <F4> <Esc>mqgg=G`qzza

" F5 to sort selection or paragraph
vnoremap <F5> :sort i<CR>
nnoremap <F5> Vip:sort i<CR>

" press f12 to toggle showing the non-printable charactes
noremap <F12> :set list!<CR>
inoremap <F12> <Esc>:set list!<CR>a

" remap the <Leader> and set it's timeout
let mapleader=","
set timeout timeoutlen=1500

" makes j and k work the way you expect
" instead of working in some archaic
" 'movement by file line instead of screen line' fashion.
nnoremap j gj
nnoremap k gk

" get rid of that stupid goddamned help key that you will
" invaribly hit constantly while aiming for escape
inoremap <F1> <ESC>
nnoremap <F1> <ESC>
vnoremap <F1> <ESC>

" re-select the text that was just pasted (to perform actions on it)
nnoremap <leader>v V`]

" quickly open up ~/.vimrc file in a vertically split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" quickly open up ~/.zshrc file in a vertically split window
nnoremap <leader>ez :e ~/.zshrc<cr>

" open a new split window and switch over to it
nnoremap <leader>w <C-w>v<C-w>l

" move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" [S]plit line (sister to [J]oin lines)
nnoremap S i<cr><esc><right>

" bubble single lines
nmap <C-k> ddkP
nmap <C-j> ddp
" bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" clear the search buffer when hitting return
" nnoremap <CR> :nohlsearch<cr>
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" mappings to quickly traverse vim's lists
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> [B :blast<CR>

" press * to find current selection in visual mode
" as in tip 86, page 212 of pragmatic practical vim
xnoremap * :<C-u>call <SID>VSetSearch()<CR>/<C-R>=@/<CR><CR>
xnoremap # :<C-u>call <SID>VSetSearch()<CR>?<C-R>=@/<CR><CR>

function! s:VSetSearch()
  let temp = @s
  norm! gv"sy
  let @/ = '\V' . substitute(escape(@s, '/\'), '\n', '\\n', 'g')
  let @s = temp
endfunction

" count the number of search matches
nnoremap <silent> <Leader>c :%s///gn<CR>

"█▓▒░ auto-reload .vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    call lightline#init()
    call lightline#enable()
augroup END " }

"
" ┌┐┐┬ ┬┬─┐  ┬─┐┌┐┐┬─┐
"  │ │─┤├─   ├─ ││││ │
"  ┆ ┆ ┴┴─┘  ┴─┘┆└┘┆─┘
