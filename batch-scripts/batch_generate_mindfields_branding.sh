#!/bin/bash

# Mind Fields YouTube Channel Branding Generation
# 14 total images: 7 dark psychological portraits + 7 psychological landscape headers

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (linocut black and white)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Byron's photo reference (need to upload to GitHub)
BYRON_PHOTO_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/Byron%20photos/Screenshot%202024-02-15%20at%2000.05.26.png"

# PART 1: Dark Psychological Portrait Treatments (7 images with Byron's photo)
PORTRAIT_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference in a half-shadow portrait - half face in deep shadow, half illuminated, haunting effect"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference in a half-monster transformation - one side normal face, other side grotesque dark psychological manifestation"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference in a double exposure - face blended with psychological imagery like neurons, shadows, dark concepts"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference with fragmented glitch effect - face partially distorted or digitally corrupted"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference in mirror reflection horror - looking into dark mirror with sinister psychological reflection"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference as silhouette with glowing eyes - dark silhouette with piercing, intense light in eyes"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference with eyes in darkness - face mostly obscured in shadow, only intense eyes clearly visible"
)

# PART 2: Psychological Landscape Headers (7 images, no character reference)
LANDSCAPE_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting neural network pattern morphing into wolves and shadows"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting endless corridor of mirrors reflecting dark psychological concepts"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting dark forest with hidden eyes watching from the shadows"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting mind map visualization with dark, twisted psychological connections"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting floating psychological symbols in void - eyes, brains, masks, wolves, synapses"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting gothic psychological laboratory with specimen jars and dark instruments"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting surreal dreamscape of psychological fears and concepts merging"
)

# Combine all prompts
ALL_PROMPTS=("${PORTRAIT_PROMPTS[@]}" "${LANDSCAPE_PROMPTS[@]}")

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=(
  "mindfields_portrait_01_half_shadow"
  "mindfields_portrait_02_half_monster"
  "mindfields_portrait_03_double_exposure"
  "mindfields_portrait_04_fragmented_glitch"
  "mindfields_portrait_05_mirror_horror"
  "mindfields_portrait_06_silhouette_glowing_eyes"
  "mindfields_portrait_07_eyes_in_darkness"
  "mindfields_landscape_01_neural_wolves"
  "mindfields_landscape_02_mirror_corridor"
  "mindfields_landscape_03_dark_forest_eyes"
  "mindfields_landscape_04_mind_map"
  "mindfields_landscape_05_floating_symbols"
  "mindfields_landscape_06_gothic_laboratory"
  "mindfields_landscape_07_psychological_dreamscape"
)

echo "Starting Mind Fields YouTube Branding generation"
echo "14 total images: 7 dark psychological portraits + 7 psychological landscape headers"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!ALL_PROMPTS[@]}"; do
  # Determine which references to use
  if [ $i -lt 7 ]; then
    # Portrait images (0-6) - use Byron's photo reference
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$BYRON_PHOTO_REF")
  else
    # Landscape images (7-13) - style references only
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
        \"prompt\": \"${ALL_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS_JSON,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/14 submitted: $TASK_ID - ${DESCRIPTIONS[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 14 Mind Fields branding tasks submitted! Now monitoring for completion..."
echo "Total cost: $0.28 (14 × $0.02)"
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

  echo "Progress: $COMPLETED/14 completed"
  sleep 10
done

echo ""
echo "🎬🧠 MIND FIELDS BRANDING COMPLETE! 🧠🎬"
echo "All branding images saved to: $SAVE_DIR"
echo "Cost: $0.28 total"
echo ""
echo "=== MIND FIELDS BRANDING SET ==="
echo "✅ 7 Dark Psychological Portraits (using Byron's photo reference)"
echo "✅ 7 Psychological Landscape Headers"
echo "✅ All in haunting linocut black and white style"
echo "✅ Ready for YouTube channel branding!"