#!/bin/bash

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Define your improved story prompts
PROMPTS=(
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting a child crouched in the dirt on their haunches, animal-like posture"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of the child's eyes looking wild with the silhouette of a wolf reflected in one of the retinas"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of the child's mouth in a snarl"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting adult hands outstretched in an offer of safety"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's hand lashing out, showing motion and defiance"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's bare feet standing in earth"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a small single bed in a small lonely empty room"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wide open landscape with forests and the moon"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting a hand clutching a fistful of earth"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a stylized map outline of Ukraine"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting the child happily scampering on all fours alongside several dogs"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an adult outside their small house in a Ukrainian village looking concerned"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting a doctor and nurse in a Ukrainian town looking concerned while in the background the child sits on a hospital bed"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of the child's mouth poised to speak"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting the child holding their hand against a mirror looking at their own reflection"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting two wolf pups playing with each other"
  "In the exact style of the reference images, featuring the child character from the reference: a lino-cut black and white engraving with bold lines and high contrast, depicting the child looking scruffy and unkempt as a wolf child"
)

# Reference images - style + character
REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/oksana-character-reference.png"
)

# For map scene, we'll use the map reference instead of character
MAP_REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/maps/ukraine-map-reference.png"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting batch generation of ${#PROMPTS[@]} Oksana story images..."
echo "Save directory: $SAVE_DIR"

# 1. Submit all tasks (single loop, no individual approvals)
for i in "${!PROMPTS[@]}"; do
  # Use map references for prompt #10 (Ukraine map), character+style for others
  if [ $i -eq 9 ]; then  # 0-indexed, so prompt 10 is index 9
    REFS="[\"${MAP_REF_IMAGES[0]}\", \"${MAP_REF_IMAGES[1]}\", \"${MAP_REF_IMAGES[2]}\"]"
  else
    REFS="[\"${REF_IMAGES[0]}\", \"${REF_IMAGES[1]}\", \"${REF_IMAGES[2]}\"]"
  fi

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${PROMPTS[$i]}\",
        \"image_urls\": $REFS,
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
      FILENAME="oksana_story_$(printf "%02d" $((i+1))).png"
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

echo "🎉 Oksana story batch complete! All images in: $SAVE_DIR"