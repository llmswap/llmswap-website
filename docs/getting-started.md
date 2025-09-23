---
layout: default
title: Getting Started
parent: Documentation
nav_order: 1
---

# Getting Started with llmswap
{: .no_toc }

Get up and running with llmswap in 5 minutes.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Installation

### Option 1: Install with pip (Recommended)

```bash
pip install llmswap
```

### Option 2: Install with Homebrew

```bash
brew install llmswap/tap/llmswap
```

### Option 3: Install from source

```bash
git clone https://github.com/sreenathmmenon/llmswap
cd llmswap
pip install -e .
```

## Provider Setup

llmswap supports 8 AI providers. You only need to configure **one** to get started.

### Quick Setup (Choose One)

#### OpenAI
```bash
export OPENAI_API_KEY="sk-..."
llmswap chat  # Ready to use!
```

#### Anthropic Claude
```bash
export ANTHROPIC_API_KEY="sk-ant-..."
llmswap chat  # Ready to use!
```

#### Google Gemini
```bash
export GEMINI_API_KEY="..."
llmswap chat  # Ready to use!
```

#### Local Models (Ollama)
```bash
# Install Ollama first
curl -fsSL https://ollama.ai/install.sh | sh

# Pull a model
ollama pull llama3.1

# Use with llmswap
llmswap chat --provider ollama
```

## First Commands

### 1. Check Provider Status

See which providers are configured and available:

```bash
llmswap providers
```

Output:
```
╭─────────────┬──────────┬──────────────────────┬─────────────────────╮
│ Provider    │ Status   │ Model                │ Issue               │
├─────────────┼──────────┼──────────────────────┼─────────────────────┤
│ ANTHROPIC   │ ✓ Ready  │ claude-3-5-sonnet    │                     │
│ OPENAI      │ ✓ Ready  │ gpt-4o               │                     │
│ GEMINI      │ ✗        │                      │ Missing API key     │
│ OLLAMA      │ ✓ Ready  │ llama3.1             │                     │
╰─────────────┴──────────┴──────────────────────┴─────────────────────╯
```

### 2. Ask a Question

Simple one-off question:

```bash
llmswap ask "What is the capital of France?"
```

### 3. Start a Chat

Interactive conversation with context:

```bash
llmswap chat
```

Example session:

<div class="terminal-window">
  <div class="terminal-header">
    <span class="terminal-dot red"></span>
    <span class="terminal-dot yellow"></span>
    <span class="terminal-dot green"></span>
  </div>
  <pre><code>🤖 Starting chat with claude-3-5-sonnet
Type '/help' for commands, '/quit' to exit

You: Hi, my name is Alice
Assistant: Hello Alice! It's nice to meet you. How can I help you today?

You: What's my name?
Assistant: Your name is Alice.

You: /switch openai
🔄 Switched to openai (gpt-4o)

You: Can you help me write Python code?
Assistant: Of course! I'd be happy to help you write Python code...</code></pre>
</div>

### 4. Generate Code

Transform natural language to code:

```bash
# Generate a bash command
llmswap generate "find all Python files modified in last 24 hours"

# Generate Python code
llmswap generate "function to validate email addresses" --language python

# Generate and execute (with confirmation)
llmswap generate "create backup of current directory" --execute
```

### 5. Review Code

Get AI-powered code review:

```bash
# Review a Python file
llmswap review app.py

# Focus on security issues
llmswap review app.py --focus security

# Review with specific focus
llmswap review src/api.js --focus performance
```

## Configuration

### Set Default Provider

```bash
llmswap config set provider.default anthropic
```

### Set Default Models

```bash
llmswap config set provider.models.openai gpt-4-turbo
llmswap config set provider.models.anthropic claude-3-opus
```

### View Configuration

```bash
llmswap config show
```

## Python SDK Quick Start

### Basic Usage

```python
from llmswap import LLMClient

# Initialize client (auto-detects provider)
client = LLMClient()

# Simple query
response = client.query("Explain quantum computing in simple terms")
print(response.content)

# Check which provider was used
print(f"Provider: {response.provider}")
print(f"Model: {response.model}")
```

### Conversation with Context

```python
from llmswap import LLMClient

client = LLMClient()

# Start a conversation
messages = [
    {"role": "user", "content": "My name is Bob"}
]
response = client.chat(messages)
print(response.content)

# Continue conversation
messages.append({"role": "assistant", "content": response.content})
messages.append({"role": "user", "content": "What's my name?"})
response = client.chat(messages)
print(response.content)  # Will remember your name is Bob
```

### Switch Providers

```python
from llmswap import LLMClient

client = LLMClient()

# Use OpenAI
client.set_provider("openai", model="gpt-4")
response = client.query("Hello from GPT-4")

# Switch to Claude
client.set_provider("anthropic", model="claude-3-5-sonnet")
response = client.query("Hello from Claude")

# Use local Ollama
client.set_provider("ollama", model="llama3.1")
response = client.query("Hello from local Llama")
```

## Next Steps

- [CLI Reference](/docs/cli) - Explore all CLI commands
- [Provider Setup](/docs/providers) - Configure additional providers
- [Python SDK](/docs/sdk) - Full SDK documentation
- [Examples](/tutorials) - Real-world use cases
- [Configuration](/docs/config) - Advanced configuration

## Troubleshooting

### Provider Not Available

If you see "No providers available":
1. Check you've set at least one API key
2. Verify the key is correct
3. Run `llmswap providers` to see status

### API Key Issues

```bash
# Check if key is set
echo $OPENAI_API_KEY

# Set key in shell config (.bashrc, .zshrc, etc.)
echo 'export OPENAI_API_KEY="sk-..."' >> ~/.zshrc
source ~/.zshrc
```

### Ollama Connection Issues

```bash
# Check if Ollama is running
curl http://localhost:11434/api/tags

# Start Ollama service
ollama serve
```

## Getting Help

- **Documentation**: [llmswap.org](https://llmswap.org)
- **GitHub Issues**: [Report bugs](https://github.com/sreenathmmenon/llmswap/issues)
- **Examples**: [View examples](/tutorials)

---

Ready to explore more? Check out the [CLI Reference](/docs/cli) for all available commands.