#!/bin/bash
#===============================================================================
# vim9-my-configure — Vim 9+ 配置安装脚本
# 支持: Debian / Ubuntu / Fedora
# 用法:
#   ./install.sh              # 交互模式
#   NONINTERACTIVE=1 ./install.sh  # 非交互模式 (CI/自动化)
#===============================================================================

set -euo pipefail

# ── 颜色输出 ──────────────────────────────────────────────────────────────────
RED='\033[0;31m'; GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
info()  { echo -e "${GREEN}[INFO]${NC}  $*"; }
warn()  { echo -e "${YELLOW}[WARN]${NC}  $*"; }
error() { echo -e "${RED}[ERROR]${NC} $*"; exit 1; }

# ── 发行版检测 (基于 /etc/os-release) ────────────────────────────────────────
detect_distro() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        case "${ID}" in
            debian|ubuntu|linuxmint|pop|elementary|zorin) echo "debian"  ;;
            fedora|rhel|centos|rocky|alma|ol)             echo "fedora"  ;;
            *)                                           echo "unknown" ;;
        esac
    else
        echo "unknown"
    fi
}

detect_distro_name() {
    if [ -f /etc/os-release ]; then
        . /etc/os-release
        echo "${PRETTY_NAME:-${NAME:-Unknown}}"
    else
        echo "Unknown"
    fi
}

# ── 依赖安装 ──────────────────────────────────────────────────────────────────
install_deps_debian() {
    info "检测到 Debian/Ubuntu 系发行版: $(detect_distro_name)"
    info "更新软件源…"
    sudo apt update -qq

    info "安装基础构建工具…"
    sudo apt install -y \
        build-essential \
        cmake \
        git \
        curl \
        python3-dev \
        nodejs \
        npm \
        universal-ctags \
        cscope

    info "安装 Vim (带 Python3 和剪贴板支持)…"
    sudo apt install -y vim-gtk3 || sudo apt install -y vim-nox
}

install_deps_fedora() {
    info "检测到 Fedora/RHEL 系发行版: $(detect_distro_name)"
    info "更新软件源…"
    sudo dnf update -y

    info "安装基础构建工具…"
    sudo dnf install -y \
        gcc gcc-c++ make automake \
        cmake \
        git \
        curl \
        python3-devel \
        nodejs \
        npm \
        universal-ctags \
        cscope

    info "安装 Vim (带 Python3 和 GUI 支持)…"
    sudo dnf install -y vim-enhanced vim-X11
}

# ── 环境检查 ──────────────────────────────────────────────────────────────────
check_prerequisites() {
    info "检查运行环境…"

    # Bash 版本
    if [ "${BASH_VERSINFO[0]}" -lt 4 ]; then
        warn "Bash 版本过低 (${BASH_VERSION})，建议 >= 4.0"
    fi

    # 确认是 Linux
    if [ "$(uname -s)" != "Linux" ]; then
        error "当前仅支持 Linux 平台，检测到: $(uname -s)"
    fi

    # sudo 权限
    if ! sudo -n true 2>/dev/null; then
        warn "需要 sudo 权限来安装系统软件包"
        info "可能会提示你输入密码"
    fi
}

# ── 检测 Python ───────────────────────────────────────────────────────────────
detect_python() {
    local py_cmd=""

    # 优先 Python 3
    for candidate in python3 python3.12 python3.11 python3.10 python3.9 python3.8 python; do
        if command -v "$candidate" &>/dev/null; then
            local ver
            ver=$("$candidate" --version 2>&1 | grep -oP '\d+\.\d+' | head -1)
            if [ -n "$ver" ]; then
                local major; major=$(echo "$ver" | cut -d. -f1)
                if [ "$major" -ge 3 ]; then
                    py_cmd="$candidate"
                    break
                fi
            fi
        fi
    done

    if [ -z "$py_cmd" ]; then
        error "未找到 Python 3 (>= 3.8) 解释器，请先安装 Python 3"
    fi

    echo "$py_cmd"
}

# ── 部署配置文件 ──────────────────────────────────────────────────────────────
deploy_configs() {
    local distro; distro=$(detect_distro)
    local src_dir; src_dir="$(cd "$(dirname "$0")" && pwd)"

    info "部署 Vim 配置文件…"

    # 备份已有配置
    for f in "$HOME/.vim" "$HOME/.vimrc" "$HOME/.vimrc.custom.config"; do
        if [ -e "$f" ] && [ ! -L "$f" ]; then
            local bak="${f}.bak.$(date +%Y%m%d%H%M%S)"
            info "备份 $f → $bak"
            mv "$f" "$bak"
        fi
    done

    cp -rf "$src_dir/vim"        "$HOME/.vim"
    cp -f  "$src_dir/vimrc"      "$HOME/.vimrc"
    cp -f  "$src_dir/vimrc.custom.config" "$HOME/.vimrc.custom.config"
    cp -f  "$src_dir/ycm_extra_conf.py"   "$HOME/.ycm_extra_conf.py"

    info "配置文件部署完成"
}

# ── 安装 vim-plug ─────────────────────────────────────────────────────────────
ensure_vim_plug() {
    local plug_path="$HOME/.vim/autoload/plug.vim"

    if [ -f "$plug_path" ]; then
        info "vim-plug 已就绪"
        return
    fi

    info "下载 vim-plug…"
    curl -fLo "$plug_path" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    info "vim-plug 安装完成"
}

# ── 安装 Vim 插件 ─────────────────────────────────────────────────────────────
install_vim_plugins() {
    info "安装 Vim 插件 (PlugInstall)…"
    # 静默安装插件，忽略交互错误
    vim -E -s -u "$HOME/.vimrc" -c "PlugInstall" -c "qa" 2>/dev/null || {
        warn "部分插件安装可能失败 (非致命)，可手动执行 :PlugInstall"
    }
    info "插件安装完成"
}

# ── 安装 YouCompleteMe ────────────────────────────────────────────────────────
install_ycm() {
    local ycm_path="$HOME/.vim/plugged/YouCompleteMe"

    # 检查是否已编译成功
    if [ -f "$ycm_path/third_party/ycmd/ycm_core.so" ] || \
       [ -f "$ycm_path/third_party/ycmd/ycm_core."*.so ]; then
        info "YouCompleteMe 已编译，跳过"
        return
    fi

    info "克隆 YouCompleteMe…"
    if [ ! -d "$ycm_path" ]; then
        git clone --depth=1 https://github.com/ycm-core/YouCompleteMe.git "$ycm_path"
    fi

    cd "$ycm_path"
    info "更新子模块…"
    git submodule update --init --recursive --depth=1

    local python_cmd; python_cmd=$(detect_python)
    info "使用 ${python_cmd} 编译 YouCompleteMe…"

    if "$python_cmd" install.py --clang-completer 2>&1 | tail -20; then
        info "YouCompleteMe (with clang) 编译成功"
    else
        warn "带 clang 编译失败，尝试无 clang 编译…"
        if "$python_cmd" install.py 2>&1 | tail -20; then
            info "YouCompleteMe 编译成功 (without clang)"
        else
            error "YouCompleteMe 编译失败，请检查编译日志"
        fi
    fi

    cd - > /dev/null
}

# ── Fedora 特殊处理 ───────────────────────────────────────────────────────────
setup_fedora_alias() {
    local distro; distro=$(detect_distro)
    if [ "$distro" != "fedora" ]; then
        return
    fi

    info "配置 Fedora vim 别名…"
    # 检查是否已经有别名
    if grep -q "alias vim=" "$HOME/.bashrc" 2>/dev/null; then
        info "~/.bashrc 中已存在 vim 别名，跳过"
        return
    fi

    # 只有 vimx 存在且不同于 vim 时才添加别名
    if command -v vimx &>/dev/null && [ "$(command -v vim)" != "$(command -v vimx)" ]; then
        echo 'alias vim=vimx' >> "$HOME/.bashrc"
        info "添加 alias vim=vimx 到 ~/.bashrc"
    fi
}

# ── 验证安装 ──────────────────────────────────────────────────────────────────
verify_installation() {
    info "验证安装…"
    local ok=true

    # 检查 vim
    if ! command -v vim &>/dev/null; then
        warn "vim 未安装或不在 PATH 中"
        ok=false
    else
        local vim_ver; vim_ver=$(vim --version 2>/dev/null | head -1 || echo "unknown")
        info "Vim 版本: $vim_ver"
    fi

    # 检查关键配置
    for f in "$HOME/.vimrc" "$HOME/.vim" "$HOME/.ycm_extra_conf.py"; do
        if [ ! -e "$f" ]; then
            warn "缺少: $f"
            ok=false
        fi
    done

    # vim-plug
    if [ ! -f "$HOME/.vim/autoload/plug.vim" ]; then
        warn "vim-plug 未安装"
        ok=false
    fi

    if $ok; then
        info "安装验证通过"
    else
        warn "部分组件可能未正确安装，请检查上述警告"
    fi
}

# ── 打印摘要 ──────────────────────────────────────────────────────────────────
print_summary() {
    local distro_name; distro_name=$(detect_distro_name)
    local python_cmd; python_cmd=$(detect_python 2>/dev/null || echo "?")
    local vim_ver; vim_ver=$(vim --version 2>/dev/null | head -1 || echo "未安装")

    echo ""
    echo "╔══════════════════════════════════════════════╗"
    echo "║        vim9-my-configure 安装完成            ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║  发行版 : $(printf '%-34s' "$distro_name")║"
    echo "║  Vim    : $(printf '%-34s' "$vim_ver")║"
    echo "║  Python : $(printf '%-34s' "$python_cmd")║"
    echo "║  配置   : ~/.vimrc, ~/.vim/                 ║"
    echo "╠══════════════════════════════════════════════╣"
    echo "║  常用快捷键:                                 ║"
    echo "║    F2  - NERDTree 文件树                     ║"
    echo "║    F3  - TagList 标签列表                    ║"
    echo "║    F4  - 生成 ctags                          ║"
    echo "║    F5  - 生成 cscope                         ║"
    echo "║    F6  - YCM 诊断信息                        ║"
    echo "║    ,,i - 安装插件     ,,u - 更新插件         ║"
    echo "║    ,,y - 复制到剪贴板  ,,p - 粘贴            ║"
    echo "╚══════════════════════════════════════════════╝"
    echo ""
    info "重新打开终端或执行 'source ~/.bashrc' 使别名生效"
}

# ═══════════════════════════════════════════════════════════════════════════════
# main
# ═══════════════════════════════════════════════════════════════════════════════
main() {
    echo ""
    info "vim9-my-configure 安装脚本启动"
    info "当前平台: $(uname -s) / $(uname -m)"
    echo ""

    check_prerequisites

    local distro; distro=$(detect_distro)

    case "$distro" in
        debian)
            install_deps_debian
            ;;
        fedora)
            install_deps_fedora
            ;;
        *)
            error "不支持的发行版: $(detect_distro_name)
支持: Debian / Ubuntu / Linux Mint / Pop!_OS / Fedora / RHEL / CentOS"
            ;;
    esac

    deploy_configs
    ensure_vim_plug
    install_vim_plugins
    install_ycm
    setup_fedora_alias
    verify_installation
    print_summary
}

main "$@"
