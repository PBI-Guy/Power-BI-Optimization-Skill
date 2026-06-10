# Installation Guide

## Quick Install

### Option 1: PowerShell (Windows)
```powershell
# User scope (recommended)
irm https://raw.githubusercontent.com/PBI-Guy/Power-BI-Optimization-Skill/main/install.ps1 | iex

# Or download and run locally
git clone https://github.com/PBI-Guy/Power-BI-Optimization-Skill.git
cd Power-BI-Optimization-Skill
.\install.ps1

# Workspace scope
.\install.ps1 -Scope workspace
```

### Option 2: Bash (macOS/Linux)
```bash
# User scope (recommended)
curl -fsSL https://raw.githubusercontent.com/PBI-Guy/Power-BI-Optimization-Skill/main/install.sh | bash

# Or download and run locally
git clone https://github.com/PBI-Guy/Power-BI-Optimization-Skill.git
cd Power-BI-Optimization-Skill
chmod +x install.sh
./install.sh

# Workspace scope
./install.sh workspace
```

### Option 3: Manual Installation

1. **Clone or download the repository:**
   ```bash
   git clone https://github.com/PBI-Guy/Power-BI-Optimization-Skill.git
   ```

2. **Copy to your desired location:**

   **User Scope** (available in all workspaces):
   - Windows: `%USERPROFILE%\.github\skills\powerbi-optimization`
   - macOS/Linux: `~/.github/skills/powerbi-optimization`

   **Workspace Scope** (current project only):
   - Windows/macOS/Linux: `.github\skills\powerbi-optimization`

3. **Copy the skill files:**
   ```bash
   # Copy the entire .github/skills/powerbi-optimization folder
   cp -r Power-BI-Optimization-Skill/.github/skills/powerbi-optimization ~/.github/skills/
   ```

---

## Installation Scopes

### User Scope (Recommended)
- **Location:** `~/.github/skills/powerbi-optimization`
- **Availability:** All workspaces and projects
- **Use case:** You want the skill available everywhere
- **Command:** `.\install.ps1` or `./install.sh`

### Workspace Scope
- **Location:** `.github/skills/powerbi-optimization` (in current folder)
- **Availability:** Current workspace only
- **Use case:** Team shared skill, project-specific customizations
- **Command:** `.\install.ps1 -Scope workspace` or `./install.sh workspace`

---

## Verification

After installation, verify the skill is available:

1. Open **VS Code**
2. Open **GitHub Copilot Chat**
3. Type `@powerbi-optimization` - you should see it in the autocomplete
4. Try a test command:
   ```
   @powerbi-optimization what can you help me with?
   ```

---

## What Gets Installed?

### Hub Skill
- **@powerbi-optimization** - Central triage and routing skill

### Specialist Skills
- **@dax-mastery** - DAX performance optimization
- **@model-design** - Semantic model architecture
- **@report-performance** - Report UX and visuals
- **@powerquery-m** - Power Query optimization
- **@security-rls** - Row-level security

### Supporting Files
- Analysis framework
- Templates
- MCP integration guide
- BPA integration guide
- Sample prompts

---

## Updating

To update to the latest version:

```powershell
# Windows
cd Power-BI-Optimization-Skill
git pull
.\install.ps1
```

```bash
# macOS/Linux
cd Power-BI-Optimization-Skill
git pull
./install.sh
```

---

## Uninstallation

To remove the skill:

**User scope:**
```powershell
# Windows
Remove-Item -Recurse -Force "$env:USERPROFILE\.github\skills\powerbi-optimization"
```

```bash
# macOS/Linux
rm -rf ~/.github/skills/powerbi-optimization
```

**Workspace scope:**
```powershell
# Windows
Remove-Item -Recurse -Force ".github\skills\powerbi-optimization"
```

```bash
# macOS/Linux
rm -rf .github/skills/powerbi-optimization
```

---

## Troubleshooting

### Skill not showing in Copilot
1. **Reload VS Code window:** `Ctrl+Shift+P` → "Developer: Reload Window"
2. **Check installation path:**
   ```powershell
   # Windows
   Test-Path "$env:USERPROFILE\.github\skills\powerbi-optimization\SKILL.md"
   ```
   ```bash
   # macOS/Linux
   ls ~/.github/skills/powerbi-optimization/SKILL.md
   ```
3. **Verify YAML frontmatter:** Open `SKILL.md` and check the frontmatter is valid

### Permission denied errors
- **Windows:** Run PowerShell as Administrator
- **macOS/Linux:** Use `sudo` or check file permissions

### Installation script not running
- **Windows:** Set execution policy:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```
- **macOS/Linux:** Make script executable:
  ```bash
  chmod +x install.sh
  ```

---

## Advanced: Custom Installation Path

If you want to install to a custom location:

```powershell
# Windows
.\install.ps1 -Path "C:\MyCustomPath\.github\skills"
```

```bash
# macOS/Linux
./install.sh /custom/path
```

**Note:** Custom paths may not be automatically detected by GitHub Copilot. User and workspace scopes are recommended.

---

## Next Steps

After installation:
1. ✅ Read the [README.md](README.md) for usage examples
2. ✅ Check [examples/sample-prompts.md](examples/sample-prompts.md) for inspiration
3. ✅ Try analyzing a Power BI file: `@powerbi-optimization analyze my report`
4. ✅ Review the [MCP-GUIDE.md](.github/skills/powerbi-optimization/MCP-GUIDE.md) for MCP server integration

---

## Support

- **Issues:** https://github.com/PBI-Guy/Power-BI-Optimization-Skill/issues
- **Discussions:** https://github.com/PBI-Guy/Power-BI-Optimization-Skill/discussions
- **Blog:** https://aka.nu/PBIGuyBlog
- **Email:** kristian@krbubalo.com

---

**Happy Optimizing!** 🚀
