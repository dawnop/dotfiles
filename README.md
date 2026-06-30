# dotfiles

我的 macOS 开发环境配置（shell 层）。编辑器/复用层由独立项目 [dawn.nvim](https://github.com/dawnop/dawn.nvim) 管理，本仓库自动引用它。

## 技术栈

| 层 | 工具 |
|----|------|
| 终端 | iTerm2（或 Ghostty） |
| Shell | zsh + oh-my-zsh（autosuggestions / syntax-highlighting） |
| Prompt | [Starship](https://starship.rs)（gruvbox-rainbow preset） |
| 编辑器 | Neovim ← [dawn.nvim](https://github.com/dawnop/dawn.nvim) |
| 复用层 | tmux ← [dawn.nvim](https://github.com/dawnop/dawn.nvim) |
| CLI 工具 | eza · bat · fzf · ripgrep · zoxide · mise · [atuin](https://atuin.sh)（历史）· dust · procs · tokei |
| 监控 | btop |

## 目录结构

```
dotfiles/
├── install.sh          # 装 oh-my-zsh + 插件，软链各配置，克隆并安装 dawn.nvim
├── Brewfile            # 一键安装工具链
├── zsh/                # .zshrc .zprofile .zshenv
├── starship/           # starship.toml
├── ghostty/            # config（终端配置）
├── atuin/              # config.toml（shell 历史）
└── btop/               # btop.conf（资源监控）
```

> nvim 与 tmux 的配置**不在本仓库**，由 `install.sh` 自动 clone [dawn.nvim](https://github.com/dawnop/dawn.nvim) 到 `~/.config/dawn.nvim` 并运行其安装脚本。

## 安装

```bash
git clone https://github.com/dawnop/dotfiles.git ~/workspace/dotfiles
cd ~/workspace/dotfiles

# 1. 安装工具链（含 Nerd Font）
brew bundle --file=Brewfile

# 2. 软链配置 + 安装 dawn.nvim
./install.sh

# 3. 重载 shell
exec zsh
```

安装脚本会在覆盖前自动备份已有配置为 `*.backup.<时间戳>`。

## 说明

- **Prompt 切换**：`starship preset <name> -o ~/.config/starship.toml --force`，可选 `gruvbox-rainbow`、`catppuccin-powerline` 等。
- **字体**：终端需设为 Nerd Font（JetBrainsMono / Hack）才能正常显示图标。
