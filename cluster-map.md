# Proxmox Cluster Infrastructure Map

**Cluster:** homelab
**Nodes:** pve-01, pve-02, pve-03
**Last Audit:** 2026-06-17

---

## 1. pve-01 (10.10.40.11)
| CT ID | Name | Service | Type | Ports | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 101 | adguard | AdGuard Home | LXC (Native) | 53 | DNS, ad-blocking |
| 105 | npm | Nginx Proxy Manager | LXC (Docker) | 80-81, 443 | Reverse Proxy |
| 106 | tailscale | Tailscale | LXC (Native) | - | VPN, mesh networking |
| 107 | vaultwarden | Vaultwarden | LXC (Docker) | 80 | Password manager |
| 150 | mcp-server | Proxmox MCP | LXC (Native) | 8011 | MCP server for Hermes |
| 203 | librenms | LibreNMS | LXC (Native) | 80 | Network monitoring |

---

## 2. pve-02 (10.10.40.12)
| CT ID | Name | Service | Type | Ports | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 201 | pbs-server | Proxmox Backup | LXC (Native) | 8007 | Backup server |
| 204 | rclone-sync | Rclone Sync | LXC (Native) | - | Backup sync |
| 208 | grafana | Prometheus + Grafana | LXC (Docker) | 9090, 3000 | Monitoring stack |

---

## 3. pve-03 (10.10.40.13) - Main Workhorse
### LXC Containers
| CT ID | Name | Service | Type | Ports | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- |
| 302 | docker-host | Media Stack | LXC (Docker) | Various | Media server root |
| 303 | dev-environment | Code Server | LXC (Native) | 8080 | Web-based VS Code |
| 304 | pve-ai-agent | Ollama | LXC (Native) | 11434 | Local LLM server |
| 305 | ai-infra | n8n + Qdrant | LXC (Docker) | 5678, 6333 | Automation + Vector DB |

### Docker Services in CT302 (docker-host)
| Container Name | Image | Ports | Function |
| :--- | :--- | :--- | :--- |
| jellyfin | linuxserver/jellyfin | 8096, 8920 | Media Player |
| immich_server | immich-app | 2283 | Photo backup |
| radarr | linuxserver/radarr | 7878 | Movie management |
| sonarr | linuxserver/sonarr | 8989 | Series management |
| qbittorrent | linuxserver/qbittorrent | - | Torrent client |
| gluetun | qmcgaw/gluetun | 8080 | VPN for qBittorrent |
| gitea | gitea/gitea | 3000, 2222 | Self-hosted Git |
| homepage | gethomepage/homepage | 3001 | Dashboard |
| portainer | portainer/portainer-ce | 9000 | Docker management |
| cadvisor | gcr.io/cadvisor | 8082 | Resource monitoring |

### Docker Services in CT305 (ai-infra)
| Container Name | Image | Ports | Function |
| :--- | :--- | :--- | :--- |
| n8n | n8nio/n8n | 5678 | Workflow automation |
| qdrant | qdrant/qdrant | 6333-6334 | Vector database |
| mem0 | mem0ai/mem0 | 8888 | AI memory layer |
| searxng | searxng/searxng | 8080 | Meta-search engine |
| postgres | postgres:16-alpine | 5432 | General database |

---

## Network & Storage Notes
- **ZFS Storage:** /rpool/aidata (for service data)
- **AI Network:** ai-net (internal)
- **Reverse Proxy:** Handled by CT105 (NPM)
- **Monitoring:** Grafana/Prometheus on pve-02
