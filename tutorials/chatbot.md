---
layout: default
title: Build a Chatbot
parent: Tutorials
nav_order: 1
---

# Build an Intelligent Chatbot with llmswap
{: .no_toc }

Create a production-ready chatbot with conversation memory, provider switching, and cost optimization.
{: .fs-6 .fw-300 }

## Table of contents
{: .no_toc .text-delta }

1. TOC
{:toc}

---

## Overview

In this tutorial, we'll build a complete chatbot that:
- Maintains conversation context
- Switches between AI providers
- Tracks costs in real-time
- Handles errors gracefully
- Saves conversation history

**Time Required**: 20 minutes  
**Prerequisites**: Python 3.8+, llmswap installed

## Part 1: Basic Chatbot

Let's start with a simple chatbot class:

```python
# chatbot.py
from llmswap import LLMClient
import json
from datetime import datetime

class IntelligentChatbot:
    def __init__(self, provider="auto"):
        """Initialize chatbot with specified provider."""
        self.client = LLMClient(provider=provider)
        self.messages = []
        self.session_start = datetime.now()
        self.total_cost = 0.0
        
    def chat(self, user_input):
        """Process user input and return response."""
        # Add user message to history
        self.messages.append({
            "role": "user",
            "content": user_input
        })
        
        # Get AI response
        response = self.client.chat(
            self.messages,
            cache_bypass=True  # Don't cache conversations
        )
        
        # Add assistant response to history
        self.messages.append({
            "role": "assistant",
            "content": response.content
        })
        
        # Track costs
        if response.usage:
            self.total_cost += self._estimate_cost(response)
        
        return response
    
    def _estimate_cost(self, response):
        """Estimate cost based on token usage."""
        # Simplified cost calculation
        tokens = response.usage.get('total_tokens', 0)
        rate_per_1k = 0.01  # Default rate
        return (tokens / 1000) * rate_per_1k
```

## Part 2: Add Advanced Features

Now let's enhance our chatbot with more capabilities:

```python
# enhanced_chatbot.py
from llmswap import LLMClient
import json
import os
from datetime import datetime
from typing import Dict, List, Optional

class EnhancedChatbot:
    def __init__(self, 
                 provider: str = "auto",
                 system_prompt: Optional[str] = None,
                 save_history: bool = True):
        """
        Initialize enhanced chatbot.
        
        Args:
            provider: AI provider to use
            system_prompt: Optional system message to set context
            save_history: Whether to save conversation history
        """
        self.client = LLMClient(provider=provider)
        self.messages = []
        self.session_id = datetime.now().strftime("%Y%m%d_%H%M%S")
        self.save_history = save_history
        self.stats = {
            "messages": 0,
            "total_tokens": 0,
            "total_cost": 0.0,
            "providers_used": set(),
            "session_start": datetime.now()
        }
        
        # Add system prompt if provided
        if system_prompt:
            self.messages.append({
                "role": "system",
                "content": system_prompt
            })
    
    def chat(self, user_input: str) -> Dict:
        """
        Process user input and return structured response.
        
        Returns:
            Dict with response, provider, cost, and tokens
        """
        # Handle special commands
        if user_input.startswith("/"):
            return self._handle_command(user_input)
        
        # Add user message
        self.messages.append({
            "role": "user",
            "content": user_input
        })
        
        try:
            # Get AI response
            response = self.client.chat(
                self.messages,
                cache_bypass=True
            )
            
            # Add to history
            self.messages.append({
                "role": "assistant",
                "content": response.content
            })
            
            # Update statistics
            self._update_stats(response)
            
            # Save conversation if enabled
            if self.save_history:
                self._save_conversation()
            
            return {
                "content": response.content,
                "provider": response.provider,
                "model": response.model,
                "tokens": response.usage.get('total_tokens', 0),
                "latency": response.latency
            }
            
        except Exception as e:
            return {
                "content": f"Error: {str(e)}",
                "provider": "error",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
    
    def _handle_command(self, command: str) -> Dict:
        """Handle special chatbot commands."""
        cmd = command.lower().strip()
        
        if cmd == "/help":
            return {
                "content": """Available commands:
/help - Show this help message
/stats - Show conversation statistics
/switch <provider> - Switch AI provider
/save - Save conversation to file
/clear - Clear conversation history
/providers - List available providers""",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
        
        elif cmd == "/stats":
            duration = datetime.now() - self.stats["session_start"]
            return {
                "content": f"""Session Statistics:
Messages: {self.stats['messages']}
Total Tokens: {self.stats['total_tokens']}
Estimated Cost: ${self.stats['total_cost']:.4f}
Duration: {duration}
Providers Used: {', '.join(self.stats['providers_used'])}""",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
        
        elif cmd.startswith("/switch "):
            new_provider = cmd.split(" ", 1)[1]
            try:
                self.client.set_provider(new_provider)
                return {
                    "content": f"Switched to {new_provider}",
                    "provider": "system",
                    "model": "none",
                    "tokens": 0,
                    "latency": 0
                }
            except Exception as e:
                return {
                    "content": f"Failed to switch: {e}",
                    "provider": "system",
                    "model": "none",
                    "tokens": 0,
                    "latency": 0
                }
        
        elif cmd == "/clear":
            self.messages = []
            self.stats["messages"] = 0
            return {
                "content": "Conversation cleared",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
        
        elif cmd == "/save":
            filename = self._save_conversation()
            return {
                "content": f"Conversation saved to {filename}",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
        
        elif cmd == "/providers":
            providers = self.client.get_available_providers()
            current = self.client.get_current_provider()
            provider_list = "\n".join([
                f"• {p} {'(current)' if p == current else ''}"
                for p in providers
            ])
            return {
                "content": f"Available providers:\n{provider_list}",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
        
        else:
            return {
                "content": f"Unknown command: {command}",
                "provider": "system",
                "model": "none",
                "tokens": 0,
                "latency": 0
            }
    
    def _update_stats(self, response):
        """Update conversation statistics."""
        self.stats["messages"] += 2  # User + Assistant
        if response.usage:
            tokens = response.usage.get('total_tokens', 0)
            self.stats["total_tokens"] += tokens
            # Estimate cost (simplified)
            self.stats["total_cost"] += (tokens / 1000) * 0.01
        self.stats["providers_used"].add(response.provider)
    
    def _save_conversation(self) -> str:
        """Save conversation to JSON file."""
        filename = f"chat_{self.session_id}.json"
        data = {
            "session_id": self.session_id,
            "timestamp": datetime.now().isoformat(),
            "messages": self.messages,
            "statistics": {
                **self.stats,
                "providers_used": list(self.stats["providers_used"]),
                "session_start": self.stats["session_start"].isoformat()
            }
        }
        
        with open(filename, 'w') as f:
            json.dump(data, f, indent=2)
        
        return filename
    
    def load_conversation(self, filename: str):
        """Load a previous conversation."""
        with open(filename, 'r') as f:
            data = json.load(f)
        self.messages = data["messages"]
        self.session_id = data["session_id"]
        print(f"Loaded conversation from {filename}")
```

## Part 3: Interactive CLI Interface

Create a user-friendly command-line interface:

```python
# cli_chatbot.py
import sys
from enhanced_chatbot import EnhancedChatbot
from rich.console import Console
from rich.panel import Panel
from rich.markdown import Markdown
from rich.table import Table

console = Console()

def run_chatbot():
    """Run interactive chatbot session."""
    
    # Welcome message
    console.print(Panel.fit(
        "[bold cyan]🤖 Intelligent Chatbot powered by llmswap[/bold cyan]\n"
        "Type '/help' for commands, 'quit' to exit",
        border_style="cyan"
    ))
    
    # Initialize chatbot
    bot = EnhancedChatbot(
        system_prompt="You are a helpful, friendly AI assistant."
    )
    
    # Main chat loop
    while True:
        try:
            # Get user input
            user_input = console.input("\n[bold green]You:[/bold green] ")
            
            # Check for quit
            if user_input.lower() in ['quit', 'exit', 'bye']:
                console.print("[yellow]Goodbye! 👋[/yellow]")
                # Show final stats
                stats = bot.chat("/stats")
                console.print(Panel(stats["content"], title="Session Summary"))
                break
            
            # Get bot response
            console.print("[dim]Thinking...[/dim]", end="\r")
            response = bot.chat(user_input)
            
            # Clear thinking message
            console.print(" " * 20, end="\r")
            
            # Display response
            if response["provider"] == "system":
                # System message
                console.print(Panel(
                    response["content"],
                    title="System",
                    border_style="yellow"
                ))
            else:
                # AI response
                console.print(f"[bold blue]Assistant[/bold blue] "
                            f"[dim]({response['provider']}/{response['model']})[/dim]:")
                console.print(Markdown(response["content"]))
                
                # Show metrics
                if response["tokens"] > 0:
                    console.print(
                        f"[dim]Tokens: {response['tokens']} | "
                        f"Time: {response['latency']:.2f}s[/dim]"
                    )
        
        except KeyboardInterrupt:
            console.print("\n[yellow]Use 'quit' to exit properly[/yellow]")
        except Exception as e:
            console.print(f"[red]Error: {e}[/red]")

if __name__ == "__main__":
    run_chatbot()
```

## Part 4: Web Interface (Bonus)

Create a simple web interface using Flask:

```python
# web_chatbot.py
from flask import Flask, render_template, request, jsonify
from enhanced_chatbot import EnhancedChatbot
import os

app = Flask(__name__)
chatbots = {}  # Store chatbot instances per session

@app.route('/')
def index():
    return render_template('chat.html')

@app.route('/chat', methods=['POST'])
def chat():
    data = request.json
    session_id = data.get('session_id', 'default')
    message = data.get('message', '')
    
    # Get or create chatbot for this session
    if session_id not in chatbots:
        chatbots[session_id] = EnhancedChatbot()
    
    bot = chatbots[session_id]
    response = bot.chat(message)
    
    return jsonify(response)

@app.route('/new_session', methods=['POST'])
def new_session():
    session_id = request.json.get('session_id')
    chatbots[session_id] = EnhancedChatbot()
    return jsonify({"status": "created"})

if __name__ == '__main__':
    app.run(debug=True)
```

## Part 5: Testing Your Chatbot

Create tests to ensure reliability:

```python
# test_chatbot.py
import pytest
from enhanced_chatbot import EnhancedChatbot

def test_basic_conversation():
    """Test basic conversation flow."""
    bot = EnhancedChatbot()
    
    # First message
    response = bot.chat("Hello, my name is Alice")
    assert response["content"]
    assert response["provider"]
    
    # Follow-up should remember context
    response = bot.chat("What's my name?")
    assert "Alice" in response["content"]

def test_provider_switching():
    """Test switching between providers."""
    bot = EnhancedChatbot()
    
    # Switch provider
    response = bot.chat("/switch gemini")
    assert "Switched" in response["content"]
    
    # Verify provider changed
    response = bot.chat("Hello")
    assert response["provider"] == "gemini"

def test_statistics_tracking():
    """Test that statistics are tracked correctly."""
    bot = EnhancedChatbot()
    
    # Send messages
    bot.chat("Message 1")
    bot.chat("Message 2")
    
    # Check stats
    response = bot.chat("/stats")
    assert "Messages: 4" in response["content"]

def test_conversation_saving():
    """Test saving and loading conversations."""
    bot = EnhancedChatbot()
    
    # Have a conversation
    bot.chat("Test message")
    
    # Save it
    response = bot.chat("/save")
    assert "saved to" in response["content"]
    
    # Verify file exists
    import os
    files = [f for f in os.listdir('.') if f.startswith('chat_')]
    assert len(files) > 0

# Run tests
if __name__ == "__main__":
    pytest.main([__file__, "-v"])
```

## Deployment Considerations

### 1. Environment Variables

```bash
# .env file
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GEMINI_API_KEY=...
DEFAULT_PROVIDER=anthropic
```

### 2. Docker Container

```dockerfile
# Dockerfile
FROM python:3.9-slim

WORKDIR /app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY . .

CMD ["python", "web_chatbot.py"]
```

### 3. Production Settings

```python
# config.py
import os

class Config:
    # Provider settings
    DEFAULT_PROVIDER = os.getenv('DEFAULT_PROVIDER', 'anthropic')
    FALLBACK_ENABLED = True
    
    # Caching
    CACHE_ENABLED = False  # Disable for conversations
    
    # Rate limiting
    MAX_REQUESTS_PER_MINUTE = 20
    
    # Cost controls
    MAX_TOKENS_PER_MESSAGE = 4000
    MAX_COST_PER_SESSION = 1.00
    
    # Security
    ALLOWED_PROVIDERS = ['openai', 'anthropic', 'gemini']
    SANITIZE_INPUTS = True
```

## Complete Example Usage

```python
# main.py
from enhanced_chatbot import EnhancedChatbot

def main():
    # Create chatbot with custom system prompt
    bot = EnhancedChatbot(
        provider="anthropic",
        system_prompt="""You are a helpful customer service assistant 
        for an e-commerce company. Be friendly, professional, and 
        solution-oriented."""
    )
    
    # Simulate customer service conversation
    conversations = [
        "Hi, I have a problem with my order",
        "The order number is #12345",
        "It was supposed to arrive yesterday",
        "/stats",
        "/switch gemini",  # Switch to cheaper provider
        "Can you check the tracking?",
        "Thanks for your help!"
    ]
    
    for message in conversations:
        response = bot.chat(message)
        print(f"\nUser: {message}")
        print(f"Bot ({response['provider']}): {response['content'][:200]}...")
        if response['tokens'] > 0:
            print(f"[Tokens: {response['tokens']}, Time: {response['latency']:.2f}s]")

if __name__ == "__main__":
    main()
```

## Summary

You've now built a production-ready chatbot with:
- ✅ Conversation memory
- ✅ Provider switching
- ✅ Cost tracking
- ✅ Error handling
- ✅ Command system
- ✅ Conversation saving
- ✅ Statistics tracking

### Next Steps

1. **Add a database** for persistent storage
2. **Implement user authentication**
3. **Add rate limiting** for production use
4. **Create a React frontend** for better UX
5. **Deploy to cloud** (AWS, GCP, Azure)

### Resources

- [llmswap Documentation](/docs)
- [Python SDK Reference](/docs/sdk)
- [Provider Setup Guide](/docs/providers)
- [Cost Optimization Tutorial](/tutorials/cost-optimization)

---

Happy coding! 🚀