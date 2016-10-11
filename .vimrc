"  __   __   __     __    __     ______     ______
" /\ \ / /  /\ \   /\ "-./  \   /\  == \   /\  ___\
" \ \ \'/   \ \ \  \ \ \-./\ \  \ \  __<   \ \ \____
"  \ \__|    \ \_\  \ \_\ \ \_\  \ \_\ \_\  \ \_____\
"   \/_/      \/_/   \/_/  \/_/   \/_/ /_/   \/_____/
"
"           this is Le Hung Thien's .vimrc
"
set nocompatible " be the IMproved
"
" -----------------------------vundle configurations-----------------------------------
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

filetype off " required for Vundle, will be on when Vundle is completed

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" vim airline
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline_powerline_fonts = 1 " allow airline to use Powerline patched fonts

" apprentice colortheme
Plugin 'romainl/apprentice'

" molokai colortheme
Plugin 'tomasr/molokai'

" solarized colortheme
Plugin 'altercation/vim-colors-solarized'

" base 16 theme
Plugin 'chriskempson/base16-vim'

" jellybean theme
Plugin 'nanotech/jellybeans.vim'

" tree explorer plugin
Plugin 'scrooloose/nerdtree'

" the NERD commenter
Plugin 'scrooloose/nerdcommenter'

" ruby on rails support
Plugin 'tpope/vim-rails'

" automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'raimondi/delimitmate'

" supertab
Bundle 'ervandew/supertab'

" vim suround
Plugin 'tpope/vim-surround'

" visulize vim undo tree
Plugin 'sjl/gundo.vim'
nnoremap <F10> :GundoToggle<CR>

" a parser for a condensed HTML format
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}

" 'a Git wrapper so awesome, it should be illegal'
Plugin 'tpope/vim-fugitive'

" indent guide
Plugin 'nathanaelkane/vim-indent-guides'
" to ignore plugin indent changes, instead use:
" filetype plugin on

" papercolor-theme
Plugin 'NLKNguyen/papercolor-theme'

" javascript bundle for vim
Plugin 'pangloss/vim-javascript'

let g:javascript_plugin_jsdoc = 1 " enable syntax highlighting for JSDocs
let g:javascript_plugin_ngdoc = 1 " enables some additional syntax highlighting for NGDocs.
let g:javascript_plugin_flow = 1  " enable syntax highlighting for Flow

" vorange color-theme
Plugin 'marfisc/vorange'

" light (& dark) color scheme inspired by iA Writer
Plugin 'reedes/vim-colors-pencil'

" vim motions on speed!
Plugin 'easymotion/vim-easymotion'

" true fuzzy find.
Plugin 'ctrlpvim/ctrlp.vim'

" hybrid color theme
Plugin 'w0ng/vim-hybrid'

" unix-based only
if !exists("g:os")
    if has('unix')
        " auto code completion
        Plugin 'valloric/youcompleteme'

        " snippets configurations
        Plugin 'sirver/ultisnips'   " the engine
        Plugin 'honza/vim-snippets' " the actual snippets

        " make YCM compatible with UltiSnips (using supertab)
        let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
        let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
        let g:SuperTabDefaultCompletionType = '<C-n>'

        " trigger configuration. Do not use <tab>
        " if you use https://github.com/Valloric/YouCompleteMe.
        let g:UltiSnipsExpandTrigger="<tab>"
        let g:UltiSnipsJumpForwardTrigger="<c-b>"
        let g:UltiSnipsJumpBackwardTrigger="<c-z>"

        " if you want :UltiSnipsEdit to split your window.
        " let g:UltiSnipsEditSplit="vertical"

        " tagbar plugin
        Plugin 'majutsushi/tagbar'
        nmap <F9> :TagbarToggle<CR>

        " plugin that set the tmux status bar color using airline/powerline
        Plugin 'edkolev/tmuxline.vim'

        " ack plugin
        Plugin 'mileszs/ack.vim'
    endif
endif

" all of plugins must be added before the following line
call vundle#end()            " required

" ---------------------------------personal settings-----------------------------------
" display settings
set encoding=utf-8  " encoding used for displaying file
set ruler           " show the cursor position all the time
set showmatch       " highlight matching braces
set showmode        " show insert/replace/visual mode
set t_Co=256        " tell the world that this emulator is capable of display 256 colors
set laststatus=2    " always display the statusline in all windows
set wrap            " always wrap long lines
set guioptions-=r   " hide the right scroll bar
set guioptions-=L   " hide the left scroll bar
set foldenable      " enable code folding

" read/write settings
set confirm                         " confirm :q in case of unsaved changes
set fileencoding=utf-8              " encoding used when saving file
set undofile                        " keep the undo files
set backup                          " keep the backup~ file
set noswapfile                      " it's <insert current year>, vim!
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
" when a file has been detected to have been changed outside of Vim and
" it has not been changed inside of Vim, automatically read it again.
set autoread
" write the contents of the file, if it has been modified, on each
" :next, :rewind, :last, :first, :previous, :stop, :suspend, :tag, :!,
" :make, CTRL-] and CTRL-^ command; and when a :buffer, CTRL-O, CTRL-I,
" '{A-Z0-9}, or `{A-Z0-9} command takes one to another file.
set autowrite
" auto save on losing focus
au FocusLost * :wa

" edit settings
set backspace=indent,eol,start  " backspacing over everything in insert mode
set expandtab                   " fill tabs with spaces
set nojoinspaces                " no extra space after '.' when joining lines
set shiftwidth=4                " set indentation depth to 8 columns
set softtabstop=4               " backspacing over 8 spaces like over tabs
set tabstop=4                   " set tabulator length to 8 columns
" set textwidth=80              " wrap lines automatically at <number>th column
set relativenumber              " show line number as relative to current line

" search settings
set hlsearch    " highlight search results
set incsearch   " do incremental search
set ignorecase  " do case insensitive search...
set smartcase   " ...unless capital letters are used

" file type specific settings
filetype on         " enable file type detection
filetype plugin on  " load the plugins for specific file types
filetype indent on  " automatically indent code
set modelines=0     " prevents some security exploits having to do with modeline in files.

" syntax highlighting
colorscheme hybrid  " set color scheme, must be installed first
set background=dark " dark background
syntax enable       " enable syntax highlighting
" characters for displaying non-printable characters
set listchars=eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+
" don't try to highlight lines longer than 800 characters.
set synmaxcol=800
" highlight VCS conflict markers
match ErrorMsg '^\(<\|=\|>\)\{7\}\([^=].\+\)\?$'

" tuning for gVim base on OSs
if has('gui_running')
    set number                  " show line numbers
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

" automatic commands
if has('autocmd')
    " file type specific automatic commands
    " tuning textwidth for Java code
    " autocmd FileType java setlocal textwidth=132
    " if has('gui_running')
    " autocmd FileType java setlocal columns=136
    " endif
    " don't replace Tabs with spaces when editing makefiles
    autocmd Filetype makefile setlocal noexpandtab
    " disable automatic code indentation when editing TeX and XML files
    autocmd FileType tex,xml setlocal indentexpr=
    " clean-up commands that run automatically on write; use with caution
    " delete empty or whitespaces-only lines at the end of file
    autocmd BufWritePre * :%s/\(\s*\n\)\+\%$//ge
    " replace groups of empty or whitespaces-only lines with one empty line
    autocmd BufWritePre * :%s/\(\s*\n\)\{3,}/\r\r/ge
    " delete any trailing whitespaces
    autocmd BufWritePre * :%s/\s\+$//ge
endif

" general key mappings
" center view on the search result
noremap n nzz
noremap N Nzz

" press F4 to fix indentation in whole file; overwrites marker 'q' position
noremap <F4> mqggVG=`qzz
inoremap <F4> <Esc>mqggVG=`qzza

" press F5 to sort selection or paragraph
vnoremap <F5> :sort i<CR>
nnoremap <F5> Vip:sort i<CR>

" press F8 to turn the search results highlight off
noremap <F8> :nohl<CR>
inoremap <F8> <Esc>:nohl<CR>a

" press F12 to toggle showing the non-printable charactes
noremap <F12> :set list!<CR>
inoremap <F12> <Esc>:set list!<CR>a

" remap the <Leader> and set it's timeout
let mapleader=","
set timeout timeoutlen=1500

" disable the arrow keys while in normal mode to help you learn to use hjkl.
" also disables the arrow keys in insert mode to force you to get back into normal
" mode the instant you’re done inserting text, which is the RIGHT WAY to do things.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" makes j and k work the way you expect instead of working in some archaic
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

" quickly open up my ~/.vimrc file in a vertically split window
nnoremap <leader>ev <C-w><C-v><C-l>:e $MYVIMRC<cr>

" open a new split window and switch over to it
nnoremap <leader>w <C-w>v<C-w>l

" move around splits
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l

" map a key for Ack
nnoremap <leader>a :Ack

" split line (sister to [J]oin lines)
" the normal usage of S is reproducable with cc which is the same amount of keystrokes.
nnoremap S i<cr><esc><right>

" bubble single lines
" due to macOS keybinding of the C-Up key, chose to remap to C-k and so forth.
nmap <C-k> ddkP
nmap <C-j> ddp
" bubble multiple lines
vmap <C-k> xkP`[V`]
vmap <C-j> xp`[V`]

" clear the search buffer when hitting return
nnoremap <CR> :nohlsearch<cr>

" auto-reload .vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
" -------------------------------------the end-----------------------------------------
