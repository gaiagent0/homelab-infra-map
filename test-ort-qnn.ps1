# ONNX Runtime QNN EP teszt
$py = "C:\Users\istva\AppData\Local\Programs\Python\Python312-arm64\python.exe"

$testPy = @"
import sys
print(f"Python: {sys.exversion if hasattr(sys, 'exversion') else sys.version}")

# Probaljuk meg importalni az onnxruntime-qnn-t
try:
    import onnxruntime_qnn as ort_qnn
    print(f"onnxruntime_qnn: {ort_qnn.__version__}")
    print(f"Providers: {ort_qnn.get_available_providers()}")
except ImportError as e:
    print(f"onnxruntime_qnn import HIBA: {e}")

# Probaljuk meg a QNN EP-t a sima onnxruntime-bol
import onnxruntime as ort
print(f"\nonnxruntime: {ort.__version__}")
print(f"Providers: {ort.get_available_providers()}")

# QnnHtp.dll betoltes
import ctypes, os
qairt_base = r"C:\Qualcomm\AIStack\QAIRT\2.45.40.260406"
qnn_dll = os.path.join(qairt_base, 'lib', 'arm64x-windows-msvc', 'QnnHtp.dll')
print(f"\nQnnHtp.dll: {os.path.exists(qnn_dll)}")
if os.path.exists(qnn_dll):
    try:
        dll = ctypes.CDLL(qnn_dll)
        print(f"QnnHtp.dll betoltve: {dll}")
    except Exception as e:
        print(f"QnnHtp.dll betoltes HIBA: {e}")
"@
& $py -c $testPy 2>&1
