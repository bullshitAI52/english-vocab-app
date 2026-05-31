#!/bin/bash
# SSH 直接登入 VPS 脚本
# 自带连接配置，不需要依赖 ~/.ssh/config。
# 支持交互式 Shell、单条命令执行、快速信息查看。
#
# 用法:
#   ./ssh_login.sh shell    - 打开交互式 SSH 会话
#   ./ssh_login.sh exec     - 执行单条命令（示例模式）
#   ./ssh_login.sh info     - 查看服务器状态汇总
#   ./ssh_login.sh <cmd>    - 直接执行远程命令

set -euo pipefail

# ── VPS 连接配置 ──────────────────────────────────────
REMOTE_USER="root"
REMOTE_HOST="107.172.32.153"
REMOTE_PORT="9966"

# 密钥文件（留空则使用 SSH 默认密钥链）
IDENTITY_FILE="$HOME/.ssh/id_ed25519"
[ -f "$IDENTITY_FILE" ] || IDENTITY_FILE="$HOME/.ssh/id_rsa"

# ── SSH 基础参数 ──────────────────────────────────────
SSH_OPTS=(
    -p "$REMOTE_PORT"
    -o StrictHostKeyChecking=no
    -o UserKnownHostsFile=/dev/null
    -o ServerAliveInterval=30
    -o ServerAliveCountMax=3
    -o ConnectTimeout=10
)

if [ -n "$IDENTITY_FILE" ] && [ -f "$IDENTITY_FILE" ]; then
    SSH_OPTS+=(-i "$IDENTITY_FILE")
fi

REMOTE="${REMOTE_USER}@${REMOTE_HOST}"

# ── 函数 ──────────────────────────────────────────────

shell_login() {
    echo "🔗 正在连接 $REMOTE_HOST:$REMOTE_PORT ..."
    echo ""
    exec ssh "${SSH_OPTS[@]}" "$REMOTE"
}

exec_command() {
    if [ $# -eq 0 ]; then
        echo "用法: $0 exec \"<command>\""
        echo "示例: $0 exec \"uptime && docker ps\""
        exit 1
    fi
    ssh "${SSH_OPTS[@]}" "$REMOTE" "$@"
}

show_info() {
    echo "📡 正在获取 VPS 状态 ..."
    echo ""
    ssh "${SSH_OPTS[@]}" "$REMOTE" "
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '  系统信息'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '  主机名: '$(hostname)
        echo '  内核:   '$(uname -r)
        echo '  运行时间:'
        uptime
        echo ''
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '  磁盘使用'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        df -h --type=ext4 --type=xfs --type=btrfs 2>/dev/null || df -h
        echo ''
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '  内存使用'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        free -h
        echo ''
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        echo '  Docker 容器'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
        docker ps --format 'table {{.Names}}\t{{.Image}}\t{{.Ports}}\t{{.Status}}' 2>/dev/null || echo '  Docker 未运行'
        echo '━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━'
    "
}

show_help() {
    cat <<EOF
用法: $0 {shell|info|exec|<command>}

命令:
  shell     打开交互式 SSH 会话（默认）
  info      查看服务器状态汇总
  exec      执行远程命令（后接命令字符串）
  <cmd>     直接执行任意远程命令

示例:
  $0 shell                          # 登入 VPS
  $0 info                           # 查看服务器状态
  $0 exec "docker ps"               # 列出 Docker 容器
  $0 exec "cat /etc/os-release"     # 查看系统版本
  $0 "uptime && free -h"            # 快捷执行命令
EOF
}

# ── 主逻辑 ──────────────────────────────────────────────

case "${1:-shell}" in
    shell|login)
        shell_login
        ;;
    info|status)
        show_info
        ;;
    exec)
        shift
        exec_command "$@"
        ;;
    -h|--help|help)
        show_help
        ;;
    *)
        # 其他所有参数都当作远程命令直接执行
        exec_command "$@"
        ;;
esac
