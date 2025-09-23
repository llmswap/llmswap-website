---
layout: default
title: Provider Setup
parent: Documentation
nav_order: 3
---

# Provider Setup Guide
{: .no_toc }

Configure and optimize each AI provider for llmswap.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

llmswap supports 8 AI providers, each with unique strengths:

| Provider | Best For | Starting Cost | Speed |
|----------|----------|---------------|--------|
| **OpenAI** | General purpose, GPT-4 | $0.01/1K tokens | Fast |
| **Anthropic** | Long context, Claude 3.5 | $0.003/1K tokens | Fast |
| **Google Gemini** | Cost-effective, multimodal | $0.00025/1K tokens | Fast |
| **IBM Watson** | Enterprise, secure | $0.0002/1K tokens | Medium |
| **Groq** | Ultra-fast inference | $0.00005/1K tokens | Ultra-fast |
| **Cohere** | RAG, enterprise search | $0.0005/1K tokens | Fast |
| **Perplexity** | Web-connected, search | $0.0002/1K tokens | Medium |
| **Ollama** | Local, private | Free | Varies |

---

## OpenAI

### Setup

1. **Get API Key**: [platform.openai.com/api-keys](https://platform.openai.com/api-keys)
2. **Set Environment Variable**:
```bash
export OPENAI_API_KEY="sk-..."
```

### Available Models

- `gpt-4o` - Most capable, multimodal (default)
- `gpt-4-turbo` - Faster GPT-4 variant
- `gpt-4` - Original GPT-4
- `gpt-4o-mini` - Small, fast, cheap
- `o1-preview` - Reasoning model
- `o1-mini` - Smaller reasoning model
- `gpt-3.5-turbo` - Fast, affordable

### Configuration

```bash
# Set default model
llmswap config set provider.models.openai gpt-4-turbo

# Use specific model
llmswap chat --provider openai --model gpt-4o-mini
```

### Best Practices

- Use `gpt-4o-mini` for simple tasks (90% cheaper)
- Use `gpt-4o` for complex reasoning
- Use `o1-preview` for math/coding problems

---

## Anthropic Claude

### Setup

1. **Get API Key**: [console.anthropic.com](https://console.anthropic.com)
2. **Set Environment Variable**:
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
```

### Available Models

- `claude-3-5-sonnet-20241022` - Latest, most capable (default)
- `claude-3-opus` - Powerful, more expensive
- `claude-3-5-haiku` - Fast, affordable
- `claude-3-haiku` - Fastest, cheapest

### Configuration

```bash
# Set default model
llmswap config set provider.models.anthropic claude-3-5-sonnet-20241022

# Use specific model
llmswap chat --provider anthropic --model claude-3-haiku
```

### Best Practices

- Claude excels at long documents (200K context)
- Best for creative writing and analysis
- Use Haiku for simple tasks (10x cheaper)

---

## Google Gemini

### Setup

1. **Get API Key**: [makersuite.google.com/app/apikey](https://makersuite.google.com/app/apikey)
2. **Set Environment Variable**:
```bash
export GEMINI_API_KEY="..."
```

### Available Models

- `gemini-1.5-pro` - Most capable (default)
- `gemini-1.5-flash` - Fast, efficient
- `gemini-2.0-flash-exp` - Experimental, cutting-edge

### Configuration

```bash
# Set default model
llmswap config set provider.models.gemini gemini-1.5-flash

# Use specific model
llmswap chat --provider gemini --model gemini-2.0-flash-exp
```

### Best Practices

- Extremely cost-effective (90% cheaper than GPT-4)
- Great for multimodal tasks
- Flash models are perfect for high-volume

---

## IBM Watson

### Setup

1. **Get Credentials**: [cloud.ibm.com/catalog/services/watsonx-ai](https://cloud.ibm.com/catalog/services/watsonx-ai)
2. **Set Environment Variables**:
```bash
export WATSONX_API_KEY="..."
export WATSONX_PROJECT_ID="..."
```

### Available Models

- `granite-13b-chat` - General purpose (default)
- `granite-3.1-8b-instruct` - Efficient
- `granite-3.1-2b-instruct` - Lightweight

### Configuration

```bash
# Set default model
llmswap config set provider.models.watsonx granite-3.1-8b-instruct

# Use Watson
llmswap chat --provider watsonx
```

### Best Practices

- Enterprise-grade security and compliance
- Best for regulated industries
- Supports custom model deployment

---

## Groq

### Setup

1. **Get API Key**: [console.groq.com](https://console.groq.com)
2. **Set Environment Variable**:
```bash
export GROQ_API_KEY="gsk_..."
```

### Available Models

- `llama-3.3-70b-versatile` - Most capable (default)
- `llama-3.1-8b-instant` - Ultra-fast
- `mixtral-8x7b-32768` - Good for code

### Configuration

```bash
# Set default model
llmswap config set provider.models.groq llama-3.1-8b-instant

# Use Groq for speed
llmswap generate "python web scraper" --provider groq
```

### Best Practices

- **Fastest inference** (840+ tokens/second)
- Perfect for real-time applications
- 5-15x faster than other providers

---

## Cohere

### Setup

1. **Get API Key**: [dashboard.cohere.com/api-keys](https://dashboard.cohere.com/api-keys)
2. **Set Environment Variable**:
```bash
export COHERE_API_KEY="..."
```

### Available Models

- `command-r-plus-08-2024` - Most capable (default)
- `command-r-03-2024` - Efficient
- `aya-expanse-32b` - Multilingual

### Configuration

```bash
# Set default model
llmswap config set provider.models.cohere command-r-plus-08-2024

# Use Cohere
llmswap chat --provider cohere
```

### Best Practices

- Excellent for RAG applications
- Strong multilingual support
- Good for enterprise search

---

## Perplexity

### Setup

1. **Get API Key**: [perplexity.ai/settings/api](https://perplexity.ai/settings/api)
2. **Set Environment Variable**:
```bash
export PERPLEXITY_API_KEY="pplx-..."
```

### Available Models

- `sonar-pro` - Web-connected (default)
- `sonar` - Standard web search
- `sonar-reasoning` - Complex reasoning

### Configuration

```bash
# Set default model  
llmswap config set provider.models.perplexity sonar-pro

# Use for web-connected queries
llmswap ask "latest news about AI" --provider perplexity
```

### Best Practices

- **Real-time web access** for current information
- Automatic source citations
- Best for research and fact-checking

---

## Ollama (Local Models)

### Setup

1. **Install Ollama**:
```bash
# macOS/Linux
curl -fsSL https://ollama.ai/install.sh | sh

# Windows
# Download from ollama.ai
```

2. **Pull Models**:
```bash
# Popular models
ollama pull llama3.1       # 8B parameters
ollama pull mistral        # 7B parameters  
ollama pull codellama      # Code-focused
ollama pull phi3           # Microsoft's 3.8B
```

3. **Start Ollama Service**:
```bash
ollama serve  # Usually auto-starts
```

### Available Models

Run `ollama list` to see installed models:
- `llama3.1` - Meta's latest (default)
- `mistral` - Fast, efficient
- `codellama` - Optimized for code
- `phi3` - Small but capable
- `gemma2` - Google's open model
- `qwen2.5-coder` - Excellent for coding

### Configuration

```bash
# Set default model
llmswap config set provider.models.ollama llama3.1

# Use local model
llmswap chat --provider ollama --model codellama
```

### Best Practices

- **Completely free** and private
- No internet required after setup
- Speed depends on your hardware
- Use smaller models (3B-7B) for speed
- Use larger models (13B-70B) for quality

---

## Provider Selection Strategy

### By Use Case

| Use Case | Recommended Provider | Why |
|----------|---------------------|-----|
| **General chat** | Anthropic Claude | Best conversation quality |
| **Code generation** | OpenAI GPT-4 | Strong coding abilities |
| **Fast responses** | Groq | 5-15x faster |
| **Cost savings** | Gemini | 90% cheaper |
| **Privacy** | Ollama | Local, no data sharing |
| **Web search** | Perplexity | Real-time information |
| **Enterprise** | Watson | Compliance, security |
| **RAG/Search** | Cohere | Optimized for retrieval |

### By Budget

```bash
# See cost comparison
llmswap compare --input-tokens 10000 --output-tokens 5000

# Monthly cost estimate
llmswap costs --estimate --daily-queries 100
```

### Auto-Fallback Chain

llmswap automatically falls back through providers if one fails:

1. Anthropic (if configured)
2. OpenAI (if configured)
3. Gemini (if configured)
4. Cohere (if configured)
5. Perplexity (if configured)
6. Watson (if configured)
7. Groq (if configured)
8. Ollama (if available)

Configure fallback order:
```bash
llmswap config set provider.fallback_order "anthropic,gemini,ollama"
```

---

## Troubleshooting

### Check Provider Status

```bash
llmswap providers
```

### Common Issues

**"API key invalid"**
- Verify key is correct: `echo $PROVIDER_API_KEY`
- Check key permissions on provider dashboard
- Regenerate key if needed

**"Rate limit exceeded"**
- Wait a few minutes
- Upgrade your plan
- Switch to different provider: `/switch gemini`

**"Model not found"**
- Check available models: `llmswap config get provider.models`
- Update model name: `llmswap config set provider.models.openai gpt-4o`

**"Ollama not responding"**
- Check service: `curl http://localhost:11434/api/tags`
- Restart: `ollama serve`
- Verify model installed: `ollama list`

---

Ready to start? Check our [Getting Started](/docs/getting-started) guide or explore [Examples](/tutorials).