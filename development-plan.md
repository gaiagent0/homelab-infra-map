# Egységes Fejlesztési Terv — Proxmox AI Cluster + Vivo AI Stack

**Datum:** 2026-06-17
**Verzió:** 1.0 (egyesített v2 + valós állapot)
**Cél:** Hatékony, jól dokumentált, skálázható AI infrastruktúra

---

## 1. Jelenlegi Állapot (Audit)

### Proxmox Cluster
- 3 node (pve-01, pve-02, pve-03)
- 12 LXC container (mind running)
- 31 Docker konténer (5 LXC-ben)
- Nincs egységes dokumentáció, nincs CI/CD

### Vivo Laptop
- Windows natív: Ollama (nincs model), LiteLLM (20 model), 16 node folyamat
- WSL2: Docker, 1 konténer (litellm — redundáns a Windows-sal)
- C:\AI\apps\: 15 AI app mappa (több nem fut)

### Problémák
1. **Kettős LiteLLM:** Windows natív + WSL2 Docker — redundáns, erőforrás pazarlás
2. **Nincs egységes monitoring:** Prometheus/Grafana csak Proxmox-on
3. **Nincs CI/CD:** Manuális deploy, nincs automatizált tesztelés
4. **Nincs backup stratégia:** PBS van, de nincs dokumentálva
5. **AI app-ok nincsenek kategorizálva:** C:\AI\apps\ mappában 15 app, több nem fut
6. **Nincs egységes dokumentáció:** Csak cluster-map.md és vivo-ai-stack.md

---

## 2. Célarchitektúra

```
┌─────────────────────────────────────────────────────────────────┐
│                        VIVO LAPTOP                               │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ Windows Natív                                            │    │
│  │  ├── Hermes Agent (AI orchestrator)                      │    │
│  │  ├── Ollama (helyi modellek)                             │    │
│  │  └── LiteLLM Proxy (multi-provider, 1 példány)          │    │
│  └─────────────────────────────────────────────────────────┘    │
│  ┌─────────────────────────────────────────────────────────┐    │
│  │ WSL2 (Ubuntu 24.04)                                      │    │
│  │  └── Docker (fejlesztői környezet, CI/CD agent)          │    │
│  └─────────────────────────────────────────────────────────┘    │
└─────────────────────────────────────────────────────────────────┘
                              │
                              │ SSH / API
                              ▼
┌─────────────────────────────────────────────────────────────────┐
│                      PROXOX CLUSTER                              │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────┐             │
│  │   pve-01    │  │   pve-02    │  │   pve-03    │             │
│  │  Infra      │  │  Backup     │  │  AI/Media   │             │
│  │  - NPM      │  │  - PBS      │  │  - Media    │             │
│  │  - Vault    │  │  - Grafana  │  │  - AI Infra │             │
│  │  - MCP      │  │  - Prometheus│  │  - Dev Env  │             │
│  │  - LibreNMS │  │  - Rclone   │  │  - Ollama   │             │
│  └─────────────┘  └─────────────┘  └─────────────┘             │
└─────────────────────────────────────────────────────────────────┘
```

---

## 3. Fejlesztési Fázisok

### Fázis 0: Alapok (1-2 nap)
**Cél:** Jelenlegi állapot stabilizálása, dokumentáció javítása

- [ ] 0.1 GitHub repo tisztítása (cluster-map.md, vivo-ai-stack.md)
- [ ] 0.2 WSL2 LiteLLM konténer eltávolítása (redundáns)
- [ ] 0.3 C:\AI\apps\ mappa audit — mi fut, mi nem, mi kell
- [ ] 0.4 Egységes dokumentációs struktúra létrehozása

### Fázis 1: Egységes LiteLLM (2-3 nap)
**Cél:** Egyetlen LiteLLM proxy, minden szolgáltatás felé

- [ ] 1.1 LiteLLM config optimalizálás (Windows natív)
- [ ] 1.2 WSL2 LiteLLM konténer leállítása és törlése
- [ ] 1.3 Proxmox CT305 (ai-infra) LiteLLM integráció
- [ ] 1.4 Fallback chain tesztelés

### Fázis 2: Monitoring & Observability (3-5 nap)
**Cél:** Teljes körű monitoring minden node-on

- [ ] 2.1 Prometheus + Grafana bővítése (összes node)
- [ ] 2.2 Node exporter telepítése minden LXC-re
- [ ] 2.3 Docker monitoring (cadvisor) bővítése
- [ ] 2.4 Alertmanager konfigurálás
- [ ] 2.5 Grafana dashboard-ok létrehozása

### Fázis 3: Backup & Disaster Recovery (3-5 nap)
**Cél:** Automatizált, tesztelt backup stratégia

- [ ] 3.1 PBS backup szabályok definiálása
- [ ] 3.2 Rclone sync konfigurálás
- [ ] 3.3 ZFS snapshot automatizálás
- [ ] 3.4 Restore tesztek végrehajtása
- [ ] 3.5 Backup dokumentáció

### Fázis 4: CI/CD Pipeline (5-7 nap)
**Cél:** Automatizált deploy és tesztelés

- [ ] 4.1 Gitea CI/CD beállítása (CT302)
- [ ] 4.2 GitHub Actions → Proxmox deploy pipeline
- [ ] 4.3 Automatizált healthcheck-ek
- [ ] 4.4 Rollback mechanizmus

### Fázis 5: AI Stack Optimalizálás (5-7 nap)
**Cél:** Hatékony AI szolgáltatások

- [ ] 5.1 Ollama modellek letöltése (Proxmox CT304)
- [ ] 5.2 Qdrant collection optimalizálás (CT305)
- [ ] 5.3 n8n workflow-ok létrehozása
- [ ] 5.4 Mem0 integráció
- [ ] 5.5 SearXNG konfigurálás

### Fázis 6: Biztonsági Audit (3-5 nap)
**Cél:** Teljes biztonsági hardening

- [ ] 6.1 Security audit végrehajtása
- [ ] 6.2 Container hardening
- [ ] 6.3 Network segmentation
- [ ] 6.4 Secret management
- [ ] 6.5 Penetration testing

---

## 4. Kivitelezési Workflow

### 4.1 Általános szabályok

1. **Minden változtatás előtt:** ZFS snapshot + PBS backup
2. **Minden deploy után:** Healthcheck futtatása
3. **Minden fázis után:** Dokumentáció frissítése
4. **Hibajavítás:** Rollback.sh futtatás, root cause analysis

### 4.2 Deploy Pipeline

```
Fejlesztés (vivo) → Gitea (CT302) → CI/CD → Proxmox (pve-03)
     │                  │                │           │
     │                  │                │           │
  Kód írás         Git push        Build+Test     Deploy
  Lokális teszt    Code review     Image build    Healthcheck
                                   Security scan  Rollback (ha kell)
```

### 4.3 Kommunikáció

- **Hermes Agent:** Orchestrator, feladatok kiosztása
- **Gitea (CT302):** Kódtár, CI/CD, issue tracking
- **Grafana (CT208):** Monitoring, alerting
- **n8n (CT305):** Workflow automatizálás

---

## 5. Erőforrás Allokáció

### Proxmox Node-ok

| Node | Szerep | CPU | RAM | Storage |
|:---|:---|:---|:---|:---|
| pve-01 | Infra | 2 core | 4GB | 50GB |
| pve-02 | Backup/Monitoring | 2 core | 4GB | 100GB |
| pve-03 | AI/Media | 4 core | 8GB | 200GB |

### Vivo Laptop

| Szerep | CPU | RAM | Storage |
|:---|:---|:---|:---|
| Hermes Agent | 2 core | 4GB | 50GB |
| LiteLLM Proxy | 1 core | 2GB | 10GB |
| Ollama | 2 core | 4GB | 50GB |
| WSL2 Docker | 2 core | 4GB | 50GB |

---

## 6. Üzemeltetési Dokumentáció

### 6.1 Mappastruktúra

```
homelab-docs/
├── README.md                    # Főoldal, gyors referencia
├── cluster-map.md               # Proxmox cluster térkép
├── vivo-ai-stack.md             # Vivo laptop AI stack
├── architecture/                # Architektúra diagramok
│   ├── overview.md
│   ├── network.md
│   └── data-flow.md
├── runbooks/                    # Üzemeltetési útmutatók
│   ├── deploy.md
│   ├── backup.md
│   ├── monitoring.md
│   └── troubleshooting.md
├── security/                    # Biztonsági dokumentáció
│   ├── audit.md
│   ├── hardening.md
│   └── incident-response.md
└── development/                 # Fejlesztési dokumentáció
    ├── roadmap.md
    ├── changelog.md
    └── testing.md
```

### 6.2 Dokumentációs szabályok

- Minden új szolgáltatás: RUNBOOK.md a service mappájában
- Minden hiba: TROUBLESHOOTING.md frissítése
- Minden deploy: CHANGELOG.md frissítése
- Hetente: README.md review

---

## 7. Következő lépések

### Azonnali (ma)
1. GitHub repo tisztítása
2. WSL2 LiteLLM eltávolítása
3. C:\AI\apps\ audit

### Ezen a héten
4. Monitoring bővítése
5. Backup stratégia dokumentálása
6. Security audit

### Következő hónap
7. CI/CD pipeline
8. AI stack optimalizálás
9. Teljes biztonsági hardening

---

## 8. Siker Kritériumok

- [ ] Egyetlen LiteLLM proxy, minden szolgáltatás felé
- [ ] Teljes körű monitoring (összes node, összes konténer)
- [ ] Automatizált backup, tesztelt restore
- [ ] CI/CD pipeline működő
- [ ] Biztonsági audit kész, kritikus hibák javítva
- [ ] Teljes dokumentáció naprakész
