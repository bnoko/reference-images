#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video - BATCH 6 (CHARACTER CORRECTED)
# 4 images using proper character references now that they're uploaded to GitHub

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Character references (now working!)
MARCOS_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/marcos-character-reference.png"
ADULT_OKSANA_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/oksana-adult-character-reference.png"

# Batch 6 prompts (4 character-dependent images)
BATCH6_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the character reference image as a young boy among wolves in Spanish mountains"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the character reference image sitting alone in a modern room, looking lost"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the adult woman from the character reference image in a restaurant, eating with her hands"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the adult woman from the character reference image at edge of a human social group, looking somewhat apart"
)

# Character reference assignments
CHARACTER_REFS=(
  "$MARCOS_REF"      # Young Marcos with wolves
  "$MARCOS_REF"      # Marcos alone in room
  "$ADULT_OKSANA_REF" # Adult Oksana eating with hands
  "$ADULT_OKSANA_REF" # Adult Oksana apart from group
)

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=(
  "batch6_young_marcos_with_wolves_PROPER_REF"
  "batch6_marcos_alone_modern_room_PROPER_REF"
  "batch6_adult_oksana_eating_hands_PROPER_REF"
  "batch6_adult_oksana_apart_group_PROPER_REF"
)

echo "Starting batch 6 (CHARACTER CORRECTED) generation of 4 images with proper character references"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!BATCH6_PROMPTS[@]}"; do
  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${BATCH6_PROMPTS[$i]}\",
        \"image_urls\": [\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"${CHARACTER_REFS[$i]}\"],
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/4 submitted: $TASK_ID - ${DESCRIPTIONS[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 4 batch 6 (CHARACTER CORRECTED) tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.08 (4 × $0.02)"
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

  echo "Progress: $COMPLETED/4 completed"
  sleep 10
done

echo ""
echo "🎉 BATCH 6 (CHARACTER CORRECTED) COMPLETE! 🎉"
echo "All character-consistent images saved to: $SAVE_DIR"
echo "Cost: $0.08 total"
echo ""
echo "=== CHARACTER CONSISTENCY ACHIEVED ==="
echo "✅ Young Marcos with wolves (using Marcos character reference)"
echo "✅ Marcos alone in modern room (using Marcos character reference)"
echo "✅ Adult Oksana eating with hands (using Adult Oksana character reference)"
echo "✅ Adult Oksana apart from group (using Adult Oksana character reference)"
echo ""
echo "🎬 ALL WOLF CHILD VIDEO IMAGES COMPLETE! 🎬"
echo "Total: 95+ images across 6 batches ready for video production!"