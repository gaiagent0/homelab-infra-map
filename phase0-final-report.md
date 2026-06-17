# Fázis 0 — NPU Környezet Audit és Tesztelés (VEGSÖ)

**Datum:** 2026-06-17
**Status:** BEFEJZVE

---

## 1. NPU Hardware

**Snapdragon X Elite X1E78100**
- 12 mag (Oryon CPU)
- 45 TOPS NPU (Hexagon)
- ARM64 architektura

**QAIRT SDK:** 2.45.40.260406
- QnnHtp.dll (NPU backend) ✅
- QnnCpu.dll ✅
- QnnGpu.dll ✅
- Genie.dll ✅
- Python binding ✅
- Converter toolok ✅

---

## 2. NPU Modellek (D: meghajtó)

### Foundry Local NPU modellek (D:\models\Foundry\Microsoft\)
| Modell | Meret | Device | Status |
|:---|:---|:---|:---|
| deepseek-r1-distill-qwen-7b-qnn-npu-2 | 3.1GB | NPU | ✅ TELEPITVE |
| qwen2.5-1.5b-instruct-qnn-npu-2 | 0.6GB | NPU | ✅ TELEPITVE |
| qwen2.5-7b-instruct-qnn-npu-2 | 3.0GB | NPU | ✅ TELEPITVE |

### Genie modellek (D:\models\genie\)
| Modell | Meret | Device | Status |
|:---|:---|:---|:---|
| Llama3.2-3B | 1.5GB | NPU | ✅ TELEPITVE |
| qwen3_4b-genie-w4a16 | 4.0GB | NPU | ✅ TELEPITVE |
| qwen3_4b_instruct_2507-genie-w4a16 | 4.0GB | NPU | ✅ TELEPITVE |

### GGUF modellek (D:\models\LLM-studio\, D:\models\ollama\, D:\models\mtp-models\)
| Modell | Meret | Format | Status |
|:---|:---|:---|:---|
| Qwen3-VL-8B-Instruct (Q4_K_M) | ~5GB | GGUF | ✅ |
| gemma-4-E4B-it (Q4_K_M) | ~3GB | GGUF | ✅ |
| Carnice-Qwen3.6-MoE-35B-A3B | ~20GB | GGUF | ✅ |
| Qwen3.6-27B-MTP | ~15GB | GGUF | ✅ |
| Qwen3.5-4B-UD | ~3GB | GGUF | ✅ |
| Qwen3-8B-UD-Q8_K_XL | ~8GB | GGUF | ✅ |
| Ollama blobs (tobb modell) | - | Ollama | ✅ |

### Embedding/Reranker (D: es C:)
| Modell | Meret | Format | Status |
|:---|:---|:---|:---|
| bge-m3 (D:\hf_cache\) | ~2.2GB | safetensors | ✅ |
| bge-m3 (C:\AI\npu\models\) | 2.1GB | ONNX | ✅ |
| all-MiniLM-L6-v2 (D:\hf_cache\) | ~90MB | ONNX/safetensors | ✅ |
| Qwen3-Embedding-0.6B (D:\hf_cache\) | ~1.2GB | safetensors | ✅ |
| Qwen3-Embedding-0.6B (C:\AI\npu\models\) | 2.2GB | ONNX | ✅ |

---

## 3. Foundry Local javitas

### Problema
A `foundry model run` parancs nem mukodik, mert:
1. Az Azure Foundry Catalog nem elerheto (online hiba)
2. A modellek nincsenek a Foundry Local cache-ben
3. A Foundry Local csak Azure Foundry Catalog URI-kat fogad

### Megoldas
A Foundry Local cache manualis feltoltese:
1. A D:\models\Foundry\Microsoft\ modellek masolasa a Foundry cache-be
2. A foundry.modelinfo.json frissitese lokalis modellekkel
3. A foundry model run parancs ujratesztelese

### Status
- Foundry Local service fut (port 5272) ✅
- QNN EP regisztralva ✅
- 36 model elerheto a katalogbol (NPU + CPU) ✅
- `foundry model run` → HIBA (catalog hiba, cache ures)

---

## 4. NPU Embedding Teszt

### ONNX Runtime QNNExecutionProvider
- **SIKERESEN mukodik** ✅
- Graph preparation lefutott (VTCM Allocation, DDR bandwidth)
- Modell betoltve: model_quantized.onnx (585MB)
- **Hiba:** npu_embedding.py script input hiba (position_ids, past_key_values hianyzik)
- **Javitas:** script javitasa szukseges

### NPU Environment Check
- 26 OK, 6 WARNING, 1 HIANY
- Hianyzo Python csomagok: chromadb, optimum, sentence_transformers
- GenieAPIService NEM fut (port 8912)

---

## 5. Fázis 0 — Végső státusz

| Feladat | Státusz |
|:---|:---|
| C:\AI\apps\ audit | ✅ KÉSZ |
| D:\ meghajtó audit | ✅ KÉSZ |
| Windows natív LiteLLM leállítás | ✅ NEM KELL (nem fut) |
| WSL2 LiteLLM ellenőrzés | ✅ FUT (stabil) |
| NPU environment check | ✅ KÉSZ |
| NPU embedding teszt | ⚠️ MŰKÖDIK (script hiba) |
| Foundry Local service | ✅ FUT |
| Foundry Local NPU model run | ❌ Catalog hiba |
| GenieAPI indítás | ❌ Modellek D:-n vannak, config javítás kell |

---

## 6. Következő lépések (Fázis 1)

1. **Foundry Local cache feltöltése** (D: → Foundry cache)
2. **NPU embedding script javítása** (position_ids, past_key_values)
3. **GenieAPI config javítása** (D:\models\genie\ útvonalakra)
4. **bge-reranker-v2-m3 letöltése** (HuggingFace)
5. **LiteLLM WSL2 konfiguráció** (NPU endpoint hozzáadása)
