---
layout: default
title: Home
nav_order: 1
description: "llmswap - Universal AI CLI supporting 8 LLM providers through one interface"
permalink: /
---

<div class="hero">
  <h1>Universal AI CLI</h1>
  <p class="hero-subtitle">8 Providers. One Interface. Zero Lock-in.</p>
  <div class="hero-buttons">
    <a href="#quick-install" class="btn">Quick Install</a>
    <a href="/docs/getting-started" class="btn">Get Started</a>
    <a href="https://github.com/sreenathmmenon/llmswap" class="btn">View on GitHub</a>
  </div>
</div>

## 🚀 Transform Your AI Workflow

**llmswap** is a universal AI CLI and Python SDK that lets you seamlessly use OpenAI, Claude, Gemini, Watson, Groq, Cohere, Perplexity, and local Ollama models through a single interface.

<div class="terminal-window">
  <div class="terminal-header">
    <span class="terminal-dot red"></span>
    <span class="terminal-dot yellow"></span>
    <span class="terminal-dot green"></span>
  </div>
  <pre><code class="language-bash">$ llmswap chat
🤖 Starting chat (Provider: claude)
You: What's the weather like?
Assistant: I don't have access to real-time weather data...

You: /switch gemini
🔄 Switched to gemini

You: Tell me about Python decorators
Assistant: Python decorators are a powerful feature...</code></pre>
</div>

## ⚡ Why llmswap?

<div class="feature-grid">
  <div class="feature-card">
    <h3>🔄 No Vendor Lock-in</h3>
    <p>Switch between 8 AI providers instantly. Use OpenAI today, Claude tomorrow - your choice.</p>
  </div>
  
  <div class="feature-card">
    <h3>💰 90% Cost Savings</h3>
    <p>Pay-per-use instead of subscriptions. Use cheaper providers for simple tasks, premium for complex ones.</p>
  </div>
  
  <div class="feature-card">
    <h3>🧠 Conversation Memory</h3>
    <p>Maintains context across messages. The AI remembers your conversation, just like ChatGPT.</p>
  </div>
  
  <div class="feature-card">
    <h3>🛠️ Code Generation</h3>
    <p>Natural language to code. Like GitHub Copilot CLI but works with any provider.</p>
  </div>
  
  <div class="feature-card">
    <h3>🏢 Enterprise Ready</h3>
    <p>Configuration management, async support, and production-grade architecture.</p>
  </div>
  
  <div class="feature-card">
    <h3>🔒 Privacy First</h3>
    <p>No conversation storage by default. Run locally with Ollama for complete privacy.</p>
  </div>
</div>

## 🤖 Supported Providers

<div class="provider-grid">
  <span class="provider-badge openai">OpenAI GPT-4</span>
  <span class="provider-badge anthropic">Claude 3.5</span>
  <span class="provider-badge gemini">Google Gemini</span>
  <span class="provider-badge watson">IBM Watson</span>
  <span class="provider-badge groq">Groq</span>
  <span class="provider-badge cohere">Cohere</span>
  <span class="provider-badge perplexity">Perplexity</span>
  <span class="provider-badge ollama">Ollama (Local)</span>
</div>

## 📊 Compare with Others

<div class="comparison-table">

| Feature | llmswap | GitHub Copilot CLI | Claude CLI | Gemini CLI |
|---------|---------|-------------------|------------|------------|
| **Providers** | 8 providers | 3 (locked) | 1 only | 1 only |
| **Cost** | Pay-per-use | $10/month | $20/month | Limited free |
| **Conversation Context** | <span class="check">✓</span> | <span class="check">✓</span> | <span class="check">✓</span> | <span class="check">✓</span> |
| **Provider Switching** | <span class="check">✓</span> | <span class="cross">✗</span> | <span class="cross">✗</span> | <span class="cross">✗</span> |
| **Local Models** | <span class="check">✓</span> | <span class="cross">✗</span> | <span class="cross">✗</span> | <span class="cross">✗</span> |
| **Code Generation** | <span class="check">✓</span> | <span class="check">✓</span> | <span class="cross">✗</span> | <span class="cross">✗</span> |
| **Cost Analytics** | <span class="check">✓</span> | <span class="cross">✗</span> | <span class="cross">✗</span> | <span class="cross">✗</span> |
| **Open Source** | <span class="check">✓</span> | <span class="cross">✗</span> | <span class="cross">✗</span> | <span class="cross">✗</span> |

</div>

## 🎯 Quick Examples

### Natural Language to Code
<div class="terminal-window">
  <pre><code class="language-bash">$ llmswap generate "create nginx config for load balancing"

upstream backend {
    server backend1.example.com:8080;
    server backend2.example.com:8080;
    server backend3.example.com:8080;
}

server {
    listen 80;
    location / {
        proxy_pass http://backend;
    }
}</code></pre>
</div>

### Interactive Chat with Context
<div class="terminal-window">
  <pre><code class="language-bash">$ llmswap chat
You: My name is Alice
Assistant: Nice to meet you, Alice! How can I help you today?

You: What's my name?
Assistant: Your name is Alice.</code></pre>
</div>

### Cost Comparison
<div class="terminal-window">
  <pre><code class="language-bash">$ llmswap compare --input-tokens 1000 --output-tokens 500

Provider Cost Comparison:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Provider    | Cost    | Savings
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ollama      | $0.000  | 100%
Groq        | $0.001  | 95%
Gemini      | $0.002  | 90%
Claude      | $0.015  | 25%
GPT-4       | $0.020  | 0%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━</code></pre>
</div>

## 🚀 Quick Install {#quick-install}

<div class="install-tabs">
  <div class="tab-header">
    <button class="tab active" onclick="showTab(event, 'pip')">pip</button>
    <button class="tab" onclick="showTab(event, 'homebrew')">Homebrew</button>
    <button class="tab" onclick="showTab(event, 'source')">From Source</button>
  </div>
  <div class="tab-content">
    <div id="pip" class="tab-pane active">
      <pre><code class="language-bash"># Install with pip
pip install llmswap

# Set up your preferred provider (only need one)
export OPENAI_API_KEY="sk-..."
export ANTHROPIC_API_KEY="sk-ant-..."
export GEMINI_API_KEY="..."

# Start using
llmswap chat</code></pre>
    </div>
    <div id="homebrew" class="tab-pane">
      <pre><code class="language-bash"># Install with Homebrew
brew install llmswap/tap/llmswap

# Configure provider
export ANTHROPIC_API_KEY="sk-ant-..."

# Start using
llmswap chat</code></pre>
    </div>
    <div id="source" class="tab-pane">
      <pre><code class="language-bash"># Clone repository
git clone https://github.com/sreenathmmenon/llmswap
cd llmswap

# Install dependencies
pip install -e .

# Configure and run
export OPENAI_API_KEY="sk-..."
llmswap chat</code></pre>
    </div>
  </div>
</div>

## 📈 Trusted by Developers

<div class="stats-grid">
  <div class="stat-card">
    <h3>11K+</h3>
    <p>Downloads in 50 days</p>
  </div>
  <div class="stat-card">
    <h3>8</h3>
    <p>AI Providers</p>
  </div>
  <div class="stat-card">
    <h3>40+</h3>
    <p>Models Supported</p>
  </div>
  <div class="stat-card">
    <h3>90%</h3>
    <p>Cost Savings</p>
  </div>
</div>

## 🎓 Learn More

- [Getting Started Guide](/docs/getting-started) - 5-minute quickstart
- [CLI Reference](/docs/cli) - Complete command documentation
- [Python SDK](/docs/sdk) - Use llmswap in your Python code
- [Provider Setup](/docs/providers) - Configure each AI provider
- [Examples](/tutorials) - Real-world use cases

## 🌟 Get Involved

<div class="cta-section">
  <a href="https://github.com/sreenathmmenon/llmswap" class="btn-primary">Star on GitHub</a>
  <a href="/docs/getting-started" class="btn-secondary">Documentation</a>
  <a href="https://github.com/sreenathmmenon/llmswap/issues" class="btn-secondary">Report Issue</a>
</div>

<script>
function showTab(evt, tabName) {
  var i, tabpane, tabs;
  tabpane = document.getElementsByClassName("tab-pane");
  for (i = 0; i < tabpane.length; i++) {
    tabpane[i].classList.remove("active");
  }
  tabs = document.getElementsByClassName("tab");
  for (i = 0; i < tabs.length; i++) {
    tabs[i].classList.remove("active");
  }
  document.getElementById(tabName).classList.add("active");
  evt.currentTarget.classList.add("active");
}
</script>

<style>
.feature-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.provider-grid {
  display: flex;
  flex-wrap: wrap;
  gap: 0.5rem;
  margin: 2rem 0;
  justify-content: center;
}

.stats-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(150px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
  text-align: center;
}

.stat-card {
  padding: 1.5rem;
  border: 1px solid #E5E7EB;
  border-radius: 0.5rem;
  background: #F9FAFB;
}

.stat-card h3 {
  font-size: 2rem;
  color: #6B46C1;
  margin: 0;
}

.cta-section {
  display: flex;
  gap: 1rem;
  justify-content: center;
  margin: 3rem 0;
  flex-wrap: wrap;
}

.btn-primary, .btn-secondary {
  padding: 0.75rem 1.5rem;
  border-radius: 0.5rem;
  text-decoration: none;
  font-weight: 600;
  display: inline-block;
  transition: transform 0.2s;
}

.btn-primary {
  background: #6B46C1;
  color: white;
}

.btn-secondary {
  background: #F3F4F6;
  color: #374151;
  border: 1px solid #E5E7EB;
}

.btn-primary:hover, .btn-secondary:hover {
  transform: translateY(-2px);
}
</style>