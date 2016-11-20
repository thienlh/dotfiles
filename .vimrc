"  __   __   __     __    __     ______     ______
" /\ \ / /  /\ \   /\ "-./  \   /\  == \   /\  ___\
" \ \ \'/   \ \ \  \ \ \-./\ \  \ \  __<   \ \ \____
"  \ \__|    \ \_\  \ \_\ \ \_\  \ \_\ \_\  \ \_____\
"   \/_/      \/_/   \/_/  \/_/   \/_/ /_/   \/_____/
"
"█▓▒░ this is Le Hung Thien's .vimrc
"
set nocompatible " be the IMproved
set modelines=0  " security
set hidden       " hide buffers, not close them

"
" ┐ ┬┬ ┐┌┐┐┬─┐┬  ┬─┐
" │┌┘│ │││││ ││  ├─
" └┘ ┆─┘┆└┘┆─┘┆─┘┴─┘
"

" set the runtime path to include Vundle and initialize
if !exists("g:os")
    if has('win64') || has('win32') || has('win16')
        " sometimes you just have to deal with Windows
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

" vim airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1 " use powerline patched fonts

" tree explorer plugin
Plugin 'scrooloose/nerdtree'

" the NERD commenter
Plugin 'scrooloose/nerdcommenter'
" add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1

" ruby on rails support
Plugin 'tpope/vim-rails'

" automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'raimondi/delimitmate'

" perform all your vim insert mode completions with <tab>
Bundle 'ervandew/supertab'

" vim suround
Plugin 'tpope/vim-surround'

" visulize vim undo tree
Plugin 'sjl/gundo.vim'
nnoremap <F10> :GundoToggle<CR>

" a parser for a condensed HTML format
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" 'a git wrapper so awesome, it should be illegal'
Plugin 'tpope/vim-fugitive'

" display the indention levels with thin vertical lines
Plugin 'yggdroot/indentline'

" javascript bundle for vim
Plugin 'pangloss/vim-javascript'
let g:javascript_plugin_jsdoc = 1
let g:javascript_plugin_ngdoc = 1
let g:javascript_plugin_flow = 1

" vim motions on speed!
Plugin 'easymotion/vim-easymotion'

" active fork of kien/ctrlp
Plugin 'ctrlpvim/ctrlp.vim'

" emmet for vim
Plugin 'mattn/emmet-vim'

" unix-based only
if !exists("g:os")
    if has('unix')
        " auto code completion
        Plugin 'valloric/youcompleteme'

        " snippets configurations
        Plugin 'sirver/ultisnips'   " the engine
        Plugin 'honza/vim-snippets' " the actual snippets

        " make youcompleteme compatible with ultisnips and supertab
        let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
        let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
        let g:SuperTabDefaultCompletionType = '<C-n>'
        let g:UltiSnipsJumpForwardTrigger="<c-b>"
        let g:UltiSnipsJumpBackwardTrigger="<c-z>"

        " tagbar plugin
        Plugin 'majutsushi/tagbar'
        nmap <F9> :TagbarToggle<CR>

        " set the tmux status bar color using airline/powerline
        Plugin 'edkolev/tmuxline.vim'

        " ack plugin
        Plugin 'mileszs/ack.vim'
        nnoremap <leader>a :Ack
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
au FocusLost * :wa

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

"█▓▒░ tuning for gvim base on os
if has('gui_running')
    set number                  " show line numbers
    colorscheme pencil          " set color scheme
    set background=dark         " dark background

    if has("gui_gtk2")          " linux
        set guifont=Inconsolata:h12
        let g:airline_powerline_fonts = 0
    elseif has("gui_macvim")    " macvim
        set guifont=Anonymous\ Pro\ for\ Powerline:h14
    elseif has("gui_win32")     " windows
        set guifont=Consolas:h10:cANSI
        let g:airline_powerline_fonts = 0
    endif
endif

"█▓▒░ automatic commands
if has('autocmd')
    " don't replace tabs with spaces when editing makefiles
    autocmd Filetype makefile setlocal noexpandtab
    " disable automatic code indentation for TeX and XML files
    autocmd FileType tex,xml setlocal indentexpr=
    " clean-up commands that run automatically on write
    " USE WITH CAUTIOn
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

" center view on the search result
noremap n nzz
noremap N Nzz

" F4 to fix indentation in whole file
noremap <F4> mqggVG=`qzz
" overwrites marker 'q' position
inoremap <F4> <Esc>mqggVG=`qzza

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
nnoremap <CR> :nohlsearch<cr>

"█▓▒░ auto-reload .vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

"
" ┌┐┐┬ ┬┬─┐  ┬─┐┌┐┐┬─┐
"  │ │─┤├─   ├─ ││││ │
"  ┆ ┆ ┴┴─┘  ┴─┘┆└┘┆─┘
