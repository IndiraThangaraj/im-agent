# test_pipeline.py
import asyncio
import httpx

GATEWAY_URL = "http://localhost:8000/v1/chat/completions"
API_KEY = "DEMO-SECRET-KEY"  # from kong.yaml

async def call_llm(i: int):
    payload = {
        "model": "Phi-4-mini-instruct-GGUF",  # or whatever your local dir model is called
        "messages": [
            {"role": "user", "content": f"Hello from agent {i}, short answer please."}
        ],
        "max_tokens": 64,
        "temperature": 0.7,
    }
    headers = {
        "x-api-key": API_KEY,
        "Content-Type": "application/json",
    }

    async with httpx.AsyncClient(timeout=120.0) as client:
        r = await client.post(GATEWAY_URL, json=payload, headers=headers)
        r.raise_for_status()
        data = r.json()
        print(f"[agent {i}] {data['choices'][0]['message']['content']}")

async def main():
    await asyncio.gather(
        call_llm(1),
        call_llm(2),
    )

if __name__ == "__main__":
    asyncio.run(main())
