#!/bin/bash

# Batch generation for symbolic/abstract drowning concepts
# Alternative approach using concepts that work better with AI
# Avoiding complex water scenes in favor of symbolic representations

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Boat reference for style consistency
BOAT_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/man-on-boat-reference.png"

# 30 symbolic/abstract alternatives that should work much better
SYMBOLIC_PROMPTS=(
  # Abstract concepts for panic and loss of control
  "In the exact style of the reference image: a lino-cut black and white engraving of dark geometric patterns spiraling inward, representing mounting panic and loss of control"
  "In the exact style of the reference image: a lino-cut black and white engraving of concentric circles breaking apart, symbolizing disintegration of consciousness"
  "In the exact style of the reference image: a lino-cut black and white engraving of fragmenting shapes scattering across the frame, representing mind breaking down"
  "In the exact style of the reference image: a lino-cut black and white engraving of hands reaching desperately toward bright light above, universal symbol of distress"
  "In the exact style of the reference image: a lino-cut black and white engraving of clock faces with hands spinning wildly, representing time running out"

  # Close-up details that work well
  "In the exact style of the reference image: a lino-cut black and white engraving of extreme close-up of panicked eyes, wide with terror"
  "In the exact style of the reference image: a lino-cut black and white engraving of hands gripping desperately, knuckles white with strain"
  "In the exact style of the reference image: a lino-cut black and white engraving of hands slowly releasing their grip, losing control"
  "In the exact style of the reference image: a lino-cut black and white engraving of a face in stark dramatic lighting, expression of pure fear"
  "In the exact style of the reference image: a lino-cut black and white engraving of lips gasping for air, mouth open in desperation"

  # Environmental metaphors (land-based)
  "In the exact style of the reference image: a lino-cut black and white engraving of a figure falling through dark storm clouds toward earth"
  "In the exact style of the reference image: a lino-cut black and white engraving of someone being buried under heavy sand, weight pulling them down"
  "In the exact style of the reference image: a lino-cut black and white engraving of a mountain climber losing grip, falling into abyss"
  "In the exact style of the reference image: a lino-cut black and white engraving of forest growing darker and more oppressive, consciousness fading"
  "In the exact style of the reference image: a lino-cut black and white engraving of gathering storm clouds, approaching inevitable danger"

  # Architectural/mechanical metaphors
  "In the exact style of the reference image: a lino-cut black and white engraving of massive gears grinding to a halt, systems failing"
  "In the exact style of the reference image: a lino-cut black and white engraving of a bridge collapsing in dramatic fashion, loss of support"
  "In the exact style of the reference image: a lino-cut black and white engraving of lightbulbs dimming one by one, consciousness fading away"
  "In the exact style of the reference image: a lino-cut black and white engraving of heavy doors slamming shut with force, throat closing"
  "In the exact style of the reference image: a lino-cut black and white engraving of chains binding a human figure, biological responses taking over"

  # Silhouettes and shadows
  "In the exact style of the reference image: a lino-cut black and white engraving of dramatic black silhouette against white background, figure in distress"
  "In the exact style of the reference image: a lino-cut black and white engraving of shadow figure reaching upward in desperation"
  "In the exact style of the reference image: a lino-cut black and white engraving of negative space composition, emptiness representing loss"
  "In the exact style of the reference image: a lino-cut black and white engraving of silhouettes of people walking away, isolation and abandonment"
  "In the exact style of the reference image: a lino-cut black and white engraving of shadow gradually consuming a human figure"

  # Biological/medical that should work better
  "In the exact style of the reference image: a lino-cut black and white engraving of simplified lungs diagram with clear airways blocked"
  "In the exact style of the reference image: a lino-cut black and white engraving of heart monitor line going from normal rhythm to flatline"
  "In the exact style of the reference image: a lino-cut black and white engraving of brain neurons firing chaotically then going dark"
  "In the exact style of the reference image: a lino-cut black and white engraving of hourglass with sand running out rapidly"
  "In the exact style of the reference image: a lino-cut black and white engraving of scales tipping from balance to chaos, survival vs death"
)

# Descriptive filenames
FILENAMES=(
  "symbolic_spiral_panic_patterns"
  "symbolic_concentric_circles_breaking"
  "symbolic_fragmenting_consciousness"
  "symbolic_hands_reaching_light"
  "symbolic_spinning_clock_time"
  "closeup_panicked_eyes_terror"
  "closeup_gripping_hands_desperate"
  "closeup_releasing_hands_control"
  "closeup_face_dramatic_fear"
  "closeup_gasping_lips_air"
  "metaphor_falling_storm_clouds"
  "metaphor_buried_heavy_sand"
  "metaphor_mountain_climber_falling"
  "metaphor_forest_growing_darker"
  "metaphor_gathering_storm_danger"
  "mechanical_gears_grinding_halt"
  "mechanical_bridge_collapsing"
  "mechanical_lightbulbs_dimming"
  "mechanical_doors_slamming_shut"
  "mechanical_chains_binding_figure"
  "silhouette_black_white_distress"
  "silhouette_shadow_reaching_upward"
  "silhouette_negative_space_loss"
  "silhouette_people_walking_away"
  "silhouette_shadow_consuming_figure"
  "biological_lungs_airways_blocked"
  "biological_heart_monitor_flatline"
  "biological_brain_neurons_dark"
  "biological_hourglass_sand_running"
  "biological_scales_survival_death"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting symbolic/abstract drowning alternatives!"
echo "Generating 30 symbolic concepts that should work much better than literal water scenes"
echo "Save directory: $SAVE_DIR"
echo "Total cost: $0.60 (30 × $0.02)"
echo ""

# Submit all 30 tasks
for i in "${!SYMBOLIC_PROMPTS[@]}"; do
  # Use boat reference for style consistency
  IMAGE_URLS="[\"$BOAT_REF\"]"

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${SYMBOLIC_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/30 submitted: $TASK_ID - ${FILENAMES[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 30 symbolic alternative tasks submitted! Now monitoring for completion..."
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

  echo "Progress: $COMPLETED/30 completed ($(( COMPLETED * 100 / 30 ))%)"
  sleep 10
done

echo ""
echo "🎉 SYMBOLIC ALTERNATIVES COMPLETE! 🎉"
echo "All symbolic images saved to: $SAVE_DIR"
echo "Cost: $0.60 total"
echo ""
echo "=== ALTERNATIVE APPROACH SUCCESS ==="
echo "✅ 30 symbolic/abstract concepts for drowning themes"
echo "✅ Avoiding problematic water scenes entirely"
echo "✅ Using concepts that work well with AI generation"
echo "✅ Ready to replace difficult scenes in main video!"
echo ""
echo "🎨 Much more reliable than literal water scenes!"