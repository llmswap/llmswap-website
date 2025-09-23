---
layout: default
title: Tutorials
nav_order: 3
has_children: true
---

# Tutorials & Examples
{: .no_toc }

Real-world examples and practical tutorials for llmswap.
{: .fs-6 .fw-300 }

---

## Quick Examples

### 🚀 DevOps & System Administration

```bash
# Generate Docker Compose file
llmswap generate "docker compose for WordPress with MySQL"

# Debug server error
llmswap debug --error "nginx: [emerg] bind() to 0.0.0.0:80 failed"

# Analyze logs
llmswap logs --analyze /var/log/system.log --since "1h ago"
```

### 💻 Development Workflows

```bash
# Code review
llmswap review api.py --focus security

# Generate unit tests
llmswap generate "pytest tests for user authentication" --save test_auth.py

# Fix code issues
llmswap debug --file error.log --language python
```

### 📊 Data Science

```python
from llmswap import LLMClient

client = LLMClient()

# Generate data cleaning code
response = client.query("""
Generate pandas code to:
1. Load CSV with proper encoding
2. Handle missing values
3. Remove duplicates
4. Standardize column names
""")
print(response.content)
```

### 🎯 Cost Optimization

```bash
# Compare provider costs
llmswap compare --input-tokens 100000 --output-tokens 50000

# Check monthly spending
llmswap costs --days 30

# Use cheaper provider for simple tasks
llmswap ask "What time is it in Tokyo?" --provider gemini
```

---

## Featured Tutorials

<div class="tutorial-grid">
  <div class="tutorial-card">
    <h3>📱 Build a Chatbot</h3>
    <p>Create an intelligent chatbot with conversation memory and provider switching.</p>
    <a href="/tutorials/chatbot">View Tutorial →</a>
  </div>
  
  <div class="tutorial-card">
    <h3>🔄 Replace GitHub Copilot</h3>
    <p>Use llmswap as a free alternative to GitHub Copilot CLI.</p>
    <a href="/tutorials/copilot-alternative">View Tutorial →</a>
  </div>
  
  <div class="tutorial-card">
    <h3>💰 Cost Optimization Guide</h3>
    <p>Reduce AI costs by 90% with smart provider selection.</p>
    <a href="/tutorials/cost-optimization">View Tutorial →</a>
  </div>
  
  <div class="tutorial-card">
    <h3>🏢 Enterprise Setup</h3>
    <p>Configure llmswap for team use with security and compliance.</p>
    <a href="/tutorials/enterprise">View Tutorial →</a>
  </div>
  
  <div class="tutorial-card">
    <h3>🤖 RAG Implementation</h3>
    <p>Build a retrieval-augmented generation system.</p>
    <a href="/tutorials/rag-system">View Tutorial →</a>
  </div>
  
  <div class="tutorial-card">
    <h3>🔒 Local AI Setup</h3>
    <p>Run completely offline with Ollama models.</p>
    <a href="/tutorials/local-setup">View Tutorial →</a>
  </div>
</div>

---

## Code Snippets

### Vim Integration

```vim
" Add to .vimrc
" Generate code with ,g
nnoremap ,g :r !llmswap generate "

" Review current file with ,r
nnoremap ,r :!llmswap review %<CR>

" Get help with error under cursor
nnoremap ,d :exec '!llmswap debug --error "' . getline('.') . '"'<CR>
```

### Shell Aliases

```bash
# Add to .bashrc or .zshrc
alias ai='llmswap ask'
alias aic='llmswap chat'
alias aigen='llmswap generate'
alias aicode='llmswap review'

# Quick provider switching
alias ai-gpt='llmswap chat --provider openai'
alias ai-claude='llmswap chat --provider anthropic'
alias ai-local='llmswap chat --provider ollama'
```

### Git Hooks

```bash
#!/bin/bash
# .git/hooks/pre-commit

# AI code review before commit
files=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.(py|js|ts)$')
for file in $files; do
    echo "Reviewing $file..."
    llmswap review "$file" --focus bugs --quiet
done
```

---

## Integration Examples

### VS Code Task

```json
{
  "version": "2.0.0",
  "tasks": [
    {
      "label": "AI Review",
      "type": "shell",
      "command": "llmswap review ${file}",
      "problemMatcher": []
    },
    {
      "label": "Generate Tests",
      "type": "shell", 
      "command": "llmswap generate 'unit tests for ${file}' --save ${fileDirname}/test_${fileBasename}",
      "problemMatcher": []
    }
  ]
}
```

### GitHub Actions

```yaml
name: AI Code Review
on: [pull_request]

jobs:
  review:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - name: Install llmswap
        run: pip install llmswap
      - name: Review Changes
        env:
          ANTHROPIC_API_KEY: ${{ secrets.ANTHROPIC_API_KEY }}
        run: |
          for file in $(git diff --name-only origin/main...HEAD); do
            llmswap review "$file" --focus security
          done
```

---

## Browse All Tutorials

- [Build a Chatbot](/tutorials/chatbot) - Complete chatbot implementation
- [GitHub Copilot Alternative](/tutorials/copilot-alternative) - Code generation workflows
- [Cost Optimization](/tutorials/cost-optimization) - Save 90% on AI costs
- [Enterprise Setup](/tutorials/enterprise) - Team configuration
- [RAG System](/tutorials/rag-system) - Document Q&A system
- [Local Setup](/tutorials/local-setup) - Offline AI with Ollama

<style>
.tutorial-grid {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(280px, 1fr));
  gap: 1.5rem;
  margin: 2rem 0;
}

.tutorial-card {
  border: 1px solid #E5E7EB;
  border-radius: 0.5rem;
  padding: 1.5rem;
  background: white;
  transition: transform 0.2s, box-shadow 0.2s;
}

.tutorial-card:hover {
  transform: translateY(-2px);
  box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1);
}

.tutorial-card h3 {
  margin-top: 0;
  color: #6B46C1;
}

.tutorial-card a {
  font-weight: 600;
  color: #6B46C1;
}
</style>