# Classical-vs-AI-Vessel-Enhancement

Benchmarking classical and AI-based vessel enhancement methods across varying vessel image complexity levels.

---

## Objective

Enhancing vascular structures is a common preprocessing step in biomedical image analysis.

This project compares:

1. Histogram Equalization
2. CLAHE (Contrast Limited Adaptive Histogram Equalization)
3. Frangi Vesselness Filtering
4. AI-Based Vessel Enhancement

across vessel images ranging from low complexity to high complexity.

---

## Methods

### Classical Methods

- Histogram Equalization
- CLAHE
- Frangi Vesselness Filter

Implemented in MATLAB.

### AI Method

Deep learning-based vessel enhancement implemented in Python.

---

## Dataset

The code files are available here, but the dataset is dependent on the user. The user can add the images themselves upon downloading the code.

---

## Evaluation

Methods were assessed using:

- Contrast-to-Noise Ratio (CNR)
- Vessel Density
- Connected Vessel Components
- Visual Inspection

---

## Repository Structure

```text
matlab/     Classical methods
python/     AI implementation
results/    Outputs
figures/    Publication-style figures
docs/       Study notes
