" This is Johan Isacsson's .vimrc file
" Launch Config {{{
execute pathogen#infect('bundle/{}')
" }}}
" Basic Editor Config {{{
set exrc " load .vimrc files
set modelines=1 " look for modelines in files
set hidden " allow unsaved background buffers and remember marks/undo for them
set history=10000 " remember more commands and search history
set switchbuf=useopen " use existing buffer 
" Prevent Vim from clobbering the scrollback buffer. See
" http://www.shallowsky.com/linux/noaltscreen.html
set t_ti= t_te=
" keep more context when scrolling off the end of a buffer
set scrolloff=3
" }}}
" Colors {{{
syntax enable " enable syntax highlitning
set t_Co=256 " 256 colors
set background=dark " use the dark variant of solarized
colorscheme solarized " solarized!
" }}}
" Misc {{{
set ttyfast                    " faster redraw
set backspace=indent,eol,start " allow backspacing over everything in insert mode
" }}}
" Spaces & Tabs {{{
set expandtab " use spaces for tabs
set tabstop=4
set shiftwidth=4
set softtabstop=4
filetype plugin indent on " Load indent files, to automatically do language-dependent indenting.
set autoindent
" }}}
" UI Layout {{{
"set relativenumber
"autocmd InsertEnter * :set number
"autocmd InsertLeave * :set relativenumber
set number " show line numbers
set numberwidth=5
set showcmd " display incomplete commands
set cursorline " highlight current line
set wildmenu
" use emacs-style tab completion when selecting files, etc
set wildmode=longest,list
set showmatch " higlight matching parens
set cmdheight=2 " set command bar height
"set winwidth=79
" }}}
" Searching {{{
set ignorecase smartcase " make searches case-sensitive only if they contain upper-case characters
set incsearch " incremental search as you type
set hlsearch " highlight all matches
" Clear the search buffer when hitting return
function! MapCR()
  nnoremap <cr> :nohlsearch<cr>
endfunction
call MapCR()
" }}}
" Folding {{{
set foldmethod=indent   " fold based on indent level
set foldnestmax=10      " max 10 depth
set foldenable          " don't fold files by default on open
nnoremap <space> za
set foldlevelstart=10    " start with fold level of 1
" }}}
" Line Shortcuts {{{
" jump visual lines
nnoremap j gj 
nnoremap k gk
" shourtcuts for begining and end of lines
nnoremap B ^
nnoremap E $
" highlight last inserted text
nnoremap gV `[v`]
" disable backspace (force use of <C-h>, and <C-w>)
:inoremap <bs> <nop>
:inoremap <c-d> <del>
" }}}
" Backups {{{
set backup
set backupdir=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
set directory=~/.vim-tmp,~/.tmp,~/tmp,/var/tmp,/tmp
" }}}
" Leader Shortcuts {{{
let mapleader=","
" yank and paste using system clipboard
map <leader>y "*y
map <leader>p "*p
" switch between last buffers
nnoremap <leader><leader> <c-^>
" }}}
" Navidation Keymaps {{{
" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l
" }}}
" Auto Groups {{{
augroup vimrcEx
  " Clear all autocmds in the group
  autocmd!
  autocmd FileType mail setlocal fo+=aw
  autocmd FileType text setlocal textwidth=78
  " Jump to last cursor position unless it's invalid or in an event handler
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

  "for ruby, autoindent with two spaces, always expand tabs
  autocmd FileType ejs,ruby,haml,eruby,yaml,html,js,javascript,sass,cucumber set ai sw=2 sts=2 et
  autocmd FileType python set sw=4 sts=4 et

  autocmd! BufRead,BufNewFile *.sass setfiletype sass 

  autocmd BufRead *.mkd  set ai formatoptions=tcroqn2 comments=n:&gt;
  autocmd BufRead *.markdown  set ai formatoptions=tcroqn2 comments=n:&gt;

  " Indent p tags
  autocmd FileType ejs,html,eruby if g:html_indent_tags !~ '\\|p\>' | let g:html_indent_tags .= '\|p\|li\|dt\|dd' | endif

  " Don't syntax highlight markdown because it's often wrong
  autocmd! FileType mkd setlocal syn=off

  " Leave the return key alone when in command line windows, since it's used
  " to run commands there.
  autocmd! CmdwinEnter * :unmap <cr>
  autocmd! CmdwinLeave * :call MapCR()
augroup END
au BufRead,BufNewFile *.pde set filetype=arduino
au BufRead,BufNewFile *.ino set filetype=arduino
au BufNewFile,BufRead *.ejs set filetype=html
" }}}
" Airline {{{
 if !exists('g:airline_symbols')
   let g:airline_symbols = {}
 endif
  let g:airline_left_sep = ''
  let g:airline_left_alt_sep = ''
  let g:airline_right_sep = ''
  let g:airline_right_alt_sep = ''
  let g:airline_symbols.branch = ''
  let g:airline_symbols.readonly = ''
  let g:airline_symbols.linenr = ''
"  let g:airline#extensions#tabline#enabled = 1
" let g:airline_left_sep = '»'
" let g:airline_left_sep = '▶'
" let g:airline_right_sep = '«'
" let g:airline_right_sep = '◀'
" let g:airline_symbols.linenr = '␊'
" let g:airline_symbols.linenr = '␤'
" let g:airline_symbols.linenr = '¶'
" let g:airline_symbols.branch = '⎇'
" let g:airline_symbols.paste = 'ρ'
" let g:airline_symbols.paste = 'Þ'
" let g:airline_symbols.paste = '∥'
" let g:airline_symbols.whitespace = 'Ξ'
 let g:airline_theme='solarized'
 let g:airline#extensions#whitespace#enabled = 0
 let g:airline#extensions#bufferline#enabled = 1
 let g:airline#extensions#bufferline#overwrite_variables = 1
 let g:bufferline_echo = 0

"let g:airline_powerline_fonts = 1
let g:airline#extensions#tmuxline#enabled = 0
set laststatus=2
" }}}
" STATUS LINE {{{
:set statusline=%<%f\ (%{&ft})\ %-4(%m%)%=%-19(%3l,%02c%03V%)
" }}}
" Syntastic {{{
let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': ['ruby' ],
                           \ 'passive_filetypes': ['puppet', 'php'] }
" }}}
" Files and Buffers {{{
" OPEN FILES IN DIRECTORY OF CURRENT FILE
cnoremap %% <C-R>=expand('%:h').'/'<cr>
map <leader>e :edit %%
map <leader>v :view %%
" RENAME CURRENT FILE
function! RenameFile()
    let old_name = expand('%')
    let new_name = input('New file name: ', expand('%'), 'file')
    if new_name != '' && new_name != old_name
        exec ':saveas ' . new_name
        exec ':silent !rm ' . old_name
        redraw!
    endif
endfunction
map <leader>n :call RenameFile()<cr>
" }}}
" MISC KEY MAPS {{{
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Insert a hash rocket with <c-l>
imap <c-l> <space>=><space>
" Can't be bothered to understand ESC vs <c-c> in insert mode
imap <c-c> <esc>
" }}}
" UlitSnip {{{
" Trigger configuration. Do not use <tab> if you use https://github.com/Valloric/YouCompleteMe.
"let g:UltiSnipsExpandTrigger="<C-c>"
"let g:UltiSnipsJumpForwardTrigger="<C-tab>"
"let g:UltiSnipsJumpBackwardTrigger="<s-tab>"
let g:UltiSnipsExpandTrigger="<tab>"
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<c-k>"
"let g:UltiSnipsSnippetsDir="~/.vim/johan/UltiSnips" 
", "vim-snippets"]

" If you want :UltiSnipsEdit to split your window.
let g:UltiSnipsEditSplit="vertical"
"let g:UltiSnipsListSnippets='<C-tab>'
"nmap <leader>s :UltiSnipsEdit<cr>
"let g:ulti_expand_or_jump_res = 0 "default value, just set once
function! Ulti_ExpandOrJump_and_getRes()
 call UltiSnips_ExpandSnippetOrJump()
 return g:ulti_expand_or_jump_res
endfunction
"inoremap <tab> <C-R>=(Ulti_ExpandOrJump_and_getRes() > 0)?"":InsertTabWrapper()<cr>
" }}}
" MULTIPURPOSE TAB KEY (disabled) {{{
" Indent if we're at the beginning of a line. Else, do completion.
function! InsertTabWrapper()
    call UltiSnips_ExpandSnippetOrJump()
    if g:ulti_expand_or_jump_res < 1
      let col = col('.') - 1
      if !col || getline('.')[col - 1] !~ '\k'
          return "\<tab>"
      else
        return "\<c-p>"
      endif
    endif
endfunction
"inoremap <tab> <c-r>=InsertTabWrapper()<cr>
"inoremap <s-tab> <c-n>
" }}}
" CtrlP {{{
nmap <leader>f :CtrlP<cr>
nmap <leader>F :CtrlP %%<cr>
nmap <leader>b :CtrlPBuffer<cr>
""let g:ctrlp_map = '<Leader>t'
""let g:ctrlp_match_window_bottom = 0
""let g:ctrlp_match_window_reversed = 0
"let g:ctrlp_custom_ignore = '\v\~$|node_modules|bower_components|\.(o|swp|pyc|wav|mp3|ogg|blend)$|(^|[/\\])\.(hg|git|bzr)($|[/\\])|__init__\.py'
let g:ctrlp_working_path_mode = 0
"let g:ctrlp_dotfiles = 0
let g:ctrlp_switch_buffer = 0
set wildignore+=*/tmp/*,*.so,*.swp,*.zip  
let g:ctrlp_match_window = 'bottom,order:ttb'  
let g:ctrlp_user_command = 'ag %s -l --nocolor --hidden -g ""'
let g:ctrlp_use_caching = 0
let grepprg='ag --nogroup --nocolor'
nnoremap K :grep! "\b<C-R><C-W>\b"<CR>:cw<CR>
"let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
"let g:ctrlp_user_command = 'find %s -type f'
"let g:ctrlp_user_command = { 
"      \ 'types': {
"      \ 1: ['.git', 'cd %s && git ls-files'],
"      \ 2: ['.hg', 'hg --cwd %s locate -I .'],
"      \ },
"      \ 'fallback': 'find %s -type f'
"      \ }
"
" 
" }}}
"  Code Completion {{{
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplete.
let g:neocomplete#enable_at_startup = 1
" Use smartcase.
let g:neocomplete#enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

" Define dictionary.
let g:neocomplete#sources#dictionary#dictionaries = {
    \ 'default' : '',
    \ 'vimshell' : $HOME.'/.vimshell_hist'
        \ }

" Define keyword.
if !exists('g:neocomplete#keyword_patterns')
    let g:neocomplete#keyword_patterns = {}
endif
let g:neocomplete#keyword_patterns['default'] = '\h\w*'

" Plugin key-mappings.
inoremap <expr><C-g>     neocomplete#undo_completion()
inoremap <expr><C-l>     neocomplete#complete_common_string()

" Recommended key-mappings.
" <CR>: close popup and save indent.
inoremap <silent> <CR> <C-r>=<SID>my_cr_function()<CR>
"inoremap <silent><expr><CR> pumvisible() ?
"    \ (len(keys(UltiSnips#SnippetsInCurrentScope())) > 0 ?
"    \ neocomplete#close_popup()."\<tab>l:call UltiSnips#ExpandSnippet()\<CR>" :
"    \ neocomplete#close_popup()) : "\<CR>"
function! s:my_cr_function()
  return neocomplete#close_popup() . "\<CR>"
  " For no inserting <CR> key.
"  return pumvisible() ? 
"        \ (len(keys(UltiSnips#SnippetsInCurrentScope())) > 0 ? 
"        \ neocomplete#close_popup()."\<C-c>l:call UltiSnips#ExpandSnippet()\<CR>" :
"        \ neocomplete#close_popup()) : "\<CR>"
endfunction
" <TAB>: completion.
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" <C-h>, <BS>: close popup and delete backword char.
inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><BS> neocomplete#smart_close_popup()."\<C-h>"
inoremap <expr><C-y>  neocomplete#close_popup()
inoremap <expr><C-e>  neocomplete#cancel_popup()
" Close popup by <Space>.
"inoremap <expr><Space> pumvisible() ? neocomplete#close_popup() : "\<Space>"

" For cursor moving in insert mode(Not recommended)
"inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
"inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
"inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
"inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"
" Or set this.
"let g:neocomplete#enable_cursor_hold_i = 1
" Or set this.
"let g:neocomplete#enable_insert_char_pre = 1

" AutoComplPop like behavior.
"let g:neocomplete#enable_auto_select = 1

" Shell like behavior(not recommended).
"set completeopt+=longest
"let g:neocomplete#enable_auto_select = 1
"let g:neocomplete#disable_auto_complete = 1
"inoremap <expr><TAB>  pumvisible() ? "\<Down>" : "\<C-x>\<C-u>"

" Enable omni completion.
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags

" Enable heavy omni completion.
if !exists('g:neocomplete#sources#omni#input_patterns')
  let g:neocomplete#sources#omni#input_patterns = {}
endif
"let g:neocomplete#sources#omni#input_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
"let g:neocomplete#sources#omni#input_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
"let g:neocomplete#sources#omni#input_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

" For perlomni.vim setting.
" https://github.com/c9s/perlomni.vim
"let g:neocomplete#sources#omni#input_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" }}}
" SWITCH BETWEEN TEST AND PRODUCTION CODE {{{
function! OpenTestAlternate()
  let new_file = AlternateForCurrentFile()
  exec ':e ' . new_file
endfunction
function! AlternateForCurrentFile()
  let current_file = expand("%")
  let new_file = current_file
  let in_spec = match(current_file, '^spec/') != -1
  let going_to_spec = !in_spec
  let in_app = match(current_file, '\<controllers\>') != -1 || match(current_file, '\<models\>') != -1 || match(current_file, '\<views\>') != -1 || match(current_file, '\<helpers\>') != -1
  if going_to_spec
    if in_app
      let new_file = substitute(new_file, '^app/', '', '')
    end
    let new_file = substitute(new_file, '\.rb$', '_spec.rb', '')
    let new_file = 'spec/' . new_file
  else
    let new_file = substitute(new_file, '_spec\.rb$', '.rb', '')
    let new_file = substitute(new_file, '^spec/', '', '')
    if in_app
      let new_file = 'app/' . new_file
    end
  endif
  return new_file
endfunction
nnoremap <leader>. :call OpenTestAlternate()<cr>
" }}}
" RUNNING TESTS {{{
map <leader>t :call RunTestFile()<cr>
map <leader>T :call RunNearestTest()<cr>
map <leader>a :call RunTests('')<cr>
map <leader>c :w\|:!script/features<cr>
map <leader>w :w\|:!script/features --profile wip<cr>

function! RunTestFile(...)
    if a:0
        let command_suffix = a:1
    else
        let command_suffix = ""
    endif

    " Run the tests for the previously-marked file.
    let in_test_file = match(expand("%"), '\(.feature\|_spec.rb\)$') != -1
    if in_test_file
        call SetTestFile()
    elseif !exists("t:grb_test_file")
        return
    end
    call RunTests(t:grb_test_file . command_suffix)
endfunction

function! RunNearestTest()
    let spec_line_number = line('.')
    call RunTestFile(":" . spec_line_number . " -b")
endfunction

function! SetTestFile()
    " Set the spec file that tests will be run for.
    let t:grb_test_file=@%
endfunction

function! RunTests(filename)
    " Write the file and run tests for the given filename
    :w
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    :silent !echo;echo;echo;echo;echo;echo;echo;echo;echo;echo
    if match(a:filename, '\.feature$') != -1
        exec ":!script/features " . a:filename
    else
        if filereadable("script/test")
            exec ":!script/test " . a:filename
        elseif filereadable("Gemfile")
            exec ":!bundle exec rspec --color " . a:filename
        else
            exec ":!rspec --color " . a:filename
        end
    end
endfunction
" }}}
" OpenChangedFiles COMMAND {{{
" Open a split for each dirty file in git
function! OpenChangedFiles()
  only " Close all windows, unless they're modified
  let status = system('git status -s | grep "^ \?\(M\|A\|UU\)" | sed "s/^.\{3\}//"')
  let filenames = split(status, "\n")
  exec "edit " . filenames[0]
  for filename in filenames[1:]
    exec "sp " . filename
  endfor
endfunction
command! OpenChangedFiles :call OpenChangedFiles()
" }}}
" InsertTime COMMAND {{{
" Insert the current time
command! InsertTime :normal a<c-r>=strftime('%F %H:%M:%S.0 %z')<cr>
function s:find_jshintrc(dir)
    let l:found = globpath(a:dir, '.jshintrc')
    if filereadable(l:found)
        return l:found
    endif

    let l:parent = fnamemodify(a:dir, ':h')
    if l:parent != a:dir
        return s:find_jshintrc(l:parent)
    endif

    return "~/.jshintrc"
endfunction
" }}}
" Update .jshintrc {{{
function UpdateJsHintConf()
    let l:dir = expand('%:p:h')
    let l:jshintrc = s:find_jshintrc(l:dir)
    let g:syntastic_javascript_jshint_conf = l:jshintrc
endfunction

au BufEnter * call UpdateJsHintConf()
" }}}
" Nvim {{{
if has('nvim')
  tnoremap <C-o> <C-\><C-n> 
  nmap <BS> <C-W>h
endif
" }}}
" vim:foldmethod=marker:foldlevel=0:set ts=2 sts=2 sw=2 expandtab:
