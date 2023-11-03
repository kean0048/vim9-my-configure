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
" 设置编码方式  
set encoding=utf-8
 
set number "显示行号
set tabstop=4  "tab宽度
set shiftwidth=4  "设置自动对齐空格数
 
filetype on "检测文件类型
filetype indent on "针对不同文件采用不同的缩进方式
filetype plugin on "允许插件
set showmatch "设置代码匹配，包括括号匹配情况
set nocp

let mapleader=","           "将<leader>映射为","，默认为"\"
" ctags的配置 ctrl+f12快速生成tags
map <F4> :!ctags -R --c-kinds=+p --fields=+iaS --extras=+q .<CR>
" set tags+=/home/renhai/works/Linuxs/linux/tags

" vim支持cscope
map <F5> :!cscope -Rbkq<CR>
" 添加 cscope.out
" cs add /home/renhai/works/Linuxs/linux/cscope.out /home/renhai/works/Linuxs/linux/
 
" 设置NerdTree
map <F3> :NERDTreeToggle<CR>
" 将 NERDTree 的窗口设置在 vim 窗口的右侧（默认为左侧）
let NERDTreeWinPos="left"
"  当打开 NERDTree 窗口时，自动显示 Bookmarks
let NERDTreeShowBookmarks=1
" 在 vim 启动的时候默认开启 NERDTree（autocmd 可以缩写为 au）
" autocmd VimEnter * NERDTree

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

call plug#begin()

Plug 'preservim/tagbar'
Plug 'yegappan/taglist'
Plug 'fholgado/minibufexpl.vim'
Plug 'Lokaltog/vim-powerline'
Plug 'preservim/nerdtree'
Plug 'fatih/vim-go'
Plug 'Valloric/YouCompleteMe'

call plug#end()

" Tlist的配置
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口
" Tlist 的快捷键
map <F2> <Esc>:TlistToggle<Cr>


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
    set csprg=~/bin/cscope " 指定用来执行cscope的命令
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

nnoremap <C-J> <C-W><C-J> "Ctrl-j to move down a split  
nnoremap <C-K> <C-W><C-K> "Ctrl-k to move up a split  
nnoremap <C-L> <C-W><C-L> "Ctrl-l to move    right a split  
nnoremap <C-H> <C-W><C-H> "Ctrl-h to move left a split
