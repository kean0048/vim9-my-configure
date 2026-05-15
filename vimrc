"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" vim9-my-configure
" 通用 Vim 9+ 配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

let mapleader=","           " 将 <leader> 映射为 , (默认为 \)

" ── 外观 ────────────────────────────────────────────────────────────────────
colorscheme molokai
syntax enable              " 语法高亮 (保留用户配色偏好)
set number                 " 显示行号
set showmatch              " 括号匹配高亮
set mouse=a                " 启用鼠标

" ── 编辑行为 ────────────────────────────────────────────────────────────────
set autoindent             " 自动缩进
set cindent                " C 风格缩进
set smartindent            " 智能缩进
set tabstop=4              " Tab 宽度
set shiftwidth=4           " 自动对齐空格数
set expandtab              " Tab 转空格 (推荐)

" ── 文件处理 ────────────────────────────────────────────────────────────────
set nobackup               " 不生成备份文件
set noswapfile             " 不生成交换文件
filetype on                " 检测文件类型
filetype indent on         " 按文件类型缩进
filetype plugin on         " 允许文件类型插件

" ── 编码 ────────────────────────────────────────────────────────────────────
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

" ── 补全 ────────────────────────────────────────────────────────────────────
set wildmenu               " 命令行模式智能补全
set completeopt-=preview   " 补全时不显示预览窗口

" ── 状态栏 ──────────────────────────────────────────────────────────────────
set laststatus=2           " 始终显示状态栏

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 快捷键
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" ── ctags / cscope ──────────────────────────────────────────────────────────
map <F4> :!ctags -R --c-kinds=+p --fields=+iaS --extras=+q .<CR>
set tags+=./tags;,tags

map <F5> :!cscope -Rbkq<CR>

" ── 分屏窗口移动 ────────────────────────────────────────────────────────────
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" ── 系统剪贴板 ──────────────────────────────────────────────────────────────
vmap <leader><leader>y "+y         " 复制到系统剪贴板
nnoremap <leader><leader>p "+p     " 从系统剪贴板粘贴

" ── 在新窗口中打开标签 ──────────────────────────────────────────────────────
nnoremap <C-]> <C-w><C-]>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 插件管理 (vim-plug)
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 卸载插件辅助函数
function! s:deregister(repo)
  let repo = substitute(a:repo, '[\/]\+$', '', '')
  let name = fnamemodify(repo, ':t:s?\.git$??')
  call remove(g:plugs, name)
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)

call plug#begin()

Plug 'preservim/tagbar'
Plug 'yegappan/taglist'
Plug 'fholgado/minibufexpl.vim'
Plug 'Lokaltog/vim-powerline'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go'
Plug 'ycm-core/YouCompleteMe'
Plug 'github/copilot.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'tpope/vim-fugitive'

call plug#end()

" ── 插件管理快捷键 ─────────────────────────────────────────────────────────
nnoremap <leader><leader>i :PlugInstall<cr>
nnoremap <leader><leader>u :PlugUpdate<cr>
nnoremap <leader><leader>c :PlugClean<cr>

" ── NERDTree ────────────────────────────────────────────────────────────────
map <F2> :NERDTreeToggle<CR>
let NERDTreeWinPos="left"
let NERDTreeShowBookmarks=1

" ── TagList ─────────────────────────────────────────────────────────────────
map <F3> <Esc>:TlistToggle<Cr>
let Tlist_Show_One_File = 1
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 1

" ── MiniBufExplorer ─────────────────────────────────────────────────────────
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne = 0

" ── Powerline ───────────────────────────────────────────────────────────────
let g:Powerline_symbols = 'unicode'

" ── YouCompleteMe ───────────────────────────────────────────────────────────
let g:ycm_confirm_extra_conf = 0
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '✹'
let g:ycm_seed_identifiers_with_syntax = 1
let g:ycm_complete_in_comments = 1
let g:ycm_complete_in_strings = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_semantic_triggers = {
    \ 'c' : ['->', '.','re![_a-zA-z0-9]'],
    \ 'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s', 're!\[.*\]\s'],
    \ 'ocaml' : ['.', '#'],
    \ 'cpp,objcpp' : ['->', '.', '::','re![_a-zA-Z0-9]'],
    \ 'perl' : ['->'],
    \ 'php' : ['->', '::'],
    \ 'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
    \ 'ruby' : ['.', '::'],
    \ 'lua' : ['.', ':'],
    \ 'erlang' : [':'],
    \ }

nnoremap <leader>u :YcmCompleter GoToDeclaration<cr>
nnoremap <leader>o :YcmCompleter GoToInclude<cr>
nnoremap <leader>ff :YcmCompleter FixIt<cr>
nmap <F6> :YcmDiags<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 自动命令
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" 打开文件时自动定位到上次编辑位置
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 加载自定义配置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable(expand($HOME . '/.vimrc.custom.config'))
    source $HOME/.vimrc.custom.config
endif
