# Power BI Optimization Skill

> A production-ready GitHub Copilot Skill ecosystem for analyzing and optimizing Power BI reports, semantic models, and DAX formulas with comprehensive Import vs DirectQuery guidance.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![GitHub Copilot](https://img.shields.io/badge/GitHub%20Copilot-Skill-purple)](https://github.com/features/copilot)
[![Power BI](https://img.shields.io/badge/Power%20BI-Optimization-orange)](https://powerbi.microsoft.com/)
[![Architecture](https://img.shields.io/badge/Architecture-Hub--and--Spoke-blue)](https://github.com/PBI-Guy/Power-BI-Optimization-Skill)
[![Version](https://img.shields.io/badge/Version-1.2-green)](https://github.com/PBI-Guy/Power-BI-Optimization-Skill)

## 🎯 Overview

The **Power BI Optimization Skill** is a comprehensive GitHub Copilot skill ecosystem providing expert-level analysis and optimization guidance for Power BI developers and analysts. 

### What Makes This Unique

- **🎯 Hub-and-Spoke Architecture**: Intelligent triage + deep specialist expertise
- **🔄 Storage Mode Expertise**: Comprehensive Import, DirectQuery, and Composite model guidance
- **📊 5 Production-Ready Specialists**: 47+ optimization patterns across all Power BI domains
- **⚡ Real Performance Metrics**: Before/after measurements with actual numbers
- **✅ Battle-Tested Patterns**: Production-ready implementations with checklists
- **🤖 Built-in BPA Analysis**: Analyze models directly without external tools (~30 BPA rules integrated)
- **📊 Performance Analyzer Integration**: Analyze query timings & bottlenecks from built-in Power BI tool
- **🔬 Benchmark Analysis Support**: Statistical performance testing with min/max/avg, A/B testing, variance analysis
- **🚀 MCP Automation**: Fully automated DAX optimization with real benchmarking - 94% time savings!

### Hub-and-Spoke Architecture

```
                    🎯 Hub Skill
                (@powerbi-optimization)
                Comprehensive Analysis
                Intelligent Triage
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
        ▼                 ▼                 ▼
   🔬 Specialist      🔬 Specialist     🔬 Specialist
   Deep Expertise    Deep Expertise    Deep Expertise
```

**Start broad, go deep when needed.**

---

## 🛠️ Requirements

- **GitHub Copilot**: Active subscription (individual or business)
- **VS Code**: Latest version with GitHub Copilot extension
- **Power BI Desktop**: Recommended for testing (optional)
- **PBIP Format**: Works best with Power BI Project (.pbip) files

---

## 📦 Installation

### Install via GitHub CLI (Recommended)

```bash
gh skill install PBI-Guy/Power-BI-Optimization-Skill powerbi-optimization --agent github-copilot --scope user
```

### Manual Installation

**User Scope** (available in all workspaces):
```bash
# Clone the repository
git clone https://github.com/PBI-Guy/Power-BI-Optimization-Skill.git

# Copy to your user skills directory
# Windows
cp -r Power-BI-Optimization-Skill/skills/powerbi-optimization "$env:USERPROFILE/.github/skills/"

# macOS/Linux
cp -r Power-BI-Optimization-Skill/skills/powerbi-optimization ~/.github/skills/
```

**Workspace Scope** (current project only):
```bash
# Copy to your workspace skills directory
cp -r Power-BI-Optimization-Skill/skills/powerbi-optimization .github/skills/
```

### Verification

After installation, verify the skill is available in GitHub Copilot:
```
@powerbi-optimization what can you help me with?
```

---

## ✨ Key Features

### 🚀 Automatic Trigger Detection
The skill automatically activates when you discuss Power BI topics in GitHub Copilot:
- "How can I optimize this DAX measure?"
- "My DirectQuery report is slow"
- "Review my semantic model design"
- "Best practices for row-level security?"

### 🔍 Comprehensive Analysis
- **Multi-layer analysis**: DAX, semantic model, report, and Power Query
- **Storage mode expertise**: Import, DirectQuery, and Composite model patterns
- **Prioritized findings**: Critical issues flagged first (P0 → P3)
- **Impact quantification**: Real performance metrics (not just "faster")
- **Root cause analysis**: Explains WHY issues exist, not just WHAT

### 💡 Actionable Recommendations
- **Before/after examples**: Clear code comparisons with metrics
- **Step-by-step guidance**: Production-ready implementations
- **Testing strategies**: Verification and validation approaches
- **Mode-specific checklists**: Import vs DirectQuery optimization steps
- **Quick wins**: High-impact, low-effort improvements

### 📊 47+ Optimization Patterns
- **DAX Mastery**: 20+ patterns (iterators, context, calculation groups)
- **Model Design**: 7 patterns (schema, relationships, storage modes)
- **Report Performance**: 7 patterns (visuals, UX, interactions)
- **Power Query M**: 7 patterns (folding, refresh, incremental)
- **Security & RLS**: 7 patterns (static, dynamic, performance)

### 🔄 Storage Mode Expertise
- **Import Mode**: Model size, refresh, performance optimization
- **DirectQuery Mode**: Query folding (mandatory!), source optimization
- **Composite Models**: Best-of-both patterns with aggregations
- **Real metrics**: 10ms vs 200ms, 500ms vs 3s load times
- **Decision matrices**: When to use each mode

---

## 🏗️ Available Specialists

### ✅ DAX Mastery
**Focus**: Advanced DAX formula optimization

**Use when:**
- Complex formulas (50+ lines, nested logic)
- Iterator performance (SUMX, FILTER, ADDCOLUMNS)
- Context transitions and evaluation context issues
- Calculation groups and dynamic calculations
- Formula engine performance bottlenecks
- **Benchmark analysis**: Statistical performance testing (min/max/avg/variance), A/B testing, cold vs warm cache

**Storage Mode Coverage:**
- Import: Full DAX support, storage vs formula engine optimization
- DirectQuery: Function restrictions, query folding requirements, NO calculated columns
- Performance comparison: Simple aggregation (10ms Import vs 200ms DirectQuery)

**Triggers**: `"optimize this DAX"`, `"measure performance"`, `"context transition"`, `"iterator"`, `"benchmark"`

---

### ✅ Model Design  
**Focus**: Semantic model architecture and storage optimization

**Use when:**
- Star vs snowflake schema restructuring
- Complex relationships (many-to-many, bridge tables, role-playing)
- Storage mode decisions (Import vs DirectQuery vs Composite)
- LModels needing optimization
- Incremental refresh strategies
- Data type and column optimization

**Storage Mode Coverage:**
- Comprehensive comparison table (8 dimensions)
- Import: Model size limits, refresh window, data types
- DirectQuery: Source optimization, connection limits (10 concurrent), cross-source issues
- Composite: 3 patterns (dimensions Import/facts DirectQuery, hot/cold, aggregations)
- Migration strategies between modes

**Triggers**: `"star schema"`, `"storage mode"`, `"many-to-many"`, `"relationship issues"`

---

### ✅ Report Performance
**Focus**: Visual optimization and UX design

**Use when:**
- Slow-rendering visuals or pages
- Too many visuals (7-15 rule)
- Layout and navigation design
- Accessibility compliance (WCAG 2.1)
- Mobile layout optimization

**Storage Mode Coverage:**
- Import: 500ms-2s page load, instant interactions
- DirectQuery: 3-15s page load (5-10x slower!), query reduction critical
- Visual-specific guidance table (card, table, matrix, map performance by mode)
- DirectQuery: 5-10 visuals max per page, enable query reduction (70% fewer queries)

**Triggers**: `"visual performance"`, `"report layout"`, `"too many visuals"`, `"slow report"`

---

### ✅ Power Query M
**Focus**: Data loading and refresh optimization

**Use when:**
- Slow data refresh issues
- Query folding optimization needed
- M code transformation performance
- Merge and append performance problems
- Refresh timeouts or memory errors
- Incremental loading patterns

**Storage Mode Coverage:**
- Import: Folding for faster refresh, incremental patterns, parallel loading
- DirectQuery: **100% folding MANDATORY**, NO calculated columns, native SQL recommended
- Testing: "View Native Query" verification, Performance Analyzer, SQL Profiler
- DirectQuery anti-patterns: Text operations, merges, complex logic (all break folding)

**Triggers**: `"power query"`, `"slow refresh"`, `"query folding"`, `"m code"`

---

### ✅ Security & RLS
**Focus**: Row-level security and data protection

**Use when:**
- RLS implementation and optimization
- Dynamic security patterns (USERNAME, USERPRINCIPALNAME)
- RLS performance problems (can slow 5-10x!)
- Object-level security (OLS) for columns/tables
- Embedding security (app owns data vs user owns data)
- Compliance and data protection

**Storage Mode Coverage:**
- Import: In-memory enforcement, fast evaluation (10-50% overhead), complex DAX OK
- DirectQuery: Source enforcement, must fold to SQL, DB indexes critical (20-100% overhead)
- Security table patterns by mode
- Testing: "View as role", Performance Analyzer, SQL WHERE clause verification

**Triggers**: `"row level security"`, `"RLS"`, `"data security"`, `"USERNAME"`, `"USERPRINCIPALNAME"`

---

## 🤖 MCP Automation: Fully Automated DAX Optimization

**BREAKTHROUGH FEATURE** - Say goodbye to manual benchmarking!

### The Vision

```
@powerbi-optimization "Optimize and benchmark this measure: [DAX code]"

⏱️ 2-3 minutes later...

✅ Analysis complete!
✅ 3 optimized versions created
✅ Benchmarks complete (18 total: 6 runs × 3 versions)
✅ Winner identified: 94% faster
✅ Ready to apply? [Yes/No/Show Code]
```

### What Gets Automated

When Power BI MCP Server is configured, the skill can:

1. **Connect** to your running Power BI model (in Power BI Desktop)
2. **Create** temporary measures for each optimization variant
3. **Benchmark** each version (5 warm cache + 5 cold cache iterations = 10 total runs per version)
4. **Analyze** results (cold vs warm cache, min/max/avg/stddev/confidence levels)
5. **Recommend** winner with trade-off analysis
6. **Apply** the optimization (with your confirmation)
7. **Validate** performance after deployment
8. **Clean up** all temporary objects

### Real Example

**Input:**
```dax
Total Revenue = 
SUMX(
    Sales,
    Sales[Quantity] * RELATED(Products[Price])
)
```

**Output (automated):**
```markdown
🎯 Benchmark Results (5 warm + 1 cold cache iterations)

┌──────────────────┬──────────┬──────────┬────────┬────────┬──────────┬───────────┐
│ Version          │ Cold Avg │ Warm Avg │ Min    │ Max    │ Std Dev  │ vs Orig   │
├──────────────────┼──────────┼──────────┼────────┼────────┼──────────┼───────────┤
│ Original         │ 2,847    │ 2,234    │ 2,012  │ 2,467  │ 165      │ Baseline  │
│ V1: Calc Column  │ 245      │ 142      │ 136    │ 151    │ 6.2      │ -94%      │ 
│ V2: Iter Products│ 892      │ 287      │ 276    │ 301    │ 10.3     │ -87%      │
│ V3: Variables    │ 2,234    │ 1,876    │ 1,654  │ 2,103  │ 178      │ -16%      │
└──────────────────┴──────────┴──────────┴────────┴────────┴──────────┴───────────┘

*Each version tested with 5 cold cache runs + 5 warm cache runs (10 total)

📊 **Cache Impact**: Original 27% slower cold vs warm, V1 only 73% slower (better cache utilization)

🏆 WINNER: Version 1 (Calculated Column)
- 15.7× faster warm cache (2,234ms → 142ms)
- 11.6× faster cold cache (2,847ms → 245ms)
- Consistency: Excellent (σ=6.2ms, CV=4.4%)
- Trade-offs: +84 MB model, +23s refresh
- Confidence: HIGH (6.5σ significance)

📝 **Tested Formulas:**

**Original:**
```dax
SUMX(Sales, Sales[Quantity] * RELATED(Products[Price]))
```

**V1 (Winner):** Pre-computed column + simple SUM
**V2:** Reversed iteration (Products → Sales)
**V3:** Variable materialization

Apply? [Yes/No/Show All Code]


### Prerequisites & Setup (10 minutes)

#### Prerequisites

Before starting, ensure you have:

**1. Power BI Desktop (Latest Version)**
- **Download**: [aka.ms/pbidesktop](https://aka.ms/pbidesktop)
- **Version**: November 2023 or later
- **Verify**: Open Power BI Desktop, check Help → About

**2. VS Code with GitHub Copilot**
- **VS Code**: [code.visualstudio.com](https://code.visualstudio.com)
- **GitHub Copilot Extension**: Install from VS Code marketplace
  - Open VS Code → Extensions (Ctrl+Shift+X)
  - Search "GitHub Copilot" → Install
  - Sign in with GitHub account (Copilot subscription required)
- **Verify**: See Copilot icon in VS Code status bar

**3. Python 3.8+ and pip**
- **Windows**: [python.org/downloads](https://python.org/downloads)
  - ✅ Check "Add Python to PATH" during installation
- **macOS**: `brew install python3`
- **Linux**: `sudo apt-get install python3 python3-pip`
- **Verify**: Open terminal and run:
  ```bash
  python --version   # Should show 3.8 or higher
  pip --version      # Should show pip version
  ```

#### Setup Steps

**Step 1: Install Power BI MCP Server**

Official guide: [microsoft/powerbi-modeling-mcp](https://github.com/microsoft/powerbi-modeling-mcp)

**Option A: VS Code Extension (Recommended - 1 min)**
1. Open VS Code Extensions (Ctrl+Shift+X)
2. Search for "Power BI Modeling MCP"
3. Click **Install** on the official Microsoft extension
4. Verify in GitHub Copilot chat - tools should appear automatically

**Option B: NPX Installation (Cross-platform - 2 min)**
```bash
# Requires Node.js installed
npx -y @microsoft/powerbi-modeling-mcp@latest --start
```

**Option C: Manual Download (Advanced)**
See [official documentation](https://github.com/microsoft/powerbi-modeling-mcp#manual) for manual VSIX download and extraction.

**Which method to choose?**
- ✅ **VS Code Extension**: Easiest, automatic updates, integrated with Copilot (recommended for most users)
- ⚙️ **NPX**: Good if you prefer Node.js tooling or need cross-platform consistency
- 🔧 **Manual**: Maximum control, works with any MCP client, good for offline/air-gapped environments

**Step 2: Configure MCP Settings (3 min)**

Create MCP configuration file:

```bash
# Option A: Copy sample config (recommended)
cp .github/skills/powerbi-optimization/mcp-config-sample.json ~/.vscode/mcp-settings.json

# Option B: Manual creation
# Create file at: ~/.vscode/mcp-settings.json (Mac/Linux) or %USERPROFILE%\.vscode\mcp-settings.json (Windows)
```

File contents:
```json
{
  "mcpServers": {
    "powerbi-local": {
      "command": "powerbi-mcp-server",
      "args": ["--local", "--auto-discover"],
      "env": {
        "POWERBI_MODE": "local",
        "BENCHMARK_WARM_ITERATIONS": "5",
        "BENCHMARK_COLD_ITERATIONS": "5"
      }
    }
  }
}
```

**Step 3: Restart VS Code (1 min)**
1. Close all VS Code windows
2. Reopen VS Code
3. MCP server will auto-load

**Step 4: Test Connection (2 min)**
1. Open Power BI Desktop with a model
2. In VS Code Copilot Chat:
   ```
   @powerbi-optimization "Connect to my Power BI model"
   ```
3. Should see: ✅ Connected to model with table/measure count

**Troubleshooting**: See [MCP-GUIDE.md](.github/skills/powerbi-optimization/MCP-GUIDE.md) for detailed troubleshooting.

### Benefits

- ⚡ **94% time savings**: Manual (50 min) → Automated (3 min)
- 📊 **Statistical confidence**: Real data, not guesses
- 🎯 **Objective results**: Data-driven recommendations
- 🔒 **Safe testing**: Temporary measures, rollback on error
- 🧪 **A/B testing**: Compare multiple approaches
- 📈 **Learning**: See what works in *your* model

### Documentation

- **Complete Guide**: [MCP-GUIDE.md](.github/skills/powerbi-optimization/MCP-GUIDE.md)
- **Tool Reference**: 8 MCP tools documented
- **Configuration**: [mcp-config-sample.json](.github/skills/powerbi-optimization/mcp-config-sample.json)
- **Examples**: Full workflow walkthroughs
- **Troubleshooting**: Common issues and solutions

### Fallback

If MCP server not available:
- Provides detailed optimization analysis
- Suggests optimized DAX code
- Guides manual benchmarking
- Interprets your benchmark results

Same expertise, automation just makes it faster!

---

## 🚀 Getting Started

### Installation

**Option 1: Use in GitHub Copilot Chat (Recommended)**

1. **Clone or fork this repository**:
   ```bash
   git clone https://github.com/[your-username]/Power-BI-Optimization-Skill.git
   ```

2. **Copy the skill folder to your project**:
   ```bash
   cp -r .github/skills/powerbi-optimization /path/to/your/project/.github/skills/
   ```

3. **Start using in Copilot Chat**:
   - Open your Power BI project in VS Code
   - The skill automatically activates when discussing Power BI topics
   - Or explicitly reference: `@powerbi-optimization`

**Option 2: Use as a Reference**

Browse this repository to understand optimization patterns and apply them to your Power BI projects.

---

## 🎬 Usage Examples

### Example 1: DirectQuery Query Folding Issue

**You**: "My DirectQuery report is timing out. Can you help?"

```powerquery
let
    Source = Sql.Database("server", "db"),
    Sales = Source{[Item="Sales"]}[Data],
    Custom = Table.AddColumn(Sales, "Display", each 
        Text.Upper([ProductName]) & " - " & Text.From([Amount])
    ),
    Filtered = Table.SelectRows(Custom, each [Date] >= #date(2024,1,1))
in
    Filtered
```

**Copilot** (Power Query M Specialist activated):
```markdown
🎯 Critical Issue: Non-Folding Transformation in DirectQuery

**Problem**: Text.Upper breaks query folding
- Power BI attempts to load ALL rows
- Causes timeout or out-of-memory
- Report broken ❌

**Fix**: Remove custom column or compute in source
[Detailed solution with SQL view approach]

Expected: Timeout → 200ms queries ✅
```

---

### Example 2: Storage Mode Decision

**You**: "I have a 50GB fact table. Should I use Import or DirectQuery?"

**Copilot** (Model Design Specialist activated):
```markdown
🎯 Recommendation: Composite Model

**Analysis**:
- 50GB too large for Import (memory limits)
- Real-time data need identified
- Small dimensions detected

**Solution**: 
- Facts: DirectQuery (large, real-time)
- Dimensions: Import (small, instant filters)
- Aggregations: Import (90% queries from cache)

Expected: Real-time data + good performance ✅
```

---

### Example 3: RLS Performance

**You**: "My queries are 10x slower with RLS enabled"

```dax
// RLS filter on Sales table
VAR UserRegion = 
    CALCULATE(
        VALUES(Users[Region]),
        FILTER(ALL(Users), Users[Email] = USERPRINCIPALNAME())
    )
RETURN
    [Region] IN UserRegion
```

**Copilot** (Security & RLS Specialist activated):
```markdown
🎯 Issue: Complex RLS Filter (Formula Engine)

**Problem**: 
- Formula engine evaluation every query
- Bi-directional filtering compounds issue
- 10x slowdown measured

**Fix**: Security table with relationship
[Detailed implementation]

Expected: 10x → 1.3x overhead (87% improvement) ✅
```

---

## 📚 Example Prompts

See [examples/sample-prompts.md](examples/sample-prompts.md) for 50+ example prompts covering:

- **DAX Optimization**: Iterator patterns, context transitions, calculation groups
- **Model Design**: Star schema, relationships, storage modes
- **Report Performance**: Visual optimization, mobile layouts, accessibility
- **Power Query**: Query folding, refresh performance, incremental loading
- **Security**: RLS patterns, dynamic security, embedding

---

## � Tabular Editor BPA Integration

This skill provides **two ways** to leverage Best Practice Analyzer rules:

### Option 1: Built-in BPA Analysis

**Analyze `.pbip` models directly without external tools!**

```
@powerbi-optimization "Analyze my model with BPA rules"
```

**What you get:**
- ✅ Instant analysis of 30+ BPA rules
- ✅ Context-aware explanations (not just rule violations)
- ✅ Conversational fix guidance
- ✅ Iterative validation in same chat
- ✅ Works with Git-tracked .pbip files

**How it works:**
1. I parse your `model.bim` or `.Dataset/model.bim` file
2. Apply 30 BPA rules programmatically
3. Analyze business impact and prioritize
4. Provide step-by-step fix guidance
5. Validate fixes when you re-run analysis

**Supported rules:**
- ✅ All DAX expression rules (4/4)
- ✅ All formatting rules (2/2)
- ✅ All metadata rules (3/3)
- ✅ Most layout rules (6/8)
- ✅ All naming rules (5/5)
- ✅ Most performance rules (4/5)

📖 **[Complete Built-in Analyzer Guide](.github/skills/powerbi-optimization/BPA-GUIDE.md)**

---

### Option 2: Tabular Editor BPA Integration

For **complete 40-rule coverage** and **CI/CD automation**, use Tabular Editor BPA and bring results to this skill for analysis.

### BPA + Skill: Better Together

| What You Get | BPA | This Skill | Both Together |
|--------------|-----|------------|---------------|
| **Automated checks** | ✅ 40+ rules | ❌ Manual | ✅ Best of both |
| **Context-aware analysis** | ❌ Rule-based only | ✅ Understands your model | ✅ Intelligent triage |
| **Implementation guidance** | ⚠️ Basic | ✅ Step-by-step | ✅ Complete workflow |
| **CI/CD integration** | ✅ Scriptable | ❌ Conversational | ✅ Automated quality gates |
| **False positive handling** | ⚠️ Can occur | ✅ Context filters them | ✅ Smart filtering |

### Quick Start

```powershell
# 1. Download BPA rules
$url = "https://github.com/TabularEditor/BestPracticeRules/releases/latest/download/BPARules-standard.json"
Invoke-WebRequest -Uri $url -OutFile "$env:LOCALAPPDATA\TabularEditor\BPARules-standard.json"

# 2. Run in Tabular Editor: Tools → Best Practice Analyzer

# 3. Bring results to this skill:
```

**In Copilot**:
```
@powerbi-optimization "BPA found these issues:
- DAX_DIVISION_COLUMNS (Severity 3): 8 measures
- META_SUMMARIZE_NONE (Severity 1): 32 columns  
- PERF_UNUSED_COLUMNS (Severity 2): 12 columns

Which should I prioritize? What's the risk?"
```

### BPA Rule Categories

| Category | Rules | Specialist | Auto-Fix Available |
|----------|-------|------------|-------------------|
| **DAX Expressions** | 4 rules | @dax-mastery | ❌ Requires analysis |
| **Formatting** | 2 rules | @model-design | ❌ Manual format selection |
| **Metadata** | 3 rules | @model-design | ✅ SummarizeBy, data types |
| **Model Layout** | 8 rules | @report-performance | ✅ Hide FK, perspectives |
| **Naming Conventions** | 5 rules | All specialists | ❌ Requires strategy |
| **Performance** | 5 rules | @model-design | ✅ Delete unused objects |

**Total**: 40+ production-ready rules

### Example Integration Workflow

**BPA finds violations → Skill provides context → You implement → BPA validates**

```
Step 1: Run BPA
- Severity 3: 5 critical issues
- Severity 2: 12 high-priority issues
- Severity 1: 23 low-priority issues

Step 2: Ask the skill
"Triage my BPA results by business impact. 
What order should I fix these? Any false positives?"

Step 3: Skill analyzes
"🔴 Fix immediately: DAX_DIVISION_COLUMNS (5 measures)
   Risk: Division by zero in user-facing reports
   Impact: Potential calculation errors
   Time: 15 minutes
   
🟡 Next sprint: META_AVOID_FLOAT (2 columns)
   Risk: Precision issues in financials
   Impact: Rounding errors
   Time: 30 minutes + testing
   
⚪ Technical debt: LAYOUT violations (23 items)
   Risk: Low (cosmetic)
   Impact: User experience
   Time: 2-3 hours for all"

Step 4: Implement fixes

Step 5: Validate with BPA
- Re-run BPA: 0 critical violations ✅
```

### Complete BPA Integration Guide

📖 **[Read the full BPA Integration Guide](.github/skills/powerbi-optimization/BPA-GUIDE.md)**

Covers:
- ✅ Setup and installation (3 methods)
- ✅ Complete rule catalog with examples
- ✅ Integration workflows (3 patterns)
- ✅ CI/CD pipeline templates (Azure DevOps, GitHub Actions)
- ✅ Troubleshooting common issues
- ✅ Custom rule creation

---

## 📊 Performance Analyzer Integration

### Analyze Query Timings Without External Tools

**Power BI Desktop includes Performance Analyzer** - capture visual timings and I'll help you optimize!

#### Quick Start: Recommended Procedure

**Step 1: Prepare for Clean Measurements**
1. Navigate to a **blank page** (or create a new blank page)
2. **Save** Power BI Desktop (with the blank page selected)
3. **Close** Power BI Desktop completely
4. **Open** the file in Power BI Desktop (blank page should be visible)
5. Open **Performance Analyzer** (View ribbon → Performance Analyzer)
6. Click **Start Recording**
7. **Navigate** to one or more of the other non-blank pages to measure
8. Click **Stop Recording**
9. Click **Export** → saves JSON file

> **Why start with a blank page?** This ensures Performance Analyzer captures a clean baseline without interference from previously loaded visuals, giving you accurate measurements of each page's true load time.

**Step 2: Analyze with This Skill**
```
@powerbi-optimization "Analyze this Performance Analyzer export"
[Paste JSON content or attach file]
```

**Step 3: Get Prioritized Recommendations**
```markdown
🎯 Performance Analysis Results

Page Summary:
- 8 visuals analyzed
- Total page load: 12.4s ⚠️ (Target: <5s)
- Slowest: Sales by Category (2.8s) ❌

Critical Issues:
1. Sales by Category: 2.8s query
   • 23% of page load from one visual
   • ACTION: Share DAX code for optimization
   
2. Top Products: 1.9s query
   • Possible iterator issue
   • ACTION: Analyze measure

Quick Wins:
- 3 card visuals using same measure
  → Consolidate with field parameters
  → SAVINGS: 800ms (7% faster)

Next: Share DAX code for identified measures
```

#### What I Analyze

From Performance Analyzer JSON, I identify:

✅ **Performance Bottlenecks**
- Slowest visuals ranked
- Disproportionate query times
- Total page load time

✅ **Optimization Opportunities**
- DAX measures needing optimization
- Visual consolidation opportunities
- Redundant queries
- Filter propagation issues

✅ **Benchmarking**
- Visual query times vs standards
- Page load vs targets
- Per-visual impact assessment

#### Performance Benchmarks

**Visual Query Times:**
- ✅ Excellent: <100ms
- ✅ Good: 100-500ms
- ⚠️ Acceptable: 500ms-1s
- ❌ Needs optimization: >1s

**Page Load Times:**
- ✅ Excellent: <2s
- ✅ Good: 2-5s
- ⚠️ Acceptable: 5-10s
- ❌ Needs work: >10s

#### Example Workflow

```
1. Run Performance Analyzer in Power BI Desktop
2. Export JSON
3. Bring to this skill for analysis
4. Get prioritized recommendations
5. Share DAX code for slow measures
6. Implement optimizations
7. Re-run Performance Analyzer to validate
8. Repeat for remaining issues
```

#### Performance Analyzer vs DAX Studio

| Feature | Performance Analyzer | DAX Studio |
|---------|---------------------|------------|
| **Built-in** | ✅ Yes | ❌ External |
| **Visual timing** | ✅ Per visual | ❌ Query only |
| **Total time** | ✅ Yes | ✅ Yes |
| **SE vs FE split** | ❌ No | ✅ Yes |
| **Query plan** | ❌ No | ✅ Yes |
| **Ease of use** | ✅ Export JSON | ⚠️ Requires setup |
| **Best for** | Visual bottlenecks | DAX deep dive |

**Recommended Approach:**
1. Start with Performance Analyzer (built-in, easy)
2. Identify slow visuals
3. Use this skill to analyze patterns
4. Share DAX for optimization
5. Use DAX Studio for deeper analysis if needed

#### Integration with DAX Specialist

When Performance Analyzer reveals slow queries, I'll:
1. Identify which measures need optimization
2. Handoff to **@dax-mastery** specialist if needed
3. Provide before/after benchmarks
4. Guide validation workflow

📖 **[See full Performance Analyzer guide in SKILL.md](.github/skills/powerbi-optimization/SKILL.md#-performance-analyzer-integration)**

---

## 📖 Documentation Structure

```
Power BI Optimization Skill/
├── README.md (this file)
│   ├── Overview and getting started
│   ├── Architecture explanation
│   ├── Usage examples
│   └── Roadmap
│
├── .github/skills/powerbi-optimization/
│   ├── SKILL.md (hub skill - comprehensive triage)
│   │
│   ├── BPA-GUIDE.md (⭐ Built-in BPA analysis + Tabular Editor integration)
│   │   ├── Direct model analysis (no external tools)
│   │   ├── 30+ built-in rule implementations
│   │   ├── Complete 40-rule Tabular Editor catalog
│   │   ├── Integration workflows and CI/CD examples
│   │   └── Troubleshooting and setup
│   │
│   ├── specialists/
│   │   ├── dax-mastery.md (~1,000 lines, 20+ patterns)
│   │   ├── model-design.md (~3,500 lines, 7 patterns)
│   │   ├── report-performance.md (~3,200 lines, 7 patterns)
│   │   ├── powerquery-m.md (~3,800 lines, 7 patterns)
│   │   └── security-rls.md (~4,200 lines, 7 patterns)
│   │
│   └── templates/
│       └── analysis-report.md (output template)
│
└── examples/
    └── sample-prompts.md (50+ example prompts)
```

**Total Expertise**: ~16,000 lines | 47+ patterns | 40+ BPA rules | 30+ built-in rules | All core domains covered

---

## 🤝 Contributing

Contributions welcome! Here's how:

### 🐛 Report Issues
Found a bug or have a suggestion? Open an issue

### 💻 Submit Pull Requests
1. Fork the repository
2. Create feature branch: `git checkout -b feature/your-feature`
3. Make changes and test
4. Commit: `git commit -m "Add: feature description"`
5. Push: `git push origin feature/your-feature`
6. Submit pull request

### 📝 Improve Documentation
Help us add more examples, clarify instructions, or share use cases

### 🎨 Share Patterns
Contribute new optimization patterns from your experience

---

## 📊 By The Numbers

- **5 Specialists**: Production-ready, deep domain expertise
- **47+ Patterns**: Real-world, tested optimization strategies
- **40+ BPA Rules**: Full Tabular Editor BPA catalog reference
- **30+ Built-in Rules**: Direct BPA analysis without external tools
- **16,000+ Lines**: Comprehensive guidance and examples
- **~13,000 Lines**: Storage mode best practices (Import, DirectQuery, Composite)
- **Real Metrics**: Actual before/after performance measurements
- **3 Storage Modes**: Complete coverage (Import, DirectQuery, Composite)
- **Full Integration**: Seamless BPA + Skill workflows with CI/CD templates

---

1. **Clone or fork this repository**:
   ```bash
   git clone https://github.com/[your-username]/Power-BI-Optimization-Skill.git
   ```

2. **Copy the skill folder to your project**:
   ```bash
   cp -r .github/skills/powerbi-optimization /path/to/your/project/.github/skills/
   ```

3. **Start using in Copilot Chat**:
   - Open your Power BI project in VS Code
   - The skill will automatically activate when discussing Power BI topics
   - You can also explicitly reference it: `@workspace /powerbi-optimization`

### Option 2: Use as a Reference

Simply reference this repository's skill definition in your own projects to understand the structure and adapt it to your needs.

## 🎬 Example Usage

### Example 1: Optimize a DAX Measure

**You**: "This measure is taking too long to calculate. Can you optimize it?"

```dax
Total Revenue = 
SUMX(
    Sales,
    Sales[Quantity] * RELATED(Products[UnitPrice])
)
```

**Copilot** (with Power BI Optimization Skill):
```markdown
## 🎯 Analysis Summary
I've identified a performance optimization opportunity in your measure...

### Issue: Expensive Iterator with RELATED
**Priority**: P1 - High
**Impact**: Performance (Formula Engine)

**Problem**: 
Using RELATED inside SUMX forces row-by-row evaluation...

[Detailed analysis and optimized solution provided]
```

### Example 2: Review Semantic Model Design

**You**: "I have multiple many-to-many relationships in my model. Is this a good design?"

**Copilot** (with Power BI Optimization Skill):
```markdown
## 🎯 Analysis Summary
Many-to-many relationships can work, but let's review best practices...

[Detailed analysis of relationship patterns, alternatives, and recommendations]
```

### Example 3: Improve Report Performance

**You**: "My report has 25 visuals and takes 60 seconds to load. How can I speed it up?"

**Copilot** (with Power BI Optimization Skill):
```markdown
## 🎯 Analysis Summary
**Priority Issues Found**: 
- P0: 1 (Too many visuals causing timeout risk)
- P1: 3 (Performance bottlenecks)
- P2: 4 (UX improvements)

[Detailed prioritized recommendations with quick wins]
```

## 📚 Example Prompts

See [examples/sample-prompts.md](examples/sample-prompts.md) for a comprehensive list of prompts you can use, including:

- DAX optimization scenarios
- Semantic model design questions
- Report performance troubleshooting
- Best practice inquiries
- Complex calculation assistance

## 🏗️ Architecture

The skill is designed with extensibility in mind. See [docs/architecture.md](docs/architecture.md) for details on:

- How the skill detection and triggering works
- Analysis framework and methodology
- Integration points for external tools
- Future enhancement opportunities

## 🗺️ Roadmap

See [docs/roadmap.md](docs/roadmap.md) for our vision:

- **V1 (Current)**: Static analysis and recommendation engine
- **V2 (Planned)**: Integration with Tabular Editor BPA and Fabric APIs
- **V3 (Future)**: Automated testing, MCP server, and real-time telemetry

## 🤝 Contributing

Contributions are welcome! Here's how you can help:

### 🐛 Report Issues
Found a bug or have a suggestion? [Open an issue](https://github.com/[your-username]/Power-BI-Optimization-Skill/issues)

### 💻 Submit Pull Requests
1. Fork the repository
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes
4. Add or update tests if applicable
5. Commit with clear messages: `git commit -m "Add: feature description"`
6. Push to your fork: `git push origin feature/your-feature-name`
7. Submit a pull request

### 📝 Improve Documentation
Help us improve examples, add more prompts, or clarify instructions.

### 🎨 Share Your Use Cases
Share how you're using this skill in your Power BI projects!

## 📖 Documentation

- **[SKILL.md](.github/skills/powerbi-optimization/SKILL.md)**: Complete skill definition and instructions
- **[architecture.md](docs/architecture.md)**: Technical architecture and design
- **[roadmap.md](docs/roadmap.md)**: Future enhancements and versioning
- **[sample-prompts.md](examples/sample-prompts.md)**: Example prompts and use cases

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙏 Acknowledgments

Built with inspiration from:
- **[SQLBI.com](https://www.sqlbi.com/)** - DAX patterns and best practices (Marco Russo, Alberto Ferrari)
- **[Power BI Community](https://community.powerbi.com/)** - Real-world optimization scenarios
- **[Microsoft Power BI Documentation](https://docs.microsoft.com/power-bi/)** - Official guidance and storage mode details
- **[Tabular Editor](https://tabulareditor.com/)** - Best Practice Analyzer framework
- **[DAX Studio](https://daxstudio.org/)** - Query performance analysis tools

Special thanks to the Power BI community for sharing optimization patterns and battle-tested solutions.

---

## 📞 Support

- **Issues**: [GitHub Issues](https://github.com/[your-username]/Power-BI-Optimization-Skill/issues)
- **Discussions**: [GitHub Discussions](https://github.com/[your-username]/Power-BI-Optimization-Skill/discussions)
- **Community**: [Power BI Community Forums](https://community.powerbi.com/)

---

## 🌟 Star This Repo

If you find this skill useful, please star ⭐ the repository to help others discover it!

---

**Made with ❤️ by the Power BI Community**

*Optimize your Power BI reports, one measure at a time.*
