# Proxmox Homelab Cluster Infrastructure Map

**Cluster:** homelab
**Datum:** 2026-06-17
**Nodes:** 3 (pve-01, pve-02, pve-03)
**LXC:** 12 (mind running)
**Docker konténerek:** 30+ (5 LXC-ben)
**VM:** 0

---

## 1. Node-ok

| Node | IP | CPU | RAM | Status |
|:---|:---|:---|:---|:---|
| pve-01 | 10.10.40.11 | 2.3% | 3.2GB/15.5GB | online |
| pve-02 | 10.10.40.12 | 3.0% | 2.8GB/7.6GB | online |
| pve-03 | 10.10.40.13 | 3.9% | 6.8GB/14.9GB | online |

---

## 2. pve-01 (10.10.40.11) — 6 LXC

| CT | Név | Szolgáltatás | Típus | Port | RAM |
|:---|:---|:---|:---|:---|:---|
| 101 | adguard | AdGuard Home (DNS) | LXC native | 53 | 13.8MB |
| 105 | npm | Nginx Proxy Manager | Docker | 80-81, 443 | - |
| 106 | tailscale | Tailscale VPN | LXC native | - | 31.4MB |
| 107 | vaultwarden | Vaultwarden | Docker | 80 | 9.0MB |
| 150 | mcp-server | Proxmox MCP | LXC (Python) | 8011 | 72.0MB |
| 203 | librenms | LibreNMS | LXC (PHP/Nginx/MariaDB) | 80 | 49.1MB |

---

## 3. pve-02 (10.10.40.12) — 3 LXC

| CT | Név | Szolgáltatás | Típus | Port | RAM |
|:---|:---|:---|:---|:---|:---|
| 201 | pbs-server | Proxmox Backup Server | LXC native | 8007 | 27.6MB |
| 204 | rclone-sync | Rclone backup sync | LXC native | - | - |
| 208 | grafana | Prometheus + Grafana | Docker | 9090, 3000 | 173.2MB |

### CT208 Docker konténerek
| Konténer | Port | Funkció |
|:---|:---|:---|
| prometheus | 9090 | Metrikák tárolása |
| grafana | 3000 | Adatvizualizáció |

---

## 4. pve-03 (10.10.40.13) — 4 LXC

| CT | Név | Szolgáltatás | Típus | Port | RAM |
|:---|:---|:---|:---|:---|:---|
| 302 | docker-host | Media Stack (21 konténer) | Docker | lásd lent | 2845MB |
| 303 | dev-environment | Code Server (VS Code) | LXC native | 8080? | 126MB |
| 304 | pve-ai-agent | Ollama | LXC native | 11434 | 28MB |
| 305 | ai-infra | AI Infra (6 konténer) | Docker | lásd lent | 737MB |

### CT302 Docker konténerek (21 db)
| Konténer | Port | Funkció |
|:---|:---|:---|
| jellyfin | 8096, 8920 | Média lejátszó |
| jellystat | 3010 | Jellyfin statisztika |
| jellyseerr | 5055 | Média kérelem kezelő |
| qbittorrent | - | Torrent kliens |
| gluetun | 8080, 6881 | VPN (qBittorrenthez) |
| radarr | 7878 | Filmek automatizálása |
| sonarr | 8989 | Sorozatok automatizálása |
| lidarr | 8686 | Zene automatizálása |
| bazarr | 6767 | Feliratok automatizálása |
| prowlarr | 9696 | Indexer kereső |
| profilarr | 9850 | 'Arr profilok |
| jackett | 9117 | Torrent indexelő |
| wizarr | 5690 | Felhasználó onboarding |
| immich_server | 2283 | Fotó galéria |
| immich_postgres | 5432 | Immich adatbázis |
| immich_redis | 6379 | Immich cache |
| immich_power_tools | 8002 | Immich bővítmény |
| gitea | 3000, 2222 | Saját Git szerver |
| gitea-db | 5432 | Gitea adatbázis |
| homepage | 3001 | Kezdőlap (Dashboard) |
| portainer | 9000, 9443 | Docker vezérlő panel |
| cadvisor | 8082 | Docker erőforrás monitorozás |
| tvheadend | 9981-9982 | Live TV / DVR |

### CT305 Docker konténerek (6 db)
| Konténer | Port | Funkció |
|:---|:---|:---|
| n8n | 5678 | Workflow automatizálás |
| mem0 | 8888 | AI memory szolgáltatás |
| postgres | 5432 | Adatbázis |
| qdrant | 6333-6334 | Vektor adatbázis (RAG) |
| searxng | 8080 | Metakereső motor |
| portainer_agent | 9001 | Portainer agent |

---

## 5. Összesítés

### Szolgáltatás kategóriák

**Infrastruktúra (pve-01):**
- DNS: AdGuard (CT101)
- Reverse Proxy: Nginx Proxy Manager (CT105, Docker)
- VPN: Tailscale (CT106)
- Jelszókezelő: Vaultwarden (CT107, Docker)
- MCP Server: Proxmox MCP (CT150)
- Hálózati monitor: LibreNMS (CT203)

**Backup & Monitoring (pve-02):**
- Backup: Proxmox Backup Server (CT201)
- Sync: Rclone (CT204)
- Monitoring: Prometheus + Grafana (CT208, Docker)

**Media & AI (pve-03):**
- Média: Jellyfin, Radarr, Sonarr, Lidarr, Bazarr, Prowlarr, Jackett (CT302, Docker)
- Letöltés: qBittorrent + GlueTun VPN (CT302, Docker)
- Fotó: Immich (CT302, Docker)
- Git: Gitea (CT302, Docker)
- Dashboard: Homepage + Portainer (CT302, Docker)
- Dev: Code Server (CT303)
- AI: Ollama (CT304)
- AI Infra: n8n, Qdrant, Mem0, SearXNG (CT305, Docker)

### Docker összesítés
| LXC | Docker konténerek |
|:---|:---|
| CT105 (npm) | 1 |
| CT107 (vaultwarden) | 1 |
| CT208 (grafana) | 2 |
| CT302 (docker-host) | 21 |
| CT305 (ai-infra) | 6 |
| **Összesen** | **31** |

---

## 6. Hálózat és Storage

- **ZFS Storage:** /rpool/aidata/[SERVICE_NAME]
- **AI Network:** ai-net (internal)
- **Reverse Proxy:** Nginx Proxy Manager (CT105)
- **Monitoring:** Prometheus (9090) + Grafana (3000) on CT208

---

## 7. Elérési útvonalak

| Szolgáltatás | URL |
|:---|:---|
| Nginx Proxy Manager | https://10.10.40.11:81 |
| Vaultwarden | http://10.10.40.17 |
| LibreNMS | http://10.10.40.13 |
| Proxmox Backup | https://10.10.40.21:8007 |
| Prometheus | http://10.10.40.28:9090 |
| Grafana | http://10.10.40.28:3000 |
| Jellyfin | http://10.10.40.32:8096 |
| Immich | http://10.10.40.32:2283 |
| Gitea | http://10.10.40.32:3000 |
| Homepage | http://10.10.40.32:3001 |
| Portainer | http://10.10.40.32:9000 |
| Code Server | http://10.10.40.33 |
| Ollama | http://10.10.40.34:11434 |
| n8n | http://10.10.40.35:5678 |
| Qdrant | http://10.10.40.35:6333 |
| SearXNG | http://10.10.40.35:8080 |
