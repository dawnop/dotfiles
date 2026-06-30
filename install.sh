#!/usr/bin/env bash
# dotfiles 安装脚本
# - 软链 zsh / starship 配置
# - 引用并安装 dawn.nvim（管理 nvim + tmux）
set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONFIG_DIR="${HOME}/.config"
DAWN_NVIM_REPO="https://github.com/dawnop/dawn.nvim.git"
DAWN_NVIM_DIR="${CONFIG_DIR}/dawn.nvim"

GREEN='\033[0;32m'; YELLOW='\033[0;33m'; RED='\033[0;31m'; NC='\033[0m'
info() { echo -e "${GREEN}[INFO]${NC} $1"; }
warn() { echo -e "${YELLOW}[WARN]${NC} $1"; }
err()  { echo -e "${RED}[ERROR]${NC} $1"; }

backup_if_exists() {
    local target="$1"
    if [ -e "$target" ] || [ -L "$target" ]; then
        local backup="${target}.backup.$(date +%Y%m%d%H%M%S)"
        warn "备份已存在的 $target -> $backup"
        mv "$target" "$backup"
    fi
}

link() {
    local src="$1" dst="$2"
    backup_if_exists "$dst"
    ln -s "$src" "$dst"
    info "软链: $dst -> $src"
}

install_omz() {
    # oh-my-zsh 本体
    if [ ! -d "$HOME/.oh-my-zsh" ]; then
        info "安装 oh-my-zsh ..."
        RUNZSH=no KEEP_ZSHRC=yes sh -c \
            "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    fi
    # 两个外部插件（.zshrc 的 plugins=() 依赖它们）
    local custom="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
    local -a repos=(
        "https://github.com/zsh-users/zsh-autosuggestions $custom/plugins/zsh-autosuggestions"
        "https://github.com/zsh-users/zsh-syntax-highlighting $custom/plugins/zsh-syntax-highlighting"
    )
    for entry in "${repos[@]}"; do
        set -- $entry
        [ -d "$2" ] || { info "安装插件 $(basename "$2") ..."; git clone --depth=1 "$1" "$2"; }
    done
}

main() {
    mkdir -p "$CONFIG_DIR"

    # ── 1. oh-my-zsh + 插件 ──
    install_omz

    # ── 2. zsh 配置 ──
    for f in .zshrc .zprofile .zshenv; do
        link "$SCRIPT_DIR/zsh/$f" "$HOME/$f"
    done

    # ── 3. starship 配置 ──
    link "$SCRIPT_DIR/starship/starship.toml" "$CONFIG_DIR/starship.toml"

    # ── 3.5 其余 app 配置（ghostty / atuin / btop）──
    mkdir -p "$CONFIG_DIR/ghostty" "$CONFIG_DIR/atuin" "$CONFIG_DIR/btop"
    link "$SCRIPT_DIR/ghostty/config"     "$CONFIG_DIR/ghostty/config"
    link "$SCRIPT_DIR/atuin/config.toml"  "$CONFIG_DIR/atuin/config.toml"
    link "$SCRIPT_DIR/btop/btop.conf"     "$CONFIG_DIR/btop/btop.conf"

    # ── 4. 引用 dawn.nvim（nvim + tmux）──
    if [ -d "$DAWN_NVIM_DIR/.git" ]; then
        info "更新已存在的 dawn.nvim ..."
        git -C "$DAWN_NVIM_DIR" pull --ff-only || warn "dawn.nvim 更新失败，跳过"
    else
        info "克隆 dawn.nvim ..."
        git clone "$DAWN_NVIM_REPO" "$DAWN_NVIM_DIR"
    fi
    info "运行 dawn.nvim 安装脚本（配置 nvim + tmux）..."
    bash "$DAWN_NVIM_DIR/install.sh"

    echo ""
    info "安装完成！已配置："
    echo "  - oh-my-zsh + 插件 (autosuggestions / syntax-highlighting)"
    echo "  - zsh      -> ~/.zshrc ~/.zprofile ~/.zshenv"
    echo "  - starship -> ~/.config/starship.toml"
    echo "  - ghostty  -> ~/.config/ghostty/config"
    echo "  - atuin    -> ~/.config/atuin/config.toml"
    echo "  - btop     -> ~/.config/btop/btop.conf"
    echo "  - nvim/tmux -> 由 dawn.nvim 管理 ($DAWN_NVIM_DIR)"
    echo ""
    echo "下一步: brew bundle --file=$SCRIPT_DIR/Brewfile   # 安装工具链"
    echo "        exec zsh                                   # 重载 shell"
}

main "$@"
