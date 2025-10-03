#!/bin/bash

# Batch generation for "How does it feel to drown" video essay
# 87 images numbered for sequential CapCut import
# All images use linocut black and white style with drowning-specific references

# Setup
DATE=$(date +%Y-%m-%d)
SAVE_DIR="/Users/byron/Projects/Jimmy/Tools/reference-images/generated-images/$DATE"
mkdir -p "$SAVE_DIR"

# Style references (linocut black and white)
STYLE_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino1-light.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/linocut_black_and_white/lino4-dark.png"
)

# Drowning-specific reference images
DROWNING_REFS=(
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/man-on-boat-reference.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/francesco-pia-reference.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/titanic-ship-reference.png"
  "https://raw.githubusercontent.com/bnoko/reference-images/main/references/videos/drowning/baywatch-lifeguard-reference.png"
)

# All 87 image prompts (numbered for CapCut sequence)
DROWNING_PROMPTS=(
  # 01-10: Opening sequence
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting wide ocean with the sailboat from the boat reference image just visible in the distance"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the boat from the boat reference image on the open ocean, with the man from the boat reference image holding a rail looking out over the water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image looking out over the ocean from the sailboat"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a mans hand holding a small photo of his wife"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting from inside the cottage, the man from the boat reference image and a woman in embrace at the front doorway - the man has just arrived home from a sailing trip, you can see his face but the woman has her back to us"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting churning ocean waves"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close up of hand holding a rail on the sailboat from the boat reference image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of the man from the boat reference image being betrayed by the ocean"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the boat from the boat reference image dropping over a wave, with the man from the boat reference image going over the rail"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image falling to the water beside the boat after having gone over the rail"

  # 11-20: Beginning of biological response
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting stark headshot of the man from the boat reference image, wearing his sailing jacket, looking to camera, deadpan"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image to represent a dark biological script written into our genome"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting double helix DNA strand morphing into chains binding a human figure"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in his sailing gear, in a diagram as per Leonardo's vitruvian man"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a giant fist clamping around the chest of the man from the boat reference image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in the churning sea, head barely above water, gasping for air"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting biological diagram of human breathing apparatus, airways and lungs"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting biological diagram of human breathing apparatus, airways and lungs being flooded with water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person sitting with their head in their hands on a pier, looking miserably resigned"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image thrashing in a churning sea, barely above the water, side view where we can see both above and below the water"

  # 21-30: Panic and instinctive drowning response (Francesco Pia section)
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close up of the panicking face of the man from the boat reference image"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting legs kicking in water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in ocean trying to keep his head above water - head only just visible above surface"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbol of not speaking, a persons face with their hands covering their mouth"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person covering their ears while grimacing as if to shield themselves from loud music"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a lifeguard tower on a busy beach of holidaymakers"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the lifeguard from the Baywatch reference image running across the beach"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close up of the head of the man from the boat reference image low in the water in the sea, mouth barely above the surface, eyes glassy and unfocused"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the lifeguard expert from the Francesco Pia reference image scanning the water at a busy beach"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close up of the mouth of the man from the boat reference image barely managing to surface to gasp a breath in a churning sea"

  # 31-40: Desperate struggle and loss of control
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting waves on a churning sea"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting split of 3 images to represent Breathe, Kick, Stay afloat"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting desperate arm of the man from the boat reference image reaching up from underwater toward the sailboat from the boat reference image floating above"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting open hands, fingers trying to grip at empty air to symbolise failed grasps and slipping control"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting a representation of a human brain divided into fragments"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in waterlogged sailing jacket being pulled down by the weight of his soaked clothes in churning ocean water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting underwater view of heavy leather shoes acting like anchors, dragging a person's legs down toward the ocean floor"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting survival manual pages dissolving and floating away in dark water, text becoming illegible"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the struggle of the man from the boat reference image intensifying as he sinks deeper, desperation in his eyes"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting cross-section anatomical diagram of human chest and throat during drowning, showing internal battle"

  # 41-50: Internal battle and physiological responses
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man's face contorted in violent coughing, seawater spraying from his mouth"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting medical illustration of human throat muscles clamping shut like a trap mechanism"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of a person being strangled by their own shadow or reflection"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man underwater, body convulsing as multiple systems begin to fail simultaneously"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting shattered mirror or glass reflecting fragmented memories - faces, voices, moments"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting jagged memory fragments floating in dark water - a child's laughing face, an elderly parent's voice waveform"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting brain scan showing tunnel vision effect, with most areas going dark except a small central focus"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man's face going slack as consciousness begins to fade, entering the shutdown phase"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man's arms becoming heavy and sluggish in dark water, losing coordination"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of the man's eyes with vision tunneling - peripheral darkness closing in"

  # 51-60: Shutdown phase and dissociation
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting abstract representation of sounds becoming muffled and distorted underwater"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man's face showing exhaustion rather than panic - a biological shutdown beginning"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of a brain conserving energy, dimming like a dying battery"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting ethereal boundary between life and death - the moment before dissociation begins"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting split perspective showing the man drowning from above and below - an out-of-body experience"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man's ghostly transparent form floating above his own drowning body in the water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting peaceful face of a drowning survivor contrasted with distant traumatic scene"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of protective hands shielding eyes from a traumatic scene"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the ship from the Titanic reference image sinking at night with its lights still on"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting masses of people falling into freezing water from the ship from the Titanic reference image"

  # 61-70: Historical context and survival techniques
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting cinematic scene of people gasping and clawing at water around the ship from the Titanic reference image, then falling still in icy ocean"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting split comparison: quick silent death in cold water versus prolonged dramatic movie drowning"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting overcrowded refugee boat capsizing in Mediterranean sea with people falling into water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting families disappearing beneath waves with barely any disturbance on the water surface"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting abstract visualization of global drowning statistics - invisible epidemic represented symbolically"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting split screen showing panicked thrashing vs calm floating survival technique"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person thrashing violently in water until exhausted"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in sailing jacket suddenly stopping his panicked thrashing and becoming still in the water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person tilting onto their back, floating calmly in water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of water supporting rather than fighting a human body"

  # 71-80: Training and aftermath
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting lifeguard instructor teaching floating technique to trainees"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting military or survival training showing calm as a tactical advantage over panic"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of a person floating calmly on their back in water, demonstrating survival technique"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting drowning survivor sitting alone, haunted expression, with ghostly water imagery around them"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person covering ears as rushing water sounds trigger traumatic memories"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person avoiding a swimming pool or beach, walking away from water"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image in sailing jacket courageously stepping back into ocean water, facing his fear"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person taking a deep, conscious breath with heightened awareness"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting abstract representation of human identity layers peeling away like onion skins, revealing biological core"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting split image showing thinking mind versus struggling body - the fragile connection between consciousness and survival"

  # 81-87: Final philosophical reflections
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic image of identity dissolving like layers being stripped away, leaving only basic biological functions"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting person holding a precious gift, with dark abyss visible in background - representing paradoxical gift of near-death experience"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting abstract representation of a dark abyss reaching toward a human figure"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting the man from the boat reference image standing at the very edge of life and death, balanced between two worlds"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting close-up of person breathing deeply with intense mindfulness and gratitude"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting symbolic balance scale showing survival being earned moment by moment"
  "In the exact style of the reference images: a lino-cut black and white engraving with bold lines and high contrast, depicting visual representation of the space between panic and calm - perhaps a person floating serenely between two opposing forces"
)

# Reference assignments (which specific references to use for each image)
REFERENCE_ASSIGNMENTS=(
  # 01-10: Opening sequence - use man-on-boat reference for boat/character consistency
  1 1 1 0 0 0 1 0 1 1
  # 11-20: Early drowning - mix character and boat references
  1 0 0 0 0 1 0 0 0 1
  # 21-30: Francesco Pia section - use Francesco reference + lifeguard
  1 0 1 0 0 0 4 1 0 1
  # 31-40: Struggle continues - boat reference for character consistency
  0 0 1 0 0 1 0 0 1 0
  # 41-50: Internal battle - character reference for close-ups
  1 0 0 1 0 0 0 1 1 1
  # 51-60: Dissociation and Titanic - use Titanic reference for ship scenes
  0 1 0 0 1 1 0 0 3 3
  # 61-70: Historical and survival - mix Titanic and training references
  3 0 0 0 0 0 0 1 0 0
  # 71-80: Training and aftermath - character reference for personal scenes
  0 0 0 0 0 0 1 0 0 0
  # 81-87: Final philosophy - character reference for personal conclusion
  0 0 0 1 0 0 1
)

# Array to store task IDs
TASK_IDS=()

# Generate descriptive filenames with numbers
FILENAMES=()
for i in $(seq -f "%02g" 1 87); do
  FILENAMES+=("${i}_drowning_video_image")
done

echo "Starting COMPLETE drowning video generation!"
echo "Generating all 87 images in sequence for CapCut import"
echo "Save directory: $SAVE_DIR"
echo "Total cost: $1.74 (87 × $0.02)"
echo ""
echo "Images will be numbered 01-87 for perfect CapCut sequence!"
echo ""

# Submit all 87 tasks
for i in "${!DROWNING_PROMPTS[@]}"; do
  REF_INDEX=${REFERENCE_ASSIGNMENTS[$i]}

  # Build image_urls array based on reference assignment
  if [ "$REF_INDEX" -eq 0 ]; then
    # No specific reference, use only style references
    IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\"]"
  else
    # Use style + specific drowning reference
    REF_URL=${DROWNING_REFS[$((REF_INDEX-1))]}
    IMAGE_URLS="[\"${STYLE_REFS[0]}\", \"${STYLE_REFS[1]}\", \"$REF_URL\"]"
  fi

  RESPONSE=$(curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer 7d24e9bf54569abf2625f84efbe28f22" \
    -d "{
      \"model\": \"google/nano-banana-edit\",
      \"input\": {
        \"prompt\": \"${DROWNING_PROMPTS[$i]}\",
        \"image_urls\": $IMAGE_URLS,
        \"output_format\": \"png\",
        \"image_size\": \"16:9\"
      }
    }")

  TASK_ID=$(echo $RESPONSE | jq -r '.data.taskId')
  TASK_IDS+=($TASK_ID)
  echo "Task $((i+1))/87 submitted: $TASK_ID - ${FILENAMES[$i]}"
  sleep 1  # Rate limiting
done

echo ""
echo "All 87 drowning video tasks submitted! Now monitoring for completion..."
echo "This will take approximately 15-30 minutes for full completion."
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

  echo "Progress: $COMPLETED/87 completed ($(( COMPLETED * 100 / 87 ))%)"
  sleep 15  # Longer sleep for large batch
done

echo ""
echo "🎉 COMPLETE DROWNING VIDEO GENERATION FINISHED! 🎉"
echo "All 87 images saved to: $SAVE_DIR"
echo "Cost: $1.74 total"
echo ""
echo "=== CAPCUT IMPORT READY ==="
echo "✅ All images numbered 01-87 for sequential import"
echo "✅ Drag entire folder into CapCut project"
echo "✅ Images will appear in script order automatically!"
echo ""
echo "🎬 DROWNING VIDEO ESSAY COMPLETE! 🎬"
echo "Ready for editing in CapCut with perfect sequence order!"