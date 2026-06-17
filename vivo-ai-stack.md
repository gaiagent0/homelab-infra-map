# Vivo Laptop - Teljes AI Stack Térkép

**Datum:** 2026-06-17
**Gep:** vivo (Windows 11 + WSL2 Ubuntu 24.04)
**RAM:** 11GB (WSL2: 11Gi total, 1.5Gi used)
**Disk:** /dev/sdd 1007G (948G free)

---

## 1. Windows Native Szolgaltatasok

| Szolgaltatas | Status | Port | PID | Megjegyzes |
|:---|:---|:---|:---|:---|
| **Ollama** | FUT | 11434 | 17188 | 21 model (phi4-mini, llama3.1:8b, qwen3.6, stb.) |
| **LiteLLM Win Proxy** | FUT | 4001 | 5392 | vivo2, master_key: sk-win-vivo2 |
| **Open WebUI** | NEM FUT | 8091 | - | Inditas: `C:\AI\apps\open-webui\start.ps1` |
| **Foundry Local (NPU)** | NEM FUT | 5272 | - | Inditas: `start-foundry.ps1` |
| **GenieAPI (NPU)** | NEM FUT | 8912 | - | Inditas: manuális |
| **NotebookLM CLI** | READY | - | - | notebooklm-py v0.6.0, auth OK |

### LiteLLM Konfiguracio (vivo2)

```
Host: http://localhost:4001
Master Key: sk-win-vivo2
Auth header: Bearer

Providers:
- NPU: foundry-npu-deepseek (:5272), foundry-npu-qwen2.5-7b (:5272), genie-npu (:8912)
- Local: lm-studio (:1234), llama-cpp (:8083)
- Cloud: OpenRouter (owl-alpha, deepseek-v4-flash:free, kimi-k2.6:free, gemma-4-31b:free)
- Cloud: hermes-groq (:4000), hermes-gemini (:4000), hermes-coder (:4000)
```

---

## 2. WSL2 (Ubuntu 24.04) - Docker Kontenerek

| Kontener Nev | Image | Status | Port | PID |
|:---|:---|:---|:---|:---|
| **litellm** | ghcr.io/berriai/litellm:main-latest | Up 38 hours | 4001->4000 | 11408 |

### WSL2 Folyamatok (ps aux)

| Folyamat | Parancs | PID | CPU | RAM |
|:---|:---|:---|:---|:---|
| dockerd | /usr/bin/dockerd | 8083 | 0.0% | 6.9% |
| litellm | python3.13 /usr/bin/litellm --config /app/config.yaml | 11408 | 0.3% | 6.9% |
| ollama | /usr/local/bin/ollama serve | 8765 | 0.0% | 0.2% |

---

## 3. Network es Storage

### WSL2 Network (docker network ls)

| Network ID | Nev | Driver | Scope |
|:---|:---|:---|:---|
| 50f66667368d | bridge | bridge | local |
| cdffcf9c459c | host | host | local |
| 0fef8aac2112 | litellm_default | bridge | local |
| 5094810d6d85 | none | null | local |

### ZFS Storage (Proxmox)

- **Storage:** /rpool/aidata/[SERVICE_NAME]
- **AI Network:** ai-net (internal)
- **Reverse Proxy:** Traefik

---

## 4. Inditasi Sorrend (Ha mindent futtani akarsz)

1. **Ollama:** `ollama serve` (már fut Windows-on)
2. **LiteLLM:** `C:\AI\apps\litellm-win\start-litellm.ps1`
3. **Open WebUI:** `C:\AI\apps\open-webui\start.ps1`
4. **Foundry Local:** `C:\AI\apps\foundry-local\start-foundry.ps1`
5. **WSL2 Docker:** `wsl -d Ubuntu-24.04 -e docker start litellm`

---

## 5. Projekt Mappak

| Projekt | Utvonal | Megjegyzes |
|:---|:---|:---|
| Hangsegéd Platform | `C:\Users\istva\hangsegéd-platform\` | Windows native + WSL2 |
| MADDIE | `C:\Users\istva\MADDIE\` | Multi-agent debate engine |
| Agent Research | `C:\Users\istva\agent-research\` | Kanban + research reports |
| Homelab Docs | `C:\Users\istva\homelab-docs\` | Proxmox + AI stack docs |

---

## 6. Python Venv

- **Hermes Agent:** `C:\Users\istva\AppData\Local\hermes\hermes-agent\venv\Scripts\python.exe`
- **WSL2 Python:** `/usr/bin/python3.13` (LiteLLM-hez)

---

**Kovetkezo lepesek:**
- Ha Open WebUI-t akarsz futtani: `C:\AI\apps\open-webui\start.ps1`
- Ha Foundry Local-t akarsz: `start-foundry.ps1` (NPU models)
- Frissites: `ollama list` / `docker ps` / `netstat -ano | findstr LISTEN`
