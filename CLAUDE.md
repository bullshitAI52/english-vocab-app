# Project Instructions

## Server Access

- **VPS**: `ssh vps` (root@107.172.32.153:9966, key auth, no password needed)
- **OS**: Ubuntu 22.04 LTS
- **Docker**: v29.1.5

## SSH Direct Login

Use `./ssh_login.sh` for direct VPS access (self-contained config, no `~/.ssh/config` dependency).

```bash
./ssh_login.sh shell              # Interactive SSH session
./ssh_login.sh info               # Server status summary
./ssh_login.sh exec "docker ps"   # Run remote command
./ssh_login.sh "uptime && free"   # Quick inline command
```

## SSH Tunnel (Local Port Mapping)

Run `./ssh_tunnel.sh start` to activate tunnels before using local URLs.

| Service    | Local URL                  | VPS Port |
|------------|---------------------------|----------|
| PocketBase | http://localhost:8090      | 8090     |
| MeTube     | http://localhost:8082      | 8082     |

## PocketBase

- **API**: http://localhost:8090/api/ (via tunnel) or http://107.172.32.153:8090/api/ (direct)
- **Admin Dashboard**: http://localhost:8090/_/ or http://107.172.32.153:8090/_/
- **Admin Email**: zwm64920093@gmail.com

### Collections

- `users` (auth) — Shared user accounts, email required
- `en_wordlists` — English word lists (name, filename, content)
- `en_progress` — User learning progress
- `en_word_stats` — Per-word statistics
- `en_daily_stats` — Daily practice summary

Collection naming convention: prefix by project (e.g., `en_` for English vocab app).

## Common Commands

```bash
# Check server status
ssh vps "uptime && df -h && free -h && docker ps"

# Restart PocketBase
ssh vps "docker restart pocketbase"

# View PocketBase logs
ssh vps "docker logs --tail 50 pocketbase"

# Manage SSH tunnel
./ssh_tunnel.sh start|stop|restart|status
```

## SMTP (Brevo)

- Host: smtp-relay.brevo.com
- Port: 587
- Login: a9f51d001@smtp-brevo.com
