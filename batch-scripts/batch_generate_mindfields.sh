#!/bin/bash

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Define your prompts array
PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a shadowy figure of a child crouched low in the dirt, body positioned on all fours, hair tangled, eyes glinting faintly in the darkness"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of a snarling human mouth, lips pulled back to reveal bared teeth, caught mid-growl, animalistic yet unmistakably human"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a pair of bare feet pressed into rough earth, hardened and dirty, toes gripping the soil with instinctive tension"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a bed in a dimly lit room, sheets neatly tucked but empty, beside it the ground is marked with disturbed dirt and footprints"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting outstretched adult hands reaching forward, open and welcoming, surrounded by darkness that feels invasive rather than safe"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a symbolic image of heavy shoes being pushed onto small bare feet, the leather stiff"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lone child's silhouette against the open earth, back arched like an animal, poised to flee"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of tangled, matted strands of hair obscuring sharp, watchful eyes peering through"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's hand curled into the dirt, fingernails clawing into soil as if anchoring to the ground"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a wide view of a dark, empty forest clearing, the atmosphere tense as though hiding something feral within it"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a close-up of an ear, alert and pricked toward sound, emphasizing animal-like vigilance"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a child's silhouette framed against a doorway, half lit by warm interior light, half swallowed by the wild darkness outside"
)

# Reference images to use (your new correct URLs)
REF_IMAGES=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting batch generation of ${#PROMPTS[@]} images..."
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
      FILENAME="mindfields_$(printf "%02d" $((i+1))).png"
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

echo "🎉 Batch complete! All images in: $SAVE_DIR"