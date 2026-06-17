# Session Zárás — 2026-06-17 (18:15)

## Eddigi fázisok összefoglaló

### Fázis 0 — Audit (KÉSZ)
- C:\AI\apps\ audit: 15 AI alkalmazás mappa azonosítva
- D:\ meghajtó audit: 80GB+ modell találva
- Feltérképezve: Ollama (11434), LiteLLM WSL2 (4001), Foundry Local (5272), GenieAPI (8912)

### Fázis 1 — NPU Reranker (KÉSZ)
- bge-reranker-v2-m3 letöltve (2.27GB) és ONNX-ba konvertálva
- ONNX Runtime 1.24.4 (onnxruntime-qnn) telepítve — QNNExecutionProvider elérhető
- NPU reranking működik: ~500-670ms/dokumentum
- Teszt eredmény: helyes rangsorolás (AI dokumentumok előre, irrelevánsak hátra)

### Fázis 2 — Foundry Local + GenieAPI (FOLYAMATBAN)
- Foundry Local cache feltöltve: 3 NPU modell (8.4GB) átmásolva
  - deepseek-r1-distill-qwen-7b-qnn-npu-2 (3.72GB)
  - qwen2.5-1.5b-instruct-qnn-npu-2 (0.95GB)
  - qwen2.5-7b-instruct-qnn-npu-2 (3.75GB)
- foundry.modelinfo.json átmásolva
- `foundry model run` továbbra sem működik (Azure Foundry Catalog offline hiba)
- GenieAPI config javítva (E: → D: útvonal)
- GenieAPIService indítása sikertelen (port 8912)
- bge-reranker-v2-minicpm-layerwise (10.9GB) letöltve de ONNX konvertálás sikertelen (custom config class, optimum nem támogatja)

## Befejezetlen feladatok

### Következő session elején:
1. **bge-reranker-v2-minicpm-layerwise ONNX konvertálás** — manuális konvertálás szükséges (optimum nem támogatja a custom LayerWiseMiniCPMConfig-et). `trust_remote_code=True` kell, és saját export script.
2. **GenieAPIService indítása** — mert a C++ service valamiért nem indul el (lehet, hogy QAIRT SDK környezet kell). Projektspecifikus indítási script kell.
3. **Foundry Local NPU model tesztelés** — ha a catalog hiba megoldható, vagy API-n keresztül lehet futtatni
4. **vivo-embed frissítés** — bge-m3 + reranker NPU integráció

## GitHub repo állapot
- https://github.com/gaiagent0/homelab-infra-map — NAPRAÉSZ
- https://github.com/gaiagent0/hermes-foundry-npu — NINCS FRISÍTVE (D: meghajtó modell listával)
- https://github.com/gaiagent0/vivo-embed — NINCS FRISÍTVE (bge-m3 + reranker információkkal)

## Környezet
- Python 3.12-arm64 (C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe) — onnxruntime-qnn 1.24.4, optimum, transformers
- HF HOME: D:\hf_cache
- Genie modellek: D:\models\genie\ (Llama3.2-3B, qwen3_4b, qwen3_4b_instruct_2507)
- Foundry modellek: D:\models\Foundry\Microsoft\ (3 NPU modell)
- Reranker ONNX: D:\models\ONNX\bge-reranker-v2-m3\onnx\ (model.onnx + model.onnx_data)
- GGUF modellek: D:\models\LLM-studio\, D:\models\ollama\, D:\models\mtp-models\

## Hermes memória frissítve
- NPU környezet: Snapdragon X Elite, QAIRT SDK 2.45.40.260406, Foundry Local UWP 0.8.119
- Modell térkép: 80GB+ modell D: meghajtón
- NPU reranking: bge-reranker-v2-m3 működik, ~500ms/doc
- Scriptek: C:\Users\istva\homelab-docs\ mappában (.ps1 és .py fájlok)
