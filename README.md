# dotfiles

我的 macOS 开发环境配置（shell 层）。编辑器/复用层由 [dawn.nvim](https://github.com/dawnop/dawn.nvim) 作为 git submodule 管理。

## 技术栈

| 层 | 工具 |
|----|------|
| 终端 | [Ghostty](https://ghostty.org)（GPU 加速，Quick Terminal） |
| Shell | zsh + oh-my-zsh（autosuggestions / syntax-highlighting） |
| Prompt | [Starship](https://starship.rs)（gruvbox-rainbow preset） |
| 编辑器 | Neovim ← [dawn.nvim](https://github.com/dawnop/dawn.nvim) |
| 复用层 | tmux ← [dawn.nvim](https://github.com/dawnop/dawn.nvim) |
| CLI 工具 | eza · bat · fzf · ripgrep · fd · zoxide · mise · git-delta · television · navi · tldr · atuin · dust · procs · tokei · onefetch · hyperfine · jq |
| TUI 工具 | lazygit · yazi（文件管理，含视频/PDF/图片预览） |
| 监控 | btop |
| AI | Claude Code（代理透传）· claude-dsv4pro（DeepSeek V4 Pro via Anthropic 协议） |

## 目录结构

```
dotfiles/
├── install.sh          # 装 oh-my-zsh + 插件，软链各配置，初始化 dawn.nvim submodule
├── Brewfile            # 一键安装工具链
├── zsh/                # .zshrc .zprofile .zshenv
├── starship/           # starship.toml
├── ghostty/            # config（终端配置，含 Quick Terminal）
├── atuin/              # config.toml（shell 历史）
├── btop/               # btop.conf（资源监控，不纳入版本控制）
├── clangd/             # config.yaml → ~/Library/Preferences/clangd/config.yaml（macOS 全局 C++ 标准等）
├── clang-format/       # .clang-format → ~/.clang-format（全局代码格式 fallback）
└── dawn.nvim/          # submodule → github.com/dawnop/dawn.nvim（nvim + tmux）
```

> nvim 与 tmux 的配置由 `dawn.nvim/` submodule 管理，`install.sh` 会自动 `submodule update --init` 并运行其安装脚本。更新 dawn.nvim：`git submodule update --remote dawn.nvim`，然后在本仓库提交 submodule 指针。

## 安装

```bash
git clone --recursive https://github.com/dawnop/dotfiles.git ~/workspace/dotfiles
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
- **yazi**：用 `y` 启动（而非 `yazi`），退出时自动 cd 到文件管理器当前目录。
- **Quick Terminal**：`opt+\`` 全局唤起 Ghostty 悬浮终端（从屏幕顶部滑出）。

<details>
<summary><strong>CUDA intellisense on macOS（无 GPU / 无 toolkit）</strong></summary>

macOS 没有官方 CUDA toolkit，但可以用 clang 的 CUDA 前端 + 伪 toolkit headers 实现 `.cu`/`.cuh` 的补全、语义检查和高亮。

**需要手动搭建的文件**（不在本仓库，需在新机器上复现）：

| 路径 | 内容 |
|------|------|
| `~/.local/cuda/include/` | ~105 个 CUDA headers，从 `nvidia-*-cu12` pip wheels 解包 |
| `~/.local/cuda/nvvm/libdevice/libdevice.10.bc` | libdevice bitcode（`--cuda-path` 要求存在） |
| `~/.local/cuda/bin/ptxas` | placeholder 可执行文件 |
| `~/.local/cuda/version.txt` | 内容：`CUDA Version 12.3.0` |
| `~/.local/cuda/clangd_cuda_shim.h` | 见下方 shim 代码 |

clangd 配置已在本仓库 `clangd/config.yaml` 中（仅对 `.cu`/`.cuh` 生效，不影响普通 C++）。

**复现步骤：**

```sh
mkdir -p ~/.local/cuda/{include,nvvm/libdevice,bin}
pip download nvidia-cuda-runtime-cu12 nvidia-curand-cu12 --no-deps -d /tmp/cu
# 解压 wheel（zip 格式），将 include/*.h 复制到 ~/.local/cuda/include/
echo 'CUDA Version 12.3.0' > ~/.local/cuda/version.txt
touch ~/.local/cuda/bin/ptxas && chmod +x ~/.local/cuda/bin/ptxas
```

**clangd_cuda_shim.h**（处理 clang 不识别 CUDA 版本时的 legacy launch API）：

```cpp
#ifdef __CLANGD__
extern "C" cudaError_t cudaConfigureCall(dim3 gridDim, dim3 blockDim,
                                         size_t sharedMem = 0, cudaStream_t stream = 0);
#endif
```

验证：打开一个 `.cu` 文件，`:LspInfo` 应报告 0 errors。

</details>

### Claude Code

`claude` 函数自动透传本地代理（port 7897），无需手动设置环境变量：

```zsh
claude          # 走代理，连 Anthropic 官方 API
claude-dsv4pro  # 不走代理，API key 存于 Keychain，后端为 DeepSeek V4 Pro
```

`claude-dsv4pro` 初次使用前需将 DeepSeek API Key 存入 Keychain：

```bash
security add-generic-password -s claude-dsv4pro -a $USER -w
```
