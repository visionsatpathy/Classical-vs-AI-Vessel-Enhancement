import torch
import cv2
import numpy as np
import matplotlib.pyplot as plt

from model import UNet


# ==================================
# SETTINGS
# ==================================

MODEL_PATH = "trained_model/unet_model.pth"

IMAGE_PATH = "G:\\Raw data\\optoacoustic imaging\\AI training Photoaccousatic data\\4042171\\Photoacoustic_UNet\\Contrast_testing_Set\\C7.png"

IMAGE_SIZE = 256

DEVICE = torch.device(
    "cuda"
    if torch.cuda.is_available()
    else "cpu"
)

print("Using:", DEVICE)


# ==================================
# LOAD MODEL
# ==================================

model = UNet().to(DEVICE)

model.load_state_dict(
    torch.load(
        MODEL_PATH,
        map_location=DEVICE
    )
)

model.eval()

print("Model loaded successfully!")


# ==================================
# LOAD IMAGE
# ==================================

raw_img = cv2.imread(
    IMAGE_PATH,
    cv2.IMREAD_GRAYSCALE
)

if raw_img is None:
    raise ValueError(
        f"Cannot load image:\n{IMAGE_PATH}"
    )

original_size = raw_img.shape

# Resize to training size
input_img = cv2.resize(
    raw_img,
    (IMAGE_SIZE, IMAGE_SIZE)
)

# Normalize
input_img = (
    input_img.astype(np.float32)
    / 255.0
)

# Add dimensions
input_tensor = np.expand_dims(
    input_img,
    axis=0
)

input_tensor = np.expand_dims(
    input_tensor,
    axis=0
)

input_tensor = torch.tensor(
    input_tensor
).to(DEVICE)


# ==================================
# PREDICTION
# ==================================

with torch.no_grad():

    prediction = model(
        input_tensor
    )

prediction = (
    prediction
    .cpu()
    .numpy()[0, 0]
)

# Clip values
prediction = np.clip(
    prediction,
    0,
    1
)

# Convert to uint8
prediction = (
    prediction * 255
).astype(np.uint8)

# Resize back
prediction = cv2.resize(
    prediction,
    (
        original_size[1],
        original_size[0]
    )
)


# ==================================
# DISPLAY RESULTS
# ==================================

plt.figure(figsize=(12, 5))

plt.subplot(1, 2, 1)
plt.imshow(raw_img,
           cmap='gray')
plt.title("Raw Image")
plt.axis("off")

plt.subplot(1, 2, 2)
plt.imshow(prediction,
           cmap='gray')
plt.title("AI Enhanced")
plt.axis("off")

plt.tight_layout()
plt.show()


# ==================================
# SAVE IMAGE
# ==================================

cv2.imwrite(
    "enhanced_output.png",
    prediction
)

print(
    "Enhanced image saved as:"
)

print(
    "enhanced_output.png"
)