" Example Vim configuration.
" Copy or symlink to ~/.vimrc or ~/_vimrc.

set nocompatible                  " Must come first because it changes other options.

silent! call pathogen#runtime_append_all_bundles()

syntax enable                     " Turn on syntax highlighting.
filetype off
filetype on
filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load the matchit plugin.

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set tags=./tags;../../tags;
let g:ackprg="ack-grep -H --nocolor --nogroup --column"

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
set tabstop=4                    " Global tab width.
set shiftwidth=4                 " And again, related.
set expandtab                    " Use spaces instead of tabs

set laststatus=2                  " Show the status line all the time
" Useful status information at bottom of screen
" set statusline=[%n]\ %<%.99f\ %h%w%m%r%y\ %{fugitive#statusline()}%{exists('*CapsLockStatusline')?CapsLockStatusline():''}%=%-16(\ %l,%c-%v\ %)%P

""""""""""""""
" tmux fixes "
""""""""""""""
" Handle tmux $TERM quirks in vim
if $TERM =~ '^screen-256color'
    map <Esc>OH <Home>
    map! <Esc>OH <Home>
    map <Esc>OF <End>
    map! <Esc>OF <End>
endif
set t_Co=256
let g:solarized_termcolors=256
"let g:solarized_termtrans = 1
set background=dark
colorscheme solarized "desert topfunky-light
" color wombat

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
map <leader>bf :call g:Jsbeautify()<cr>

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

setlocal omnifunc=syntaxcomplete#Complete
set cot+=menuone

" keywords for ruby
" autocmd FileType ruby set iskeyword=@,48-57,_,?,!,192-255

" tab configs for python
autocmd FileType python set tabstop=4
autocmd FileType python set shiftwidth=4
autocmd FileType python set expandtab
autocmd FileType python compiler pylint
let g:pylint_onwrite = 0

let g:pydiction_location = '/home/johannes/.vim/sources/pydiction-1.2/complete-dict'

autocmd FileType html set tabstop=4
autocmd FileType html set shiftwidth=4

autocmd FileType htmldjango set tabstop=4
autocmd FileType htmldjango set shiftwidth=4

autocmd FileType ruby set tabstop=2
autocmd FileType ruby set shiftwidth=2
autocmd FileType ruby set expandtab

autocmd FileType javascript set tabstop=4
autocmd FileType javascript set shiftwidth=4

autocmd FileType php set tabstop=4
autocmd FileType php set shiftwidth=4
autocmd FileType php set expandtab

" ragtag
inoremap <M-o> <Esc>o
inoremap <C-j> <Down>
let g:ragtag_global_maps = 1

let g:pyflakes_use_quickfix = 0

"if has("gui_running")
	 highlight SpellBad term=underline gui=undercurl guisp=Orange 
"endif
 
" CTRL+Space for auto-complete
inoremap <Nul> <C-n>
" F6 to cycle through documents (next buffer)
nnoremap <F6> :bn<CR>
" F7 to delete the buffer
nnoremap <F7> :bd<CR>
" F8 to toggle indent off
nnoremap <F8> :setl noai nocin nosi inde=<CR>
" text wrapping
set formatoptions=cq textwidth=120 foldignore= wildignore+=*.py[co]

""" UNITE
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
" Set up some custom ignores
call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
      \ 'ignore_pattern', join([
      \ '\.git/',
      \ 'tmp/',
      \ 'public/assets/',
      \ 'public/javascripts/',
      \ '\.png$',
      \ '\.jpg$',
      \ '\.gif$',
      \ '\.log$',
      \ ], '\|'))

call unite#set_profile('files', 'context.smartcase', 1)
call unite#custom#source('line,outline','matchers','matcher_fuzzy')
let g:unite_data_directory='~/.vim/.cache/unite'
" let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=5000
let g:unite_prompt='» '

" For ack.
if executable('ack-grep')
  let g:unite_source_grep_command = 'ack-grep'
  " Match whole word only. This might/might not be a good idea
  let g:unite_source_grep_default_opts = '--no-heading --no-color'
  let g:unite_source_grep_recursive_opt = ''
elseif executable('ack')
  let g:unite_source_grep_command = 'ack'
  let g:unite_source_grep_default_opts = '--no-heading --no-color'
  let g:unite_source_grep_recursive_opt = ''
endif

function! s:unite_settings()
  nmap <buffer> Q <plug>(unite_exit)
  nmap <buffer> <esc> <plug>(unite_exit)
  imap <buffer> <esc> <plug>(unite_exit)
endfunction
autocmd FileType unite call s:unite_settings()

nmap <space> [unite]
nnoremap [unite] <nop>

nnoremap <silent> [unite]<space> :<C-u>Unite -toggle -auto-resize -buffer-name=mixed file_rec/async buffer file_mru bookmark<cr><c-u>
nnoremap <silent> [unite]f :<C-u>Unite -toggle -auto-resize -buffer-name=files file_rec/async<cr><c-u>

nnoremap <C-e> :Unite -no-split -start-insert file_rec<cr>
nnoremap <silent> [unite]b :<C-u>Unite -start-insert -auto-resize -buffer-name=buffers buffer<cr>
nnoremap <silent> [unite]s :Unite -buffer-name=buffers -auto-resize -quick-match buffer<cr>
nnoremap <silent> [unite]y :<C-u>Unite -buffer-name=yanks history/yank<cr>
nnoremap <silent> [unite]l :<C-u>Unite -start-insert -no-split -auto-resize -buffer-name=line line<cr>
nnoremap <silent> [unite]m :Unite -no-split -buffer-name=mru -start-insert file_mru<cr>
nnoremap <silent> [unite][ :Unite -start-insert -auto-resize -buffer-name=outline outline<cr>
" nnoremap <silent> [unite]/ :<C-u>Unite -no-quit -buffer-name=search grep:.<cr>
nnoremap <silent> [unite]/ :<C-u>Unite -no-split -buffer-name=search grep:.<cr>

"autocmd FileType python map <buffer> <F3> :call Pep8()<CR>
let no_pep8_maps = 1

"airline
let g:airline_theme='badwolf'
" let g:airline_left_sep = '»'
let g:airline_left_sep=''
let g:airline_right_sep=''
let g:airline_fugitive_prefix = '⎇ '
let g:airline_detect_paste=1
let g:airline#extensions#tabline#fnametruncate=10
let g:airline#extensions#branch#displayed_head_limit=10

" vimpress
let VIMPRESS = [{'username':'','blog_url':''}]
let g:slime_target = "tmux"

" Quote a word consisting of letters from iskeyword.
nnoremap <silent> qw :call Quote('"')<CR>
nnoremap <silent> qs :call Quote("'")<CR>
nnoremap <silent> wq :call UnQuote()<CR>
function! Quote(quote)
  normal mz
  exe 's/\(\k*\%#\k*\)/' . a:quote . '\1' . a:quote . '/'
  normal `zl
endfunction

function! UnQuote()
  normal mz
  exe 's/["' . "'" . ']\(\k*\%#\k*\)[' . "'" . '"]/\1/'
  normal `z
endfunction

" for coffeescript
au BufNewFile,BufReadPost *.coffee setl shiftwidth=2 expandtab

" vim-sneak with easymotion
nmap s <Plug>(easymotion-overwin-f2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)

" let g:ctrlp_map = '<c-e>'
" let g:ctrlp_cmd = 'CtrlP'
