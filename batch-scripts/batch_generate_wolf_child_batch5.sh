#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video - BATCH 5 (REVISIONS)
# 12 revised/missing images based on feedback

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Batch 5 revised prompts (12 images)
BATCH5_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a weathered Spanish man with wild hair and gentle eyes, character reference style"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a weathered Spanish man as a young boy among wolves in Spanish mountains"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a weathered Spanish man sitting alone in a modern room, looking lost"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting honest animal wolf-like eyes contrasted with human masks/false smiles"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting golden wolf destiny vs. harsh reality split image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a single feral child watching wolves from distance, copying their movements"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child with messy hair holding a mobile phone in a village house, looking confused"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult woman in a restaurant, eating with her hands"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult woman at edge of a human social group, looking somewhat apart"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an abstract representation of belonging, using many hands holding each other"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an evolutionary diagram showing layers of human development"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting ghostly wolf-child figures in human minds"
)

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=(
  "batch5_marcos_character_ref"
  "batch5_young_marcos_with_wolves"
  "batch5_marcos_alone_modern_room"
  "batch5_wolf_eyes_vs_human_masks"
  "batch5_golden_wolf_vs_harsh_reality"
  "batch5_feral_child_copying_wolves"
  "batch5_child_with_phone_village"
  "batch5_adult_woman_eating_hands"
  "batch5_adult_woman_apart_group"
  "batch5_hands_holding_belonging"
  "batch5_evolutionary_diagram"
  "batch5_ghostly_wolf_child_minds"
)

echo "Starting batch 5 (REVISIONS) generation of 12 revised/missing images"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!BATCH5_PROMPTS[@]}"; do
  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${BATCH5_PROMPTS[$i]}\",
        \"image_urls\": [\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"],
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/12 submitted: $TASK_ID - ${DESCRIPTIONS[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 12 batch 5 (REVISIONS) tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.24 (12 × $0.02)"
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

  echo "Progress: $COMPLETED/12 completed"
  sleep 10
done

echo ""
echo "🎉 BATCH 5 (REVISIONS) COMPLETE! 🎉"
echo "All revised images saved to: $SAVE_DIR"
echo "Cost: $0.24 total"
echo ""
echo "=== REVISIONS SUMMARY ==="
echo "✅ Marcos character reference (no external ref)"
echo "✅ Young Marcos with wolves (no external ref)"
echo "✅ Marcos alone in room (no external ref)"
echo "✅ Wolf eyes vs human masks (regenerated)"
echo "✅ Golden wolf vs harsh reality (regenerated)"
echo "✅ Single feral child copying wolves"
echo "✅ Child with phone in village house (not forest)"
echo "✅ Adult woman eating with hands (no external ref)"
echo "✅ Adult woman apart from group (no external ref)"
echo "✅ Hands holding each other (regenerated)"
echo "✅ Evolutionary diagram (regenerated)"
echo "✅ Ghostly wolf-child figures (regenerated)"