#!/bin/bash

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Define your prompts array
PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a pair of adult wolves standing watch at the edge of a den, while pups tumble and play nearby"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human hand reaching into a circle of wolves, the animals neither attacking nor fleeing, but holding their ground"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of two wolves nuzzling each other, fur intermingling in quiet contact"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's silhouette walking in step with a line of wolves across a barren field, blending into the rhythm of the group"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a young adult sitting alone on a narrow bed in a small bare room, posture hunched, eyes distant"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of lips slightly parted as if to speak, but the sound caught halfway between word and growl"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wolf's shadow cast across the wall of a sterile room, with no wolf present"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a figure sitting at a dining table surrounded by empty chairs, untouched utensils laid out before them"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone person standing outside the gates of a village, the figures inside gathered together but turned away"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a cracked mirror reflecting only half of a face, the other half fading into shadow"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone wolf in the distance on a ridge, watching a human settlement from afar"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting rows of shoes lined neatly in a hallway, with a single pair left empty and abandoned"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a figure sitting in a chair under a harsh overhead light, surrounded by deep shadows pressing in"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human silhouette divided down the middle: one side smooth and formal, the other side wild and disheveled"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a childlike figure standing in a schoolroom with chalkboards and desks, utterly alone in the empty space"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wolf lying close beside a human figure, both staring outward into the same darkness"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a person walking along a deserted city street at night, head lowered, lit only by a solitary streetlamp"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a blurred reflection in a puddle showing half a human face and half a wolf's muzzle"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone figure at the edge of a forest, facing toward the trees while behind them stretches an empty human road"
)

# Reference images to use
REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting batch generation of ${#PROMPTS[@]} isolation-themed images..."
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
      FILENAME="isolation_$(printf "%02d" $((i+1))).png"
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

echo "🎉 Isolation batch complete! All images in: $SAVE_DIR"