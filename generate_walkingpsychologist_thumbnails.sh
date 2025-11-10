#!/bin/bash

################################################################################
# Walking Psychologist Thumbnail Generation
# Generates 42 cinematic photorealistic thumbnails using NanoBanana
################################################################################

# Configuration
API_KEY="7d24e9bf54569abf2625f84efbe28f22"
API_ENDPOINT="https://api.kie.ai/api/v1/jobs"
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/image creation/reference-images/generated-images/walkingpsychologist-thumbnails-2025-10-17"
mkdir -p "$SAVE_DIR"

# Character reference (Byron)
CHARACTER_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/ACTIVE%20REFERENCES/byron-character-reference.png"

# Image briefs organized by set and topic
# Format: "filename|prompt"

declare -a BRIEFS=(
  # SET 1: Realistic versions
  "set1_1a|cinematic photo of the character in the reference image standing on an empty street at dusk, phone in hand, faint neon reflections on face, expression tense and lonely, natural lighting, shallow depth of field, cinematic realism, 35mm lens style"
  "set1_1b|cinematic photo of the character in the reference image standing on an empty street at dusk, phone in hand, faint neon reflections on face, expression tense and lonely, right-hand side has bold white text overlay: Rejected again., clean background behind text, cinematic composition, realistic lighting and atmosphere"

  "set1_2a|cinematic photo of the character in the reference image standing near an open fridge at night, blue-white fridge light illuminating face, expression blank or ashamed, dark kitchen, natural realism, shallow depth of field"
  "set1_2b|cinematic photo of the character in the reference image standing near an open fridge at night, blue-white fridge light illuminating face, dark kitchen, moody contrast, text overlay on right-hand side in large bold letters: Greedy pig., high-impact emotional tone, realistic cinematic lighting, clear background for text"

  "set1_3a|cinematic urban sidewalk scene, morning light, the character in the reference image walking mid-step past a blurred older person sitting on a bench in the background, expression conflicted or guilty, shallow depth, natural realism"
  "set1_3b|cinematic urban sidewalk scene, the character in the reference image walking mid-step past a blurred older person sitting on a bench, expression conflicted or guilty, soft daylight, cinematic atmosphere, bold white text overlay on right-hand side: You looked away., clean composition, emotional realism"

  "set1_4a|cinematic photo at golden hour in a quiet suburban field, the character in the reference image standing in the foreground looking regretful, young Latina female with long dark hair standing a few steps behind, distance between them, warm sunlight, long shadows, emotional realism"
  "set1_4b|cinematic sunset photo, the character in the reference image in foreground looking regretful, young Latina female with long dark hair behind him, golden light, warm cinematic tones, bold text overlay on right-hand side: I broke her first., realistic composition, clear area for text overlay"

  "set1_5a|cinematic night photo of the character in the reference image leaning slightly toward an open refrigerator, blue-white fridge light reflecting on face, dark kitchen, expression lost or restless, cinematic realism, shallow depth of field"
  "set1_5b|cinematic night photo of the character in the reference image leaning toward an open fridge, blue-white glow, dim kitchen, bold white text overlay on right-hand side: Still empty., cinematic tone, clean area for text"

  "set1_6a|cinematic domestic evening scene, warm lamplight, the character in the reference image sitting on sofa edge facing slightly away from a blurred female figure in background, tension in posture, natural light, shallow depth of field, cinematic realism"
  "set1_6b|cinematic domestic evening scene, the character in the reference image sitting on sofa edge facing slightly away from blurred female figure in background, tension visible, text overlay on right-hand side: I can't stand you., cinematic composition, emotional realism, realistic grain and light"

  "set1_7a|cinematic overcast forest path, the character in the reference image walking a few steps behind a young Latina female with long dark hair, subtle envy or longing in expression, muted tones, natural lighting, cinematic realism"
  "set1_7b|cinematic overcast forest path, the character in the reference image walking behind a young Latina female with long dark hair, visible distance between them, soft natural light, text overlay on right-hand side in bold font: She always got more., muted cinematic tone, soft background for legibility"

  # SET 2: Surreal metaphorical versions
  "set2_1a|cinematic photo of the character in the reference image walking alone through a foggy street at dusk, faint glowing phone screens floating around him like ghosts of past matches, blue-pink reflections on his face, expression hollow, surreal realism, shallow depth, cinematic tone"
  "set2_1b|cinematic foggy street at dusk, the character in the reference image surrounded by faint glowing phone screens floating in air, blue-pink reflections, expression hollow, right-hand side bold white text overlay: Rejected again., eerie but realistic, cinematic balance of fog and light"

  "set2_2a|cinematic kitchen at night, fridge door half-open, the character in the reference image staring at his reflection faintly visible on the metal surface, face lit by blue-white glow, subtle surreal repetition of food items around him like a loop, shallow depth of field"
  "set2_2b|cinematic night kitchen, blue-white glow, the character in the reference image staring at his faint reflection in the fridge, background subtly repeating shelves of food, bold white text overlay: Greedy pig., dramatic emotional tone, cinematic lighting with soft fog for contrast"

  "set2_3a|cinematic urban street at dawn, the character in the reference image walking past a figure sitting on a bench whose face is revealed to be his own, subtle surreal reflection, golden early light and long shadows, emotional realism, symbolic composition"
  "set2_3b|cinematic dawn street scene, the character in the reference image walking past a blurred older version of himself sitting on a bench, golden light, faint fog, bold text overlay on right-hand side: You looked away., moody realism, clear space for text"

  "set2_4a|cinematic wide shot at sunset in an open field, the character in the reference image facing a young Latina female with long dark hair, but her outline slightly blurred and fading as if dissolving into light, warm tones, emotional surrealism, cinematic lens depth"
  "set2_4b|cinematic sunset field, the character in the reference image in foreground reaching slightly toward fading silhouette of young Latina female with long dark hair, golden haze, bold white text overlay: I broke her first., cinematic realism meets dreamlike tone"

  "set2_5a|cinematic night kitchen, fridge open, the character in the reference image staring into it while identical copies of him stand frozen in the background in slightly different poses, dim blue light, surreal repetition effect, shallow depth, cinematic realism"
  "set2_5b|cinematic night kitchen scene, multiple ghostly versions of the character in the reference image frozen around the open fridge, blue-white glow, text overlay in large bold white font: Still empty., moody atmospheric realism, clear composition"

  "set2_6a|cinematic interior scene split by light — one side warm, one cold, the character in the reference image on the darker side staring at blurred female figure on the warm side, faint visible crack in wall between them, emotional symbolism, cinematic depth"
  "set2_6b|cinematic domestic split-light scene, the character in the reference image on dark side of room, blurred female figure on warm-lit side, visible crack or dividing line, bold white text overlay: I can't stand you., tense atmosphere, realistic but stylized lighting"

  "set2_7a|cinematic forest path in soft rain, the character in the reference image walking behind a young Latina female with long dark hair, but his shadow is much larger and darker than hers, stretching ahead of her on the path, muted tones, natural fog, cinematic symbolism"
  "set2_7b|cinematic rainy forest path, the character in the reference image walking behind a young Latina female with long dark hair, exaggerated shadow on ground overtaking hers, muted green-grey palette, bold text overlay: She always got more., emotional cinematic tone, clean composition for text"

  # SET 3: More metaphorical versions
  "set3_1a|cinematic photo of the character in the reference image standing still in a dark room surrounded by floating translucent phone screens forming a slow circle around him, each showing blurred faces fading in and out, faint red glow, expression exhausted, photorealistic lighting and atmosphere, surreal cinematic tone"
  "set3_1b|cinematic photo of the character in the reference image surrounded by a rotating halo of glowing blurred phone screens in a dark room, faint red light on face, exhausted expression, right-hand side bold white text overlay: No one stays., clean space for text, cinematic realism and metaphorical depth"

  "set3_2a|cinematic portrait of the character in the reference image sitting at a table filled with untouched food, chest area subtly replaced by a dark glowing hollow hole emitting faint blue light, expression numb, desaturated tones, soft cinematic realism"
  "set3_2b|cinematic photo of the character in the reference image sitting at a table of untouched food, faint glowing void in chest, dark blue light, expression numb, bold white text overlay: Still empty., minimalist surreal composition, clean for text readability"

  "set3_3a|cinematic city street scene at dawn, the character in the reference image walking with eyes down, passing a figure sitting against a wall whose body is half-transparent, fading away, expression of guilt on main subject, realistic lighting with subtle surrealism"
  "set3_3b|cinematic city street, the character in the reference image walking past a fading transparent figure sitting on ground, dawn light, faint fog, bold white text overlay: You saw me., emotional, haunting realism, cinematic tone"

  "set3_4a|cinematic golden-hour field, the character in the reference image facing a younger Latina female version of himself reflected in mid-air like a memory, warm light, emotional surrealism, subtle lens flare, cinematic realism"
  "set3_4b|cinematic sunset field, the character in the reference image facing a glowing mirrored version of a young Latina female child version of himself, emotional regret, warm tones, bold white text overlay: I taught her fear., cinematic surreal style, soft light on text area"

  "set3_5a|cinematic kitchen at night, the character in the reference image standing in front of a fridge whose open door reveals another identical kitchen inside, repeating infinitely, blue-white glow, expression dazed, hyperrealistic lighting"
  "set3_5b|cinematic night kitchen, infinite repeating fridge doors stretching into distance, the character in the reference image staring blankly, blue glow, text overlay in bold white: Nothing ever changes., moody, emotional, surreal realism"

  "set3_6a|cinematic interior, the character in the reference image sitting on sofa, visible crack running diagonally through wall and across his body, faint dust floating in light, warm light from one side, cold light from the other, photorealistic symbolism"
  "set3_6b|cinematic interior split by a crack across wall and body of the character in the reference image, warm vs cold light sides, dust particles glowing, bold white text overlay: We broke long ago., cinematic realism, clear space for text"

  "set3_7a|cinematic forest path from above, splitting into two diverging trails; the character in the reference image stands at the fork, a young Latina female figure already far down the brighter path, soft fog and light, muted tones, metaphorical composition"
  "set3_7b|cinematic aerial or wide forest shot, the character in the reference image standing at fork in path, young Latina female far ahead on brighter path, muted green-grey tones, bold text overlay on right-hand side: She got everything., cinematic realism and emotional depth"
)

TOTAL=${#BRIEFS[@]}

echo "=========================================="
echo "Walking Psychologist Thumbnail Generation"
echo "=========================================="
echo "Total images: $TOTAL"
echo "Output: $SAVE_DIR"
echo "Character reference: $CHARACTER_REF"
echo "Estimated cost: \$$(echo "$TOTAL * 0.02" | bc)"
echo "=========================================="
echo ""

# STEP 1: Submit all tasks
echo "STEP 1: Submitting all tasks..."
echo ""

TASK_IDS=()
FILENAMES=()

for brief in "${BRIEFS[@]}"; do
  IFS='|' read -r filename prompt <<< "$brief"

  # Skip if already exists
  if [ -f "$SAVE_DIR/${filename}.png" ]; then
    echo "[$filename] Already exists, skipping..."
    TASK_IDS+=("SKIP")
    FILENAMES+=("$filename")
    continue
  fi

  # Submit task with character reference (using jq for proper JSON escaping)
  JSON_PAYLOAD=$(jq -n \
    --arg model "google/nano-banana-edit" \
    --arg prompt "$prompt" \
    --arg char_ref "$CHARACTER_REF" \
    '{
      model: $model,
      input: {
        prompt: $prompt,
        image_urls: [$char_ref],
        output_format: "png",
        image_size: "16:9"
      }
    }')

  RESPONSE=$(curl -s -X POST "$API_ENDPOINT/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer $API_KEY" \
    -d "$JSON_PAYLOAD")

  TASK_ID=$(echo "$RESPONSE" | jq -r '.data.taskId // "null"')
  TASK_IDS+=("$TASK_ID")
  FILENAMES+=("$filename")

  echo "[$filename] Submitted: $TASK_ID"
  sleep 1  # Rate limiting
done

echo ""
echo "All tasks submitted!"
echo ""

# STEP 2: Monitor all tasks
echo "=========================================="
echo "STEP 2: Monitoring all tasks..."
echo "=========================================="
echo ""

COMPLETED=0

while [ $COMPLETED -lt $TOTAL ]; do
  for i in "${!TASK_IDS[@]}"; do
    TASK_ID="${TASK_IDS[$i]}"

    # Skip completed or skipped tasks
    [[ $TASK_ID == "COMPLETED" || $TASK_ID == "SKIP" ]] && continue

    filename="${FILENAMES[$i]}"

    # Check status
    STATUS_RESPONSE=$(curl -s -X GET "$API_ENDPOINT/recordInfo?taskId=$TASK_ID" \
      -H "Authorization: Bearer $API_KEY")

    STATE=$(echo "$STATUS_RESPONSE" | jq -r '.data.state')

    if [ "$STATE" = "success" ]; then
      IMAGE_URL=$(echo "$STATUS_RESPONSE" | jq -r '.data.resultJson | fromjson | .resultUrls[0]')
      curl -s -o "$SAVE_DIR/${filename}.png" "$IMAGE_URL"
      echo "✅ [$filename] Saved"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))

    elif [ "$STATE" = "fail" ]; then
      ERROR=$(echo "$STATUS_RESPONSE" | jq -r '.data.errorMsg // "Unknown error"')
      echo "❌ [$filename] Failed: $ERROR"
      TASK_IDS[$i]="COMPLETED"
      ((COMPLETED++))
    fi
  done

  # Count skipped tasks as completed
  SKIPPED=$(printf '%s\n' "${TASK_IDS[@]}" | grep -c "SKIP" || true)
  TOTAL_DONE=$((COMPLETED + SKIPPED))

  echo "Progress: $TOTAL_DONE/$TOTAL completed"
  sleep 10
done

echo ""
echo "=========================================="
echo "GENERATION COMPLETE!"
echo "=========================================="
echo "All images saved to: $SAVE_DIR"
echo "Actual cost: \$$(echo "$COMPLETED * 0.02" | bc)"
echo "=========================================="
