# ============================================================
# Oh My Zsh
# ============================================================
export ZSH="$HOME/.oh-my-zsh"

# 主题留空：提示符由 Starship 接管（见文件末尾）
ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# ============================================================
# PATH / 环境变量
# ============================================================
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="/opt/homebrew/opt/llvm/bin:$PATH"

export EDITOR='nvim'

# Homebrew 清华镜像
export HOMEBREW_API_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles

# ============================================================
# 工具集成
# ============================================================
eval "$(starship init zsh)"     # 提示符
eval "$(zoxide init zsh)"        # 智能 cd（z 跳转，zi 模糊选择）
eval "$(mise activate zsh)"      # 多语言版本管理
source <(fzf --zsh)              # 模糊查找（Ctrl-R 历史 / Ctrl-T 文件 / Alt-C 目录）
eval "$(navi widget zsh)"        # 命令速查表（Ctrl-G 唤起）

# yazi 文件管理器：用 y 启动，退出时自动 cd 到所在目录
function y() {
	local tmp="$(mktemp -t yazi-cwd.XXXXXX)" cwd
	yazi "$@" --cwd-file="$tmp"
	IFS= read -r -d '' cwd < "$tmp"
	[ -n "$cwd" ] && [ "$cwd" != "$PWD" ] && builtin cd -- "$cwd"
	rm -f -- "$tmp"
}

# ============================================================
# 别名
# ============================================================
# eza —— 带图标的 ls
alias ls='eza --icons --group-directories-first'
alias ll='eza -l --icons --group-directories-first --git'
alias la='eza -la --icons --group-directories-first --git'
alias lt='eza --tree --level=2 --icons'

# bat —— 带语法高亮的 cat
alias cat='bat --paging=never'
export BAT_THEME='ansi'

claude-dsv4pro() {
  export ANTHROPIC_BASE_URL=https://api.deepseek.com/anthropic
  export ANTHROPIC_AUTH_TOKEN="$(security find-generic-password -s claude-dsv4pro -w 2>/dev/null)"
  if [[ -z "$ANTHROPIC_AUTH_TOKEN" ]]; then
    echo "❌ 未找到 DeepSeek API Key，运行: security add-generic-password -s claude-dsv4pro -a \$USER -w"
    return 1
  fi
  export ANTHROPIC_MODEL=deepseek-v4-pro[1m]
  export ANTHROPIC_DEFAULT_OPUS_MODEL=deepseek-v4-pro[1m]
  export ANTHROPIC_DEFAULT_SONNET_MODEL=deepseek-v4-pro[1m]
  export ANTHROPIC_DEFAULT_HAIKU_MODEL=deepseek-v4-flash
  export CLAUDE_CODE_SUBAGENT_MODEL=deepseek-v4-flash
  export CLAUDE_CODE_EFFORT_LEVEL=max
  claude "$@"
}
