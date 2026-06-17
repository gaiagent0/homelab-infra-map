# Fázis 0 — NPU Környezet Audit és Tesztelés

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

## 2. NPU Modellek

### ONNX modellek (C:\AI\npu\models\)
| Modell | Meret | Format | Status |
|:---|:---|:---|:---|
| bge-m3 | 2.1GB | ONNX | ✅ |
| bge-m3-dense | 2.1GB | ONNX | ✅ |
| qwen3-embedding-0.6b | 2.2GB | ONNX | ✅ |
| qwen3-embedding-0.6b-onnx | 585MB-2.2GB | ONNX (kvantizalt) | ✅ |

### Foundry Local NPU modellek (catalog)
| Modell | Meret | Device |
|:---|:---|:---|
| qwen2.5-7b | 6.81GB | NPU |
| qwen2.5-coder-7b | 7.08GB | NPU |
| deepseek-r1-7b | 3.71GB | NPU |
| deepseek-r1-14b | 7.12GB | NPU |
| phi-3-mini-4k | 3.54GB | NPU |
| phi-3-mini-128k | 3.54GB | NPU |
| phi-3.5-mini | 2.01GB | NPU |
| qwen2.5-0.5b | 0.43GB | NPU |
| qwen2.5-1.5b | 1.06GB | NPU |
| qwen2.5-coder-0.5b | 0.43GB | NPU |
| qwen2.5-coder-1.5b | 1.06GB | NPU |

**MEGJEGYZES:** A Foundry Local NPU modellek NINCSENEK letoltve. A `foundry model run` nem mukodik (Azure Foundry Catalog hiba).

---

## 3. Tesztelés eredménye

### NPU Environment Check
- 26 OK, 6 WARNING, 1 HIANY
- Hianyzo Python csomagok: chromadb, optimum, sentence_transformers
- GenieAPIService NEM fut (port 8912)

### NPU Embedding Teszt
- **QNNExecutionProvider SIKERESEN inicializalva** ✅
- Graph preparation lefutott (VTCM Allocation, stb.)
- Modell betoltve: model_quantized.onnx (585MB)
- **Hiba:** script input hiba (position_ids, past_key_values hianyzik)
- **Javitas szukseges:** npu_embedding.py script javitasa

### Foundry Local
- Service fut (port 5272) ✅
- QNN EP regisztralva ✅
- `foundry model list` → 36 model (NPU + CPU) ✅
- `foundry model run` → HIBA (Azure Foundry Catalog nem elerheto)

---

## 4. Fázis 0 — Végső státusz

| Feladat | Státusz |
|:---|:---|
| C:\AI\apps\ audit | ✅ KÉSZ |
| Windows natív LiteLLM leállítás | ✅ NEM KELL (nem fut) |
| WSL2 LiteLLM ellenőrzés | ✅ FUT (stabil) |
| NPU environment check | ✅ KÉSZ |
| NPU embedding teszt | ⚠️ MŰKÖDIK (script hiba) |
| Foundry Local service | ✅ FUT |
| Foundry Local NPU model run | ❌ Catalog hiba |
| GenieAPI indítás | ❌ Modellek hiányoznak (E:\models\genie\) |

---

## 5. Következő lépések (Fázis 1)

1. **NPU embedding script javítása** (position_ids, past_key_values)
2. **Foundry Local NPU model letöltése** (offline/catalog workaround)
3. **GenieAPI modell letöltése** (Qwen2.5-7B NPU)
4. **LiteLLM WSL2 konfiguráció** (NPU endpoint hozzáadása)
