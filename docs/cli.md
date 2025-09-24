---
layout: default
title: CLI Reference
parent: Documentation
nav_order: 2
---

# CLI Reference
{: .no_toc }

Complete reference for all llmswap CLI commands.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Core Commands

### llmswap ask

Quick one-off questions to AI.

```bash
llmswap ask "Your question here"
```

**Options:**
- `--provider PROVIDER` - Specify provider (openai, anthropic, gemini, etc.)
- `--no-cache` - Disable response caching
- `--quiet` - Minimal output
- `--age N` - Adapt language for age N
- `--audience TYPE` - Target audience (developer, student, business, etc.)
- `--teach` - Enable teaching mode
- `--explain` - Add detailed explanations

**Examples:**
```bash
# Simple question
llmswap ask "What is Docker?"

# Explain to a specific audience
llmswap ask "Explain kubernetes" --audience "business owner"

# Age-appropriate explanation
llmswap ask "What is AI?" --age 10

# Use specific provider
llmswap ask "Generate a UUID" --provider openai
```

---

### llmswap chat

Start an interactive chat session with conversation memory.

```bash
llmswap chat
```

**Options:**
- `--provider PROVIDER` - Initial provider
- `--no-cache` - Disable caching
- `--age N` - Set age context for session
- `--audience TYPE` - Set target audience

**Chat Commands:**
- `/help` - Show available commands
- `/provider` - Show current provider
- `/switch <provider>` - Switch to different provider
- `/clear` - Clear conversation history
- `/stats` - Show session statistics
- `/age N` - Update age context
- `/audience TYPE` - Update audience
- `/quit` or `/exit` - End chat session

**Example Session:**

<div class="terminal-window">
  <div class="terminal-header">
    <span class="terminal-dot red"></span>
    <span class="terminal-dot yellow"></span>
    <span class="terminal-dot green"></span>
  </div>
  <pre><code>$ llmswap chat
🤖 Starting chat with claude-3-5-sonnet
You: Hello, my name is Sarah
Assistant: Hello Sarah! Nice to meet you. How can I help you today?
You: /switch gemini
🔄 Switched to gemini
You: What's my name?
Assistant: Your name is Sarah.
You: /stats
📊 Session Statistics:
Messages: 4
Total tokens: 156
Session duration: 2m 15s
You: /quit
👋 Goodbye!</code></pre>
</div>

---

### llmswap generate

Generate code or commands from natural language descriptions.

```bash
llmswap generate "description of what you want"
```

**Options:**
- `--language LANG` - Target programming language
- `--execute` - Execute generated bash commands (with confirmation)
- `--save FILENAME` - Save output to file
- `--explain` - Add explanations to generated code
- `--provider PROVIDER` - Use specific provider

**Examples:**
```bash
# Generate bash command
llmswap generate "find files larger than 100MB"
# Output: find . -type f -size +100M

# Generate Python code
llmswap generate "async function to fetch JSON from API" --language python

# Generate and save
llmswap generate "nginx reverse proxy config" --save nginx.conf

# Generate and execute (asks for confirmation)
llmswap generate "create Python project structure" --execute
```

---

### llmswap review

AI-powered code review for your files.

```bash
llmswap review <file>
```

**Options:**
- `--focus AREA` - Focus area: bugs, security, style, performance, general
- `--language LANG` - Override detected language
- `--provider PROVIDER` - Use specific provider

**Examples:**
```bash
# General review
llmswap review app.py

# Security-focused review
llmswap review api.js --focus security

# Performance review
llmswap review database.py --focus performance

# Style review
llmswap review components/Header.jsx --focus style
```

---

### llmswap debug

Analyze errors and get debugging help.

```bash
llmswap debug --error "error message"
llmswap debug --file error.log
```

**Options:**
- `--error MESSAGE` - Error message to analyze
- `--file FILE` - File containing error/logs
- `--context` - Include system context
- `--language LANG` - Programming language context

**Examples:**
```bash
# Debug an error message
llmswap debug --error "TypeError: Cannot read property 'map' of undefined"

# Analyze error log
llmswap debug --file npm-debug.log

# Debug with context
llmswap debug --error "Connection refused" --language python --context
```

---

### llmswap providers

Show status of all configured providers.

```bash
llmswap providers
```

**Output Example:**
```
╭─────────────┬──────────┬──────────────────────┬─────────────────────╮
│ Provider    │ Status   │ Model                │ Issue               │
├─────────────┼──────────┼──────────────────────┼─────────────────────┤
│ ANTHROPIC   │ ✓ Ready  │ claude-3-5-sonnet    │                     │
│ OPENAI      │ ✓ Ready  │ gpt-4o               │                     │
│ GEMINI      │ ✗        │                      │ Missing API key     │
│ COHERE      │ ✓ Ready  │ command-r-plus       │                     │
│ PERPLEXITY  │ ✗        │                      │ Missing API key     │
│ WATSONX     │ ✗        │                      │ Missing project ID  │
│ GROQ        │ ✓ Ready  │ llama-3.3-70b        │                     │
│ OLLAMA      │ ✓ Ready  │ llama3.1             │                     │
╰─────────────┴──────────┴──────────────────────┴─────────────────────╯
```

---

## Analytics Commands

### llmswap compare

Compare costs across providers for a given token count.

```bash
llmswap compare --input-tokens <N> --output-tokens <N>
```

**Options:**
- `--input-tokens N` - Number of input tokens
- `--output-tokens N` - Number of output tokens
- `--monthly` - Show monthly cost projection

**Example:**
```bash
$ llmswap compare --input-tokens 1000 --output-tokens 500

Provider Cost Comparison (1000 input, 500 output tokens):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Provider    │ Cost      │ Savings vs Most Expensive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ollama      │ $0.0000   │ 100.0%
Groq        │ $0.0001   │ 99.5%
Gemini      │ $0.0019   │ 90.5%
Claude      │ $0.0150   │ 25.0%
GPT-4       │ $0.0200   │ 0.0%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### llmswap usage

View usage statistics and analytics.

```bash
llmswap usage [--days N]
```

**Options:**
- `--days N` - Show last N days (default: 7)
- `--provider PROVIDER` - Filter by provider
- `--export FILE` - Export to CSV/JSON

**Example:**
```bash
$ llmswap usage --days 30

Usage Statistics (Last 30 days):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Provider    │ Queries │ Tokens    │ Cost
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OpenAI      │ 142     │ 45,231    │ $2.15
Anthropic   │ 89      │ 31,452    │ $1.87
Gemini      │ 203     │ 67,891    │ $0.45
Ollama      │ 567     │ 234,567   │ $0.00
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total       │ 1,001   │ 379,141   │ $4.47
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### llmswap costs

Get cost analysis and optimization recommendations.

```bash
llmswap costs
```

**Output includes:**
- Current month's spending
- Cost breakdown by provider
- Optimization recommendations
- Potential savings

---

## Configuration Commands

### llmswap config

Manage llmswap configuration.

```bash
llmswap config <action> [options]
```

**Actions:**
- `set KEY VALUE` - Set configuration value
- `get KEY` - Get configuration value
- `unset KEY` - Remove configuration key
- `show [SECTION]` - Display configuration
- `reset [SECTION]` - Reset to defaults
- `export --file FILE` - Export configuration
- `import --file FILE` - Import configuration
- `validate` - Validate configuration
- `doctor` - Run diagnostics

**Examples:**
```bash
# Set default provider
llmswap config set provider.default anthropic

# Set model for specific provider
llmswap config set provider.models.openai gpt-4-turbo

# View all configuration
llmswap config show

# Reset provider settings
llmswap config reset provider

# Export configuration
llmswap config export --file my-config.yaml
```

---

## Advanced Commands

### llmswap logs

Analyze log files with AI assistance.

```bash
llmswap logs --analyze <logfile>
```

**Options:**
- `--analyze FILE` - Log file to analyze
- `--since TIME` - Filter logs since time
- `--level LEVEL` - Filter by log level
- `--pattern PATTERN` - Search pattern
- `--correlate` - Find correlated events

**Examples:**
```bash
# Analyze application logs
llmswap logs --analyze app.log

# Find errors in last 2 hours
llmswap logs --analyze system.log --since "2h ago" --level error

# Correlate events
llmswap logs --analyze nginx.log --correlate
```

---

## Global Options

These options work with all commands:

- `--provider PROVIDER` - Override provider selection
- `--no-cache` - Disable response caching
- `--quiet` - Minimal output mode
- `--debug` - Enable debug output
- `--version` - Show version information
- `--help` - Show help for any command

## Environment Variables

Configure providers via environment variables:

```bash
# OpenAI
export OPENAI_API_KEY="sk-..."

# Anthropic
export ANTHROPIC_API_KEY="sk-ant-..."

# Google Gemini
export GEMINI_API_KEY="..."

# IBM Watson
export WATSONX_API_KEY="..."
export WATSONX_PROJECT_ID="..."

# Groq
export GROQ_API_KEY="gsk_..."

# Cohere
export COHERE_API_KEY="..."

# Perplexity
export PERPLEXITY_API_KEY="pplx-..."
```

## Exit Codes

- `0` - Success
- `1` - General error
- `2` - Configuration error
- `3` - Provider error
- `4` - Network error
- `5` - Authentication error

---

Need more help? Check out our [tutorials](/tutorials) for real-world examples.