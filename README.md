# Computational Assessment of Vascular Enhancement in Photoacoustic Microscopy (PAM)

## A Study in Anatomical Confidence

Biomedical image enhancement often improves vascular visibility — but an important question remains:

> **When enhancement algorithms reveal vascular structures that are weak or barely visible in the raw image, how do we determine whether these structures reflect latent anatomy or computational amplification?**

This repository explores that question using **Photoacoustic Microscopy (PAM)** vascular datasets by comparing **classical image enhancement methods** and **AI-assisted enhancement pipelines**.

Rather than evaluating enhancement purely by visual appeal, this work investigates how different computational approaches influence:

* vascular continuity
* vessel visibility
* apparent vessel density
* signal-to-noise behavior
* anatomical interpretability

The broader goal is to encourage discussion on:

> **How should vascular enhancement be evaluated in biomedical imaging — by visibility alone, or also by confidence in anatomical fidelity?**

---

# Example Comparison

This repository compares multiple enhancement approaches on the same vascular structures:

```text
RAW → CLAHE → FRANGI → AI Enhancement
```

Suggested comparison themes include:

* visibility of weak vessels
* preservation of microvascular branching
* vessel continuity
* enhancement-induced structural changes

---

# Why This Repository Exists

In biomedical imaging, enhancement quality is often judged visually:

> *“Does the image look better?”*

However, vascular enhancement can significantly influence:

* vessel continuity
* microvascular visibility
* apparent vessel density
* perceived morphology

A visually enhanced image may appear anatomically convincing — yet an important question remains:

> **Does increased vessel visibility necessarily imply increased anatomical truth?**

This repository was built to explore that question computationally using **Photoacoustic Microscopy (PAM)** vascular data.

---

# Dataset

This work uses the publicly available:

**Duke PAM Dataset (v0.1.0)**

**Anthony DiSpirito III. (2020)**

Dataset source:

https://doi.org/10.5281/zenodo.4042171

The dataset contains **photoacoustic microscopy (PAM)** vascular images, including:

* mouse ear vasculature
* tumor-associated vascular regions

These datasets provide useful examples for studying how enhancement algorithms influence vascular appearance and interpretability.

---

# Repository Structure

```text
.
├── AI_Methods/
│   ├── dataset.py
│   ├── inference.py
│   ├── model.py
│   ├── train_unet.py
│   └── Vessel_Cheaker_tool_AI.m
│
├── classical_methods/
│   ├── Classical_cleaning.m
│   ├── clahe_enhancement.m
│   ├── frangi_enhancement.m
│   ├── FrangiFilter2D.m
│   ├── Hessian2D.m
│   ├── eig2image.m
│   ├── Vessel_Cheaking_Tool.m
│   └── vessel_assessment.m
│
└── README.md
```

---

# Classical Methods

Location:

```text
classical_methods/
```

This section contains **non-AI vascular enhancement approaches** implemented in MATLAB.

---

## 1. CLAHE Enhancement

File:

```text
clahe_enhancement.m
```

Implements:

**Contrast Limited Adaptive Histogram Equalization (CLAHE)**

Purpose:

* improve local contrast
* reveal weak vascular structures
* enhance low-visibility regions

Potential advantages:

* preserves vessel sharpness
* improves local visibility
* enhances weak branching structures

Potential challenge:

* may amplify weak background structures alongside vessels

---

## 2. Frangi Vessel Enhancement

Files:

```text
frangi_enhancement.m
FrangiFilter2D.m
Hessian2D.m
eig2image.m
```

Implements a **Frangi vesselness filter** adapted for **PAM vascular images**.

Purpose:

* enhance tubular vessel structures
* improve vascular continuity
* preserve multi-scale vessel morphology

The implementation was modified to better accommodate:

* microvascular branching
* fine vessel continuity
* sharper vascular structure preservation in PAM data

Potential challenge:

* enhancement sensitivity depends strongly on vessel scale and local morphology

---

## 3. Classical Cleaning Pipeline

File:

```text
Classical_cleaning.m
```

Performs preprocessing prior to enhancement.

Includes:

* image normalization
* structural preparation
* noise handling

---

## 4. Vessel Checking Tool

File:

```text
Vessel_Cheaking_Tool.m
```

Interactive MATLAB-based ROI analysis tool.

Features:

1. Load vascular image
2. Select ROI interactively
3. Compare local enhancement behavior

Useful for examining:

* weak vessel visibility
* continuity changes
* enhancement effects in specific vascular regions

---

## 5. Vessel Assessment

File:

```text
vessel_assessment.m
```

Provides **quantitative ROI-based comparison** of enhancement methods.

### Quantitative Metrics

#### Vessel Count

Estimates the number of segmented vascular structures within ROI.

#### Relative Vessel-to-Background SNR

Measures vessel signal quality relative to local background noise.

#### Vessel Area Fraction

Estimates vascular occupancy within ROI.

These metrics are intended for:

> **comparative assessment between enhancement approaches**

rather than direct biological ground truth.

---

# AI Methods

Location:

```text
AI_Methods/
```

This section implements **AI-assisted vascular enhancement** using a **U-Net based framework**.

---

## 1. Dataset Preparation

File:

```text
dataset.py
```

Responsible for:

* loading training data
* preprocessing
* data preparation for model training

---

## 2. Model Definition

File:

```text
model.py
```

Defines the **U-Net architecture** used for vascular enhancement.

Purpose:

* learn vascular enhancement representations
* improve vessel visibility
* reconstruct enhanced vascular appearance

---

## 3. Training Pipeline

File:

```text
train_unet.py
```

Used for:

* model training
* optimization
* learning enhancement behavior from vascular images

---

## 4. Inference Pipeline

File:

```text
inference.py
```

Runs trained models on PAM images to generate:

* AI-enhanced vascular outputs
* enhanced vessel representations

---

## 5. AI Vessel Comparison Tool

File:

```text
Vessel_Cheaker_tool_AI.m
```

Interactive MATLAB ROI tool for:

### RAW vs AI-enhanced comparison

Provides:

* ROI selection
* vessel count estimation
* relative vessel-to-background SNR
* vessel area comparison

Useful for studying how AI enhancement changes local vascular appearance.

---

# Suggested Workflow

## Classical Enhancement Workflow

1. Load PAM image
2. Apply enhancement:

   * CLAHE
   * Frangi
3. Select ROI
4. Compare:

* vessel continuity
* weak branch visibility
* vessel count
* SNR behavior

---

## AI Enhancement Workflow

### Step 1 — Train Model

```bash
python train_unet.py
```

### Step 2 — Run Inference

```bash
python inference.py
```

### Step 3 — Evaluate Local Enhancement

Use:

```text
Vessel_Cheaker_tool_AI.m
```

to compare:

```text
RAW vs AI-enhanced vasculature
```

within identical ROIs.

---

# Questions Explored by This Repository

This repository explores several computational questions:

* Do enhancement methods preserve vascular morphology equally?
* Are weak vessels recovered — or computationally amplified?
* How does enhancement alter perceived vessel continuity?
* Does higher visibility imply higher anatomical confidence?
* How should vascular enhancement quality be evaluated in biomedical imaging?

---

# Important Limitation

Improved vessel visibility should **not** be interpreted as direct anatomical truth.

Enhancement methods may:

* suppress vessels
* exaggerate weak structures
* fragment continuity
* merge nearby vessels
* amplify non-vascular patterns

Accordingly, the included quantitative metrics are intended for:

> **relative comparison between enhancement methods**

rather than biological or clinical ground truth.

---

# Citation

If using this repository or associated dataset, please cite:

**Anthony DiSpirito III. (2020)**

**Duke PAM Dataset (0.1.0)**

Zenodo

https://doi.org/10.5281/zenodo.4042171

---

# Author

**Sweta Satpathy**

PhD Researcher | Biomedical Imaging | Computational Imaging


