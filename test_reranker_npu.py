import os, sys, time
import numpy as np

# QAIRT SDK path
qairt_base = r"C:\Qualcomm\AIStack\QAIRT\2.45.40.260406"
os.environ['PATH'] = os.path.join(qairt_base, 'lib', 'arm64x-windows-msvc') + ';' + os.environ.get('PATH', '')
os.environ['QNN_SDK_ROOT'] = qairt_base

import onnxruntime as ort
from transformers import AutoTokenizer

print(f"ONNX Runtime: {ort.__version__}")
print(f"Providers: {ort.get_available_providers()}")

model_path = r"D:\models\ONNX\bge-reranker-v2-m3\onnx"
print(f"\nModell: {model_path}")

# Tokenizer
tokenizer = AutoTokenizer.from_pretrained(model_path)
print(f"Tokenizer: {tokenizer.__class__.__name__}")

# QnnHtp.dll
qnn_dll = os.path.join(qairt_base, 'lib', 'arm64x-windows-msvc', 'QnnHtp.dll')
print(f"QnnHtp.dll: {os.path.exists(qnn_dll)}")

# Session NPU-n
providers = ['QNNExecutionProvider']
provider_options = [{'backend_path': qnn_dll, 'htp_performance_mode': 'burst', 'htp_precision': 'int8'}]

print(f"\nSession letrehozasa NPU-n...")
t0 = time.time()
try:
    sess_options = ort.SessionOptions()
    sess_options.graph_optimization_level = ort.GraphOptimizationLevel.ORT_ENABLE_ALL
    session = ort.InferenceSession(
        os.path.join(model_path, 'model.onnx'),
        sess_options=sess_options,
        providers=providers,
        provider_options=provider_options
    )
    print(f"Session OK: {session.get_providers()} ({time.time()-t0:.1f}s)")
except Exception as e:
    print(f"NPU HIBA: {e}")
    print("CPU fallback...")
    session = ort.InferenceSession(
        os.path.join(model_path, 'model.onnx'),
        providers=['CPUExecutionProvider']
    )
    print(f"Session OK (CPU): {session.get_providers()}")

# Teszt szoveg
query = "What is artificial intelligence?"
documents = [
    "AI is the simulation of human intelligence by machines.",
    "The weather is nice today.",
    "Machine learning is a subset of artificial intelligence.",
    "I like to eat pizza.",
    "Natural language processing is an AI technology."
]

print(f"\nQuery: {query}")
print(f"Documents: {len(documents)}")

# Reranking
scores = []
for doc in documents:
    inputs = tokenizer(query, doc, max_length=512, padding='max_length', truncation=True, return_tensors='np')
    ort_inputs = {
        'input_ids': inputs['input_ids'].astype(np.int64),
        'attention_mask': inputs['attention_mask'].astype(np.int64),
    }
    t0 = time.time()
    outputs = session.run(None, ort_inputs)
    elapsed = time.time() - t0
    
    # Score kinyeres
    out = outputs[0]
    if out.ndim == 3:
        score = float(out[0, 0, 1])
    elif out.ndim == 2:
        score = float(out[0, 1]) if out.shape[1] > 1 else float(out[0, 0])
    else:
        score = float(out.flat[0])
    
    scores.append((doc[:60], score, elapsed*1000))

# Rendezes
scores.sort(key=lambda x: x[1], reverse=True)
print(f"\n=== RERANK EREDMENY ===")
for i, (doc, score, ms) in enumerate(scores):
    print(f"  {i+1}. [{score:.4f}] ({ms:.1f}ms) {doc}...")

print(f"\nKESZ!")
