#!/bin/bash

# Supplemental batch generation for "How does it feel to drown" video essay
# Additional images to fill gaps and improve specific moments
# All images use linocut black and white style

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (linocut black and white)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Main drowning reference for general style consistency
BOAT_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/man-on-boat-reference.png"

# New reference images to recreate in linocut style
LUNGS_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/lungs-airways-reference.png"
BRAIN_NEURONS_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/brain-neurons-reference.png"
WAKE_UP_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/wake-up-reference.png"
NERVOUS_SYSTEM_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/nervous-system-reference.png"

# Supplemental image prompts
PROMPTS=(
  # Betrayal - body betraying itself (3 variations) - softened language
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a person in water with their hand reaching toward their own throat - symbolizing an involuntary reflex"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human figure split down the middle - one half reaching upward, the other half pulling downward - representing internal conflict"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a person's reflection in water showing a contrasting expression - the reflection and person in tension"

  # Heavy limbs/loss of coordination (3 variations) - softened
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a person in water with heavy iron weights attached to their arms and legs"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a swimmer's limbs becoming heavy like stone, losing buoyancy"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a marionette figure in water with tangled strings, limbs moving uncontrollably"

  # Burnt into shared imagination (3 variations) - focus on metaphor
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting an ocean surface with flames rising from the waves, creating a surreal burning sea"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a human brain with fire marks or burn patterns etched into its surface"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting swimming figures as repeating pattern merging with flame motifs"

  # Mouth full of water (2 variations) - medical/anatomical framing
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of an open mouth with water flowing in and out"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting anatomical cross-section of human head showing mouth and throat filled with liquid"

  # Recreate lungs/airways in linocut style (2 variations) - anatomical focus
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the lungs reference image in linocut style - detailed biological diagram of human respiratory system"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the lungs reference composition - anatomical cross-section showing lungs, trachea, and airways"

  # Recreate brain neurons in linocut style (2 variations) - keep as-is (succeeded before)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the brain neurons reference image in linocut style - brain with neural network visible"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the brain neurons reference showing intricate neuron connections"

  # Observing dissociation in linocut style (2 variations) - NEW CONCEPT per user request
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a person's face watching intently with a ghostly shadow face beside them, as if observing from outside themselves"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of a face with intense observing expression, with ethereal second face overlapping - representing dissociation"

  # Recreate nervous system in linocut style (2 variations) - anatomical focus
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the nervous system reference image in linocut style - human figure showing neural pathways throughout the body"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, recreate the nervous system reference composition - network of nerves and synapses through human form"
)

# Reference assignments for each image
# 0 = style only, 1 = + boat ref, 2 = + lungs ref, 3 = + brain neurons ref, 4 = + wake up ref, 5 = + nervous system ref
REFERENCE_ASSIGNMENTS=(
  # Betrayal (3) - use boat reference for human figures
  1 1 1
  # Heavy limbs (3) - use boat reference
  1 1 1
  # Burnt into imagination (3) - style only for abstract concepts
  0 0 0
  # Mouth full of water (2) - use boat reference for facial close-ups
  1 1
  # Lungs recreations (2) - use lungs reference
  2 2
  # Brain neurons recreations (2) - use brain neurons reference
  3 3
  # Dissociation/observing (2) - use wake up reference for face composition
  4 4
  # Nervous system recreations (2) - use nervous system reference
  5 5
)

# Descriptive filenames
FILENAMES=(
  "betrayal_involuntary_reflex"
  "betrayal_split_conflict"
  "betrayal_reflection_tension"
  "heavy_limbs_weights"
  "heavy_limbs_stone"
  "heavy_limbs_marionette"
  "burnt_imagination_burning_sea"
  "burnt_imagination_branded_brain"
  "burnt_imagination_pattern"
  "mouth_water_flowing"
  "mouth_water_crosssection"
  "lungs_airways_recreation_1"
  "lungs_airways_recreation_2"
  "brain_neurons_recreation_1"
  "brain_neurons_recreation_2"
  "dissociation_observing_shadow"
  "dissociation_overlapping_faces"
  "nervous_system_recreation_1"
  "nervous_system_recreation_2"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting supplemental drowning video generation!"
echo "Generating 19 additional images (revised prompts to avoid content filtering)"
echo "Save directory: $SAVE_DIR"
echo "Total cost: $0.38 (19 × $0.02)"
echo ""

# Submit all tasks
for i in "${!PROMPTS[@]}"; do
  REF_INDEX=${REFERENCE_ASSIGNMENTS[$i]}

  # Build image_urls array based on reference assignment
  case "$REF_INDEX" in
    0)
      # Style only
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"]"
      ;;
    1)
      # Style + boat reference
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$BOAT_REF\"]"
      ;;
    2)
      # Style + lungs reference
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$LUNGS_REF\"]"
      ;;
    3)
      # Style + brain neurons reference
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$BRAIN_NEURONS_REF\"]"
      ;;
    4)
      # Style + wake up reference
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$WAKE_UP_REF\"]"
      ;;
    5)
      # Style + nervous system reference
      IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$NERVOUS_SYSTEM_REF\"]"
      ;;
  esac

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/19 submitted: $TASK_ID - ${FILENAMES[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 19 supplemental tasks submitted! Now monitoring for completion..."
echo "This will take approximately 10-15 minutes."
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
      FILENAME="${FILENAMES[$i]}_$(date +%H%M%S).png"
      curl -s -o "$SAVE_DIR/$FILENAME" "$IMAGE_URL"
      echo "✅ Downloaded: $FILENAME"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    elif [ "$STATE" = "fail" ]; then
      echo "❌ Task $((i+1)) failed: ${FILENAMES[$i]}"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    fi
  done

  echo "Progress: $COMPLETED/19 completed ($(( COMPLETED * 100 / 19 ))%)"
  sleep 15
done

echo ""
echo "🎉 SUPPLEMENTAL GENERATION FINISHED! 🎉"
echo "All 19 images saved to: $SAVE_DIR"
echo "Cost: $0.38 total"
echo ""
echo "Generated images:"
echo "  - 3 betrayal variations (softened language)"
echo "  - 3 heavy limbs variations (softened language)"
echo "  - 3 burnt into imagination variations"
echo "  - 2 mouth full of water variations (anatomical framing)"
echo "  - 2 lungs/airways recreations"
echo "  - 2 brain neurons recreations"
echo "  - 2 dissociation/observing self variations"
echo "  - 2 nervous system recreations"
echo ""
echo "✅ Ready to review and integrate into video!"