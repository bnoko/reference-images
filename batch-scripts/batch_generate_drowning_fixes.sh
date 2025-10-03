#!/bin/bash

# Batch generation for drowning video FIXES
# 17 problematic images × 2 approaches each = 34 total images
# Using simplified reference strategy - mainly just boat reference for consistency

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Single reference strategy - boat image has everything we need
BOAT_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/man-on-boat-reference.png"

# For non-boat scenes, use style references only
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# 34 revised prompts (2 approaches for each problematic image)
DROWNING_FIXES=(
  # 02A & 02B: Boat from medium distance
  "In the exact style of the reference image: a lino-cut black and white engraving showing a complete small sailboat on the open ocean from medium distance, entire vessel visible"
  "In the exact style of the reference image: a lino-cut black and white engraving of a wide ocean view with a sailboat centered in frame, showing full boat details"

  # 08A & 08B: Symbolic ocean betrayal (no character needed)
  "In the exact style of the reference images: a lino-cut black and white engraving depicting dark ocean waves with ominous swirling patterns, representing nature's betrayal"
  "In the exact style of the reference images: a lino-cut black and white engraving of churning seawater with abstract forms suggesting deception and danger"

  # 09A & 09B: Man going over rail
  "In the exact style of the reference image: a lino-cut black and white engraving showing a sailboat tilting over a large wave with a figure falling from the deck rail"
  "In the exact style of the reference image: a lino-cut black and white engraving of a dramatic moment - boat cresting a wave as a person loses grip on the rail"

  # 10A & 10B: Falling into water
  "In the exact style of the reference image: a lino-cut black and white engraving of a person mid-fall toward dark ocean water, arms outstretched"
  "In the exact style of the reference images: a lino-cut black and white engraving showing a figure tumbling through space toward churning sea below"

  # 12A & 12B: Dark biological script (oceanic theme)
  "In the exact style of the reference images: a lino-cut black and white engraving of DNA double helix emerging from ocean depths, representing primal biological responses"
  "In the exact style of the reference images: a lino-cut black and white engraving showing genetic code patterns flowing like underwater currents"

  # 15A & 15B: Giant fist (simplified)
  "In the exact style of the reference images: a lino-cut black and white engraving of a massive stone fist clenched tight against black background"
  "In the exact style of the reference images: a lino-cut black and white engraving showing a giant hand squeezing, with water droplets falling from between fingers"

  # 17A & 17B: Breathing apparatus (failed originally)
  "In the exact style of the reference images: a lino-cut black and white engraving of simplified human lungs and airways diagram, medical illustration style"
  "In the exact style of the reference images: a lino-cut black and white engraving showing cross-section of human respiratory system with clear airway passages"

  # 20A & 20B: Side view above/below water
  "In the exact style of the reference image: a lino-cut black and white engraving with split perspective - above waterline showing splashing, below showing submerged struggling figure"
  "In the exact style of the reference image: a lino-cut black and white engraving of cross-section ocean view with person barely visible beneath surface, waves above"

  # 22A & 22B: Legs kicking underwater with clothes
  "In the exact style of the reference images: a lino-cut black and white engraving of legs in trousers and boots kicking frantically underwater, bubbles rising"
  "In the exact style of the reference images: a lino-cut black and white engraving showing underwater view of clothed legs struggling, heavy boots weighing down"

  # 23A & 23B: Head barely above water
  "In the exact style of the reference image: a lino-cut black and white engraving of a person's head mostly submerged, only mouth and nose breaking surface, eyes wide with panic"
  "In the exact style of the reference image: a lino-cut black and white engraving showing someone's face barely above choppy water, expression of desperation"

  # 24A & 24B: Symbol of not speaking/calling for help
  "In the exact style of the reference images: a lino-cut black and white engraving of hands covering a mouth, preventing speech, water drops around"
  "In the exact style of the reference images: a lino-cut black and white engraving showing a silenced figure with X over mouth, unable to call for help"

  # 29A & 29B: Normal lifeguard scanning
  "In the exact style of the reference images: a lino-cut black and white engraving of an ordinary lifeguard in simple uniform scanning water from beach"
  "In the exact style of the reference images: a lino-cut black and white engraving showing a female lifeguard in basic lifeguard shirt watching over swimmers"

  # 32A & 32B: Three survival commands
  "In the exact style of the reference images: a lino-cut black and white engraving showing three clear symbols: lungs (breathe), kicking legs (kick), upward arrow (stay up)"
  "In the exact style of the reference images: a lino-cut black and white engraving of triptych showing: breath cloud, leg motion lines, floating figure"

  # 40A & 40B: Anatomical chest/throat diagram (failed originally)
  "In the exact style of the reference images: a lino-cut black and white engraving of simplified human chest cavity cross-section during drowning"
  "In the exact style of the reference images: a lino-cut black and white engraving showing medical diagram of throat and chest with water intrusion"

  # 44A & 44B: Man underwater convulsing (failed originally)
  "In the exact style of the reference image: a lino-cut black and white engraving of a figure completely submerged, body contorting as systems fail"
  "In the exact style of the reference image: a lino-cut black and white engraving showing person underwater in distress, multiple body systems shutting down"

  # 60A & 60B: Masses from Titanic (failed originally)
  "In the exact style of the reference images: a lino-cut black and white engraving of many people falling into icy water from a large sinking ship"
  "In the exact style of the reference images: a lino-cut black and white engraving showing crowds of figures plunging into freezing ocean from ship deck"

  # 61A & 61B: Cinematic Titanic scene (failed originally)
  "In the exact style of the reference images: a lino-cut black and white engraving of people desperately clawing at water around a massive sinking vessel"
  "In the exact style of the reference images: a lino-cut black and white engraving showing tragic scene of passengers struggling in icy water near ship"
)

# Reference assignments (which references to use for each image)
# 0 = style only, 1 = boat reference only, 2 = style refs only
REFERENCE_ASSIGNMENTS=(
  # 02A & 02B: Boat scenes - use boat ref
  1 1
  # 08A & 08B: Symbolic - style only
  0 0
  # 09A & 09B: Boat scenes - use boat ref
  1 1
  # 10A & 10B: Falling - could be style only or boat ref
  0 1
  # 12A & 12B: DNA/biological - style only
  0 0
  # 15A & 15B: Fist - style only
  0 0
  # 17A & 17B: Medical diagram - style only
  0 0
  # 20A & 20B: Water perspective - use boat ref for consistency
  1 1
  # 22A & 22B: Legs underwater - style only
  0 0
  # 23A & 23B: Head above water - use boat ref for character
  1 1
  # 24A & 24B: Not speaking symbol - style only
  0 0
  # 29A & 29B: Lifeguard - style only
  0 0
  # 32A & 32B: Three symbols - style only
  0 0
  # 40A & 40B: Anatomical - style only
  0 0
  # 44A & 44B: Underwater distress - use boat ref for character
  1 1
  # 60A & 60B: Titanic masses - style only
  0 0
  # 61A & 61B: Titanic scene - style only
  0 0
)

# Array to store task IDs
TASK_IDS=()

# Generate descriptive filenames
FILENAMES=(
  "02A_boat_medium_distance" "02B_boat_wide_ocean_view"
  "08A_dark_ocean_betrayal" "08B_churning_seawater_danger"
  "09A_boat_wave_falling_rail" "09B_boat_crest_lose_grip"
  "10A_person_falling_ocean" "10B_figure_tumbling_sea"
  "12A_DNA_ocean_depths" "12B_genetic_underwater_currents"
  "15A_stone_fist_clenched" "15B_giant_hand_water_drops"
  "17A_lungs_airways_simple" "17B_respiratory_cross_section"
  "20A_split_water_perspective" "20B_ocean_cross_section"
  "22A_legs_trousers_boots_underwater" "22B_clothed_legs_heavy_boots"
  "23A_head_mouth_nose_surface" "23B_face_choppy_water_desperation"
  "24A_hands_covering_mouth" "24B_silenced_figure_x_mouth"
  "29A_ordinary_lifeguard_uniform" "29B_female_lifeguard_basic_shirt"
  "32A_three_symbols_breathe_kick_up" "32B_triptych_breath_legs_float"
  "40A_chest_cavity_drowning" "40B_throat_chest_water_intrusion"
  "44A_submerged_body_contorting" "44B_underwater_systems_failing"
  "60A_people_falling_icy_ship" "60B_crowds_plunging_ship_deck"
  "61A_people_clawing_sinking_vessel" "61B_passengers_struggling_icy_water"
)

echo "Starting drowning video FIXES generation!"
echo "Generating 34 images (17 problems × 2 approaches each)"
echo "Save directory: $SAVE_DIR"
echo "Using simplified reference strategy - mainly boat reference only"
echo "Total cost: $0.68 (34 × $0.02)"
echo ""

# Submit all 34 tasks
for i in "${!DROWNING_FIXES[@]}"; do
  REF_TYPE=${REFERENCE_ASSIGNMENTS[$i]}

  # Build image_urls array based on reference assignment
  if [ "$REF_TYPE" -eq 0 ]; then
    # Style references only
    IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"]"
  elif [ "$REF_TYPE" -eq 1 ]; then
    # Boat reference only
    IMAGE_URLS="[\"$BOAT_REF\"]"
  fi

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${DROWNING_FIXES[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/34 submitted: $TASK_ID - ${FILENAMES[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 34 fix tasks submitted! Now monitoring for completion..."
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

  echo "Progress: $COMPLETED/34 completed ($(( COMPLETED * 100 / 34 ))%)"
  sleep 10
done

echo ""
echo "🎉 DROWNING VIDEO FIXES COMPLETE! 🎉"
echo "All fix images saved to: $SAVE_DIR"
echo "Cost: $0.68 total"
echo ""
echo "=== FIXES GENERATED ==="
echo "✅ 34 alternative images for 17 problematic scenes"
echo "✅ Using simplified reference strategy"
echo "✅ Two approaches per problem for maximum choice"
echo ""
echo "🔧 Ready to replace problematic images in main sequence!"