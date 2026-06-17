# Fejlesztési Projekt — Kanban Board

**Projekt:** Proxmox AI Cluster + Vivo AI Stack Egyesítés
**Datum:** 2026-06-17
**Státusz:** Aktív

---

## Backlog (Tervezett)

| ID | Feladat | Prioritás | Fázis | Becslés |
|:---|:---|:---|:---|:---|
| B01 | C:\AI\apps\ audit — mi fut, mi nem | Magas | Fázis 0 | 2h |
| B02 | Monitoring bővítés (összes node) | Magas | Fázis 2 | 4h |
| B03 | Backup stratégia dokumentálás | Magas | Fázis 3 | 3h |
| B04 | CI/CD pipeline (Gitea + GitHub Actions) | Közép | Fázis 4 | 8h |
| B05 | Ollama modellek letöltése (CT304) | Közép | Fázis 5 | 4h |
| B06 | Qdrant collection optimalizálás | Közép | Fázis 5 | 3h |
| B07 | n8n workflow-ok létrehozása | Alacsony | Fázis 5 | 6h |
| B08 | Mem0 integráció | Alacsony | Fázis 5 | 4h |
| B09 | SearXNG konfigurálás | Alacsony | Fázis 5 | 2h |
| B10 | Teljes biztonsági audit | Magas | Fázis 6 | 6h |

## In Progress (Folyamatban)

| ID | Feladat | Fázis | Kezdés | Felező |
|:---|:---|:---|:---|:---|
| A01 | GitHub repo tisztítás | Fázis 0 | 2026-06-17 | - |
| A02 | WSL2 LiteLLM eltávolítás | Fázis 1 | - | - |
| A03 | Egységes dokumentáció | Fázis 0 | - | - |

## Done (Kész)

| ID | Feladat | Fázis | Befejezés |
|:---|:---|:---|:---|
| - | Proxmox cluster audit | Audit | 2026-06-17 |
| - | Vivo AI stack audit | Audit | 2026-06-17 |
| - | GitHub repo létrehozás | Audit | 2026-06-17 |
| - | cluster-map.md | Audit | 2026-06-17 |
| - | vivo-ai-stack.md | Audit | 2026-06-17 |

---

## Fázisok

### Fázis 0: Alapok (1-2 nap)
- [ ] GitHub repo tisztítása
- [ ] C:\AI\apps\ audit
- [ ] Egységes dokumentációs struktúra

### Fázis 1: Egységes LiteLLM (2-3 nap)
- [ ] WSL2 LiteLLM eltávolítása
- [ ] LiteLLM config optimalizálás
- [ ] Fallback chain tesztelés

### Fázis 2: Monitoring (3-5 nap)
- [ ] Prometheus + Grafana bővítés
- [ ] Node exporter minden LXC-re
- [ ] Alertmanager konfigurálás

### Fázis 3: Backup (3-5 nap)
- [ ] PBS backup szabályok
- [ ] Rclone sync konfigurálás
- [ ] Restore tesztek

### Fázis 4: CI/CD (5-7 nap)
- [ ] Gitea CI/CD beállítás
- [ ] GitHub Actions pipeline
- [ ] Automatizált healthcheck-ek

### Fázis 5: AI Stack (5-7 nap)
- [ ] Ollama modellek
- [ ] Qdrant optimalizálás
- [ ] n8n workflow-ok

### Fázis 6: Biztonság (3-5 nap)
- [ ] Security audit
- [ ] Container hardening
- [ ] Network segmentation
