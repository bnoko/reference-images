#!/bin/bash

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Define your prompts array
PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting multiple human figures in silhouette, faceless or indistinct, to represent what makes us human"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting images of mouths, ears, and gestures emphasizing communication and presence"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting hands reaching toward each other, sometimes failing to connect"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting empty cityscapes, broken columns, or deserted classrooms as symbols of fragile civilization"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting contrast between open wilderness and closed human structures"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone figure framed as strange among a group, set apart by posture or shadow"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the wolf as a recurring archetype: loyal, raw, enduring"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting hybrid imagery: shadows merging wolf and human, footprints crossing paths, faces blurred between the two"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting breath in cold air, bodies pressed close, primal survival cues"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting fragile objects: cracked glass, frayed thread, with a child's silhouette behind them"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a bird's nest fallen from a tree, abandoned and empty"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting open hands holding nothing, suggesting absence rather than possession"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human figure standing at a threshold—doorway, treeline, or cliff edge—caught between two worlds"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting wolves disappearing into mist, while a lone human remains"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a circle of light illuminating only part of a figure, the rest obscured"
)

# Reference images to use
REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting batch generation of ${#PROMPTS[@]} humanity-themed images..."
echo "Save directory: $SAVE_DIR"

# 1. Submit all tasks (single loop, no individual approvals)
for i in "${!PROMPTS[@]}"; do
  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${PROMPTS[$i]}\",
        \"image_urls\": [\"${REF_IMAGES[0]}\", \"${REF_IMAGES[1]}\"],
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/${#PROMPTS[@]} submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo "All tasks submitted! Now monitoring for completion..."

# 2. Monitor all tasks and download when complete
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
      FILENAME="humanity_$(printf "%02d" $((i+1))).png"
      curl -s -o "$SAVE_DIR/$FILENAME" "$IMAGE_URL"
      echo "✅ Downloaded: $FILENAME"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    elif [ "$STATE" = "fail" ]; then
      echo "❌ Task $((i+1)) failed"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    fi
  done

  echo "Progress: $COMPLETED/${#PROMPTS[@]} completed"
  sleep 10
done

echo "🎉 Humanity batch complete! All images in: $SAVE_DIR"