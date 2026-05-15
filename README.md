# vim9-my-configure

Vim 9+ 全功能配置套件，一键安装脚本支持 **Debian** 和 **Fedora** 两大 Linux 发行版家族。

## 包含功能

- **语法高亮** — molokai 配色 + UTF-8 中文编码
- **智能补全** — YouCompleteMe (C/C++/Python/Go/JS 等)
- **GitHub Copilot** — AI 代码补全
- **文件浏览** — NERDTree 侧边栏 (F2)
- **标签导航** — TagList (F3) + ctags (F4) + cscope (F5)
- **多缓冲管理** — MiniBufExplorer
- **状态栏美化** — vim-powerline
- **编辑增强** — vim-surround / vim-commentary / auto-pairs
- **Git 集成** — vim-fugitive
- **Go 支持** — vim-go

## 支持的发行版

| 家族 | 发行版 |
|------|--------|
| **Debian 系** | Debian, Ubuntu, Linux Mint, Pop!_OS, Elementary OS, Zorin OS |
| **Fedora 系** | Fedora, RHEL, CentOS, Rocky Linux, AlmaLinux, Oracle Linux |

## 安装

```bash
git clone https://github.com/你的用户名/vim9-my-configure.git
cd vim9-my-configure
chmod +x install.sh
./install.sh
```

脚本会自动：
1. 检测你的 Linux 发行版
2. 安装所有必需的系统依赖 (构建工具、Vim、Python3 开发包等)
3. 部署 Vim 配置文件 (~/.vimrc, ~/.vim/, ~/.ycm_extra_conf.py)
4. 安装 vim-plug 插件管理器
5. 安装所有 Vim 插件
6. 编译 YouCompleteMe (含 C/C++ clang 补全支持)

### 非交互模式 (CI/自动化)

```bash
NONINTERACTIVE=1 ./install.sh
```

## 目录结构

```
vim9-my-configure/
├── install.sh            # 安装脚本
├── vimrc                 # Vim 主配置文件 → ~/.vimrc
├── vimrc.custom.config   # 自定义配置 (Copilot, cscope 快捷键) → ~/.vimrc.custom.config
├── ycm_extra_conf.py     # YouCompleteMe 额外配置 → ~/.ycm_extra_conf.py
├── vim/
│   ├── autoload/
│   │   └── plug.vim      # vim-plug 插件管理器
│   ├── colors/
│   │   ├── molokai.vim
│   │   └── solarized.vim
│   ├── plugged/          # 插件安装目录
│   └── doc/
└── README.md
```

## 常用快捷键

| 快捷键 | 功能 |
|--------|------|
| `F2` | 切换 NERDTree 文件树 |
| `F3` | 切换 TagList 标签列表 |
| `F4` | 生成 ctags |
| `F5` | 生成 cscope |
| `F6` | YCM 诊断信息 |
| `,,i` | 安装插件 |
| `,,u` | 更新插件 |
| `,,c` | 清理未使用的插件 |
| `,,y` | 复制选中内容到系统剪贴板 |
| `,,p` | 从系统剪贴板粘贴 |
| `Ctrl+J/K/H/L` | 分屏窗口间移动 |
| `Ctrl+]` | 在新窗口中打开标签预览 |
| `<leader>u` | YCM 跳转到声明 |
| `<leader>o` | YCM 跳转到头文件 |
| `<leader>ff` | YCM 自动修复建议 |

> 注: `<leader>` 默认映射为 `,` 键。

## 系统依赖

### Debian/Ubuntu

- build-essential, cmake, git, curl
- python3-dev, nodejs, npm
- universal-ctags, cscope
- vim-gtk3 (或 vim-nox)

### Fedora/RHEL

- gcc, gcc-c++, make, automake, cmake, git, curl
- python3-devel, nodejs, npm
- universal-ctags, cscope
- vim-enhanced, vim-X11

## 自定义

- 编辑 `~/.vimrc.custom.config` 添加你的个人配置
- 修改 `~/.ycm_extra_conf.py` 调整 YCM 编译选项
- 在 `~/.vimrc` 中使用 `:UnPlug 插件名` 移除不需要的插件

## 许可证

MIT
