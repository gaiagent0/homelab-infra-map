# Fázis 1 — bge-reranker-v2-m3 NPU Reranking

**Datum:** 2026-06-17
**Status:** SIKERES

---

## Eredmeny

A bge-reranker-v2-m3 modell sikeresen fut NPU-n!

### Konvertalas
- HuggingFace: BAAI/bge-reranker-v2-m3 (568M param, 2.27GB)
- ONNX: optimum + trust_remote_code
- Meret: model.onnx (0.5MB) + model.onnx_data (2.17GB)

### NPU Inference
- ONNX Runtime: 1.24.4 (onnxruntime-qnn)
- Provider: QNNExecutionProvider
- QnnHtp.dll: C:\Qualcomm\AIStack\QAIRT\2.45.40.260406\lib\arm64x-windows-msvc\QnnHtp.dll

### Teljesitmeny
- Inference: ~500-670ms/dokumentum (NPU)
- Session letrehozasa: ~3.2s

### Rerank Teszt Eredmeny
Query: "What is artificial intelligence?"

| Rank | Score | Idő | Dokumentum |
|:---|:---|:---|:---|
| 1 | 5.5263 | 609ms | AI is the simulation of human intelligence by machines. |
| 2 | -1.6228 | 618ms | Machine learning is a subset of artificial intelligence. |
| 3 | -3.9423 | 556ms | Natural language processing is an AI technology. |
| 4 | -11.0301 | 484ms | I like to eat pizza. |
| 5 | -11.0396 | 671ms | The weather is nice today. |

### Kovetkezo lepesek
1. Foundry Local cache feltoltese (D: NPU modellek)
2. GenieAPI config javitasa (D:\models\genie\ utvonal)
3. bge-reranker-v2-minicpm-layerwise konvertalas (manualis, custom config)
4. LiteLLM WSL2 konfiguracio (NPU endpoint)
