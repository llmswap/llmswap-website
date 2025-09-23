---
layout: default
title: Documentation
nav_order: 2
has_children: true
---

# Documentation
{: .no_toc }

Complete documentation for llmswap - the universal AI CLI.
{: .fs-6 .fw-300 }

---

## Quick Links

- **[Getting Started](/docs/getting-started)** - Install and start using llmswap in 5 minutes
- **[CLI Reference](/docs/cli)** - Complete command reference
- **[Provider Setup](/docs/providers)** - Configure each AI provider
- **[Python SDK](/docs/sdk)** - Use llmswap in your Python code

## Overview

llmswap is a universal AI CLI and Python SDK that provides a single interface to 8 different AI providers:

- OpenAI (GPT-4, GPT-3.5)
- Anthropic (Claude 3.5)
- Google (Gemini)
- IBM Watson
- Groq
- Cohere
- Perplexity
- Ollama (Local)

### Key Features

- **One Interface**: Same commands work with any provider
- **No Vendor Lock-in**: Switch providers instantly
- **Conversation Memory**: AI remembers your chat history
- **Cost Optimization**: Compare costs and save 90%
- **Local Models**: Run privately with Ollama
- **Enterprise Ready**: Configuration, security, analytics

### Quick Start

```bash
# Install
pip install llmswap

# Configure (choose one)
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."

# Use
llmswap chat
```

### Architecture

```
┌─────────────────┐
│   Your App      │
└─────────┬───────┘
          │
┌─────────▼───────┐    ┌──────────────┐
│    llmswap      │◄───┤ 8 Providers  │
│                 │    │ OpenAI       │
│ • CLI Commands  │    │ Claude       │
│ • Python SDK    │    │ Gemini       │
│ • Cost Tracking │    │ Watson       │
│ • Analytics     │    │ Groq         │
└─────────────────┘    │ Cohere       │
                       │ Perplexity   │
                       │ Ollama       │
                       └──────────────┘
```

## Documentation Sections

### Getting Started
- [Installation](/docs/getting-started#installation)
- [Provider Setup](/docs/getting-started#provider-setup)
- [First Commands](/docs/getting-started#first-commands)
- [Python SDK Quickstart](/docs/getting-started#python-sdk-quick-start)

### CLI Reference
- [Core Commands](/docs/cli#core-commands)
- [Analytics Commands](/docs/cli#analytics-commands)
- [Configuration](/docs/cli#configuration-commands)
- [Global Options](/docs/cli#global-options)

### Provider Setup
- [OpenAI](/docs/providers#openai)
- [Anthropic Claude](/docs/providers#anthropic-claude)
- [Google Gemini](/docs/providers#google-gemini)
- [IBM Watson](/docs/providers#ibm-watson)
- [Groq](/docs/providers#groq)
- [Cohere](/docs/providers#cohere)
- [Perplexity](/docs/providers#perplexity)
- [Ollama Local](/docs/providers#ollama-local-models)

### Python SDK
- [Basic Usage](/docs/sdk#basic-usage)
- [Async Support](/docs/sdk#async-support)
- [Streaming](/docs/sdk#streaming-responses)
- [Caching](/docs/sdk#caching)
- [Analytics](/docs/sdk#analytics--tracking)

## FAQ

### How is this different from OpenAI's library?
llmswap provides a unified interface across 8 providers, while OpenAI's library only works with OpenAI. You can switch providers without changing your code.

### Do I need API keys for all providers?
No! You only need one provider configured to start. llmswap auto-detects available providers and can fall back between them.

### Is it free?
llmswap itself is free and open source. You pay only for the AI provider APIs you use, often at 90% less cost than subscriptions.

### Can I use it offline?
Yes! Use Ollama to run models completely offline and privately on your own machine.

### Is it production ready?
Absolutely. llmswap includes enterprise features like configuration management, cost tracking, error handling, and analytics.

## Support

- **GitHub**: [Report issues](https://github.com/sreenathmmenon/llmswap/issues)
- **Documentation**: [llmswap.org](https://llmswap.org)
- **Examples**: [Tutorials](/tutorials)

---

Ready to get started? Head to our [Getting Started Guide](/docs/getting-started)!