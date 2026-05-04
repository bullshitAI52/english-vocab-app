# Claude 服务器管理

## 使用方法

双击 `auto_claude_server.command`，Claude 自动启动并连接服务器，无需任何手动输入。

## 文件说明

```
~/Documents/ssh/
├── README.md                  # 本说明文档
├── auto_claude_server.command # 一键启动入口，双击运行
└── claude_server_prompt.txt   # Claude 启动提示，包含服务器连接信息
```

## 服务器信息

- **主机**: 107.172.32.153:9966
- **用户**: root
- **主机名**: racknerd-227de59
- **系统**: Ubuntu 22.04.1 LTS

## 服务器状态（2026-04-10）

- **磁盘**: 77%（17G/23G）
- **内存**: 70%（593M/957M）
- **容器**: stock-analyzer / nextcloud / nextcloud-aio / lsky-pro

## 依赖

需要安装 `sshpass`（已安装）：
```bash
brew install hudochenkov/sshpass/sshpass
```
