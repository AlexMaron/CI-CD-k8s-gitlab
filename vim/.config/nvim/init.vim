set nocompatible               " be improved, required
filetype off                   " required
" set the runtime path to include Vundle and initialize
let g:indent_guides_enable_on_vim_startup = 1
set rtp+=~/.config/nvim/bundle/Vundle.vim
set ts=2 sw=2 et
let g:indent_guides_start_level = 1
let g:indent_guides_guide_size = 2
let g:indent_guides_auto_colors = 0
hi IndentGuidesOdd  guibg=black   ctermbg=239
hi IndentGuidesEven guibg=darkgray ctermbg=237
call vundle#begin()            " required
Plugin 'VundleVim/Vundle.vim'  " required

" ===================
" my plugins here
" ===================

" Plugin 'dracula/vim'
Plugin 'tpope/vim-fugitive'
Plugin 'scrooloose/syntastic'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'valloric/YouCompleteme'
Plugin 'mileszs/ack.vim'
Plugin 'nathanaelkane/vim-indent-guides'
Plugin 'shougo/unite.vim'
Plugin 'Shougo/vimproc.vim'
Plugin 'shougo/neomru.vim'
Plugin 'Shougo/neoyank.vim'
Plugin 'Shougo/unite-outline'

" ===================
" end of plugins
" ===================
call vundle#end()               " required
filetype plugin indent on       " required


"airline
let g:airline_powerline_fonts = 0
let g:airline#extensions#tabline#enabled = 1
if !exists('g:airline_symbols')
  let g:airline_symbols = {}
endif

"Unite
call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_rank'])
call unite#custom#source('file_rec/async','sorters','sorter_rank', )      
" replacing unite with ctrl-p
let g:unite_data_directory='~/.vim/.cache/unite'
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable=1
let g:unite_prompt='» '
let g:unite_split_rule = 'botright'
let g:unite_source_rec_async_command = ['ag', '--follow', '--nocolor', '--nogroup', '--hidden', '-g', '']

"if executable('ag')
"  let g:unite_source_grep_command='ag'
"  let g:unite_source_grep_default_opts='--nocolor --nogroup -S -C4'       
"  let g:unite_source_grep_recursive_opt=''
"endif
let g:unite_source_grep_command = 'ag'
let g:unite_source_grep_default_opts =
    \ '--line-numbers --nocolor --nogroup --hidden --ignore ' .
    \  '''.hg'' --ignore ''.svn'' --ignore ''.git'' --ignore ''.bzr'''
let g:unite_source_grep_recursive_opt = ''

" The prefix key.
	nnoremap    [unite]   <Nop>
	nmap    f [unite]
	nnoremap <silent> [unite]c  :<C-u>UniteWithCurrentDir
	        \ -buffer-name=files buffer bookmark file<CR>
	nnoremap <silent> [unite]e  :<C-u>Unite
	        \ -buffer-name=roles file_rec file/new -path=/home/vagrant/provisioning/ansible/roles/ file<CR>
	nnoremap <silent> [unite]b  :<C-u>UniteWithBufferDir
	        \ -buffer-name=files buffer bookmark file<CR>
	nnoremap <silent> [unite]r  :<C-u>Unite
	        \ -buffer-name=register register<CR>
	nnoremap <silent> [unite]o  :<C-u>Unite outline<CR>
	nnoremap <silent> [unite]f
	        \ :<C-u>Unite -buffer-name=resume resume<CR>
	nnoremap <silent> [unite]ma
	        \ :<C-u>Unite mapping<CR>
	nnoremap <silent> [unite]me
	        \ :<C-u>Unite output:message<CR>
	nnoremap  [unite]f  :<C-u>Unite source<CR>
	nnoremap <silent> [unite]s
	        \ :<C-u>Unite -buffer-name=files -no-split
	        \ jump_point file_point buffer_tab
	        \ file_rec:! file file/new<CR>
  nnoremap  <silent> [unite]g  :<C-u>Unite grep:.<CR>
  " Start insert.
	"call unite#custom#profile('default', 'context', {
	"\   'start_insert': 1
	"\ })
	" Like ctrlp.vim settings.
	"call unite#custom#profile('default', 'context', {
	"\   'start_insert': 1,
	"\   'winheight': 10,
	"\   'direction': 'botright',
	"\ })
	autocmd FileType unite call s:unite_my_settings()
	function! s:unite_my_settings()"{{{
	  " Overwrite settings.
	  imap <buffer> jj      <Plug>(unite_insert_leave)
	  "imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
	  imap <buffer><expr> j unite#smart_map('j', '')
	  imap <buffer> <TAB>   <Plug>(unite_select_next_line)
	  imap <buffer> <C-w>     <Plug>(unite_delete_backward_path)
	  imap <buffer> '     <Plug>(unite_quick_match_default_action)
	  nmap <buffer> '     <Plug>(unite_quick_match_default_action)
	  imap <buffer><expr> x
	          \ unite#smart_map('x', "\<Plug>(unite_quick_match_jump)")
	  nmap <buffer> x     <Plug>(unite_quick_match_jump)
	  nmap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
	  imap <buffer> <C-z>     <Plug>(unite_toggle_transpose_window)
	  nmap <buffer> <C-j>     <Plug>(unite_toggle_auto_preview)
	  nmap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
	  imap <buffer> <C-r>     <Plug>(unite_narrowing_input_history)
	  nnoremap <silent><buffer><expr> l
	          \ unite#smart_map('l', unite#do_action('default'))
	  let unite = unite#get_current_unite()
	  if unite.profile_name ==# 'search'
	    nnoremap <silent><buffer><expr> r     unite#do_action('replace')
	  else
	    nnoremap <silent><buffer><expr> r     unite#do_action('rename')
	  endif
	  nnoremap <silent><buffer><expr> cd     unite#do_action('lcd')
	  nnoremap <buffer><expr> S      unite#mappings#set_current_sorters(
	          \ empty(unite#mappings#get_current_sorters()) ?
	          \ ['sorter_reverse'] : [])
	  " Runs "split" action by <C-s>.
	  imap <silent><buffer><expr> <C-s>     unite#do_action('split')
	endfunction"}}}

  " Go to last file(s) if invoked without arguments.
autocmd VimLeave * nested if (!isdirectory($HOME . "/.vim")) |
    \ call mkdir($HOME . "/.vim") |
    \ endif |
    \ execute "mksession! " . $HOME . "/.vim/Session.vim"

autocmd VimEnter * nested if argc() == 0 && filereadable($HOME . "/.vim/Session.vim") |
    \ execute "source " . $HOME . "/.vim/Session.vim"
