# Fejlesztési Projekt — Kanban Board

**Projekt:** 4-Plane AI Architektúra
**Datum:** 2026-06-17
**Státusz:** Aktív — Fázis 0

---

## In Progress (Folyamatban)

| ID | Feladat | Fázis | Prioritás |
|:---|:---|:---|:---|
| A01 | GitHub repo frissítés (cluster-map.md, vivo-ai-stack.md) | Fázis 0 | Magas |
| A02 | Windows natív LiteLLM leállítás (WSL2 marad) | Fázis 0 | Magas |
| A03 | C:\AI\apps\ audit | Fázis 0 | Magas |

## Backlog — Fázis 1: NPU Compute Node

| ID | Feladat | Prioritás | Becslés |
|:---|:---|:---|:---|
| B01 | Foundry Local indítás (start-foundry.ps1) | Magas | 1h |
| B02 | NPU modellek letöltése (Qwen2.5-7B, DeepSeek-R1-7B) | Magas | 2h |
| B03 | GenieAPI indítás (Qwen3-4B, Llama3.2-3B) | Magas | 1h |
| B04 | Ollama CPU modellek letöltése (phi4-mini, qwen2.5:7b) | Magas | 2h |
| B05 | LiteLLM config frissítés (NPU modellek hozzáadása) | Magas | 1h |
| B06 | Fallback chain tesztelés (NPU → CPU → Cloud) | Magas | 2h |

## Backlog — Fázis 2: AI Control Plane (WSL2)

| ID | Feladat | Prioritás | Becslés |
|:---|:---|:---|:---|
| C01 | LiteLLM config optimalizálás (WSL2 → Proxmox PG) | Magas | 2h |
| C02 | LangGraph telepítés (WSL2 Docker) | Magas | 3h |
| C03 | Agent Runtime (FastAPI) telepítés | Magas | 3h |
| C04 | Hermes Agent integráció (delegate_task → WSL2) | Közép | 2h |
| C05 | MCP tool registry konfigurálás | Közép | 2h |

## Backlog — Fázis 3: Knowledge Plane (CT305)

| ID | Felatat | Prioritás | Becslés |
|:---|:---|:---|:---|
| D01 | PostgreSQL optimalizálás (litellm + app DB) | Magas | 2h |
| D02 | Qdrant collection design + indexelés | Magas | 3h |
| D03 | Mem0 konfiguráció (Proxmox PostgreSQL) | Közép | 2h |
| D04 | SearXNG konfigurálás (engine-ok, SSL) | Közép | 1h |
| D05 | MCP Server bővítés (CT305) | Alacsony | 2h |

## Backlog — Fázis 4: Observability Plane (CT306 — új LXC)

| ID | Feladat | Prioritás | Becslés |
|:---|:---|:---|:---|
| E01 | CT306 LXC létrehozás (pve-03, 2c/4GB) | Magas | 1h |
| E02 | ClickHouse telepítés (Langfuse DB) | Magas | 2h |
| E03 | Langfuse telepítés + konfiguráció | Magas | 3h |
| E04 | Langfuse → LiteLLM integráció (OTLP) | Magas | 2h |
| E05 | Grafana dashboard-ok (LLM metrics) | Közép | 2h |
| E06 | Alertmanager szabályok (token usage, latency) | Közép | 2h |

## Backlog — Fázis 5: Backup & DR

| ID | Feladat | Prioritás | Becslés |
|:---|:---|:---|:---|
| F01 | PBS backup szabályok (CT305, CT306) | Magas | 2h |
| F02 | Rclone sync konfigurálás | Magas | 2h |
| F03 | ZFS snapshot automatizálás | Magas | 1h |
| F04 | Restore tesztek | Magas | 2h |

## Backlog — Fázis 6: Biztonsági Audit

| ID | Feladat | Prioritás | Becslés |
|:---|:---|:---|:---|
| G01 | Container security audit | Magas | 3h |
| G02 | Network segmentation | Magas | 2h |
| G03 | Secret management | Magas | 2h |
| G04 | Langfuse PII filter | Közép | 1h |

## Done (Kész)

| ID | Feladat | Fázis | Befejezés |
|:---|:---|:---|:---|
| - | Proxmox cluster audit (3 node, 12 LXC, 31 Docker) | Audit | 2026-06-17 |
| - | Vivo AI stack audit (Windows + WSL2) | Audit | 2026-06-17 |
| - | GitHub repo létrehozás + push | Audit | 2026-06-17 |
| - | cluster-map.md | Audit | 2026-06-17 |
| - | vivo-ai-stack.md | Audit | 2026-06-17 |
| - | 4-plane architektúra terv | Tervezés | 2026-06-17 |
