curl -X POST http://0.0.0.0:8000/v1/chat/completions \
  -H "x-api-key: DEMO-SECRET-KEY" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "Phi-4-mini-instruct-GGUF",
    "messages": [
      {"role": "user", "content": "hello from curl"}
    ]
  }'
