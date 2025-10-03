#!/usr/bin/env python3
"""
Upscale training images to 2048px for Flux LoRA training
Uses Lanczos resampling for best quality
"""

import os
from PIL import Image
from pathlib import Path

SOURCE_DIR = "/Users/byron/Projects/Jimmy/Tools/reference-images/references/LoRA training set 1 - linocut black and white"
OUTPUT_DIR = "/Users/byron/Projects/Jimmy/Tools/reference-images/references/LoRA training set 2 - FLUX ready (2048px)"

def upscale_image(input_path, output_path, target_size=2048):
    """Upscale image to target size while maintaining aspect ratio"""
    with Image.open(input_path) as img:
        # Get current size
        width, height = img.size

        # Calculate new size (longest side = target_size)
        if width > height:
            new_width = target_size
            new_height = int(height * (target_size / width))
        else:
            new_height = target_size
            new_width = int(width * (target_size / height))

        # Upscale using Lanczos (best quality for upscaling)
        img_upscaled = img.resize((new_width, new_height), Image.Resampling.LANCZOS)

        # Save
        img_upscaled.save(output_path, 'PNG', optimize=True)

        return width, height, new_width, new_height

def main():
    # Create output directory
    os.makedirs(OUTPUT_DIR, exist_ok=True)

    # Get all PNG files
    source_files = list(Path(SOURCE_DIR).glob("*.png"))

    print("=" * 70)
    print("UPSCALING TRAINING SET FOR FLUX LORA")
    print("=" * 70)
    print(f"Source: {SOURCE_DIR}")
    print(f"Output: {OUTPUT_DIR}")
    print(f"Total images: {len(source_files)}")
    print(f"Target size: 2048px (longest side)")
    print("=" * 70)
    print()

    successful = 0
    failed = 0

    for source_file in sorted(source_files):
        try:
            output_file = Path(OUTPUT_DIR) / source_file.name

            old_w, old_h, new_w, new_h = upscale_image(source_file, output_file)

            print(f"✅ {source_file.name}")
            print(f"   {old_w}x{old_h} → {new_w}x{new_h}")

            successful += 1
        except Exception as e:
            print(f"❌ {source_file.name}: {e}")
            failed += 1

    print()
    print("=" * 70)
    print("UPSCALING COMPLETE!")
    print("=" * 70)
    print(f"Successful: {successful}")
    print(f"Failed: {failed}")
    print(f"Output: {OUTPUT_DIR}")
    print("=" * 70)
    print()
    print("Next step: Train Flux LoRA with upscaled images")

if __name__ == "__main__":
    main()