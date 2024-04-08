"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 通用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","           "将<leader>映射为","，默认为"\"

colorscheme molokai

" my configuration
" 关闭vi的一致性模式，避免以前版本的一些Bug和局限  
set nocompatible
 
" 打开鼠标功能
set mouse=a
syntax on "配色
syntax enable "语法高亮
" 设置取消备份，禁止临时文件生成  
set nobackup
set noswapfile
 
" 设置C/C++方式自动对齐  
set autoindent
set cindent
set smartindent
 
set number "显示行号
set tabstop=4  "tab宽度
set shiftwidth=4  "设置自动对齐空格数
 
filetype on "检测文件类型
filetype indent on "针对不同文件采用不同的缩进方式
filetype plugin on "允许插件
set showmatch "设置代码匹配，包括括号匹配情况
set nocp

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 代码补全
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set wildmenu             " vim自身命名行模式智能补全
set completeopt-=preview " 补全时不显示窗口，只显示补全列表

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 编码设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set langmenu=zh_CN.UTF-8
set helplang=cn
set termencoding=utf-8
set encoding=utf8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 卸载默认插件UnPlug
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! s:deregister(repo)
  let repo = substitute(a:repo, '[\/]\+$', '', '')
  let name = fnamemodify(repo, ':t:s?\.git$??')
  call remove(g:plugs, name)
endfunction
command! -nargs=1 -bar UnPlug call s:deregister(<args>)


" ctags的配置 ctrl+f12快速生成tags
map <F4> :!ctags -R --c-kinds=+p --fields=+iaS --extras=+q .<CR>
set tags+=./tags;,tags

" vim支持cscope
map <F5> :!cscope -Rbkq<CR>
" 添加 cscope.out
" cs add /home/renhai/works/Linuxs/linux/cscope.out /home/renhai/works/Linuxs/linux/

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
call plug#begin()

Plug 'preservim/tagbar'
Plug 'yegappan/taglist'
Plug 'fholgado/minibufexpl.vim'
Plug 'Lokaltog/vim-powerline'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go'
Plug 'ycm-core/YouCompleteMe'

call plug#end()
 
" 设置NerdTree
map <F2> :NERDTreeToggle<CR>
" 将 NERDTree 的窗口设置在 vim 窗口的右侧（默认为左侧）
let NERDTreeWinPos="left"
"  当打开 NERDTree 窗口时，自动显示 Bookmarks
let NERDTreeShowBookmarks=1
" 在 vim 启动的时候默认开启 NERDTree（autocmd 可以缩写为 au）
" autocmd VimEnter * NERDTree

" Tlist的配置
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口
" Tlist 的快捷键
map <F3> <Esc>:TlistToggle<Cr>

" YCM
" 如果不指定python解释器路径，ycm会自己搜索一个合适的(与编译ycm时使用的python版本匹配)
" let g:ycm_server_python_interpreter = '/usr/bin/python2.7'
let g:ycm_confirm_extra_conf = 0 
let g:ycm_error_symbol = '✗'
let g:ycm_warning_symbol = '✹'
let g:ycm_seed_identifiers_with_syntax = 1 
let g:ycm_complete_in_comments = 1 
let g:ycm_complete_in_strings = 1 
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_semantic_triggers =  {
            \   'c' : ['->', '.','re![_a-zA-z0-9]'],
            \   'objc' : ['->', '.', 're!\[[_a-zA-Z]+\w*\s', 're!^\s*[^\W\d]\w*\s',
            \             're!\[.*\]\s'],
            \   'ocaml' : ['.', '#'],
            \   'cpp,objcpp' : ['->', '.', '::','re![_a-zA-Z0-9]'],
            \   'perl' : ['->'],
            \   'php' : ['->', '::'],
            \   'cs,java,javascript,typescript,d,python,perl6,scala,vb,elixir,go' : ['.'],
            \   'ruby' : ['.', '::'],
            \   'lua' : ['.', ':'],
            \   'erlang' : [':'],
            \ }
nnoremap <leader>u :YcmCompleter GoToDeclaration<cr>
" 已经使用cpp-mode插件提供的转到函数实现的功能
" nnoremap <leader>i :YcmCompleter GoToDefinition<cr> 
nnoremap <leader>o :YcmCompleter GoToInclude<cr>
nnoremap <leader>ff :YcmCompleter FixIt<cr>
nmap <F6> :YcmDiags<cr>


let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1
let g:miniBufExplMoreThanOne=0

set laststatus=1
let g:Powerline_symbols='unicode'

"-- Cscope setting --
" 添加cscope数据库到当前vim
if has("cscope")
    set csprg=/usr/bin/cscope " 指定用来执行cscope的命令
    set csto=0 " 设置cstag命令查找次序：0先找cscope数据库再找标签文件；1先找标签文件再找cscope数据库
    set cst " 同时搜索cscope数据库和标签文件
    set cscopequickfix=s-,c-,d-,i-,t-,e- " 使用QuickFix窗口来显示cscope查找结果
    set nocsverb
    if filereadable("cscope.out") " 若当前目录下存在cscope数据库，添加该数据库到vim
        cs add cscope.out
        "elseif $CSCOPE_DB != "" " 否则只要环境变量CSCOPE_DB不为空，则添加其指定的数据库到vim
        "    cs add $CSCOPE_DB
    endif
    set csverb
endif

nmap css :cs find s <C-R>=expand("<cword>")<CR><CR> 	"查找C语言符号，即查找函数名、宏、枚举值等出现的地方
nmap csg :cs find g <C-R>=expand("<cword>")<CR><CR>	"查找函数、宏、枚举等定义的位置，类似ctags所提供的功能
nmap csc :cs find c <C-R>=expand("<cword>")<CR><CR>	"查找本函数调用的函数
nmap cst :cs find t <C-R>=expand("<cword>")<CR><CR>	"查找调用本函数的函数
nmap cse :cs find e <C-R>=expand("<cword>")<CR><CR>	"查找指定的字符串
nmap csf :cs find f <C-R>=expand("<cfile>")<CR><CR>	"查找egrep模式，相当于egrep功能，但查找速度快多了
nmap csi :cs find i <C-R>=expand("<cfile>")<CR>$<CR>	"查找并打开文件，类似vim的find功能
nmap csd :cs find d <C-R>=expand("<cword>")<CR><CR>	"查找包含本文件的文

" 打开文件自动定位到最后编辑的位置
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif

" 复制当前选中到系统剪切板
vmap <leader><leader>y "+y

" 将系统剪切板内容粘贴到vim
nnoremap <leader><leader>p "+p

" 分屏窗口移动
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" 安装、更新、删除插件
nnoremap <leader><leader>i :PlugInstall<cr>
nnoremap <leader><leader>u :PlugUpdate<cr>
nnoremap <leader><leader>c :PlugClean<cr>

" 加载自定义配置
if filereadable(expand($HOME . '/.vimrc.custom.config'))
    source $HOME/.vimrc.custom.config
endif
