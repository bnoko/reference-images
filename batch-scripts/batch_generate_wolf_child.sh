#!/bin/bash

# Batch generation for "How does it feel to be raised by wolves" video
# 19 total images: 12 standalone + 7 with Oksana character reference

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (mix light and dark)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Character reference for Oksana
OKSANA_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/oksana-character-reference.png"

# Standalone prompts (no character reference)
STANDALONE_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close up of a wolf barking"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wolf with ears pricked"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting wolves sleeping close together for warmth"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting wolves running together"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close up of wolf breath visible on a cold night"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an old television set showing an alpha wolf fighting a beta wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting two adults wolves protectively watching two wolf pups play"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult wolf bringing food to a young wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a biological diagram of a wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult in a Ukrainian village looking with bitterness at another adult"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human brain alive with connections and activity"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child (not Oksana) happily being looked after by his parents"
)

# Oksana character prompts (with character reference)
OKSANA_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the young girl from the character reference image with hand on mirror, reflection is a wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the young girl from the character reference image in a forest being watched over by a protective wolf god"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the young girl from the character reference image sitting on the forest floor playing with a stick, a wolf watching her with gentle curiosity"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the young girl from the character reference image as if howling like a wolf"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting wolves playing, the young girl from the character reference image kneeling on the floor amongst them, but not part of the game"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the young girl from the character reference image in a forest, watching a wolf pack from the shadows"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close up of the young girl from the character reference image as a wolf child, looking ragged but with an intensity in her eyes"
)

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=()

echo "Starting batch generation of 19 images for 'How does it feel to be raised by wolves'"
echo "Save directory: $SAVE_DIR"
echo ""

# 1. Submit standalone tasks
echo "Submitting 12 standalone images..."
for i in "${!STANDALONE_PROMPTS[@]}"; do
  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${STANDALONE_PROMPTS[$i]}\",
        \"image_urls\": [\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"],
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  DESCRIPTIONS+=("standalone_$(printf "%02d" $((i+1)))")
  echo "Task $((i+1))/14 submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "Submitting 7 Oksana character images..."

# 2. Submit Oksana character tasks
for i in "${!OKSANA_PROMPTS[@]}"; do
  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${OKSANA_PROMPTS[$i]}\",
        \"image_urls\": [\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$OKSANA_REF\"],
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  DESCRIPTIONS+=("oksana_$(printf "%02d" $((i+1)))")
  echo "Task $((i+13))/19 submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "All 19 tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.38 (19 × $0.02)"
echo ""

# 3. Monitor all tasks and download when complete
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

  echo "Progress: $COMPLETED/19 completed"
  sleep 10
done

echo ""
echo "🎉 Batch complete! All images saved to: $SAVE_DIR"
echo "Cost: $0.38 total"