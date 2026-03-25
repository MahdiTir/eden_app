# 🌿 ML — Plant Classifier Training

This folder contains the training notebook and related resources for the on-device plant identification model used in the **Eden** Flutter app.

---

## 📓 Notebook

| File | Description |
|------|-------------|
| `notebooks/plant_classifier_training.ipynb` | Full training pipeline: data loading, augmentation, fine-tuning MobileNetV3, evaluation, and TFLite export |

---

## 🧠 Model Overview

| Property | Value |
|----------|-------|
| **Architecture** | MobileNetV3 (fine-tuned) |
| **Task** | Multi-class plant family/genus classification |
| **Number of classes** | 388 (families + genera) |
| **Input shape** | `[1, 224, 224, 3]` — float32, normalized to `[0.0, 1.0]` |
| **Output** | Raw logits `[1, 388]` — softmax applied post-inference |
| **Export format** | TensorFlow Lite (`.tflite`) |
| **Deployment target** | On-device (Flutter via `tflite_flutter`) |

---

## 🔄 Training Pipeline

1. **Data loading** — Plant image dataset organized by family/genus labels
2. **Preprocessing** — Resize to 224×224, normalize pixel values to `[0, 1]`
3. **Augmentation** — Random flips, rotations, and color jitter
4. **Fine-tuning** — MobileNetV3 backbone with frozen early layers, trainable classifier head
5. **Evaluation** — Top-1 and Top-5 accuracy on validation split
6. **Export** — Converted to `.tflite` flatbuffer for on-device deployment

---

## 🚀 Deployment

The exported model (`plant_identification_mobilenetv3_family.tflite`) is bundled directly in the Flutter app under `assets/`. At runtime:

- **Offline path** → TFLite interpreter runs inference on-device via `tflite_flutter`
- **Online path** → Image is base64-encoded and sent to a Supabase Edge Function, which forwards it to a Hugging Face-hosted model for higher-accuracy results

The label mapping between class indices and plant names is stored in `assets/family_label_mapping.json`.

---

## 📂 Related App Code

| File | Role |
|------|------|
| `lib/core/services/plant_classifier_service.dart` | Inference service (offline TFLite + online API) |
| `assets/plant_identification_mobilenetv3_family.tflite` | Exported model |
| `assets/family_label_mapping.json` | Class index → label mapping (388 classes) |

---

## 👤 Author

**TIROUCHE Mahdi** — [@MahdiTir](https://github.com/MahdiTir)
