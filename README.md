# llmswap Documentation Website

This repository contains the complete documentation website for [llmswap](https://github.com/sreenathmmenon/llmswap) - the universal AI CLI.

## 🌐 Live Site

- **Production**: [llmswap.org](https://llmswap.org) (when deployed)
- **GitHub Pages**: [username.github.io/llmswap-website](https://username.github.io/llmswap-website)

## 🚀 Features

- **Beautiful Design**: Modern, responsive design with custom llmswap theme
- **Complete Documentation**: Installation, CLI reference, Python SDK, provider setup
- **Interactive Examples**: Terminal recordings, code snippets, tutorials
- **Fast Search**: Built-in search across all documentation
- **Mobile Optimized**: Works perfectly on all devices

## 🛠️ Local Development

### Prerequisites

- Ruby 3.1+
- Bundler
- Git

### Setup

```bash
# Clone repository
git clone https://github.com/sreenathmmenon/llmswap-website
cd llmswap-website

# Install dependencies
bundle install

# Serve locally
bundle exec jekyll serve

# Open browser
open http://localhost:4000
```

### Making Changes

1. Edit content in markdown files
2. Changes auto-reload in development
3. Commit and push to trigger auto-deployment

## 📁 Site Structure

```
llmswap-website/
├── _config.yml              # Jekyll configuration
├── _sass/                   # Custom SCSS styles
│   └── color_schemes/       # llmswap theme
├── docs/                    # Documentation pages
│   ├── getting-started.md   # Installation & quickstart
│   ├── cli.md              # CLI reference
│   ├── providers.md        # Provider setup
│   └── sdk.md              # Python SDK docs
├── tutorials/               # Tutorials & examples
│   ├── chatbot.md          # Build a chatbot
│   └── [more tutorials]    # Additional tutorials
├── .github/workflows/       # GitHub Actions
│   └── pages.yml           # Auto-deployment
└── index.md                # Homepage
```

## 🎨 Theme Features

- **Custom Colors**: Purple/blue gradient theme
- **Provider Badges**: Colored badges for each AI provider
- **Terminal Windows**: Styled code blocks with terminal appearance
- **Feature Cards**: Beautiful cards for showcasing features
- **Hero Section**: Gradient hero with call-to-action buttons
- **Responsive Tables**: Mobile-friendly comparison tables

## 📝 Content Guidelines

### Writing Style
- **Concise**: Keep explanations clear and to the point
- **Examples**: Include practical code examples
- **Progressive**: Start simple, build complexity
- **Visual**: Use code blocks, tables, and callouts

### Code Examples
- Always test code examples before publishing
- Include both basic and advanced examples
- Show expected output when helpful
- Use syntax highlighting

### Screenshots
- Keep terminal recordings under 30 seconds
- Use consistent terminal theme
- Include captions explaining what's shown
- Optimize GIFs for web (< 5MB)

## 🚀 Deployment

### Automatic Deployment
- **Trigger**: Push to `main` branch
- **Platform**: GitHub Pages
- **URL**: Auto-assigned or custom domain
- **SSL**: Automatic HTTPS

### Custom Domain Setup
1. Add `CNAME` file with domain name
2. Configure DNS:
   ```
   CNAME: username.github.io
   ```
3. Enable HTTPS in repository settings

### Manual Deployment
```bash
# Build site locally
bundle exec jekyll build

# Deploy to GitHub Pages
git add .
git commit -m "Update documentation"
git push origin main
```

## 📊 Analytics

Add Google Analytics by updating `_config.yml`:
```yaml
ga_tracking: "G-XXXXXXXXXX"
```

## 🔧 Customization

### Adding New Pages
1. Create `.md` file in appropriate directory
2. Add frontmatter:
   ```yaml
   ---
   layout: default
   title: Page Title
   parent: Parent Section (optional)
   nav_order: 1
   ---
   ```
3. Content will auto-appear in navigation

### Styling Changes
- Edit `_sass/color_schemes/llmswap.scss`
- Follow existing patterns
- Test on mobile devices

### Adding Tutorials
1. Create file in `tutorials/` directory
2. Follow existing tutorial format
3. Update `tutorials/index.md` with new tutorial

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/new-tutorial`
3. Make changes and test locally
4. Commit with clear message
5. Push and create pull request

### Content Ideas
- More provider-specific tutorials
- Integration examples (VS Code, vim, etc.)
- Advanced use cases
- Performance optimization guides
- Enterprise deployment guides

## 📄 License

Same as llmswap - MIT License. See [LICENSE](https://github.com/sreenathmmenon/llmswap/blob/main/LICENSE).

## 🙋‍♂️ Support

- **Issues**: [GitHub Issues](https://github.com/sreenathmmenon/llmswap/issues)
- **Documentation**: [llmswap.org](https://llmswap.org)
- **Main Project**: [github.com/sreenathmmenon/llmswap](https://github.com/sreenathmmenon/llmswap)

---

Built with ❤️ using Jekyll and hosted on GitHub Pages.