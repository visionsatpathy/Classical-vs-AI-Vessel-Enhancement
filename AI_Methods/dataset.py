import os
import cv2
import torch
import numpy as np
from torch.utils.data import Dataset

class PAMDataset(Dataset):

    def __init__(
        self,
        raw_dir,
        clean_dir,
        image_size=256
    ):

        self.raw_dir = raw_dir
        self.clean_dir = clean_dir
        self.image_size = image_size

        # Keep only image files
        raw_files = sorted([
            f for f in os.listdir(raw_dir)
            if f.lower().endswith(
                ('.png', '.jpg',
                 '.jpeg', '.tif',
                 '.tiff')
            )
        ])

        # Keep only matching files
        self.image_names = []

        for file in raw_files:

            clean_path = os.path.join(
                clean_dir,
                file
            )

            if os.path.exists(clean_path):
                self.image_names.append(file)

            else:
                print(
                    f"Missing clean image: {file}"
                )

        print(
            f"Matched image pairs: "
            f"{len(self.image_names)}"
        )

    def __len__(self):
        return len(self.image_names)

    def __getitem__(self, idx):

        img_name = self.image_names[idx]

        raw_path = os.path.join(
            self.raw_dir,
            img_name
        )

        clean_path = os.path.join(
            self.clean_dir,
            img_name
        )

        raw_img = cv2.imread(
            raw_path,
            cv2.IMREAD_GRAYSCALE
        )

        clean_img = cv2.imread(
            clean_path,
            cv2.IMREAD_GRAYSCALE
        )

        if raw_img is None:
            raise ValueError(
                f"Cannot load RAW image:\n"
                f"{raw_path}"
            )

        if clean_img is None:
            raise ValueError(
                f"Cannot load CLEAN image:\n"
                f"{clean_path}"
            )

        # Resize
        raw_img = cv2.resize(
            raw_img,
            (
                self.image_size,
                self.image_size
            )
        )

        clean_img = cv2.resize(
            clean_img,
            (
                self.image_size,
                self.image_size
            )
        )

        # Normalize
        raw_img = (
            raw_img.astype(np.float32)
            / 255.0
        )

        clean_img = (
            clean_img.astype(np.float32)
            / 255.0
        )

        # Add channel dimension
        raw_img = np.expand_dims(
            raw_img,
            axis=0
        )

        clean_img = np.expand_dims(
            clean_img,
            axis=0
        )

        return (
            torch.tensor(raw_img),
            torch.tensor(clean_img)
        )
