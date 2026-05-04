# Server Configuration Reference

## Server
- **Host**: 107.172.32.153:9966
- **OS**: Ubuntu 22.04 LTS
- **Docker**: 29.1.5

## Docker Containers

| Container | Image | Port |
|-----------|-------|------|
| pocketbase | ghcr.io/muchobien/pocketbase:latest | 8090 |
| metube | ghcr.io/alexta69/metube:latest | 8082 (local) |

## PocketBase

- **API**: http://107.172.32.153:8090/api/
- **Admin Dashboard**: http://107.172.32.153:8090/_/

### SMTP (Brevo)

| Setting | Value |
|---------|-------|
| Host | smtp-relay.brevo.com |
| Port | 587 |
| Login | a9f51d001@smtp-brevo.com |
| Password | Set on server |

### Collections

#### `users` (auth) — Shared across all projects
| Rule | Value |
|------|-------|
| listRule | `id = @request.auth.id` |
| viewRule | `id = @request.auth.id` |
| createRule | `` (open registration) |
| updateRule | `id = @request.auth.id` |
| deleteRule | `id = @request.auth.id` |
| requireEmail | true |

#### `en_wordlists` (base) — Shared word lists
Fields: `name`, `filename`, `content`

| Rule | Value |
|------|-------|
| listRule | `@request.auth.verified = true` |
| viewRule | `@request.auth.verified = true` |
| createRule | `@request.auth.verified = true` |
| updateRule | `@request.auth.verified = true` |
| deleteRule | `@request.auth.verified = true` |

#### `en_progress` (base) — User learning progress
Fields: `user` (relation→users), `last_file`, `last_content`, `last_page`

| Rule | Value |
|------|-------|
| listRule | `user = @request.auth.id && @request.auth.verified = true` |
| viewRule | `user = @request.auth.id && @request.auth.verified = true` |
| createRule | `@request.auth.verified = true` |
| updateRule | `user = @request.auth.id && @request.auth.verified = true` |
| deleteRule | `user = @request.auth.id && @request.auth.verified = true` |

#### `en_word_stats` (base) — Per-word statistics
Fields: `user` (relation→users), `word`, `correct`, `wrong`, `last_practiced`

| Rule | Value |
|------|-------|
| listRule | `user = @request.auth.id && @request.auth.verified = true` |
| viewRule | `user = @request.auth.id && @request.auth.verified = true` |
| createRule | `@request.auth.verified = true` |
| updateRule | `user = @request.auth.id && @request.auth.verified = true` |
| deleteRule | `user = @request.auth.id && @request.auth.verified = true` |

#### `en_daily_stats` (base) — Daily practice summary
Fields: `user` (relation→users), `date`, `words_practiced`, `correct_count`, `wrong_count`

| Rule | Value |
|------|-------|
| listRule | `user = @request.auth.id && @request.auth.verified = true` |
| viewRule | `user = @request.auth.id && @request.auth.verified = true` |
| createRule | `@request.auth.verified = true` |
| updateRule | `user = @request.auth.id && @request.auth.verified = true` |
| deleteRule | `user = @request.auth.id && @request.auth.verified = true` |

## Multi-Project Isolation

All project collections use a prefix (e.g., `en_` for English). To add a new project, create new collections with a different prefix (e.g., `de_wordlists`, `math_cards`). The `users` collection is shared.

## Access Flow

```
Register → Login → Unverified → Access denied
                         ↓
                  Verify email → Access granted
```

### Admin Commands

```bash
# Change admin password
docker exec pocketbase /usr/local/bin/pocketbase superuser update --dir /pb_data <email> <password>

# List superusers
docker exec pocketbase /usr/local/bin/pocketbase superuser list --dir /pb_data
```
