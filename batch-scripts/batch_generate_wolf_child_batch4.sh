#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video - BATCH 4 (FINAL)
# 16 final images from conclusion section

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Adult Oksana character reference
ADULT_OKSANA_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/oksana-adult-character-reference.png"

# Batch 4 prompts (16 final images)
BATCH4_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a feral child trying to use a mobile phone, looking confused"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting survival instincts becoming barriers in society"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting two cages: one contained a wild forest den and the other containing a civilized room"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the adult woman from the character reference image in a restaurant, eating with her hands"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the adult woman from the character reference image at edge of a human social group, looking somewhat apart"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a world map with Ukraine, Spain, California and India marked, with connecting lines between them"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an abstract representation of belonging, using many hands holding each other"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an evolutionary diagram showing layers of human development"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image: civilized human with ancient wild self as shadow"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human figure transforming, keeping essence but changing form"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a calm peaceful wolf-like sky figure floating above chaotic civilization"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close up of a large wolf tattoo on a womans shoulder"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting ghostly wolf-child figures in human minds"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human silhouette with wolf essence glowing within"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a delicate civilization structure protecting/nurturing children"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's hand releasing a wolf paw, both reaching back toward each other"
)

# Indices that need Adult Oksana character reference
ADULT_OKSANA_INDICES=(3 4)  # Restaurant scene, social group scene

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=()

echo "Starting batch 4 (FINAL) generation of 16 images for 'How does it feel to be raised by wolves'"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!BATCH4_PROMPTS[@]}"; do
  # Determine which references to use
  if [[ " ${ADULT_OKSANA_INDICES[@]} " =~ " ${i} " ]]; then
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$ADULT_OKSANA_REF")
  else
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}")
  fi

  # Build image_urls JSON array
  IMAGE_URLS_JSON="["
  for ref in "${IMAGE_REFS[@]}"; do
    IMAGE_URLS_JSON+="\"$ref\","
  done
  IMAGE_URLS_JSON="${IMAGE_URLS_JSON%,}]"  # Remove trailing comma and close array

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${BATCH4_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS_JSON,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  DESCRIPTIONS+=("batch4_$(printf "%02d" $((i+1)))")
  echo "Task $((i+1))/16 submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "All 16 batch 4 (FINAL) tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.32 (16 × $0.02)"
echo ""

# Monitor all tasks and download when complete
COMPLETED=0
while [ $COMPLETED -lt ${#TASK_IDS[@]} ]; do
  for i in "${!TASK_IDS[@]}"; do
    TASK_ID=${TASK_IDS[$i]}
    [[ $TASK_ID == "COMPLETED" ]] && continue

    STATUS_RESPONSE=$(curl -s -X GET "https://api.kie.ai/api/v1/jobs/recordInfo?taskId=$TASK_ID" \
      -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22")

    STATE=$(echo $STATUS_RESPONSE | jq -r '.data.state')

    if [ "$STATE" = "success" ]; then
      IMAGE_URL=$(echo $STATUS_RESPONSE | jq -r '.data.resultJson | fromjson | .resultUrls[0]')
      FILENAME="${DESCRIPTIONS[$i]}_$(date +%H%M%S).png"
      curl -s -o "$SAVE_DIR/$FILENAME" "$IMAGE_URL"
      echo "✅ Downloaded: $FILENAME"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    elif [ "$STATE" = "fail" ]; then
      echo "❌ Task $((i+1)) failed: ${DESCRIPTIONS[$i]}"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    fi
  done

  echo "Progress: $COMPLETED/16 completed"
  sleep 10
done

echo ""
echo "🎉🎉🎉 BATCH 4 (FINAL) COMPLETE! 🎉🎉🎉"
echo "All images saved to: $SAVE_DIR"
echo "Cost: $0.32 total"
echo ""
echo "=== COMPLETE PROJECT SUMMARY ==="
echo "Total batches: 4"
echo "Total images generated: ~90+ images"
echo "Total cost: ~$1.80"
echo "All images for 'How does it feel to be raised by wolves' video essay are complete!"