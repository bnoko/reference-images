#!/bin/bash

# Batch generation for "How does it feel to drown" reference images
# 5 reference types × 3 versions each = 15 total images
# These will be uploaded to GitHub for use in the main video generation

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (using existing linocut style)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Byron's photo reference (will need to be uploaded to GitHub first)
BYRON_PHOTO_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/byron-character-reference.png"

# Francesco Pia photo reference (will need to be uploaded to GitHub first)
FRANCESCO_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/francesco-pia-lifeguard.png"

# Reference image prompts (3 versions of each)
REFERENCE_PROMPTS=(
  # Byron character reference (3 versions)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the photo reference wearing a sailing jacket, character reference style portrait"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the photo reference wearing a sailing jacket, character reference style portrait"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the photo reference wearing a sailing jacket, character reference style portrait"

  # Man on boat reference (3 versions)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a man standing on a small sailboat holding the rail, looking out over the ocean"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a man standing on a small sailboat holding the rail, looking out over the ocean"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a man standing on a small sailboat holding the rail, looking out over the ocean"

  # Francesco Pia lifeguard reference (3 versions)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the lifeguard expert from the photo reference in professional context"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the lifeguard expert from the photo reference in professional context"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the lifeguard expert from the photo reference in professional context"

  # Titanic ship reference (3 versions)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the RMS Titanic ship at sea with its distinctive four smokestacks"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the RMS Titanic ship at sea with its distinctive four smokestacks"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the RMS Titanic ship at sea with its distinctive four smokestacks"

  # Baywatch lifeguard reference (3 versions)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an iconic lifeguard running across a beach in classic 1990s Baywatch style"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an iconic lifeguard running across a beach in classic 1990s Baywatch style"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an iconic lifeguard running across a beach in classic 1990s Baywatch style"
)

# Reference image assignments (which character references to use for each prompt)
REFERENCE_ASSIGNMENTS=(
  # Byron character (use Byron photo ref)
  "$BYRON_PHOTO_REF" "$BYRON_PHOTO_REF" "$BYRON_PHOTO_REF"
  # Man on boat (no character ref needed)
  "" "" ""
  # Francesco Pia (use Francesco photo ref)
  "$FRANCESCO_REF" "$FRANCESCO_REF" "$FRANCESCO_REF"
  # Titanic (no character ref needed)
  "" "" ""
  # Baywatch (no character ref needed)
  "" "" ""
)

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=(
  "ref_byron_character_v1"
  "ref_byron_character_v2"
  "ref_byron_character_v3"
  "ref_man_on_boat_v1"
  "ref_man_on_boat_v2"
  "ref_man_on_boat_v3"
  "ref_francesco_pia_v1"
  "ref_francesco_pia_v2"
  "ref_francesco_pia_v3"
  "ref_titanic_ship_v1"
  "ref_titanic_ship_v2"
  "ref_titanic_ship_v3"
  "ref_baywatch_lifeguard_v1"
  "ref_baywatch_lifeguard_v2"
  "ref_baywatch_lifeguard_v3"
)

echo "Starting reference image generation for 'How does it feel to drown' video"
echo "Generating 15 images (5 references × 3 versions each)"
echo "Save directory: $SAVE_DIR"
echo ""
echo "⚠️  IMPORTANT: Before running, ensure Byron and Francesco photos are uploaded to GitHub:"
echo "   - Byron photo → /references/characters/byron-character-reference.png"
echo "   - Francesco photo → /references/characters/francesco-pia-lifeguard.png"
echo ""

# Submit all tasks
for i in "${!REFERENCE_PROMPTS[@]}"; do
  CHAR_REF="${REFERENCE_ASSIGNMENTS[$i]}"

  # Build image_urls array based on whether character reference is needed
  if [ -n "$CHAR_REF" ]; then
    IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$CHAR_REF\"]"
  else
    IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"]"
  fi

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${REFERENCE_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/15 submitted: $TASK_ID - ${DESCRIPTIONS[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 15 reference image tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.30 (15 × $0.02)"
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

  echo "Progress: $COMPLETED/15 completed"
  sleep 10
done

echo ""
echo "🎉 REFERENCE IMAGES COMPLETE! 🎉"
echo "All 15 reference images saved to: $SAVE_DIR"
echo "Cost: $0.30 total"
echo ""
echo "=== REFERENCE IMAGES GENERATED ==="
echo "✅ Byron character reference (3 versions)"
echo "✅ Man on boat reference (3 versions)"
echo "✅ Francesco Pia lifeguard reference (3 versions)"
echo "✅ Titanic ship reference (3 versions)"
echo "✅ Baywatch lifeguard reference (3 versions)"
echo ""
echo "🔄 NEXT STEPS:"
echo "1. Review generated images and select best version of each reference"
echo "2. Upload chosen references to GitHub /references/ folders"
echo "3. Update main drowning video generation script with reference URLs"