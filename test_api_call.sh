#!/bin/bash

API_KEY="7d24e9bf54569abf2625f84efbe28f22"
CHARACTER_REF="https://raw.githubusercontent.com/bnoko/reference-images/main/references/ACTIVE%20REFERENCES/byron-character-reference.png"
TEST_PROMPT="cinematic photo test of a man at dusk"

JSON_PAYLOAD=$(jq -n \
  --arg model "google/nano-banana-edit" \
  --arg prompt "$TEST_PROMPT" \
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

echo "Payload:"
echo "$JSON_PAYLOAD"
echo ""
echo "Response:"

curl -s -X POST "https://api.kie.ai/api/v1/jobs/createTask" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d "$JSON_PAYLOAD" | jq '.'
