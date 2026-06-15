import torch
from torch.utils.data import (
    DataLoader,
    random_split
)

import torch.nn as nn
import torch.optim as optim
from tqdm import tqdm
import matplotlib.pyplot as plt
import os

from model import UNet
from dataset import PAMDataset


# ==================================
# SETTINGS
# ==================================

RAW_FOLDER = "Raw Train"
CLEAN_FOLDER = "Clean Train"

IMAGE_SIZE = 256
BATCH_SIZE = 8
EPOCHS = 50
LEARNING_RATE = 1e-4

DEVICE = torch.device(
    "cuda"
    if torch.cuda.is_available()
    else "cpu"
)

print("Using:", DEVICE)


# ==================================
# LOAD DATASET
# ==================================

dataset = PAMDataset(
    RAW_FOLDER,
    CLEAN_FOLDER,
    image_size=IMAGE_SIZE
)

train_size = int(
    0.8 * len(dataset)
)

val_size = len(dataset) - train_size

train_set, val_set = random_split(
    dataset,
    [train_size, val_size]
)

train_loader = DataLoader(
    train_set,
    batch_size=BATCH_SIZE,
    shuffle=True
)

val_loader = DataLoader(
    val_set,
    batch_size=BATCH_SIZE,
    shuffle=False
)

print("Training images:",
      len(train_set))

print("Validation images:",
      len(val_set))


# ==================================
# MODEL
# ==================================

model = UNet().to(DEVICE)

criterion = nn.MSELoss()

optimizer = optim.Adam(
    model.parameters(),
    lr=LEARNING_RATE
)

train_losses = []
val_losses = []


# ==================================
# TRAIN LOOP
# ==================================

for epoch in range(EPOCHS):

    model.train()

    running_loss = 0

    loop = tqdm(
        train_loader,
        leave=True
    )

    for raw_img, clean_img in loop:

        raw_img = raw_img.to(
            DEVICE
        )

        clean_img = clean_img.to(
            DEVICE
        )

        prediction = model(
            raw_img
        )

        loss = criterion(
            prediction,
            clean_img
        )

        optimizer.zero_grad()
        loss.backward()
        optimizer.step()

        running_loss += loss.item()

        loop.set_description(
            f"Epoch [{epoch+1}/{EPOCHS}]"
        )

        loop.set_postfix(
            loss=loss.item()
        )

    train_loss = (
        running_loss /
        len(train_loader)
    )

    train_losses.append(
        train_loss
    )

    # ----------------
    # Validation
    # ----------------

    model.eval()

    val_loss = 0

    with torch.no_grad():

        for raw_img, clean_img in val_loader:

            raw_img = raw_img.to(
                DEVICE
            )

            clean_img = clean_img.to(
                DEVICE
            )

            prediction = model(
                raw_img
            )

            loss = criterion(
                prediction,
                clean_img
            )

            val_loss += loss.item()

    val_loss /= len(val_loader)

    val_losses.append(
        val_loss
    )

    print(
        f"Epoch {epoch+1} | "
        f"Train Loss: "
        f"{train_loss:.5f} | "
        f"Val Loss: "
        f"{val_loss:.5f}"
    )


# ==================================
# SAVE MODEL
# ==================================

os.makedirs(
    "trained_model",
    exist_ok=True
)

torch.save(
    model.state_dict(),
    "trained_model/unet_model.pth"
)

print(
    "Training complete!"
)

print(
    "Model saved."
)


# ==================================
# LOSS PLOT
# ==================================

plt.figure(figsize=(8, 5))

plt.plot(
    train_losses,
    label="Train Loss"
)

plt.plot(
    val_losses,
    label="Validation Loss"
)

plt.xlabel("Epoch")
plt.ylabel("Loss")
plt.legend()

plt.show()