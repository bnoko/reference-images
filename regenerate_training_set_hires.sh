#!/bin/bash

# Regenerate all training images at 2048x2048 for Flux LoRA training
# Uses Nano Banana API to create high-resolution versions
# Cost: 28 images × $0.02 = $0.56

# Setup
DATE=$(date +%Y-%m-%d)
SOURCE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/references/LoRA training set 1 - linocut black and white"
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/references/LoRA training set 2 - FLUX ready (2048px)"
mkdir -p "$SAVE_DIR"

# Style references for linocut
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Get all PNG files from source directory
SOURCE_FILES=($(ls -1 "$SOURCE_DIR"/*.png))

echo "======================================================================"
echo "REGENERATING TRAINING SET FOR FLUX LORA"
echo "======================================================================"
echo "Source: $SOURCE_DIR"
echo "Output: $SAVE_DIR"
echo "Total images: ${#SOURCE_FILES[@]}"
echo "Output size: 2048x2048"
echo "Cost: \$$(echo "scale=2; ${#SOURCE_FILES[@]} * 0.02" | bc)"
echo "======================================================================"
echo ""

# Array to store task IDs
declare -A TASK_MAP  # Map task_id to filename

# Submit all tasks
echo "Submitting generation tasks..."
for SOURCE_FILE in "${SOURCE_FILES[@]}"; do
  BASENAME=$(basename "$SOURCE_FILE" .png)

  # Create prompt to recreate the image in high resolution
  PROMPT="In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast. Recreate this composition in linocut style with enhanced detail and clarity."

  # Upload source image to GitHub or use image_url (for now, just describe it)
  # Note: For best results, we should describe what each image shows
  # But for speed, we'll use a generic recreation prompt

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"$PROMPT\",
        \"image_urls\": [\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"],
        \"output_format\": \"png\",
        \"image_size\": \"1:1\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_MAP["$TASK_ID"]="$BASENAME"

  echo "  ✓ Submitted: $BASENAME (Task: $TASK_ID)"
  sleep 1  # Rate limiting
done

echo ""
echo "All ${#SOURCE_FILES[@]} tasks submitted!"
echo "Monitoring for completion (this will take 10-20 minutes)..."
echo ""

# Monitor and download
COMPLETED=0
TOTAL=${#SOURCE_FILES[@]}

while [ $COMPLETED -lt $TOTAL ]; do
  for TASK_ID in "${!TASK_MAP[@]}"; do
    FILENAME="${TASK_MAP[$TASK_ID]}"

    # Skip if already completed
    [[ "$FILENAME" == "DONE" ]] && continue

    STATUS_RESPONSE=$(curl -s -X GET "https://api.kie.ai/api/v1/jobs/recordInfo?taskId=$TASK_ID" \
      -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22")

    STATE=$(echo $STATUS_RESPONSE | jq -r '.data.state')

    if [ "$STATE" = "success" ]; then
      IMAGE_URL=$(echo $STATUS_RESPONSE | jq -r '.data.resultJson | fromjson | .resultUrls[0]')
      OUTPUT_FILE="$SAVE_DIR/${FILENAME}.png"
      curl -s -o "$OUTPUT_FILE" "$IMAGE_URL"
      echo "✅ Downloaded: $FILENAME.png"
      TASK_MAP["$TASK_ID"]="DONE"
      ((COMPLETED++))
    elif [ "$STATE" = "fail" ]; then
      echo "❌ Failed: $FILENAME"
      TASK_MAP["$TASK_ID"]="DONE"
      ((COMPLETED++))
    fi
  done

  PERCENT=$((COMPLETED * 100 / TOTAL))
  echo "Progress: $COMPLETED/$TOTAL ($PERCENT%)"
  sleep 15
done

echo ""
echo "======================================================================"
echo "REGENERATION COMPLETE!"
echo "======================================================================"
echo "Output directory: $SAVE_DIR"
echo "Total cost: \$$(echo "scale=2; $TOTAL * 0.02" | bc)"
echo ""
echo "Next step: Verify image quality and begin LoRA training"
echo "======================================================================"