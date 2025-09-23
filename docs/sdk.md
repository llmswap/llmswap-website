---
layout: default
title: Python SDK
parent: Documentation
nav_order: 4
---

# Python SDK Reference
{: .no_toc }

Complete guide to using llmswap in your Python applications.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Installation

```bash
pip install llmswap
```

## Quick Start

### Basic Usage

```python
from llmswap import LLMClient

# Initialize client (auto-detects provider)
client = LLMClient()

# Simple query
response = client.query("Explain machine learning")
print(response.content)
```

### With Specific Provider

```python
from llmswap import LLMClient

# Use specific provider
client = LLMClient(provider="anthropic")

# Or with model
client = LLMClient(provider="openai", model="gpt-4-turbo")

response = client.query("Write a haiku about Python")
print(response.content)
```

---

## LLMClient Class

### Initialization

```python
LLMClient(
    provider="auto",           # Provider name or "auto" for detection
    model=None,               # Model name (uses provider default if None)
    api_key=None,             # API key (uses env var if None)
    fallback=True,            # Enable automatic fallback
    cache_enabled=False,      # Enable response caching
    cache_ttl=3600,          # Cache time-to-live in seconds
    cache_max_size_mb=100,   # Maximum cache size
    analytics_enabled=False   # Enable usage analytics
)
```

### Example Configurations

```python
# Auto-detect with fallback
client = LLMClient()

# Specific provider, no fallback
client = LLMClient(provider="gemini", fallback=False)

# With caching enabled
client = LLMClient(cache_enabled=True, cache_ttl=7200)

# With custom API key
client = LLMClient(
    provider="openai",
    api_key="sk-..."
)
```

---

## Core Methods

### query()

Send a single query to the LLM.

```python
response = client.query(
    prompt="Your question here",
    cache_context=None,      # Optional cache context
    cache_ttl=None,         # Override default TTL
    cache_bypass=False      # Skip cache lookup
)
```

**Example:**
```python
# Simple query
response = client.query("What is quantum computing?")
print(response.content)

# With cache context (user-specific)
response = client.query(
    "Translate to French: Hello",
    cache_context={"user_id": "123"}
)

# Bypass cache for fresh response
response = client.query(
    "Latest news",
    cache_bypass=True
)
```

### chat()

Conversational interface with message history.

```python
messages = [
    {"role": "user", "content": "Hello, I'm Alice"}
]

response = client.chat(
    messages=messages,
    cache_bypass=True  # Recommended for conversations
)
```

**Example Conversation:**
```python
from llmswap import LLMClient

client = LLMClient()
messages = []

# First message
messages.append({"role": "user", "content": "My name is Bob"})
response = client.chat(messages)
print(response.content)
messages.append({"role": "assistant", "content": response.content})

# Follow-up question
messages.append({"role": "user", "content": "What's my name?"})
response = client.chat(messages)
print(response.content)  # Will remember "Bob"
```

### set_provider()

Switch to a different provider.

```python
client.set_provider(
    provider_name="anthropic",
    model="claude-3-haiku",    # Optional
    api_key=None               # Optional
)
```

**Example:**
```python
client = LLMClient()

# Start with OpenAI
client.set_provider("openai", model="gpt-4")
response1 = client.query("Hello from GPT-4")

# Switch to Claude
client.set_provider("anthropic", model="claude-3-5-sonnet")
response2 = client.query("Hello from Claude")

# Switch to local Ollama
client.set_provider("ollama", model="llama3.1")
response3 = client.query("Hello from Llama")
```

### get_available_providers()

List all configured providers.

```python
providers = client.get_available_providers()
print(providers)
# Output: ['anthropic', 'openai', 'gemini', 'ollama']
```

### is_provider_available()

Check if a specific provider is configured.

```python
if client.is_provider_available("openai"):
    client.set_provider("openai")
else:
    print("OpenAI not configured")
```

---

## Response Object

All methods return an `LLMResponse` object:

```python
class LLMResponse:
    content: str           # The AI's response text
    provider: str         # Provider used (e.g., "openai")
    model: str           # Model used (e.g., "gpt-4")
    usage: dict          # Token usage information
    metadata: dict       # Additional metadata
    latency: float       # Response time in seconds
    from_cache: bool     # Whether response was cached
```

**Example Usage:**
```python
response = client.query("Explain Python decorators")

print(f"Response: {response.content}")
print(f"Provider: {response.provider}")
print(f"Model: {response.model}")
print(f"Tokens: {response.usage.get('total_tokens', 'N/A')}")
print(f"Latency: {response.latency:.2f}s")
print(f"From cache: {response.from_cache}")
```

---

## Async Support

Use `AsyncLLMClient` for asynchronous operations:

```python
import asyncio
from llmswap import AsyncLLMClient

async def main():
    client = AsyncLLMClient()
    
    # Async query
    response = await client.query("Explain async/await")
    print(response.content)
    
    # Async streaming
    async for chunk in client.stream("Write a story"):
        print(chunk, end="", flush=True)

asyncio.run(main())
```

### Concurrent Requests

```python
import asyncio
from llmswap import AsyncLLMClient

async def ask_question(client, question):
    response = await client.query(question)
    return response.content

async def main():
    client = AsyncLLMClient()
    
    questions = [
        "What is Python?",
        "What is JavaScript?",
        "What is Rust?"
    ]
    
    # Concurrent requests
    tasks = [ask_question(client, q) for q in questions]
    results = await asyncio.gather(*tasks)
    
    for q, r in zip(questions, results):
        print(f"Q: {q}")
        print(f"A: {r[:100]}...")

asyncio.run(main())
```

---

## Streaming Responses

Stream responses in real-time:

```python
from llmswap import AsyncLLMClient
import asyncio

async def stream_example():
    client = AsyncLLMClient()
    
    print("Streaming response:")
    async for chunk in client.stream("Write a short story"):
        print(chunk, end="", flush=True)
    print("\nDone!")

asyncio.run(stream_example())
```

---

## Caching

### Enable Caching

```python
from llmswap import LLMClient

# Enable cache with 1-hour TTL
client = LLMClient(
    cache_enabled=True,
    cache_ttl=3600,
    cache_max_size_mb=100
)

# First call - hits API
response1 = client.query("What is Docker?")
print(f"From cache: {response1.from_cache}")  # False

# Second call - from cache
response2 = client.query("What is Docker?")
print(f"From cache: {response2.from_cache}")  # True
```

### Cache Management

```python
# Clear all cache
client.clear_cache()

# Invalidate specific entry
client.invalidate_cache(
    prompt="What is Docker?",
    cache_context={"user_id": "123"}
)

# Get cache statistics
stats = client.get_cache_stats()
print(f"Cache hits: {stats['hits']}")
print(f"Cache misses: {stats['misses']}")
print(f"Cache size: {stats['size_mb']} MB")
```

---

## Analytics & Tracking

### Usage Statistics

```python
from llmswap import LLMClient

client = LLMClient(analytics_enabled=True)

# Make some queries
client.query("Test 1")
client.query("Test 2")

# Get usage stats
stats = client.get_usage_stats()
print(f"Total queries: {stats['total_queries']}")
print(f"Total tokens: {stats['total_tokens']}")
print(f"Total cost: ${stats['total_cost']:.4f}")
```

### Cost Analysis

```python
# Get cost breakdown
costs = client.get_cost_breakdown(days=30)
for provider, data in costs.items():
    print(f"{provider}: ${data['cost']:.2f}")

# Compare providers
comparison = client.get_provider_comparison(
    input_tokens=10000,
    output_tokens=5000
)
print(f"Cheapest: {comparison['cheapest']}")
print(f"Savings: {comparison['max_savings_percentage']}%")
```

---

## Error Handling

```python
from llmswap import LLMClient
from llmswap.exceptions import (
    ConfigurationError,
    ProviderError,
    RateLimitError,
    AuthenticationError
)

client = LLMClient()

try:
    response = client.query("Hello")
except ConfigurationError as e:
    print(f"Configuration issue: {e}")
except AuthenticationError as e:
    print(f"Authentication failed: {e}")
except RateLimitError as e:
    print(f"Rate limit hit: {e}")
    # Switch provider or wait
except ProviderError as e:
    print(f"Provider error: {e}")
except Exception as e:
    print(f"Unexpected error: {e}")
```

---

## Advanced Examples

### Building a Chatbot

```python
from llmswap import LLMClient

class Chatbot:
    def __init__(self):
        self.client = LLMClient()
        self.messages = []
    
    def chat(self, user_input):
        # Add user message
        self.messages.append({
            "role": "user",
            "content": user_input
        })
        
        # Get response
        response = self.client.chat(
            self.messages,
            cache_bypass=True
        )
        
        # Add assistant message
        self.messages.append({
            "role": "assistant",
            "content": response.content
        })
        
        return response.content
    
    def reset(self):
        self.messages = []
    
    def switch_provider(self, provider):
        self.client.set_provider(provider)

# Usage
bot = Chatbot()
print(bot.chat("Hi, I'm Alice"))
print(bot.chat("What's my name?"))  # Remembers Alice
```

### Multi-Provider Comparison

```python
from llmswap import LLMClient

def compare_providers(prompt, providers):
    """Get responses from multiple providers."""
    results = {}
    
    for provider in providers:
        try:
            client = LLMClient(provider=provider)
            response = client.query(prompt)
            results[provider] = {
                "content": response.content,
                "latency": response.latency,
                "model": response.model
            }
        except Exception as e:
            results[provider] = {"error": str(e)}
    
    return results

# Compare responses
prompt = "Explain quantum entanglement in one sentence"
providers = ["openai", "anthropic", "gemini"]
results = compare_providers(prompt, providers)

for provider, data in results.items():
    print(f"\n{provider.upper()}:")
    if "error" in data:
        print(f"  Error: {data['error']}")
    else:
        print(f"  Model: {data['model']}")
        print(f"  Time: {data['latency']:.2f}s")
        print(f"  Response: {data['content'][:100]}...")
```

### Rate-Limited Wrapper

```python
import time
from llmswap import LLMClient
from llmswap.exceptions import RateLimitError

class RateLimitedClient:
    def __init__(self, requests_per_minute=20):
        self.client = LLMClient()
        self.requests_per_minute = requests_per_minute
        self.last_request = 0
    
    def query(self, prompt, **kwargs):
        # Rate limiting
        min_interval = 60 / self.requests_per_minute
        elapsed = time.time() - self.last_request
        if elapsed < min_interval:
            time.sleep(min_interval - elapsed)
        
        try:
            response = self.client.query(prompt, **kwargs)
            self.last_request = time.time()
            return response
        except RateLimitError:
            # Switch provider or wait
            self.client.set_provider("gemini")
            return self.client.query(prompt, **kwargs)

# Usage
client = RateLimitedClient(requests_per_minute=10)
for i in range(5):
    response = client.query(f"Question {i}")
    print(f"Response {i}: {response.content[:50]}...")
```

---

## Best Practices

1. **Use cache for repeated queries**
   ```python
   client = LLMClient(cache_enabled=True)
   ```

2. **Bypass cache for conversations**
   ```python
   response = client.chat(messages, cache_bypass=True)
   ```

3. **Handle errors gracefully**
   ```python
   try:
       response = client.query(prompt)
   except Exception as e:
       # Fallback logic
   ```

4. **Use async for concurrent requests**
   ```python
   async with AsyncLLMClient() as client:
       results = await asyncio.gather(*tasks)
   ```

5. **Monitor costs**
   ```python
   costs = client.get_cost_breakdown()
   ```

---

Ready to build? Check our [tutorials](/tutorials) for complete examples.