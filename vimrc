" Example Vim configuration.
" Copy or symlink to ~/.vimrc or ~/_vimrc.

set nocompatible                  " Must come first because it changes other options.

silent! call pathogen#runtime_append_all_bundles()

syntax enable                     " Turn on syntax highlighting.
filetype on
filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load the matchit plugin.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set tags=./tags;../../tags;
set grepprg=ack-grep

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.

set ignorecase                    " Case-insensitive searching.
set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show line numbers.
"Toggle line numbers and fold column for easy copying:
nnoremap <F2> :set nonumber!<CR>:set foldcolumn=0<CR>

set ruler                         " Show cursor position.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set wrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.

set title                         " Set the terminal's title

set visualbell                    " No beeping.

set nobackup                      " Don't make a backup before overwriting a file.
set nowritebackup                 " And again.
set directory=$HOME/.vim/tmp//,.  " Keep swap files in one location

" UNCOMMENT TO USE
"set tabstop=2                    " Global tab width.
"set shiftwidth=2                 " And again, related.
"set expandtab                    " Use spaces instead of tabs

set laststatus=2                  " Show the status line all the time
" Useful status information at bottom of screen
" set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{fugitive#statusline()}%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

" Or use vividchalk
colorscheme topfunky-light

" rcodetools
" let g:rct_completion_use_fri = 1
" let g:rct_completion_info_max_len = 20
set completeopt=menu,preview

let Tlist_Ctags_Cmd = "/usr/bin/ctags-exuberant"
" let Tlist_WinWidth = 50
map <F4> :TlistToggle<cr>
" map <F8> :!/usr/bin/ctags -R --exclude=.svn --exclude=.git --exclude=log --exclude=coverage --exclude=*.sql .<CR>

" Tab mappings.
map <leader>tt :tabnew<cr>
map <leader>te :tabedit
map <leader>tc :tabclose<cr>
map <leader>to :tabonly<cr>
map <leader>tn :tabnext<cr>
map <leader>tp :tabprevious<cr>
map <leader>tf :tabfirst<cr>
map <leader>tl :tablast<cr>
map <leader>tm :tabmove

map <leader>ff :FufFile<cr>
map <leader>fd :FufDir<cr>
map <leader>fb :FufBuffer<cr>

map <leader>ru :TRecentlyUsedFiles<cr>

map <C-n> :cn
map <C-p> :cp

" Uncomment to use Jamis Buck's file opening plugin
"map <Leader>t :FuzzyFinderTextMate<Enter>

" Controversial...swap colon and semicolon for easier commands
"nnoremap ; :
"nnoremap : ;

"vnoremap ; :
"vnoremap : ;

" Automatic fold settings for specific files. Uncomment to use.
" autocmd FileType ruby setlocal foldmethod=syntax
" autocmd FileType css  setlocal foldmethod=indent shiftwidth=2 tabstop=2

" For the MakeGreen plugin and Ruby RSpec. Uncomment to use.
autocmd BufNewFile,BufRead *_spec.rb compiler rspec

au BufRead,BufNewFile *.django.html set filetype=htmldjango
au BufRead,BufNewFile *.dj.html set filetype=htmldjango
" autocmd FileType python set ft=python.django " For SnipMate
au BufRead,BufNewFile *.dj.html set ft=htmldjango.html " For SnipMate
au BufRead,BufNewFile *.django.html set ft=htmldjango.html " For SnipMate

" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
au BufRead,BufNewFile *.html set filetype=htmldjango
au BufRead,BufNewFile *.inc set filetype=htmldjango
" !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

au BufRead,BufNewFile *.js set filetype=javascript

" keywords for ruby
" autocmd FileType ruby set iskeyword=@,48-57,_,?,!,192-255

" tab configs for python
autocmd FileType python set tabstop=4
autocmd FileType python set shiftwidth=4
autocmd FileType python set expandtab

let g:pydiction_location = '/home/johannes/.vim/sources/pydiction-1.2/complete-dict'

autocmd FileType html set tabstop=4
autocmd FileType html set shiftwidth=4

autocmd FileType htmldjango set tabstop=4
autocmd FileType htmldjango set shiftwidth=4


autocmd FileType javascript set tabstop=4
autocmd FileType javascript set shiftwidth=4

" ragtag
inoremap <M-o> <Esc>o
inoremap <C-j> <Down>
let g:ragtag_global_maps = 1

