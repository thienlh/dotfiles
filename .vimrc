"
"   This is Le Hung Thien's .vimrc!!!
"
set nocompatible              " be iMproved
" -------- VUNDLE CONFIGURATIONS ----------
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
" call vundle#begin('~/some/path/here')
filetype off " required for Vundle, will be on when Vundle is completed
" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
" Vim airline
Plugin 'bling/vim-airline'
let g:airline_powerline_fonts = 1 " Allow airline to use Powerline patched fonts

" Apprentice colortheme
Plugin 'romainl/apprentice'

" Molokai
Plugin 'tomasr/molokai'

" Solarized colortheme
Plugin 'altercation/vim-colors-solarized'

" Base 16 theme
Plugin 'chriskempson/base16-vim'

" Tree explorer plugin for vim
Plugin 'scrooloose/nerdtree'

" The NERD commenter
Plugin 'scrooloose/nerdcommenter'

" Auto code completion for vim
Plugin 'valloric/youcompleteme'

" Eclim
Plugin 'ervandew/eclim'

" Use eclim with youcompleteme
let g:EclimCompletionMethod = 'omnifunc'

" ruby on rails support
Plugin 'tpope/vim-rails'

" Automatic closing of quotes, parenthesis, brackets, etc.
Plugin 'raimondi/delimitmate'

" Supertab
Bundle 'ervandew/supertab'

" ---- Snippets configurations ----
Plugin 'sirver/ultisnips' " The engine

" The actual snippets
Plugin 'honza/vim-snippets'

" make YCM compatible with UltiSnips (using supertab)
let g:ycm_key_list_select_completion = ['<C-n>', '<Down>']
let g:ycm_key_list_previous_completion = ['<C-p>', '<Up>']
let g:SuperTabDefaultCompletionType = '<C-n>'

" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" If you want :UltiSnipsEdit to split your window.
" let g:UltiSnipsEditSplit="vertical"

" The following are examples of different formats supported.
" Keep Plugin commands between vundle#begin/end.
" plugin on GitHub repo
Plugin 'tpope/vim-fugitive'
" plugin from http://vim-scripts.org/vim/scripts.html
Plugin 'L9'
" Git plugin not hosted on GitHub
Plugin 'git://git.wincent.com/command-t.git'
" git repos on your local machine (i.e. when working on your own plugin)
" Plugin 'file:///home/gmarik/path/to/plugin'
" The sparkup vim script is in a subdirectory of this repo called vim.
" Pass the path to set the runtimepath properly.
Plugin 'rstacruz/sparkup', {'rtp': 'vim/'}
" Install L9 and avoid a Naming conflict if you've already installed a
" different version somewhere else.
" Plugin 'ascenator/L9', {'name': 'newL9'}

" All of your Plugins must be added before the following line
call vundle#end()            " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line
" ---------------- VUNDLE CONFIGURATIONS END ------------

" Display settings
set encoding=utf-8 " encoding used for displaying file
set ruler " show the cursor position all the time
set showmatch " highlight matching braces
set showmode " show insert/replace/visual mode
set t_Co=256 " Advertising: This emulator is capable of display 256 colors

" execute pathogen#infect()
set laststatus=2 " Always display the statusline in all windows
set noshowmode " Hide the default mode text (e.g. -- INSERT -- below the statusline)
set wrap  " Always wrap long lines
set guioptions-=r " Hide the right scroll bar
set guioptions-=L " Hide the left scroll bar

" Write settings
set confirm " confirm :q in case of unsaved changes
set fileencoding=utf-8 " encoding used when saving file
set nobackup " do not keep the backup~ file

" Edit settings
set backspace=indent,eol,start " backspacing over everything in insert mode
set expandtab " fill tabs with spaces
set nojoinspaces " no extra space after '.' when joining lines
set shiftwidth=4 " set indentation depth to 8 columns
set softtabstop=4 " backspacing over 8 spaces like over tabs
set tabstop=4 " set tabulator length to 8 columns
" set textwidth=80 " wrap lines automatically at 100th column

" Search settings
set hlsearch " highlight search results
set ignorecase " do case insensitive search...
set incsearch " do incremental search
set smartcase " ...unless capital letters are used

" File type specific settings
filetype on " enable file type detection
filetype plugin on " load the plugins for specific file types
filetype indent on " automatically indent code

" Syntax highlighting
colorscheme solarized " set color scheme, must be installed first
" set background=light " dark background for console
syntax enable " enable syntax highlighting

" Characters for displaying non-printable characters
set listchars=eol:$,tab:>-,trail:.,nbsp:_,extends:+,precedes:+

" Tuning for gVim only
if has('gui_running')
    " set background=light " light background for GUI
    " set columns=84 lines=48 " GUI window geometry
    set number " show line numbers
    colorscheme apprentice " Color scheme for GUI only
    if has("gui_gtk2")
        set guifont=Inconsolata\ 12
    elseif has("gui_macvim")
        set guifont=Anonymous\ Pro\ for\ Powerline:h14
    elseif has("gui_win32")
        set guifont=Consolas:h11:cANSI
    endif
endif

" Automatic commands
if has('autocmd')
    " file type specific automatic commands

    " tuning textwidth for Java code
    autocmd FileType java setlocal textwidth=132
    if has('gui_running')
        autocmd FileType java setlocal columns=136
    endif

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

" Remap the <Leader> and set it's timeout
let mapleader=","
set timeout timeoutlen=1500

" Auto-reload .vimrc file
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
