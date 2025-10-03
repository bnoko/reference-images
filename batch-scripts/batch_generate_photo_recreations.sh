#!/bin/bash

# Batch generation for recreating reference photos in linocut style
# 38 reference photos recreated in black and white linocut engraving style
# Using boat reference as style guide for consistency

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Boat reference for style consistency
BOAT_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/man-on-boat-reference.png"

# Base URL for all reference photos
BASE_URL="https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/masses%20of%20potential%20references"

# All 38 reference photo URLs (GitHub URLs with URL encoding for spaces)
REFERENCE_PHOTOS=(
  "$BASE_URL/1000_F_219862600_x9BuqKuufw8ZKlLdCXFpc4D4mqydRFQF.jpg"
  "$BASE_URL/1000w_q95.jpg.webp"
  "$BASE_URL/1168.jpg"
  "$BASE_URL/230412121505-migrant-boat-tunisia-file-2022.jpg"
  "$BASE_URL/360_F_543405234_Jj37jHmC6b5Q3WHOHriIDdpQP50J5RGp.jpg"
  "$BASE_URL/46958828-drowning-woman-in-a-swimming-pool-concept-photo-copyspace.jpg"
  "$BASE_URL/5.jpg.webp"
  "$BASE_URL/5c8674e62730ca3f61531b80.webp"
  "$BASE_URL/6647eb58748d5acf49cc3c0505.jpg"
  "$BASE_URL/9.jpg.webp"
  "$BASE_URL/CDoNNVkWYAAKbWG.jpg"
  "$BASE_URL/Designer-jpeg-qpxpbgtrknjouge0wsrowef7ravwlf65racij22650.webp"
  "$BASE_URL/F1kAIuCWcAMR_mH.jpg-large.jpeg"
  "$BASE_URL/IMG_3423-1-1024x701-1.jpg"
  "$BASE_URL/Pants-flotation-device.jpg"
  "$BASE_URL/Screenshot%202025-09-29%20at%2021.33.18.png"
  "$BASE_URL/St%C3%B6wer_Titanic.jpg"
  "$BASE_URL/clothes-as-flotation-device.jpg"
  "$BASE_URL/coldwater.jpg"
  "$BASE_URL/drowning-man-pov-looking-sun-footage-220550944_iconl.jpeg"
  "$BASE_URL/e2b4574e3205429e8d96663ac7888633_18.jpeg.webp"
  "$BASE_URL/fbfdbcea-8aa9-4553-8cc0-380282afb8bb.png"
  "$BASE_URL/gettyimages-1298687560-640x640.jpg"
  "$BASE_URL/gettyimages-1298698446-640x640.jpg"
  "$BASE_URL/ghows-OH-70e4b348-4f51-4902-e053-0100007f445c-f14edf9e.jpeg.webp"
  "$BASE_URL/how-long-does-it-take-to-drown.jpg"
  "$BASE_URL/image1170x530cropped.jpg"
  "$BASE_URL/images.jpeg"
  "$BASE_URL/intense-fear-expression-stockcake.jpg"
  "$BASE_URL/istockphoto-2163700092-612x612.jpg"
  "$BASE_URL/istockphoto-689737688-612x612.jpg"
  "$BASE_URL/maxresdefault.jpg"
  "$BASE_URL/original.jpg"
  "$BASE_URL/sea-survival-course-1.jpg.webp"
  "$BASE_URL/titanic-sailing.jpg"
  "$BASE_URL/titanic.gif.webp"
  "$BASE_URL/titanic3.jpg.avif"
  "$BASE_URL/young-man-looking-relaxed-underwater-260nw-18974020.jpg.webp"
)

# Descriptive prompts for each photo recreation
RECREATION_PROMPTS=(
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
  "In the exact style of the reference images: a lino-cut black and white engraving recreating this image with bold lines and high contrast"
)

# Generate descriptive filenames based on photo content
FILENAMES=(
  "drowning_woman_underwater"
  "person_underwater_perspective"
  "silhouette_underwater"
  "migrant_boat_mediterranean"
  "underwater_reaching_surface"
  "woman_pool_drowning_concept"
  "underwater_scene"
  "fear_expression_closeup"
  "underwater_struggling"
  "underwater_perspective"
  "person_underwater_struggle"
  "underwater_artistic_concept"
  "underwater_reaching_up"
  "survival_training_water"
  "pants_flotation_device"
  "underwater_screenshot"
  "titanic_historical_artwork"
  "clothes_flotation_technique"
  "cold_water_survival"
  "drowning_pov_sun_perspective"
  "underwater_distress"
  "survival_technique_floating"
  "underwater_struggling_person"
  "survival_water_training"
  "drowning_survival_techniques"
  "drowning_timeline_diagram"
  "water_survival_training"
  "underwater_person"
  "intense_fear_expression"
  "underwater_reaching_surface"
  "floating_survival_technique"
  "water_survival_course"
  "ocean_survival_technique"
  "sea_survival_course"
  "titanic_ship_sailing"
  "titanic_historical_scene"
  "titanic_sinking_scene"
  "relaxed_underwater_person"
)

# Array to store task IDs
TASK_IDS=()

echo "Starting photo recreation in linocut style!"
echo "Recreating 38 reference photos as black and white engravings"
echo "Save directory: $SAVE_DIR"
echo "Total cost: $0.76 (38 × $0.02)"
echo ""

# Submit all 38 tasks
for i in "${!REFERENCE_PHOTOS[@]}"; do
  # Use boat reference for style consistency + the specific photo for content
  IMAGE_URLS="[\"$BOAT_REF\", \"${REFERENCE_PHOTOS[$i]}\"]"

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${RECREATION_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/38 submitted: $TASK_ID - ${FILENAMES[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 38 photo recreation tasks submitted! Now monitoring for completion..."
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

  echo "Progress: $COMPLETED/38 completed ($(( COMPLETED * 100 / 38 ))%)"
  sleep 10
done

echo ""
echo "🎉 PHOTO RECREATION COMPLETE! 🎉"
echo "All recreated images saved to: $SAVE_DIR"
echo "Cost: $0.76 total"
echo ""
echo "=== LINOCUT RECREATIONS READY ==="
echo "✅ 38 reference photos recreated in consistent linocut style"
echo "✅ Much better alternative to challenging water scenes"
echo "✅ Ready to use for drowning video essay!"