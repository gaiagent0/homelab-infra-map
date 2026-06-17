# Egységes Fejlesztési Terv — 4-Plane AI Architektúra

**Datum:** 2026-06-17
**Verzió:** 2.0 (4-plane architektúra)
**Cél:** Hatékony, jól dokumentált, skálázható hibrid AI infrastruktúra

---

## 1. Architektúra — 4 Plane + Cloud

```
┌─────────────────────────────────────────────────────────────────────┐
│                         VIVO LAPTOP                                  │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ PLANE 1: WINDOWS — NPU Compute Node                          │   │
│  │  ├── Foundry Local (QNN HTP backend)                         │   │
│  │  ├── Ollama (CPU fallback modellek)                          │   │
│  │  └── GenieAPI (Qwen3-4B, Llama3.2-3B NPU)                   │   │
│  │  Csak inference. Nincs proxy, nincs agent.                   │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ PLANE 2: WSL2 — AI Control Plane                             │   │
│  │  ├── LiteLLM Proxy (multi-provider routing)                  │   │
│  │  ├── LangGraph (agent orchestration)                         │   │
│  │  ├── Hermes Agent (task delegation)                          │   │
│  │  └── Agent Runtime (FastAPI + async workers)                 │   │
│  │  Ez az agy. Routing, reasoning, tool execution.              │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ SSH / API / Docker network
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      PROXMOX CLUSTER                                 │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ PLANE 3: CT305 — Knowledge Plane                             │   │
│  │  ├── PostgreSQL (litellm DB + app DB)                        │   │
│  │  ├── Qdrant (vektor adatbázis, RAG)                          │   │
│  │  ├── Mem0 (AI memory layer)                                  │   │
│  │  ├── SearXNG (metakereső)                                    │   │
│  │  └── MCP Server (tool registry)                              │   │
│  │  Adattár. Tartalom, kontextus, emlékezet.                    │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ PLANE 4: CT306 — Observability Plane (ÚJ LXC)                │   │
│  │  ├── Langfuse (LLM tracing, cost tracking)                   │   │
│  │  ├── ClickHouse (Langfuse adatbázis)                         │   │
│  │  ├── Prometheus (metrikák)                                   │   │
│  │  └── Grafana (dashboard-ok)                                  │   │
│  │  Megfigyelés. Trace, log, metric, alert.                     │   │
│  └──────────────────────────────────────────────────────────────┘   │
│                                                                      │
│  ┌──────────────────────────────────────────────────────────────┐   │
│  │ EXISTING: CT208 — Monitoring (megmarad)                      │   │
│  │  ├── Prometheus (node-level metrics)                         │   │
│  │  └── Grafana (infrastructure dashboard)                      │   │
│  │  Megjegyzés: CT208 node-level, CT306 LLM-level observability │   │
│  └──────────────────────────────────────────────────────────────┘   │
└─────────────────────────────────────────────────────────────────────┘
                              │
                              │ HTTPS / API
                              ▼
┌─────────────────────────────────────────────────────────────────────┐
│                      CLOUD — Reasoning Plane                         │
│  ├── OpenRouter (owl-alpha, deepseek, kimi, gemma — free tier)      │
│  ├── Claude API (Anthropic)                                         │
│  ├── GPT API (OpenAI)                                               │
│  └── Gemini API (Google)                                            │
│  Neh modellek, amik túl nagyok lokális futtatáshoz.                 │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 2. Jelenlegi Állapot vs Cél

### Jelenlegi (Audit 2026-06-17)

| Komponens | Hol | Állapot | Probléma |
|:---|:---|:---|:---|
| LiteLLM | Windows natív + WSL2 Docker | Kettős, redundáns | Windows instabil |
| Ollama | Windows natív + WSL2 | Fut, nincs model | Nincs NPU használat |
| Foundry Local | Windows | NEM FUT | NPU kihasználatlan |
| GenieAPI | Windows | NEM FUT | NPU kihasználatlan |
| PostgreSQL | CT305 (Docker) | Fut | OK |
| Qdrant | CT305 (Docker) | Fut | OK |
| Mem0 | CT305 (Docker) | Fut | OK |
| SearXNG | CT305 (Docker) | Fut | OK |
| Langfuse | **HIÁNYZIK** | - | CT306-ra tervezve |
| ClickHouse | **HIÁNYZIK** | - | CT306-ra tervezve |
| Prometheus | CT208 (Docker) | Fut | OK |
| Grafana | CT208 (Docker) | Fut | OK |
| Hermes Agent | Windows | Fut | OK |
| LangGraph | **HIÁNYZIK** | - | WSL2-re tervezve |
| Agent Runtime | **HIÁNYZIK** | - | WSL2-re tervezve |
| MCP Server | CT150 (LXC) | Fut | OK |

### Célállapot

| Komponens | Hol | Mi változik |
|:---|:---|:---|
| LiteLLM | **WSL2 Docker** | Windows natív eltávolítása |
| Ollama | **Windows natív** | NPU modellek letöltése |
| Foundry Local | **Windows natív** | Indítás, NPU backend |
| GenieAPI | **Windows natív** | Indítás, NPU modellek |
| Langfuse | **CT306 (új LXC)** | Telepítés + konfiguráció |
| ClickHouse | **CT306 (új LXC)** | Telepítés (Langfuse DB) |
| LangGraph | **WSL2 Docker** | Telepítés + konfiguráció |
| Agent Runtime | **WSL2 Docker** | FastAPI + async workers |
| MCP Server | CT150 + CT305 | Bővítés |

---

## 3. Fejlesztési Fázisok

### Fázis 0: Alapok (1-2 nap)
**Cél:** Jelenlegi állapot stabilizálása

- [ ] 0.1 GitHub repo tisztítása (cluster-map.md, vivo-ai-stack.md frissítés)
- [ ] 0.2 C:\AI\apps\ audit — mi fut, mi nem, mi kell
- [ ] 0.3 Windows natív LiteLLM leállítása (WSL2 marad)
- [ ] 0.4 WSL2 LiteLLM konfiguráció ellenőrzés (Proxmox PostgreSQL-re mutat)

### Fázis 1: NPU Compute Node (2-3 nap)
**Cél:** Windows NPU inference képesség

- [ ] 1.1 Foundry Local indítás (start-foundry.ps1)
- [ ] 1.2 NPU modellek letöltése (Qwen2.5-7B, DeepSeek-R1-7B)
- [ ] 1.3 GenieAPI indítás (Qwen3-4B, Llama3.2-3B)
- [ ] 1.4 Ollama NPU modellek letölltése (phi4-mini, qwen2.5:7b)
- [ ] 1.5 LiteLLM config frissítés (NPU modellek hozzáadása)
- [ ] 1.6 Fallback chain tesztelés (NPU → CPU → Cloud)

### Fázis 2: AI Control Plane (WSL2) (3-5 nap)
**Cél:** WSL2-ben futó agent orchestration

- [ ] 2.1 LiteLLM config optimalizálás (WSL2)
- [ ] 2.2 LangGraph telepítés (WSL2 Docker)
- [ ] 2.3 Agent Runtime (FastAPI) telepítés
- [ ] 2.4 Hermes Agent integráció (delegate_task → WSL2 agents)
- [ ] 2.5 MCP tool registry konfigurálás

### Fázis 3: Knowledge Plane (CT305) (2-3 nap)
**Cél:** Adattár optimalizálás

- [ ] 3.1 PostgreSQL optimalizálás (litellm + app DB)
- [ ] 3.2 Qdrant collection design + indexelés
- [ ] 3.3 Mem0 konfiguráció (Proxmox PostgreSQL)
- [ ] 3.4 SearXNG konfigurálás (engine-ok, SSL)
- [ ] 3.5 MCP Server bővítés (CT305)

### Fázis 4: Observability Plane (CT306 — új LXC) (3-5 nap)
**Cél:** LLM-level monitoring

- [ ] 4.1 CT306 LXC létrehozás (pve-03, 2c/4GB)
- [ ] 4.2 ClickHouse telepítés (Langfuse DB)
- [ ] 4.3 Langfuse telepítés + konfiguráció
- [ ] 4.4 Langfuse → LiteLLM integráció (OTLP)
- [ ] 4.5 Grafana dashboard-ok (LLM metrics)
- [ ] 4.6 Alertmanager szabályok (token usage, latency)

### Fázis 5: Backup & DR (2-3 nap)
**Cél:** Automatizált backup

- [ ] 5.1 PBS backup szabályok (CT305, CT306)
- [ ] 5.2 Rclone sync konfigurálás
- [ ] 5.3 ZFS snapshot automatizálás
- [ ] 5.4 Restore tesztek

### Fázis 6: Biztonsági Audit (3-5 nap)
**Cél:** Teljes hardening

- [ ] 6.1 Container security audit
- [ ] 6.2 Network segmentation
- [ ] 6.3 Secret management
- [ ] 6.4 Langfuse PII filter

---

## 4. Erőforrás Allokáció

### Vivo Laptop

| Komponens | CPU | RAM | Storage | Hol |
|:---|:---|:---|:---|:---|
| Foundry Local (NPU) | 2 core | 2GB | 20GB | Windows |
| Ollama (CPU) | 2 core | 4GB | 30GB | Windows |
| GenieAPI (NPU) | 1 core | 1GB | 10GB | Windows |
| LiteLLM Proxy | 1 core | 2GB | 5GB | WSL2 Docker |
| LangGraph | 1 core | 2GB | 5GB | WSL2 Docker |
| Agent Runtime | 1 core | 2GB | 5GB | WSL2 Docker |
| Hermes Agent | 1 core | 2GB | 5GB | Windows |

### Proxmox CT305 (ai-infra) — 4c/6GB

| Konténer | CPU limit | RAM limit | Storage |
|:---|:---|:---|:---|
| PostgreSQL | 1 core | 2GB | 20GB |
| Qdrant | 1 core | 2GB | 10GB |
| Mem0 | 0.5 core | 1GB | 5GB |
| SearXNG | 0.5 core | 0.5GB | 5GB |
| MCP Server | 0.5 core | 0.5GB | 5GB |

### Proxmox CT306 (observability) — 2c/4GB (ÚJ)

| Konténer | CPU limit | RAM limit | Storage |
|:---|:---|:---|:---|
| ClickHouse | 1 core | 2GB | 20GB |
| Langfuse | 0.5 core | 1GB | 5GB |
| Prometheus | 0.5 core | 0.5GB | 10GB |
| Grafana | 0.5 core | 0.5GB | 5GB |

---

## 5. Kivitelezési Workflow

### 5.1 Deploy Pipeline

```
Fejlesztés (vivo) → Gitea (CT302) → CI/CD → Proxmox (pve-03)
     │                  │                │           │
  Kód írás         Git push        Build+Test     Deploy
  Lokálteszt       Code review     Image build    Healthcheck
                                   Security scan  Rollback (ha kell)
```

### 5.2 LiteLLM Routing

```
User Request
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│ WSL2 LiteLLM Proxy                                          │
│                                                              │
│  Routing strategy: latency-based-routing                     │
│                                                              │
│  Local NPU (Windows):                                        │
│    foundry-npu-deepseek (QNN, 180s timeout)                  │
│    foundry-npu (Qwen2.5-7B QNN, 180s)                       │
│    genie-npu (Qwen3-4B, 60s)                                │
│    genie-npu-llama (Llama3.2-3B, 60s)                       │
│                                                              │
│  Local CPU (Windows):                                        │
│    ollama-win (qwen2.5:14b, 180s)                           │
│    ollama-fast (qwen2.5:7b, 60s)                            │
│    lm-studio (local-model, 120s)                            │
│    llama-cpp (qwen3-8b, 120s)                               │
│                                                              │
│  Cloud (Reasoning Plane):                                    │
│    openrouter-deepseek (free)                                │
│    openrouter-qwen (free)                                    │
│    openrouter-kimi (free)                                    │
│    openrouter-gemma (free)                                   │
│    hermes-groq (fast)                                        │
│    hermes-gemini                                             │
│    hermes-coder                                              │
│                                                              │
│  Fallback chain:                                             │
│    NPU → CPU → Cloud free → Cloud paid                      │
└─────────────────────────────────────────────────────────────┘
```

### 5.3 Agent Execution Flow

```
User Request
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│ Hermes Agent (Windows)                                       │
│  → delegate_task → WSL2 Agent Runtime                       │
└─────────────────────────────────────────────────────────────┘
     │
     ▼
┌─────────────────────────────────────────────────────────────┐
│ WSL2 Agent Runtime (LangGraph)                               │
│                                                              │
│  START → Planner → Retriever → Reasoner →                   │
│  Human Review (kritikus) → Tool Execution →                  │
│  Validator → Reporter → END                                 │
│                                                              │
│  Retriever: Qdrant (CT305) + SearXNG (CT305)               │
│  Reasoner: LiteLLM (WSL2) → NPU/CPU/Cloud                  │
│  Tools: MCP Server (CT150 + CT305)                          │
│  Memory: Mem0 (CT305)                                       │
│  Tracing: Langfuse (CT306)                                  │
└─────────────────────────────────────────────────────────────┘
```

---

## 6. Siker Kritériumok

- [ ] NPU inference működik (Foundry Local + GenieAPI)
- [ ] Ollama CPU modellek letöltve és működnek
- [ ] LiteLLM WSL2-ben stabil, NPU → CPU → Cloud fallback működik
- [ ] LangGraph agent-ek futnak WSL2-ben
- [ ] Langfuse tracing működik (CT306)
- [ ] Qdrant + Mem0 integrálva az agent-ekbe
- [ ] Backup automatizálva (CT305 + CT306)
- [ ] Biztonsági audit kész

---

## 7. Következő lépések

### Azonnali (Fázis 0)
1. GitHub repo frissítés
2. Windows natív LiteLLM leállítása
3. C:\AI\apps\ audit

### Fázis 1 (NPU)
4. Foundry Local + NPU modellek
5. GenieAPI indítás
6. Ollama CPU modellek

### Fázis 2 (Control Plane)
7. LangGraph + Agent Runtime WSL2-ben
8. Hermes integráció

### Fázis 4 (Observability)
9. CT306 LXC létrehozás
10. Langfuse + ClickHouse telepítés
