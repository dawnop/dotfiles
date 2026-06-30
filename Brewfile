# Brewfile — 一键安装本套开发环境依赖
# 用法: brew bundle --file=Brewfile
#
# 这里只列 shell 层工具链。nvim/tmux 由 dawn.nvim 项目管理。

# ── Shell prompt ──
brew "starship"          # 跨 shell 提示符

# ── 现代化 CLI 工具 ──
brew "eza"               # ls 替代（图标/git 状态）
brew "bat"               # cat 替代（语法高亮）
brew "fzf"               # 模糊查找
brew "ripgrep"           # grep 替代（极快）
brew "fd"                # find 替代（television/fzf 的查找后端）
brew "zoxide"            # 智能 cd
brew "mise"              # 多语言版本管理
brew "git-delta"         # git diff 高亮
brew "television"        # 通用模糊查找器 (命令: tv)
brew "navi"              # 交互式命令速查表
brew "tldr"              # 命令速查（人话版 man）
brew "atuin"             # shell 历史（可搜索/同步）
brew "dust"              # du 替代（磁盘占用可视化）
brew "procs"             # ps 替代
brew "tokei"             # 代码行数统计
brew "onefetch"          # 仓库信息速览（git 版 neofetch）
brew "hyperfine"         # 命令基准测试
brew "jq"                # JSON 处理器
brew "duti"              # 设置文件默认打开程序

# ── TUI 工具 ──
brew "lazygit"           # git TUI
brew "yazi"              # 文件管理器
brew "btop"              # 系统资源监控
# yazi 预览依赖
brew "ffmpegthumbnailer" # 视频缩略图
brew "poppler"           # PDF 预览
brew "imagemagick"       # 图片预览

# ── 编辑器 / 复用层（dawn.nvim 会用到）──
brew "neovim"
brew "tmux"

# ── 终端 ──
cask "ghostty"           # GPU 加速终端

# ── 字体（Nerd Font，prompt/图标需要）──
cask "font-jetbrains-mono-nerd-font"
cask "font-hack-nerd-font"
