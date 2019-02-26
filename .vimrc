"
"      ██╗   ██╗██╗███╗   ███╗██████╗  ██████╗
"      ██║   ██║██║████╗ ████║██╔══██╗██╔════╝
"      ██║   ██║██║██╔████╔██║██████╔╝██║
"      ╚██╗ ██╔╝██║██║╚██╔╝██║██╔══██╗██║
"       ╚████╔╝ ██║██║ ╚═╝ ██║██║  ██║╚██████╗
"        ╚═══╝  ╚═╝╚═╝     ╚═╝╚═╝  ╚═╝ ╚═════╝
"
" █▓▒░       this is Le Hung Thien's .vimrc     ░▒▓█
"
set nocompatible             " be the IMproved
set modelines=0              " security
set hidden                   " hide buffers, not close them
runtime macros/matchit.vim   " enable matchit plugin

" ┐ ┬o┌┌┐  ┬─┐┬  ┬ ┐┌─┐
" │┌┘││││  │─┘│  │ ││ ┬
" └┘ ┆┘ ┆  ┆  ┆─┘┆─┘┆─┘
call plug#begin('~/.vim/plugged')

" █▓▒░ color themes
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

" █▓▒░ real plugins
Plug 'itchyny/lightline.vim'
let g:lightline = {
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

" file browser
Plug 'scrooloose/nerdtree'

" automatic closing of quotes, parenthesis, brackets, etc.
Plug 'raimondi/delimitmate'

" perform all your vim insert mode completions with <tab>
Plug 'ervandew/supertab'

" surround stuff
Plug 'tpope/vim-surround'

" comment stuff out
Plug 'tpope/vim-commentary'

" 'a git wrapper so awesome, it should be illegal'
Plug 'tpope/vim-fugitive'

" display the indention levels
Plug 'yggdroot/indentline'
let g:indentLine_char = '.'

" javascript bundle for vim
Plug 'pangloss/vim-javascript', {'for': ['javascript', 'typescript']}
let g:javascript_plugin_jsdoc = 1  " enable JSDoc
let g:javascript_plugin_ngdoc = 1  " enable NGDoc
let g:javascript_plugin_flow  = 1  " enable Flow

" typescript syntax files for vim
Plug 'leafgarland/typescript-vim', {'for': 'typescript'}

" vim motions on speed
Plug 'easymotion/vim-easymotion'

" vimgrep
Plug 'vim-scripts/grep.vim'

" fzf
if isdirectory('/usr/local/opt/fzf')
    Plug '/usr/local/opt/fzf' | Plug 'junegunn/fzf.vim'
else
    Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --bin' }
    Plug 'junegunn/fzf.vim'
endif

let $FZF_DEFAULT_COMMAND =  "find * -path '*/\.*' -prune -o -path 'node_modules/**' -prune -o -path 'target/**' -prune -o -path 'dist/**' -prune -o  -type f -print -o -type l -print 2> /dev/null"

" the silver searcher
if executable('ag')
    let $FZF_DEFAULT_COMMAND = 'ag --hidden --ignore .git -g ""'
    set grepprg=ag\ --nogroup\ --nocolor
endif

" ripgrep
if executable('rg')
    let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    set grepprg=rg\ --vimgrep
    command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>).'| tr -d "\017"', 1, <bang>0)
endif

cnoremap <C-P> <C-R>=expand("%:p:h") . "/" <CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>e :FZF -m<CR>

" customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'Comment'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'Statement'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'border':  ['fg', 'Ignore'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }

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
    " Plug 'SirVer/ultisnips'
    " Plug 'honza/vim-snippets'
    " let g:UltiSnipsExpandTrigger="<tab>"
    " let g:UltiSnipsJumpForwardTrigger="<tab>"
    " let g:UltiSnipsJumpBackwardTrigger="<c-b>"
    " let g:UltiSnipsEditSplit="vertical"
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

" █▓▒░ all of plugins must be added before the following line
call plug#end()

" ┬─┐┬─┐┬─┐┐─┐┌─┐┌┐┐┬─┐┬    ┐─┐┬─┐┌┐┐┌┐┐o┌┐┐┌─┐┐─┐
" │─┘├─ │┬┘└─┐│ │││││─┤│    └─┐├─  │  │ │││││ ┬└─┐
" ┆  ┴─┘┆└┘──┘┘─┘┆└┘┘ ┆┆─┘  ──┘┴─┘ ┆  ┆ ┆┆└┘┆─┘──┘
" █▓▒░ interface settings
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
set cursorline      " highlight current line
syntax on           " syntax highlight for java

" █▓▒░ read/write settings
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

" █▓▒░ edit settings
set backspace=indent,eol,start      " backspacing over everything
set expandtab                       " fill tabs with spaces
set nojoinspaces                    " no space after '.' when joining
set shiftwidth=4                    " set indentation depth to 4 columns
set softtabstop=4                   " backspacing over 4 spaces
set tabstop=4                       " set tabulator length to 4 columns
set number                          " show line number
set relativenumber                  " show relative line number

" █▓▒░ search settings
set hlsearch                        " highlight search results
set incsearch                       " do incremental search
set ignorecase                      " do case insensitive search...
set smartcase                       " ...unless capital letters are used

"█▓▒░ other settings
filetype on                         " enable file type detection
filetype plugin on                  " load the plugins for specific file types
filetype indent on                  " automatically indent code
syntax enable                       " enable syntax highlighting
" displaying non-printable characters
set listchars=eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+
" don't try to highlight lines longer than 800 characters.
set synmaxcol=800
" highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" configurations for tab completion menu
set wildmenu
set wildmode=list:longest,list:full
set wildignore+=*.o,*.obj,.git,*.rbc,*.pyc,__pycache__
set wildignorecase

" clipboard
if has('unnamedplus')
    set clipboard=unnamed,unnamedplus
endif

" █▓▒░ colorscheme and background
colorscheme gruvbox             " colorscheme
set background=dark             " dark background

" █▓▒░ tuning base on environment
if has('gui_running')
    if has("gui_gtk2")          " linux
        set guifont=Inconsolata:h12
    elseif has("gui_macvim")    " macvim
        set guifont=SF\ Mono:h13
    elseif has("gui_win32")     " windows
        " set guifont=Consolas:h11:cANSI
        set guifont=Iosevka\ Slab:h11:cANSI
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

" no highlight on search results when hitting return
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

" █▓▒░ abbreviations: no one is really happy until you have this shortcuts
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

" mapping for vim plug
noremap <F10> :PlugUpdate<CR>

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

" reload lightline
function! LightlineReload()
    call lightline#init()
    call lightline#colorscheme()
    call lightline#update()
endfunction

" set background acording to macOS dark mode
function! SetBackgroundMode(...)
    let s:new_bg = "light"
    let s:lightlinecolor = "gruvbox"

    let s:mode = systemlist("defaults read -g AppleInterfaceStyle")[0]
    if s:mode ==? "dark"
        let s:new_bg = "dark"
        let s:lightlinecolor = "lightline"
    else
        let s:new_bg = "light"
        let s:lightlinecolor = "gruvbox"
    endif

    if &background !=? s:new_bg
        let &background = s:new_bg
        let g:lightline.colorscheme = s:lightlinecolor
        call LightlineReload()
    endif
endfunction

call SetBackgroundMode()
call timer_start(3000, "SetBackgroundMode", {"repeat": -1})

" █▓▒░ auto-reload .vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
    call LightlineReload()
augroup END " }

"
" ┌┐┐┬ ┬┬─┐  ┬─┐┌┐┐┬─┐
"  │ │─┤├─   ├─ ││││ │
"  ┆ ┆ ┴┴─┘  ┴─┘┆└┘┆─┘
