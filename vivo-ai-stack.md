# Vivo Laptop - Teljes AI Stack Térkép

**Datum:** 2026-06-17 (Fázis 0 audit után)
**Gep:** vivo (Windows 11 ARM64 + WSL2 Ubuntu 24.04)
**RAM:** 11GB (WSL2: 1.5Gi used / 9.8Gi free, 8Gi swap)
**Disk:** /dev/sdd 1007G (948G free, 1% used)
**WSL2 Uptime:** 1 day, 15:50
**Docker (WSL2):** v29.5.3

## NPU Fázis 0 Audit Eredménye

**Snapdragon X Elite X1E78100** — 45 TOPS NPU (Hexagon)
- QAIRT SDK 2.45.40.260406 ✅
- Foundry Local v0.8.119 (Microsoft Store UWP) ✅
- **NPU embedding MŰKÖDIK** (QNNExecutionProvider) ✅
- **Foundry Local NPU modellek**: 3 NPU modell telepítve D:-n, cache feltöltés szükséges
- **GenieAPI**: modellek D:\models\genie\ mappában ✅ (config javítás szükséges)

## D: Meghajtó Modell Térkép

### Foundry Local NPU (D:\models\Foundry\Microsoft\)
| Modell | Meret | Device |
|:---|:---|:---|
| deepseek-r1-distill-qwen-7b-qnn-npu-2 | 3.1GB | NPU |
| qwen2.5-1.5b-instruct-qnn-npu-2 | 0.6GB | NPU |
| qwen2.5-7b-instruct-qnn-npu-2 | 3.0GB | NPU |

### Genie NPU (D:\models\genie\)
| Modell | Meret | Device |
|:---|:---|:---|
| Llama3.2-3B | 1.5GB | NPU |
| qwen3_4b-genie-w4a16 | 4.0GB | NPU |
| qwen3_4b_instruct_2507-genie-w4a16 | 4.0GB | NPU |

### GGUF Modellek (D:\models\)
| Modell | Meret | Format |
|:---|:---|:---|
| Qwen3-VL-8B-Instruct (Q4_K_M) | ~5GB | GGUF |
| gemma-4-E4B-it (Q4_K_M) | ~3GB | GGUF |
| Carnice-Qwen3.6-MoE-35B-A3B | ~20GB | GGUF |
| Qwen3.6-27B-MTP | ~15GB | GGUF |
| Qwen3.5-4B-UD | ~3GB | GGUF |
| Qwen3-8B-UD-Q8_K_XL | ~8GB | GGUF |

### Embedding/Reranker
| Modell | Hely | Format |
|:---|:---|:---|
| bge-m3 | D:\hf_cache\ + C:\AI\npu\models\ | safetensors + ONNX |
| all-MiniLM-L6-v2 | D:\hf_cache\ | ONNX + safetensors |
| Qwen3-Embedding-0.6B | D:\hf_cache\ + C:\AI\npu\models\ | safetensors + ONNX |

**ÖSSZESEN ~80GB+ modell a D: meghajtón!**



---

## 1. Windows Native AI Alkalmazasok (C:\AI\apps\)

| Mappa | Név | Funkció | Státusz |
|:---|:---|:---|:---|
| `ai-core` | AI Core | AI alaprendszer | ? |
| `ai-stack-manager` | AI Stack Manager | Stack kezelő | ? |
| `bifrost` | Bifrost | ? | ? |
| `control-center` | Control Center | FastAPI dashboard | ? |
| `Foundry` | Foundry Local | **NPU** model szerver (QNN HTP) | **NEM FUT** |
| `genie-chat` | Genie Chat | NPU chat | **NEM FUT** |
| `GenieAPIService_cpp` | GenieAPI (C++) | **NPU** API service | **NEM FUT** |
| `hermes-foundry-npu` | Hermes Foundry NPU | NPU bridge | ? |
| `litellm-win` | LiteLLM Proxy | Multi-provider proxy | **FUT (de leállítandó)** |
| `llama-cpp` | llama.cpp | Local LLM inference | ? |
| `local-vector-index` | Local Vector Index | Vector DB | ? |
| `openwebui` | Open WebUI | Chat UI | **NEM FUT** |
| `vibe-stack` | Vibe Stack | ? | ? |
| `vivo-embed` | Vivo Embed | Embedding service | ? |

---

## 2. Windows Nativ Folyamatok (AI relevans)

| ProcessName | PID | Mem(MB) | Funkcio |
|:---|:---|:---|:---|
| **ollama app** | 5484 | 86.1 | Ollama LLM server |
| **python** | 2220 | 266.9 | LiteLLM Proxy (vivo2) |
| **node** | 2760 | 36.8 | Node.js app |
| **node** | 5856 | 39.3 | Node.js app |
| **node** | 8368 | 39.2 | Node.js app |
| **node** | 9032 | 36.1 | Node.js app |
| **node** | 10344 | 39.2 | Node.js app |
| **node** | 11548 | 42.9 | Node.js app |
| **node** | 14004 | 52.5 | Node.js app |
| **node** | 19104 | 51.0 | Node.js app |
| **node** | 26908 | 50.9 | Node.js app |
| **node** | 27256 | 50.8 | Node.js app |
| **node** | 29840 | 39.1 | Node.js app |
| **node** | 30160 | 42.8 | Node.js app |
| **node** | 33000 | 39.3 | Node.js app |
| **node** | 35040 | 39.3 | Node.js app |
| **node** | 36068 | 39.3 | Node.js app |
| **node** | 36128 | 45.0 | Node.js app |

**Osszesen:** 16 node.js folyamat, 1 python (LiteLLM), 1 ollama

---

## 3. Windows Portok (AI szolgaltatasok)

| Port | PID | Szolgaltatas |
|:---|:---|:---|
| **4001** | 5392, 17188 | LiteLLM Proxy (vivo2) |
| **11434** | 17188 | Ollama |

**Megjegyzes:** A 4001-es porton ket PID is figyel — a 5392 (python/LiteLLM) es a 17188 (node/valoszinuleg egy masik proxy vagy az Ollama is hasznalja).

---

## 4. WSL2 (Ubuntu 24.04) - Docker Kontenerek

| Kontener Nev | Image | Status | Port | PID | RAM |
|:---|:---|:---|:---|:---|:---|
| **litellm** | ghcr.io/berriai/litellm:main-latest | Up 38 hours | 4001->4000 | 11408 | 6.9% (852MB) |
| **compassionate_shannon** | hello-world | Exited (0) | - | - | - |

### WSL2 Docker Images
| Repository | Tag | Size |
|:---|:---|:---|
| ghcr.io/berriai/litellm | main-latest | 5.59GB |
| hello-world | latest | 22.6kB |

### WSL2 Docker Networks
| Network ID | Name | Driver |
|:---|:---|:---|
| 50f66667368d | bridge | bridge |
| cdffcf9c459c | host | host |
| 0fef8aac2112 | litellm_default | bridge |
| 5094810d6d85 | none | null |

### WSL2 Folyamatok (top 10 by RAM)
| Process | PID | CPU | RAM | Command |
|:---|:---|:---|:---|:---|
| **litellm** | 11408 | 0.3% | 6.9% | python3.13 /usr/bin/litellm --config /app/config.yaml |
| **dockerd** | 8083 | 0.0% | 0.6% | /usr/bin/dockerd |
| **containerd** | 7927 | 0.1% | 0.4% | /usr/bin/containerd |
| **prisma-engine** | 11669 | 0.0% | 0.3% | query-engine-linux-arm64 |
| **ollama** | 8765 | 0.0% | 0.2% | /usr/local/bin/ollama serve |

---

## 5. LiteLLM Konfiguracio (Windows vivo2)

**Config:** `C:\AI\apps\litellm-win\litellm_config.yaml`
**Env:** `C:\AI\apps\litellm-win\.env`
**Port:** 4001
**Master Key:** sk-win-vivo2
**Database:** postgresql://aistack:***@10.10.40.35:5432/litellm

### Model List (20 model)

#### NPU Models (Snapdragon X Elite)
| Model Name | API Base | Timeout |
|:---|:---|:---|
| foundry-npu-deepseek | http://localhost:5272/v1 (DeepSeek-R1-7B QNN) | 180s |
| foundry-npu | http://localhost:5272/v1 (Qwen2.5-7B QNN) | 180s |
| genie-npu | http://localhost:8912/v1 (Qwen3-4B) | 60s |
| genie-npu-llama | http://localhost:8912/v1 (Llama3.2-3B) | 60s |

#### Local Models
| Model Name | API Base | Timeout |
|:---|:---|:---|
| lm-studio | http://localhost:1234/v1 | 120s |
| llama-cpp | http://localhost:8083/v1 (Qwen3-8B) | 120s |
| mtp-27b | http://localhost:8081/v1 (Qwen3.6-27B MTP) | 300s |

#### Cloud Models (OpenRouter)
| Model Name | Model ID |
|:---|:---|
| openrouter-default | openrouter/owl-alpha |
| openrouter-llama | meta-llama/llama-3.3-70b-instruct:free |
| openrouter-qwen | qwen/qwen3-coder:free |
| openrouter-nemotron | nvidia/nemotron-3-super-120b-a12b:free |
| openrouter-deepseek | deepseek/deepseek-v4-flash:free |
| openrouter-kimi | moonshotai/kimi-k2.6:free |
| openrouter-gemma | google/gemma-4-31b-it:free |
| openrouter-claude | anthropic/claude-sonnet-4-5 (fizetős) |

#### Cloud Models (Hermes Proxy)
| Model Name | API Base |
|:---|:---| 
| hermes-groq | http://localhost:4000 |
| hermes-gemini | http://localhost:4000 |
| hermes-coder | http://localhost:4000 |

#### Special Models
| Model Name | API Base | Notes |
|:---|:---|:---|
| free-claude | http://localhost:8082 | Anthropic protocol, SSE |
| freellmapi | http://localhost:3001/v1 | Free LLM API |
| anythingllm | http://localhost:3000/api/openai | AnythingLLM |

### Fallback Chain
```
foundry-npu-deepseek -> openrouter-deepseek -> openrouter-qwen -> hermes-groq
foundry-npu -> openrouter-deepseek -> openrouter-qwen -> hermes-groq
genie-npu -> lm-studio -> llama-cpp -> hermes-groq
free-claude -> freellmapi -> hermes-coder
```

### Router Settings
- **Strategy:** latency-based-routing
- **Num retries:** 1
- **Timeout:** 90s
- **Cooldown:** 20s

---

## 6. Ollama (Windows Native)

**Version:** 0.30.8
**Port:** 11434
**PID:** 5484
**Memory:** 86.1MB
**Path:** `C:\Users\istva\AppData\Local\Programs\Ollama\ollama app.exe`
**Models:** (nincsenek letöltve — `ollama list` ures)

---

## 7. WSL2 Ollama

**PID:** 8765
**Memory:** 0.2% (34MB)
**Command:** `/usr/local/bin/ollama serve`
**Status:** FUT (de valoszinuleg nincs model)

---

## 8. Inditasi Sorrend

### Windows Native
1. **Ollama:** `ollama serve` (már fut)
2. **LiteLLM:** `C:\AI\apps\litellm-win\start.ps1`
3. **Open WebUI:** `C:\AI\apps\openwebui\start.ps1`
4. **Foundry Local:** `C:\AI\apps\Foundry\start-foundry.ps1` (NPU)
5. **GenieAPI:** `C:\AI\apps\GenieAPIService_cpp\start.ps1` (NPU)

### WSL2
1. **Docker:** `sudo systemctl start docker`
2. **LiteLLM:** `docker start litellm`

---

## 9. Projekt Mappak

| Projekt | Utvonal | Funkcio |
|:---|:---|:---|
| **Homelab Docs** | `C:\Users\istva\homelab-docs\` | Proxmox + AI stack dokumentacio |
| **AI Apps** | `C:\AI\apps\` | Windows native AI alkalmazasok |
| **Hangsegéd Platform** | `C:\Users\istva\hangsegéd-platform\` | AI stack dokumentacio |
| **MADDIE** | `C:\Users\istva\MADDIE\` | Multi-agent debate engine |
| **Agent Research** | `C:\Users\istva\agent-research\` | Kanban + research reports |
| **Hermes Agent** | `C:\Users\istva\AppData\Local\hermes\` | Hermes Agent config + skills |

---

## 10. GitHub Repo

**Repo:** https://github.com/gaiagent0/homelab-infra-map
**Lokal:** `C:\Users\istva\homelab-docs\`
**Fajlok:**
- `cluster-map.md` — Proxmox cluster (3 node, 12 LXC, 30+ Docker)
- `vivo-ai-stack.md` — Vivo laptop AI stack (ez a fajl)

---

## 11. Osszegzés

### Fut Windows Nativ
- Ollama (11434) — nincs model
- LiteLLM Proxy (4001) — 20 model, fallback chain
- 16 Node.js folyamat (valoszinuleg web UI-k)

### Fut WSL2 Docker
- LiteLLM (4001->4000) — 5.59GB image
- Ollama — nincs model

### NEM FUT (de telepítve)
- Open WebUI (8091)
- Foundry Local (5272) — NPU
- GenieAPI (8912) — NPU
- AnythingLLM (3000)
- Free Claude Code (8082)
- FreeLLMAPI (3001)
- LM Studio (1234)
- llama.cpp (8083)
- MTP-27B (8081)
