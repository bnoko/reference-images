#!/bin/bash

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Define your prompts array
PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone wolf standing on a ridge under a stark moon, its silhouette sharp against the night sky"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of a wolf's piercing eyes staring directly forward, intense and unblinking"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wolf curled tightly in sleep, body wrapped in its tail, resting on bare ground"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a symbolic image of a wolf and a small child sitting side by side in silence, both gazing outward into the dark"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a distant view of a pack of wolves crossing a snowy plain, their dark forms stretched in a line across the whiteness"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone wolf howling at the moon, mouth open wide, breath visible in the cold night air"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a symbolic juxtaposition: a wolf's pawprint pressed deeply into mud, beside the faint imprint of a bare human foot"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a symbolic image of a wolf's shadow stretching long across the ground, exaggerated and looming, without the wolf visible"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone wolf standing at the edge of a village boundary, poised between wilderness and human dwellings"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child nestled tightly between sleeping wolves, half-hidden by the mass of fur and limbs"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a bare human foot pressed into snow, surrounded by wolf pawprints leading in all directions"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of a wolf's muzzle pressed gently against a child's cheek, eyes closed in simple contact"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wide view of a dark forest clearing, faint outlines of wolves and a crouched child sharing the same circle of shadows"
)

# Reference images to use
REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting batch generation of ${#PROMPTS[@]} wolf images..."
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
      FILENAME="wolves_$(printf "%02d" $((i+1))).png"
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

echo "🎉 Wolf batch complete! All images in: $SAVE_DIR"