"
"     ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"     ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"     ██║   ██║██║██╔████╔██║██████╔╝██║
"     ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"      ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"       ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
"█▓▒░       this is Le Hung Thien's .vimrc     ░▒▓█
"
set nocompatible             " be the IMproved
set modelines=0              " security
set hidden                   " hide buffers, not close them
runtime macros/matchit.vim   " enable matchit plugin

" ┐ ┬o┌┌┐  ┬─┐┬  ┬ ┐┌─┐
" │┌┘││││  │─┘│  │ ││ ┬
" └┘ ┆┘ ┆  ┆  ┆─┘┆─┘┆─┘
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes
Plug 'scrooloose/nerdtree'

"█▓▒░ color themes
Plug 'marfisc/vorange'
Plug 'NLKNguyen/papercolor-theme'
Plug 'reedes/vim-colors-pencil'
Plug 'romainl/apprentice'
Plug 'tomasr/molokai'
Plug 'altercation/vim-colors-solarized'
Plug 'chriskempson/base16-vim'
Plug 'nanotech/jellybeans.vim'
Plug 'w0ng/vim-hybrid'
Plug 'xero/sourcerer.vim'
Plug 'morhetz/gruvbox'
Plug 'fcpg/vim-orbital'
Plug 'whatyouhide/vim-gotham'
Plug 'itchyny/lightline.vim'

" configuration for lightline
let g:lightline = {
            \ 'colorscheme' : 'gruvbox',
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

" mapping for Plug update
noremap <F10> :PlugUpdate<CR>

" automatic closing of quotes, parenthesis, brackets, etc.
Plug 'raimondi/delimitmate'

" perform all your vim insert mode completions with <tab>
Plug 'ervandew/supertab'

" vim surround
Plug 'tpope/vim-surround'

" comment stuff out
Plug 'tpope/vim-commentary'

" 'a git wrapper so awesome, it should be illegal'
Plug 'tpope/vim-fugitive'

" display the indention levels with thin vertical lines
Plug 'yggdroot/indentline'
let g:indentLine_char = '.'

" javascript bundle for vim
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'typescript']}
let g:javascript_plugin_jsdoc = 1 " enable JSDoc
let g:javascript_plugin_ngdoc = 1 " enable NGDoc
let g:javascript_plugin_flow = 1  " enable Flow

" typescript syntax files for vim
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}

" vim motions on speed
Plug 'easymotion/vim-easymotion'

" active fork of kien/ctrlp
Plug 'ctrlpvim/ctrlp.vim'

" emmet for vim
Plug 'mattn/emmet-vim'

" start a * or # search from a visual block
Plug 'nelstrom/vim-visual-star-search'

" color hex codes and color names
Plug 'chrisbra/colorizer', {'on': 'ColorToggle'}
" do not colorize colornames
let g:colorizer_colornames = 0

" a collection of language packs for vim
Plug 'sheerun/vim-polyglot'
" default highlight is better than polyglot
let g:polyglot_disabled = ['python']
let python_highlight_all = 1

" syntax checker
Plug 'scrooloose/syntastic', {'on': 'SyntasticCheck'}

" python autocomplete
Plug 'davidhalter/jedi-vim'

" syntax highlight for requirements.txt
Plug 'raimon49/requirements.txt.vim'

" git diff in the gutter
Plug 'airblade/vim-gitgutter'

if v:version >= 704
    " snippets!!!
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    let g:UltiSnipsExpandTrigger="<tab>"
    let g:UltiSnipsJumpForwardTrigger="<tab>"
    let g:UltiSnipsJumpBackwardTrigger="<c-b>"
    let g:UltiSnipsEditSplit="vertical"
endif

" unix-based only
if !exists("g:os")
    if has('unix')
        " ack plugin
        Plug 'mileszs/ack.vim'
    elseif has('win32')
        " syntax highlight for powershell
        Plug 'pprovost/vim-ps1'
    endif
endif

"█▓▒░ all of plugins must be added before the following line
call plug#end()

" ┬─┐┬─┐┬─┐┐─┐┌─┐┌┐┐┬─┐┬    ┐─┐┬─┐┌┐┐┌┐┐o┌┐┐┌─┐┐─┐
" │─┘├─ │┬┘└─┐│ │││││─┤│    └─┐├─  │  │ │││││ ┬└─┐
" ┆  ┴─┘┆└┘──┘┘─┘┆└┘┘ ┆┆─┘  ──┘┴─┘ ┆  ┆ ┆┆└┘┆─┘──┘
"█▓▒░ interface settings
set encoding=utf-8  " encoding used for displaying file
set ruler           " show the cursor position all the time
set showmatch       " highlight matching braces
set showmode        " show insert/replace/visual mode
set t_Co=256        " capable of displaying 256 colors
set laststatus=2    " always display the status line in all windows
set wrap            " always wrap long lines
set guioptions-=r   " hide the right scroll bar
set guioptions-=L   " hide the left scroll bar
set foldenable      " enable code folding
syntax on           " syntax highlight for java

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

set autoread                        " auto read changed file
set autowrite                       " auto write changed to file

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

" configurations for tab completion menu
set wildmenu
set wildmode=list:longest,full
set wildignorecase

" clipboard
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

"█▓▒░ colorscheme and background
colorscheme gruvbox             " colorscheme
set background=dark             " dark background

"█▓▒░ tuning for gVim base on environment
if has('gui_running')
    set number                  " show line numbers

    if has("gui_gtk2")          " Linux
        set guifont=Inconsolata:h12
    elseif has("gui_macvim")    " macvim
        " set guifont=GohuFont:h14
        set guifont=Iosevka:h14
    elseif has("gui_win32")     " windows
        set guifont=Consolas:h11:cANSI
    endif
endif

"
" ┬┌ ┬─┐┐ ┬  ┌┌┐┬─┐┬─┐┬─┐o┌┐┐┌─┐┐─┐
" ├┴┐├─ └┌┘  ││││─┤│─┘│─┘│││││ ┬└─┐
" ┆ ┘┴─┘ ┆   ┘ ┆┘ ┆┆  ┆  ┆┆└┘┆─┘──┘
"
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

" press F12 to toggle showing the non-printable characters
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
" invariably hit constantly while aiming for escape
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

" clear the search buffer when hitting return
nnoremap <silent> <CR> :<C-u>nohlsearch<CR>

" mappings to quickly traverse vim's buffer lists
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> [B :blast<CR>
" close buffer
noremap <leader>q :bd<CR>

" count the number of search matches
nnoremap <silent> <Leader>c :%s///gn<CR>n

" set working directory
nnoremap <leader>. :lcd %:p:h<CR>

"█▓▒░ abbreviations: no one is really happy until you have this shortcuts
cnoreabbrev W! w!
cnoreabbrev Q! q!
cnoreabbrev Qall! qall!
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev wQ wq
cnoreabbrev WQ wq
cnoreabbrev W w
cnoreabbrev Q q
cnoreabbrev Qall qall

" ┬─┐┬ ┐┌┐┐┌─┐┌─┐┌┌┐┬─┐  ┬─┐┬ ┐┬  ┬─┐┐─┐
" │─┤│ │ │ │ ││  ││││ │  │┬┘│ ││  ├─ └─┐
" ┘ ┆┆─┘ ┆ ┘─┘└─┘┘ ┆┆─┘  ┆└┘┆─┘┆─┘┴─┘──┘
" the PC is fast enough, do syntax highlight syncing from start unless 200 lines
augroup vimrc-sync-fromstart
    autocmd!
    autocmd BufEnter * :syntax sync maxlines=200
augroup END

" remember cursor position
augroup vimrc-remember-cursor-position
    autocmd!
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif
augroup END

if has('autocmd')
    " don't replace tabs with spaces when editing makefiles
    autocmd Filetype makefile setlocal noexpandtab

    " disable automatic code indentation for TeX and XML files
    autocmd FileType tex,xml setlocal indentexpr=

    " clean-up commands that run automatically on write
    " USE WITH CAUTION
    " delete empty or white spaces-only lines at the end of file
    autocmd BufWritePre * :%s/\(\s*\n\)\+\%$//ge

    " replace groups of empty or white spaces-only lines
    " with an empty line
    autocmd BufWritePre * :%s/\(\s*\n\)\{3,}/\r\r/ge

    " delete any trailing white spaces
    autocmd BufWritePre * :%s/\s\+$//ge
endif

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
