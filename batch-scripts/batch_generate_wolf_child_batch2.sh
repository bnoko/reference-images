#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video - BATCH 2
# 20 additional images from the updated script

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Ukraine map reference for map-based images
UKRAINE_MAP_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/maps/ukraine-map-reference.png"

# Marcos character reference
MARCOS_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/marcos-character-reference.png"

# Batch 2 prompts (20 new images)
BATCH2_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a map of Ukraine with location marker"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting Ukrainian villagers peering through windows with fearful expressions"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image: a child's shadow casting the silhouette of a wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an image of an adult's brain and a child's brain side-by-side. The child's brain is alive with connections and neural pathways, but the adult's brain is more contained and less active"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a teenage girl with wild hair in sparse room"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a representation of not being able to speak with a zip where the lips would be"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting words floating away from a mouth, dissolving into wild animal sounds of a wolf or dog"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting three panels: wolf sniffing, wolf in alert posture, wolf howling"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a split image: human covering ears in distress, wolf howling with purpose"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image of a child being pulled between two worlds - forest and civilization"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a dog in a village being admonished by its owner"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of a fork clumsily being gripped by small hands"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a doorstep of a small village house showing rough leather boots on the doorstep"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a mouth opened as if to speak, but caught paralysed"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image: a cage labeled 'salvation'"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult happily play wrestling with a wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a metaphorical image: civilization's structures crushing natural bonds"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child reaching toward the forest while adults pull them toward buildings"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the character reference image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a map showing Spain, including its mountains"
)

# Special handling for images that need specific references
SPECIAL_REF_INDICES=(0 18 19)  # Ukraine map, Marcos character, Spain map

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=()

echo "Starting batch 2 generation of 20 additional images for 'How does it feel to be raised by wolves'"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!BATCH2_PROMPTS[@]}"; do
  # Determine which references to use
  if [[ " ${SPECIAL_REF_INDICES[@]} " =~ " ${i} " ]]; then
    case $i in
      0)  # Ukraine map
        IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$UKRAINE_MAP_REF")
        ;;
      18) # Marcos character
        IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$MARCOS_REF")
        ;;
      19) # Spain map (using Ukraine map style)
        IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$UKRAINE_MAP_REF")
        ;;
    esac
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
        \"prompt\": \"${BATCH2_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS_JSON,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  DESCRIPTIONS+=("batch2_$(printf "%02d" $((i+1)))")
  echo "Task $((i+1))/20 submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "All 20 batch 2 tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.40 (20 × $0.02)"
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

  echo "Progress: $COMPLETED/20 completed"
  sleep 10
done

echo ""
echo "🎉 Batch 2 complete! All images saved to: $SAVE_DIR"
echo "Cost: $0.40 total"