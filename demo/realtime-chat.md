# Real-Time llmswap Demo Session

## Developer Workflow: Multi-Provider AI for DevOps

```bash
$ llmswap providers
╭─────────────┬──────────┬──────────────────────┬─────────────────────╮
│ Provider    │ Status   │ Model                │ Issue               │
├─────────────┼──────────┼──────────────────────┼─────────────────────┤
│ ANTHROPIC   │ ✓ Ready  │ claude-3-5-sonnet    │                     │
│ OPENAI      │ ✓ Ready  │ gpt-4o               │                     │
│ GEMINI      │ ✓ Ready  │ gemini-1.5-pro       │                     │
│ GROQ        │ ✓ Ready  │ llama-3.3-70b        │                     │
│ OLLAMA      │ ✓ Ready  │ llama3.1             │                     │
╰─────────────┴──────────┴──────────────────────┴─────────────────────╯

$ llmswap chat
🤖 Starting chat with claude-3-5-sonnet (Tokens: 0, Cost: $0.00)

You: I'm debugging a Kubernetes deployment that's failing. The pods keep restarting.

Claude: I can help you troubleshoot the pod restart issue. Let's start by gathering some information:

1. First, let's check the pod status and recent events:
   ```bash
   kubectl get pods -o wide
   kubectl describe pod <pod-name>
   kubectl logs <pod-name> --previous
   ```

2. Common causes for pod restarts include:
   - Memory/CPU limits exceeded (OOMKilled)
   - Failed health checks
   - Application crashes
   - Configuration issues

What's the current status when you run `kubectl get pods`? Are you seeing any specific error messages?

You: Here's what I see:
```
NAME                    READY   STATUS             RESTARTS   AGE
web-app-7d4b8c6f9-x2k8r 0/1     CrashLoopBackOff   5          8m
```

The logs show: "Error: ENOENT: no such file or directory, open '/app/config.json'"

Claude: Perfect! This is a common issue. The error indicates your application is looking for `/app/config.json` but it doesn't exist in the container. Here are a few solutions:

**Option 1: ConfigMap approach**
```bash
# Create a ConfigMap with your config
kubectl create configmap app-config --from-file=config.json=./local-config.json

# Then mount it in your deployment
```

**Option 2: Check your Docker build**
Make sure your Dockerfile includes:
```dockerfile
COPY config.json /app/config.json
```

Which approach fits your setup better? Do you have the config file locally, or should we create it as a ConfigMap?

You: /switch groq

🔄 Switched to groq (llama-3.3-70b-versatile)
Tokens: 289 → 289 | Cost: $0.00 → $0.00

You: Actually, let me try the ConfigMap approach. How do I mount it properly?

Groq: Here's how to mount the ConfigMap properly in your deployment:

**1. Create the ConfigMap:**
```bash
kubectl create configmap app-config --from-literal=config.json='{"port": 3000, "env": "production"}'
```

**2. Update your deployment YAML:**
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
spec:
  template:
    spec:
      containers:
      - name: web-app
        image: your-image:latest
        volumeMounts:
        - name: config-volume
          mountPath: /app/config.json
          subPath: config.json
      volumes:
      - name: config-volume
        configMap:
          name: app-config
```

**3. Apply the changes:**
```bash
kubectl apply -f deployment.yaml
kubectl rollout restart deployment/web-app
```

The key is using `subPath: config.json` to mount just the file, not the entire directory. This prevents overwriting your `/app` folder.

Want me to help you customize this for your specific config needs?

You: Perfect! Let me try this... 

```bash
$ kubectl create configmap app-config --from-file=config.json
configmap/app-config created

$ kubectl patch deployment web-app -p '{"spec":{"template":{"spec":{"volumes":[{"name":"config-volume","configMap":{"name":"app-config"}}],"containers":[{"name":"web-app","volumeMounts":[{"name":"config-volume","mountPath":"/app/config.json","subPath":"config.json"}]}]}}}}'
deployment.apps/web-app patched

$ kubectl get pods -w
NAME                       READY   STATUS    RESTARTS   AGE
web-app-85f7d6c4b6-m9x2k   1/1     Running   0          30s
```

It's working! The pod is now running successfully.

Groq: Excellent work! 🎉 Your deployment is now healthy. The ConfigMap approach solved the missing config file issue perfectly.

**Quick validation steps:**
```bash
# Verify the config is mounted correctly
kubectl exec web-app-85f7d6c4b6-m9x2k -- cat /app/config.json

# Check application logs to ensure it's starting properly  
kubectl logs web-app-85f7d6c4b6-m9x2k
```

**Pro tip:** For future deployments, consider using tools like Helm or Kustomize to manage ConfigMaps and volume mounts more systematically. This pattern of "missing file → ConfigMap mount" is super common in Kubernetes.

Want to explore any other aspects of your deployment, or shall we look at monitoring/alerting to catch issues like this earlier?

You: /switch openai

🔄 Switched to openai (gpt-4o)
Tokens: 289 → 634 | Cost: $0.00 → $0.02

You: Let's generate a monitoring alert for this type of issue

OpenAI: Great idea! Here's a comprehensive monitoring setup to catch similar issues early:

**1. Prometheus Alert for CrashLoopBackOff:**
```yaml
# alerts.yaml
groups:
- name: kubernetes-pods
  rules:
  - alert: PodCrashLoopBackOff
    expr: |
      kube_pod_container_status_waiting_reason{reason="CrashLoopBackOff"} > 0
    for: 5m
    labels:
      severity: warning
      team: platform
    annotations:
      summary: "Pod {{ $labels.namespace }}/{{ $labels.pod }} is in CrashLoopBackOff"
      description: |
        Pod {{ $labels.namespace }}/{{ $labels.pod }} has been in CrashLoopBackOff for more than 5 minutes.
        This usually indicates:
        - Missing configuration files
        - Application startup failures  
        - Resource constraints
        
        Check: kubectl logs {{ $labels.pod }} -n {{ $labels.namespace }} --previous
```

**2. Log-based Alert for Missing Files:**
```yaml
  - alert: MissingConfigurationFile
    expr: |
      increase(log_messages_total{level="error", message=~".*ENOENT.*config.*"}[5m]) > 0
    labels:
      severity: critical
      team: development
    annotations:
      summary: "Application missing configuration file"
      description: "Application is failing due to missing configuration files"
```

**3. Quick kubectl alias for debugging:**
```bash
# Add to ~/.bashrc or ~/.zshrc
alias k-debug='kubectl get pods --all-namespaces | grep -E "(Error|CrashLoop|ImagePull)" && echo "=== Recent Events ===" && kubectl get events --sort-by=.metadata.creationTimestamp --all-namespaces | tail -10'
```

Want me to help set up the Prometheus configuration, or would you prefer a different monitoring solution like Datadog/New Relic?

You: /stats

📊 Session Statistics:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Messages: 12
Providers used: claude-3-5-sonnet, llama-3.3-70b-versatile, gpt-4o
Total tokens: 1,247 (634 input, 613 output)
Total cost: $0.02
Session duration: 15m 32s
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Provider breakdown:
• claude-3-5-sonnet: 289 tokens, $0.00
• llama-3.3-70b-versatile: 345 tokens, $0.00  
• gpt-4o: 613 tokens, $0.02

You: This is exactly what I needed! Can you help me generate a shell script that automates the ConfigMap creation for new deployments?

You: /switch anthropic

🔄 Switched to anthropic (claude-3-5-sonnet-20241220)
Tokens: 1,247 → 1,247 | Cost: $0.02 → $0.02

Claude: Absolutely! Here's a comprehensive shell script for automating ConfigMap deployments:

```bash
#!/bin/bash
# deploy-with-configmap.sh - Automated ConfigMap deployment script

set -euo pipefail

APP_NAME=${1:-}
CONFIG_FILE=${2:-}
NAMESPACE=${3:-default}

usage() {
    echo "Usage: $0 <app-name> <config-file> [namespace]"
    echo "Example: $0 web-app ./config.json production"
    exit 1
}

[[ -z "$APP_NAME" || -z "$CONFIG_FILE" ]] && usage

echo "🚀 Deploying $APP_NAME with ConfigMap..."

# Validate config file exists
[[ ! -f "$CONFIG_FILE" ]] && echo "❌ Config file not found: $CONFIG_FILE" && exit 1

# Create ConfigMap
echo "📦 Creating ConfigMap: ${APP_NAME}-config"
kubectl create configmap "${APP_NAME}-config" \
    --from-file="config.json=$CONFIG_FILE" \
    --namespace="$NAMESPACE" \
    --dry-run=client -o yaml | kubectl apply -f -

# Update deployment with ConfigMap mount
echo "🔧 Updating deployment with ConfigMap mount..."
kubectl patch deployment "$APP_NAME" \
    --namespace="$NAMESPACE" \
    --type='json' \
    -p='[
        {
            "op": "add",
            "path": "/spec/template/spec/volumes",
            "value": [{
                "name": "config-volume",
                "configMap": {"name": "'${APP_NAME}'-config"}
            }]
        },
        {
            "op": "add", 
            "path": "/spec/template/spec/containers/0/volumeMounts",
            "value": [{
                "name": "config-volume",
                "mountPath": "/app/config.json",
                "subPath": "config.json"
            }]
        }
    ]'

# Wait for rollout
echo "⏳ Waiting for rollout to complete..."
kubectl rollout status deployment "$APP_NAME" --namespace="$NAMESPACE" --timeout=300s

# Verify deployment
echo "✅ Verifying deployment..."
kubectl get pods -l app="$APP_NAME" --namespace="$NAMESPACE"

echo "🎉 Deployment complete! ConfigMap mounted successfully."
```

**Usage examples:**
```bash
# Deploy web-app with config.json in default namespace
./deploy-with-configmap.sh web-app ./config.json

# Deploy to specific namespace
./deploy-with-configmap.sh api-server ./api-config.json production

# Make it executable
chmod +x deploy-with-configmap.sh
```

This script handles error checking, creates the ConfigMap, patches the deployment, and verifies success. Want me to add any other automation features?

You: Perfect! Now let me test the cost comparison feature

```bash
$ llmswap compare --input-tokens 2000 --output-tokens 1000

Provider Cost Comparison (2000 input, 1000 output tokens):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Provider       │ Cost      │ Model               │ Savings vs Most Expensive
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Ollama         │ $0.0000   │ llama3.1           │ 100.0%
Groq           │ $0.0002   │ llama-3.3-70b      │ 99.4%
Gemini         │ $0.0038   │ gemini-1.5-pro     │ 88.1%
Anthropic      │ $0.0240   │ claude-3-5-sonnet  │ 24.8%
OpenAI         │ $0.0320   │ gpt-4o             │ 0.0%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

Monthly projection (100 requests/day):
• Ollama: $0.00/month (Local processing)
• Groq: $0.60/month (Lightning fast)
• Gemini: $11.40/month (Google's latest)
• Anthropic: $72.00/month (Reasoning excellence)  
• OpenAI: $96.00/month (Industry standard)

💡 Recommendation: Use Groq for speed-critical tasks, Claude for complex reasoning
```

Claude: Excellent demonstration of the cost comparison feature! This shows exactly why llmswap is so valuable - you can make informed decisions about provider selection based on both cost and performance needs.

**A few advanced cost optimization strategies you could implement:**

```bash
# 1. Set cost budgets per provider
llmswap config set budget.daily.openai 5.00
llmswap config set budget.monthly.anthropic 50.00

# 2. Auto-fallback to cheaper providers
llmswap config set fallback.strategy cost-optimized
llmswap config set fallback.max-cost 0.01

# 3. Smart routing based on query complexity
llmswap ask "What's 2+2?" --auto-route  # Routes to Groq (fast + cheap)
llmswap ask "Explain quantum computing" --auto-route  # Routes to Claude (complex reasoning)
```

The monthly projections are particularly useful for budget planning. Teams can now make data-driven decisions about which providers to use for different types of workloads.

You: /usage --days 30

📊 Usage Analytics (Last 30 days):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Provider    │ Requests │ Tokens     │ Cost    │ Avg Response Time │ Success Rate
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
OpenAI      │ 142      │ 245,231    │ $18.25  │ 2.3s             │ 98.6%
Anthropic   │ 89       │ 198,452    │ $15.87  │ 3.1s             │ 99.1%
Gemini      │ 203      │ 567,891    │ $12.45  │ 1.8s             │ 97.5%
Groq        │ 445      │ 1,234,567  │ $1.23   │ 0.4s             │ 99.8%
Ollama      │ 67       │ 89,234     │ $0.00   │ 8.2s             │ 95.2%
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Total       │ 946      │ 2,335,375  │ $47.80  │ 2.1s avg        │ 98.4%

🎯 Insights:
• Groq handling 47% of requests (speed advantage)
• Claude highest success rate at 99.1%
• Ollama for offline/privacy-sensitive tasks
• $47.80 total spend vs $156.80 single-provider equivalent (69% savings)

💰 Cost Optimization Opportunities:
• Route simple queries to Groq (potential $8.50/month savings)
• Use Gemini for content generation (25% faster than GPT-4)
• Consider Ollama for development/testing workloads

You: /quit

👋 Session complete! 

📊 Final Statistics:
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Messages: 18
Providers used: 4 (claude, groq, openai, anthropic)
Total tokens: 3,089
Total cost: $0.08
Session duration: 28m 15s
Conversation memory: Maintained across all providers ✓
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

💡 This session demonstrated:
• Multi-provider debugging workflow
• Real-time provider switching  
• Cost-aware decision making
• Comprehensive usage analytics
• Persistent conversation context

Thanks for using llmswap! 🚀
```