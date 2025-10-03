#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video - BATCH 3
# 17 images from Marcos story through Romanian orphanages section

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Marcos character reference
MARCOS_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/marcos-character-reference.png"

# Batch 3 prompts (17 images)
BATCH3_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the character reference image as a young boy among wolves in Spanish mountains"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the character reference image sitting alone in a modern room, looking lost"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting two panels: wolves looking gentle and peaceful, humans pointing/laughing"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting honest animal wolf-like eyes contrasted with human masks/false smiles"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wise and powerful, noble wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting classical Roman art style: the she-wolf nursing two infants"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting Mowgli swinging through jungle vines"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting Tarzan among apes in trees"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image: mythical wild child towering over city dwellers"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting golden wolf destiny vs. harsh reality split image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child alone sitting on the ground on a lonely street, distant figures walking away"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child watching wolves from distance, copying their movements"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a stark institutional building with barred windows"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting rows of silent children in institutional beds"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting empty hands reaching out, finding nothing"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a comparison image: institutional child and feral child, both with same hollow expression"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting two hands: one offering wolf companionship, one offering human indifference"
)

# Indices that need Marcos character reference
MARCOS_INDICES=(0 1)  # Young Marcos with wolves, Marcos alone in room

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=()

echo "Starting batch 3 generation of 17 images for 'How does it feel to be raised by wolves'"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!BATCH3_PROMPTS[@]}"; do
  # Determine which references to use
  if [[ " ${MARCOS_INDICES[@]} " =~ " ${i} " ]]; then
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$MARCOS_REF")
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
        \"prompt\": \"${BATCH3_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS_JSON,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  DESCRIPTIONS+=("batch3_$(printf "%02d" $((i+1)))")
  echo "Task $((i+1))/17 submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "All 17 batch 3 tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.34 (17 × $0.02)"
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

  echo "Progress: $COMPLETED/17 completed"
  sleep 10
done

echo ""
echo "🎉 Batch 3 complete! All images saved to: $SAVE_DIR"
echo "Cost: $0.34 total"