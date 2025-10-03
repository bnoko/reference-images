#!/bin/bash

# Mind Fields YouTube Channel - Refined Variations
# 6 total images: 3 ethereal "Mind Fields" landscapes + 3 half-shadow portrait variations

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (linocut black and white)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Byron's photo reference
BYRON_PHOTO_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/characters/Byron%20photos/Screenshot%202024-02-15%20at%2000.05.26.png"

# 3 Ethereal Mind Fields Landscapes (sophisticated, haunting, not obvious horror)
LANDSCAPE_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting ethereal fields made of neural networks and brain matter, rolling hills of consciousness with floating synapses, misty and dreamlike atmosphere, haunting but beautiful"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting surreal landscape of flowing brain tissue forming valleys and hills, ethereal mist rising from neural pathways, thoughts floating like dandelion seeds, poetic and haunting"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting vast fields of interconnected minds, neural networks stretching to horizon like wheat fields, ethereal consciousness flowing in waves, subtle and haunting psychological landscape"
)

# 3 Half-Shadow Portraits (identical prompt for variation)
PORTRAIT_PROMPT="In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the handsome young man from the character reference in a half-shadow portrait - half face in deep shadow, half illuminated, haunting effect"

# Combine prompts (3 landscapes + 3 identical portraits)
ALL_PROMPTS=(
  "${LANDSCAPE_PROMPTS[0]}"
  "${LANDSCAPE_PROMPTS[1]}"
  "${LANDSCAPE_PROMPTS[2]}"
  "$PORTRAIT_PROMPT"
  "$PORTRAIT_PROMPT"
  "$PORTRAIT_PROMPT"
)

# Array to store task IDs
TASK_IDS=()
DESCRIPTIONS=(
  "mindfields_ethereal_landscape_01_neural_fields"
  "mindfields_ethereal_landscape_02_brain_valleys"
  "mindfields_ethereal_landscape_03_consciousness_fields"
  "mindfields_portrait_half_shadow_var1"
  "mindfields_portrait_half_shadow_var2"
  "mindfields_portrait_half_shadow_var3"
)

echo "Starting Mind Fields Refined Variations generation"
echo "6 total images: 3 ethereal landscapes + 3 half-shadow portrait variations"
echo "Save directory: $SAVE_DIR"
echo ""

# Submit all tasks
for i in "${!ALL_PROMPTS[@]}"; do
  # Determine which references to use
  if [ $i -lt 3 ]; then
    # Landscape images (0-2) - style references only
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}")
  else
    # Portrait images (3-5) - use Byron's photo reference
    IMAGE_REFS=("${STYLE_REFS[0]}" "${STYLE_REFS[1]}" "$BYRON_PHOTO_REF")
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
  echo "Task $((i+1))/6 submitted: $TASK_ID - ${DESCRIPTIONS[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 6 Mind Fields refined variations submitted! Now monitoring for completion..."
echo "Total cost: $0.12 (6 × $0.02)"
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

  echo "Progress: $COMPLETED/6 completed"
  sleep 10
done

echo ""
echo "🧠✨ MIND FIELDS REFINED VARIATIONS COMPLETE! ✨🧠"
echo "All refined images saved to: $SAVE_DIR"
echo "Cost: $0.12 total"
echo ""
echo "=== REFINED MIND FIELDS SET ==="
echo "✅ 3 Ethereal 'Mind Fields' Landscapes (neural fields, brain valleys, consciousness)"
echo "✅ 3 Half-Shadow Portrait Variations (identical prompt for choice)"
echo "✅ All in sophisticated linocut black and white style"
echo "✅ Perfect for refined YouTube channel branding!"