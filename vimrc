" Manage the runtime path with  Pathogen.
execute pathogen#infect()

syntax enable                     " Turn on syntax highlighting.
filetype plugin indent on         " Turn on file type detection.

runtime macros/matchit.vim        " Load matchit.vim plugin.

set background=dark
colorscheme solarized
hi LineNr guibg=NONE

set showcmd                       " Display incomplete commands.
set showmode                      " Display the mode you're in.

set backspace=indent,eol,start    " Intuitive backspacing.

set hidden                        " Handle multiple buffers better.

set wildmenu                      " Enhanced command line completion.
set wildmode=list:longest         " Complete files like a shell.
set complete-=i                   " Don't look in included files.

" Ideally I'd like:
" - case-sensitive insert-mode completion
" - smart case-insensitive searching
" It looks like you can't have both through configuration;
" you have to write a customer completion function.
" For now I prioritise the first requirement.
" set ignorecase                    " Case-insensitive searching.
" set smartcase                     " But case-sensitive if expression contains a capital letter.

set number                        " Show absolute line numbers (cf. relativenumber).
set ruler                         " Show cursor position.
set laststatus=2                  " Always show a status line.

set incsearch                     " Highlight matches as you type.
set hlsearch                      " Highlight matches.

set wrap                          " Turn on line wrapping.
set scrolloff=3                   " Show 3 lines of context around the cursor.
set display+=lastline             " Display as much as possibe of a window's last line.

set shiftwidth=2                  "
set tabstop=2                     " Tabs and spaces.
set expandtab                     "

set title                         " Set the terminal's title

set visualbell                    " No beeping.

set nobackup                      " No backups.
set nowritebackup                 " No backups.
set noswapfile                    " No swap files; more hassle than they're worth.

set tildeop                       " Make tilde command behave like an operator.
set shortmess=atI                 " Avoid unnecessary hit-enter prompts.

set noequalalways                 " Resize windows as little as possible.

set autoread                      " Automatically re-read files changed outside Vim.
set updatetime=750                " Do things when I stop typing for three-quarters of a second.

set notimeout                     " Don't time out partially entered mapped key sequences.
set ttimeout                      " But do time out key codes.

set tags=.git/tags,tags           " Look for tags in .git/

set clipboard=unnamed             " Use OS clipboard by default.

" Ensure pathogen can load plugins when restoring a vim session.
set sessionoptions-=options

set cpo+=J                        " Two spaces delimit my sentences.
if v:version > 703 || (v:version == 703 && has("patch541"))
  set formatoptions+=j              " Remove comment leaders when joining lines.
endif

" Show tabs and trailing whitespace visually.
if &listchars ==# 'eol:$'
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<,nbsp:+
  if &termencoding ==# 'utf-8' || &encoding ==# 'utf-8'
    let &listchars = "tab:\u21e5 ,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  endif
endif

" Highlight non-ASCII characters.
" syntax match nonascii "[^\x00-\x7F]"
" highlight link nonascii ErrorMsg
autocmd BufEnter * syn match ErrorMsg /[^\x00-\x7F]/

let g:sql_type_default = "mysql"

" Treat buffers from stdin as scratch.
au StdinReadPost * :set buftype=nofile

" Windowing.
nnoremap + <C-W>+
nnoremap - <C-W>-
nnoremap <Tab> <C-W>w
nnoremap <S-Tab> <C-W>W
" Use | and _ to split windows though the latter breaks jump-to-column
nnoremap <Bar> <C-W>v<C-W><Right>
nnoremap _ <C-W>s<C-W><Down>

" Move current line / visual line selection up or down.
nnoremap <C-j> :m+<CR>==
nnoremap <C-k> :m-2<CR>==
vnoremap <C-j> :m'>+<CR>gv=gv
vnoremap <C-k> :m-2<CR>gv=gv


" Very magic regexes.
cnoremap s/ <C-\>eVeryMagic('s/')<CR>
cnoremap g/ <C-\>eVeryMagic('g/')<CR>
cnoremap v/ <C-\>eVeryMagic('v/')<CR>
function! VeryMagic(text)
  let cmd = getcmdline()
  return cmd . a:text . (cmd !~ '/' ? '\v' : '')
endfunction

" Keep help docs in their own tab.
cnoreabbrev <expr> h ((getcmdtype() == ':' && getcmdpos() <= 2 && &ft != 'help') ? 'tab h' : 'h')


" OS X-like space bar to scroll.
nnoremap <Space> <C-F>

" <Leader><space> turns off search highlighting.
nnoremap <Leader><space> :noh<CR>


" Convert Ruby hash syntax from 1.8 to 1.9 on current line.
nnoremap <Leader>rh :let p=@/<CR>:s/:\([^ ]*\)\(\s*\)=>/\1:/g<CR>:let @/=p<CR>

" <Leader>s shrinks current window to fit size of buffer.
nnoremap <silent> <Leader>s :call ShrinkWindow()<CR>
function! ShrinkWindow()
  let line_count = line('$')
  let window_height = winheight(0)
  if window_height > line_count
    execute "resize" line_count
  endif
endfunction

" Directory of current file.
cnoremap %% <C-R>=expand("%:h")."/"<CR>

" Copy to / paste from system pasteboard.
" (Use `:put *<CR>` and `:put! *<CR>` for linewise pasting.)
noremap <Leader>p :set paste<CR>"*p:set nopaste<CR>
noremap <Leader>P :set paste<CR>"*P:set nopaste<CR>

" Make Y consistent with D and C (instead of yy)
noremap Y y$

" Visually select the text that was most recently edited/pasted.
" Note: gv selects previously selected area.
nmap gV `[v`]

" Duplicate visual selection.
vmap D yP'<

" Make * and # work with visual selection.
" For anything more sophisticated, try:
" - https://github.com/nelstrom/vim-visual-star-search
" - https://github.com/thinca/vim-visualstar
vnoremap <silent> * yq/p<CR>
vnoremap <silent> # yq?p<CR>

" Duplicate and comment out duplicate.
nmap <leader>dc :t.<CR>k<Plug>CommentaryLinej


" Backspace closes buffer.
nnoremap <BS> :bd<CR>

" Prevent Vim from scrolling original window when splitting horizontally.
" See example 'Restoring the View' in Vim manual chapter 41.10.
nnoremap <C-W>s Hmx``:split<CR>`xzt``

" Save all buffers when focus lost, ignoring warnings,
" and return to normal mode.
"
" Ideally we'd have:
"
"   autocmd FocusLost * silent! wa stopinsert
"
" but stopinsert doesn't seem to work inside a FocusLost autocommand.
" So we use a long-winded approach instead.
"
" http://tech.groups.yahoo.com/group/vim/message/94986
autocmd FocusLost * nested silent! wa
autocmd FocusLost * if mode()[0] =~ 'i\|R' | call feedkeys("\<Esc>") | endif

" Wipe all buffers which aren't visible ('active').
" https://github.com/nelstrom/dotfiles/blob/8e8accf783aaf13e5407311f0d3079022152acf1/vimrc#L166-L189
command Only call CloseHiddenBuffers()
function! CloseHiddenBuffers()
  " Get list of visible buffers
  let visible = {}
  for t in range(1, tabpagenr('$'))
    for b in tabpagebuflist(t)
      let visible[b] = 1
    endfor
  endfor
  " Close other buffers
  for b in range(1, bufnr('$'))
    if bufloaded(b) && !has_key(visible, b)
      execute 'bw ' . b
    endif
  endfor
endfunction

" Speedier quitting.
cnoremap  Q  qa!<CR>
cnoremap WQ wqa!<CR>



"
" Filetypes
"

au Filetype css setlocal iskeyword+=-
au Filetype ruby setlocal iskeyword+=_
au BufEnter *.js syn match ErrorMsg /console.log/
au Filetype coffee syn match ErrorMsg /console.log/


"
" Colours
"

hi clear Search
hi Search guifg=#ffffff guibg=#789abc


"
" Plugins
"

" PeepOpen
" nnoremap <Leader>f <Plug>PeepOpen

" probe
" TODO set g:probe_ignore_files per-project with projectionist
let g:probe_ignore_files = [ 'vendor/fonts/.*', 'tmp/.*', 'log/.*', 'db/sphinx/.*', '.*\.png', '.*\.jpg', '/private/label_sheets/.*', 'public/system/.*' ]
nnoremap <Leader>b :ProbeFindBuffer<CR>


" vim-commentary
" disable obsolete mapping
nmap \\ <space>

" BufExplorer configuration
"nmap <script> <silent> <unique> <CR> :BufExplorer<CR>
nmap <expr> <script> <silent> <unique> <CR> &buftype ==? '' ? ':BufExplorer<CR>' : '<CR>'
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1
let g:bufExplorerShowDirectories = 0

" rails.vim configuration
autocmd User Rails silent! Rnavcommand config config -glob=*.* -suffix= -default=routes.rb

" ack.vim
nmap <silent> <unique> <Leader>a :Ack
nmap <silent> <unique> <Leader>as :AckFromSearch
nmap <silent> <unique> <Leader>af :AckFile
let g:ackprg = 'ag --nogroup --nocolor --column'

" vim-rooter
map <Leader>r <Plug>RooterChangeToRootDirectory<CR>
let g:rooter_patterns = ['Rakefile', 'Gemfile', '.git/', 'CHANGELOG']

" vim-gitgutter
highlight clear SignColumn
let g:gitgutter_sign_column_always = 1

" vim-airline
let g:airline_section_z = '%3l:%-3c [%{bufnr("%")}] '

" vim-surround
" Add replacement on # for ruby string interplation.
let g:surround_35 = "#{\r}"


" Open a gem's homepage in the browser.  This is a bit of a hack :/
" TODO: gemfile only
" nmap <silent> <Leader>g :call system("open $(gem list -d " . expand('<cword>') . " \| awk '/Homepage/ {print $2}')")<CR>

let g:projectionist_heuristics = {
  \   "Gemfile&config/application.rb": {
  \     "app/models/*.rb": {
  \       "template": ["class {camelcase} < ActiveRecord::Base", "end"]
  \     },
  \     "app/controllers/*.rb": {
  \       "template": ["class {camelcase} < ApplicationController", "end"],
  \     },
  \     "app/presenters/*.rb": {
  \       "template": ["class {camelcase}", "end"],
  \       "type": "presenter"
  \     },
  \     "app/assets/javascripts/*.js.coffee": {
  \       "type": "coffee"
  \     },
  \     "app/assets/stylesheets/*.css.sass": {
  \       "type": "sass"
  \     },
  \   }
  \ }
