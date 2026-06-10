# Best Practice Analyzer Integration Guide

> **Tabular Editor BPA + Power BI Optimization Skill**  
> Use automated rule-based checks alongside context-aware optimization guidance

---

## 📑 Table of Contents

- [Quick Start](#quick-start)
- [Setup & Installation](#setup--installation)
- [BPA Rule Reference](#bpa-rule-reference)
- [Integration Workflows](#integration-workflows)
- [Rule-to-Specialist Mapping](#rule-to-specialist-mapping)
- [CI/CD Integration](#cicd-integration)
- [Troubleshooting](#troubleshooting)

---

## Quick Start

### 30-Second Setup

1. **Download BPA rules**:
   ```powershell
   $url = "https://github.com/TabularEditor/BestPracticeRules/releases/latest/download/BPARules-standard.json"
   $dest = "$env:LOCALAPPDATA\TabularEditor\BPARules-standard.json"
   Invoke-WebRequest -Uri $url -OutFile $dest
   ```

2. **Run in Tabular Editor**:
   - Open your .pbip/.bim model
   - Tools → Best Practice Analyzer
   - Click "Analyze"

3. **Bring results to this skill**:
   ```
   User: "BPA found 23 issues. Top violations:
   - DAX_DIVISION_COLUMNS (Severity 3): 8 measures
   - META_SUMMARIZE_NONE (Severity 1): 32 columns
   - PERF_UNUSED_COLUMNS (Severity 2): 12 columns
   
   Which should I prioritize?"
   ```

---

## Setup & Installation

### Prerequisites

- **Tabular Editor 2** (free) or **Tabular Editor 3** (commercial)
  - Download: [https://tabulareditor.com/](https://tabulareditor.com/)
- **Power BI Desktop** with PBIP format support
- **Git** (optional, for version control of rules)

### Installation Methods

#### Method 1: Manual Download

```powershell
# Download standard rules (recommended)
$standardUrl = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard.json"
$destUser = "$env:LOCALAPPDATA\TabularEditor\BPARules-standard.json"
Invoke-WebRequest -Uri $standardUrl -OutFile $destUser

# Download lax rules (less strict)
$laxUrl = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard-lax.json"
$destLax = "$env:LOCALAPPDATA\TabularEditor\BPARules-lax.json"
Invoke-WebRequest -Uri $laxUrl -OutFile $destLax

# Download Power BI specific rules
$pbiUrl = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-PowerBI.json"
$destPBI = "$env:LOCALAPPDATA\TabularEditor\BPARules-PowerBI.json"
Invoke-WebRequest -Uri $pbiUrl -OutFile $destPBI
```

#### Method 2: Git Clone (For Team Customization)

```powershell
# Clone repository
git clone https://github.com/TabularEditor/BestPracticeRules.git "C:\BPA"

# Copy desired rules to Tabular Editor folder
Copy-Item "C:\BPA\BPARules-standard.json" "$env:LOCALAPPDATA\TabularEditor\"

# For organization-wide rules (requires admin):
# Copy-Item "C:\BPA\BPARules-standard.json" "$env:ProgramData\TabularEditor\"
```

#### Method 3: Custom Rules (Advanced)

Create your own rule file following the JSON schema:

```json
[
  {
    "ID": "CUSTOM_MY_RULE",
    "Name": "My custom validation rule",
    "Category": "Custom",
    "Description": "Detailed description of what this checks",
    "Severity": 3,
    "Scope": "Measure",
    "Expression": "Name.Contains(\"Test\")",
    "CompatibilityLevel": 1200
  }
]
```

Save to: `%LOCALAPPDATA%\TabularEditor\BPARules-custom.json`

### File Locations

| Location | Scope | Use Case |
|----------|-------|----------|
| `%LOCALAPPDATA%\TabularEditor\` | Current user only | Personal preferences, testing |
| `%ProgramData%\TabularEditor\` | All users on machine | Organization standards |
| Custom path | Ad-hoc | Project-specific rules |

---

## BPA Rule Reference

### Complete Rule Catalog

#### DAX Expressions Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `DAX_COLUMNS_FULLY_QUALIFIED` | Fully qualified column references | 2 | Use `Table[Column]` not `[Column]` | ❌ |
| `DAX_MEASURES_UNQUALIFIED` | Unqualified measure references | 2 | Use `[Measure]` not `Table[Measure]` | ❌ |
| `DAX_DIVISION_COLUMNS` | Avoid division operator | 3 | Use `DIVIDE()` instead of `/` | ❌ |
| `DAX_TODO` | Revisit TODO expressions | 1 | Find incomplete `// TODO` comments | ❌ |

**Integration**: Invoke `@dax-mastery` specialist for deep analysis of flagged formulas.

---

#### Formatting Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `APPLY_FORMAT_STRING_COLUMNS` | Format numeric columns | 2 | Visible numeric columns need format | ❌ |
| `APPLY_FORMAT_STRING_MEASURES` | Format numeric measures | 2 | Visible measures need format | ❌ |

**Example Fix**:
```dax
// Before (no format)
Total Sales = SUM(Sales[Amount])

// After (with format)
Total Sales = SUM(Sales[Amount])  // FormatString = "$#,0.00"
```

---

#### Metadata Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `META_SUMMARIZE_NONE` | Don't summarize numeric columns | 1 | Set `SummarizeBy = None` | ✅ Yes |
| `META_AVOID_FLOAT` | Avoid floating point types | 3 | Use `Decimal` instead of `Double` | ✅ Yes |
| `DISABLE_ATTRIBUTE_HIERACHIES` | Disable unused hierarchies | 2 | Hidden columns: `IsAvailableInMDX = false` | ✅ Yes |

**Integration**: Use `@model-design` for data type migration strategies.

---

#### Model Layout Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `LAYOUT_HIDE_FK_COLUMNS` | Hide foreign key columns | 1 | Columns in relationships should be hidden | ✅ Yes |
| `LAYOUT_ADD_TO_PERSPECTIVES` | Add objects to perspectives | 1 | Visible objects need perspective assignment | ❌ |
| `LAYOUT_COLUMNS_HIERARCHIES_DF` | Organize in display folders | 1 | Tables with >10 columns need folders | ❌ |
| `LAYOUT_MEASURES_DF` | Organize measures in folders | 1 | Tables with >10 measures need folders | ❌ |
| `TRANSLATE_HIDEABLE_OBJECT_NAMES` | Translate object names | 1 | Multi-culture models need translations | ❌ |

**Integration**: Use `@report-performance` for UX design patterns.

---

#### Naming Convention Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `NO_CAMELCASE_MEASURES_TABLES` | Avoid CamelCase | 2 | Use PascalCase or spaces | ❌ |
| `NO_CAMELCASE_COLUMNS_HIERARCHIES` | Avoid CamelCase | 2 | Consistent naming standards | ❌ |
| `UPPERCASE_FIRST_LETTER_MEASURES_TABLES` | Uppercase first letter | 2 | `Sales` not `sales` | ❌ |
| `RELATIONSHIP_COLUMN_NAMES` | Relationship naming consistency | 2 | From/To columns should match | ❌ |
| `PARTITION_NAMES_SHOULD_MATCH_TABLE_NAMES` | Partition naming | 1 | Single partition = table name | ❌ |

---

#### Performance Rules

| Rule ID | Name | Severity | Description | Auto-Fix |
|---------|------|----------|-------------|----------|
| `PERF_UNUSED_COLUMNS` | Remove unused columns | 2 | Hidden, no dependencies, no relationships | ✅ Yes (Delete) |
| `PERF_UNUSED_MEASURES` | Remove unused measures | 1 | Hidden measures with no references | ✅ Yes (Delete) |
| `AVOID_SINGLE_ATTRIBUTE_DIMENSIONS` | Avoid single-attribute dims | 2 | Dim with 1 attribute + 1 relationship | ❌ |
| `USE_MSOLEDBSQL_PROVIDER` | Use modern SQL provider | 2 | MSOLEDBSQL vs deprecated providers | ❌ |
| `SPECIFY_APPLICATION_NAME_IN_CONNECTION_STRING` | Specify app name | 1 | Add `Application Name=` to conn string | ❌ |

**Integration**: Use `@model-design` for dependency analysis and safe removal.

---

## Integration Workflows

### Workflow 1: BPA → Skill (Automated Detection + Expert Analysis)

**Best for**: Initial model health check, identifying quick wins

```
┌─────────────────┐
│ Run BPA in      │
│ Tabular Editor  │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ 23 violations   │
│ found           │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Bring results   │
│ to this skill   │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Get context-    │
│ aware priority  │
│ & guidance      │
└─────────────────┘
```

**Example Conversation**:

```
User: "I ran BPA and got these violations. Which are critical?"

[Copy/paste BPA results, grouped by severity]
- Severity 3 (Critical): 5 issues
- Severity 2 (High): 12 issues  
- Severity 1 (Low): 23 issues

Skill Response:
"Let me triage these by actual business impact:

🔴 Fix Immediately (Production Risk):
1. DAX_DIVISION_COLUMNS - 5 measures
   Risk: Division by zero errors in reports
   Impact: User-facing calculation errors
   Effort: 15 minutes (replace / with DIVIDE)
   → Use @dax-mastery for complex cases

2. META_AVOID_FLOAT - 2 columns (Sales[Amount], Sales[Tax])
   Risk: Rounding errors near zero, incorrect totals
   Impact: Financial accuracy issues
   Effort: 30 minutes (change data type, test calculations)
   → Use @model-design for migration plan

🟡 Fix Next Sprint (Technical Debt):
..."
```

---

### Workflow 2: Skill → BPA (Strategic Plan + Validation)

**Best for**: Major optimization initiatives, refactoring projects

```
┌─────────────────┐
│ User: "Optimize │
│ my model"       │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Skill provides  │
│ comprehensive   │
│ analysis        │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ User implements │
│ recommendations │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Validate with   │
│ BPA             │
└─────────────────┘
```

**Example Conversation**:

```
User: "I want to optimize my DirectQuery model"

Skill (@model-design invoked):
[Provides comprehensive analysis]
- Recommendation 1: Simplify snowflake to star
- Recommendation 2: Hide foreign key columns
- Recommendation 3: Remove unused columns
- Recommendation 4: Set appropriate data types

User: "I implemented all changes. How do I verify?"

Skill Response:
"Excellent! Run these BPA rules to validate:

✅ Validation Checklist:
1. LAYOUT_HIDE_FK_COLUMNS - Should show 0 violations (all FK hidden)
2. PERF_UNUSED_COLUMNS - Should show 0 violations (cleanup complete)
3. META_AVOID_FLOAT - Verify data type changes
4. RELATIONSHIP_COLUMN_NAMES - Confirm naming conventions

Expected BPA Result: 0 violations in Performance category

If BPA still shows issues, share results and I'll analyze."
```

---

### Workflow 3: Continuous Monitoring (CI/CD + Skill)

**Best for**: Team environments, production models

```
┌─────────────────┐
│ Developer       │
│ commits changes │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ CI Pipeline:    │
│ Run BPA via     │
│ script          │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Severity ≥ 3?   │
│ Fail build      │
└────────┬────────┘
         │
         ▼
┌─────────────────┐
│ Developer asks  │
│ skill for fix   │
│ guidance        │
└─────────────────┘
```

**Example Conversation**:

```
User: "CI pipeline failed. BPA found 2 critical issues:
- DAX_DIVISION_COLUMNS in [Profit Margin] measure
- META_AVOID_FLOAT in Sales[Discount] column

Need to fix urgently. What's the fastest approach?"

Skill Response:
"Quick fix plan (20 minutes):

Issue 1: DAX_DIVISION_COLUMNS
Current code:
Profit Margin = Sales[Profit] / Sales[Revenue]

Fixed code:
Profit Margin = DIVIDE(Sales[Profit], Sales[Revenue], 0)
             // Returns 0 instead of error when Revenue = 0

Issue 2: META_AVOID_FLOAT
1. Open Tabular Editor
2. Right-click Sales[Discount] → Properties
3. Change Data Type: Double → Decimal
4. Test calculations:
   - Run: MAXX(Sales, Sales[Discount]) 
   - Verify totals unchanged

Validation:
- Re-run BPA: Should show 0 critical violations
- Test report: Verify Profit Margin handles zero revenue
- Check precision: Discount percentages display correctly
"
```

---

## Rule-to-Specialist Mapping

### Quick Reference: Which Specialist for Which BPA Rule?

| BPA Rule Pattern | Primary Specialist | When to Escalate to Hub |
|------------------|-------------------|-------------------------|
| `DAX_*` | @dax-mastery | Multiple related measures need refactoring |
| `APPLY_FORMAT_*` | @model-design | Need format string strategy across model |
| `META_*` | @model-design | Metadata changes affect calculations |
| `LAYOUT_*` | @report-performance | UX design patterns needed |
| `NAME_*` | (Any specialist) | Renaming affects multiple domains |
| `PERF_*` | @model-design | Performance requires cross-domain analysis |

### Detailed Mapping

#### DAX Rules → @dax-mastery

**When to use specialist:**
- Multiple measures flagged by same rule
- Complex refactoring needed (not just find/replace)
- Need to understand performance implications
- Calculation groups or time intelligence involved

**Example escalation**:
```
User: "BPA flagged 47 measures with DAX_DIVISION_COLUMNS"

Skill → @dax-mastery:
"Analyze these 47 measures for bulk refactoring:
- Group by pattern (similar denominators)
- Identify calculation groups candidates
- Prioritize by query frequency
- Provide refactoring script"
```

---

#### Metadata/Performance Rules → @model-design

**When to use specialist:**
- Data type changes affect multiple tables
- Unused object removal needs dependency analysis
- Storage mode implications
- Impact on DirectQuery query folding

**Example escalation**:
```
User: "BPA wants to remove 45 unused columns. Safe to delete?"

Skill → @model-design:
"Before deletion, analyze:
1. External Power BI reports (workspace usage)
2. Excel pivot tables connected to model
3. Third-party tools (Tableau, etc.)
4. Custom MDX/DAX queries

Provide safe removal plan + rollback strategy"
```

---

#### Layout Rules → @report-performance

**When to use specialist:**
- Display folder strategy needed
- Perspective design required
- Translation workflow setup
- UX impact of metadata changes

**Example escalation**:
```
User: "BPA says I need display folders for 8 tables with >10 measures"

Skill → @report-performance:
"Design display folder structure:
- Group measures by business function
- Create consistent naming convention
- Consider report page layouts
- Plan for future growth (scalability)

Provide folder hierarchy + implementation steps"
```

---

## CI/CD Integration

### Automated BPA Checks in Build Pipeline

#### Azure DevOps Pipeline Example

```yaml
# azure-pipelines.yml
trigger:
  branches:
    include:
      - main
      - develop

pool:
  vmImage: 'windows-latest'

steps:
- task: PowerShell@2
  displayName: 'Download BPA Rules'
  inputs:
    targetType: 'inline'
    script: |
      $url = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard.json"
      $dest = "$(Build.SourcesDirectory)\BPARules.json"
      Invoke-WebRequest -Uri $url -OutFile $dest

- task: PowerShell@2
  displayName: 'Run BPA via Tabular Editor CLI'
  inputs:
    targetType: 'inline'
    script: |
      # Install Tabular Editor (if not in image)
      choco install tabulareditor -y
      
      # Run BPA analysis
      $modelPath = "$(Build.SourcesDirectory)\Model\model.bim"
      $rulesPath = "$(Build.SourcesDirectory)\BPARules.json"
      $outputPath = "$(Build.ArtifactStagingDirectory)\bpa-results.json"
      
      # Tabular Editor CLI command
      TabularEditor.exe $modelPath `
        -BPA $rulesPath `
        -BPA-Export $outputPath `
        -BPA-SeverityThreshold 3
      
      if ($LASTEXITCODE -ne 0) {
        Write-Error "BPA found critical issues (Severity >= 3)"
        exit 1
      }

- task: PublishBuildArtifacts@1
  displayName: 'Publish BPA Results'
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)'
    ArtifactName: 'bpa-reports'
```

#### GitHub Actions Example

```yaml
# .github/workflows/bpa-check.yml
name: BPA Quality Check

on:
  pull_request:
    branches: [ main ]
  push:
    branches: [ main ]

jobs:
  bpa-analysis:
    runs-on: windows-latest
    
    steps:
    - uses: actions/checkout@v3
    
    - name: Setup Tabular Editor
      run: |
        choco install tabulareditor -y
        
    - name: Download BPA Rules
      run: |
        $url = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard.json"
        Invoke-WebRequest -Uri $url -OutFile "BPARules.json"
    
    - name: Run BPA
      id: bpa
      run: |
        $violations = 0
        $modelPath = ".\Model\model.bim"
        
        # Run BPA and capture violations
        $output = TabularEditor.exe $modelPath -BPA "BPARules.json" -BPA-Export "bpa-results.json"
        
        # Parse results
        $results = Get-Content "bpa-results.json" | ConvertFrom-Json
        $critical = $results | Where-Object { $_.Severity -ge 3 }
        
        if ($critical.Count -gt 0) {
          Write-Output "::error::Found $($critical.Count) critical BPA violations"
          $violations = $critical.Count
        }
        
        echo "violations=$violations" >> $env:GITHUB_OUTPUT
    
    - name: Comment on PR
      if: github.event_name == 'pull_request' && steps.bpa.outputs.violations > 0
      uses: actions/github-script@v6
      with:
        script: |
          const violations = '${{ steps.bpa.outputs.violations }}';
          const message = `⚠️ **BPA found ${violations} critical violations**\n\n` +
            `Please review and fix before merging.\n\n` +
            `💡 Need help? Ask the Power BI Optimization Skill in Copilot:\n` +
            `\`\`\`\n` +
            `@workspace I got ${violations} critical BPA violations. ` +
            `See attached bpa-results.json. What should I prioritize?\n` +
            `\`\`\``;
          
          github.rest.issues.createComment({
            issue_number: context.issue.number,
            owner: context.repo.owner,
            repo: context.repo.repo,
            body: message
          });
    
    - name: Upload BPA Results
      uses: actions/upload-artifact@v3
      with:
        name: bpa-results
        path: bpa-results.json
    
    - name: Fail on Critical Violations
      if: steps.bpa.outputs.violations > 0
      run: exit 1
```

#### Pre-Commit Hook Example

```powershell
# .git/hooks/pre-commit (or use Husky for Node.js projects)

# Run BPA before allowing commit
$modelPath = ".\Model\model.bim"
$rulesPath = ".\BPARules.json"

Write-Host "Running BPA checks..." -ForegroundColor Cyan

# Run BPA
$result = TabularEditor.exe $modelPath -BPA $rulesPath -BPA-SeverityThreshold 3

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ BPA found critical issues. Commit blocked." -ForegroundColor Red
    Write-Host ""
    Write-Host "💡 To fix, ask the Power BI Optimization Skill:" -ForegroundColor Yellow
    Write-Host "   '@workspace Review my BPA violations and prioritize fixes'" -ForegroundColor Yellow
    exit 1
}

Write-Host "✅ BPA checks passed" -ForegroundColor Green
exit 0
```

---

## Troubleshooting

### Common Issues

#### Issue 1: BPA Rules Not Loading

**Symptom**: Tabular Editor → Best Practice Analyzer shows no rules

**Solutions**:
```powershell
# Verify file exists
Test-Path "$env:LOCALAPPDATA\TabularEditor\BPARules.json"

# Check JSON syntax
Get-Content "$env:LOCALAPPDATA\TabularEditor\BPARules.json" | ConvertFrom-Json

# Re-download if corrupted
$url = "https://raw.githubusercontent.com/TabularEditor/BestPracticeRules/master/BPARules-standard.json"
$dest = "$env:LOCALAPPDATA\TabularEditor\BPARules.json"
Invoke-WebRequest -Uri $url -OutFile $dest -Force

# Restart Tabular Editor
```

---

#### Issue 2: False Positives

**Symptom**: BPA flags valid code as violation

**Example**:
```dax
// BPA flags this as DAX_DIVISION_COLUMNS:
Percentage = [Value] / 100  // ❌ BPA violation

// But this is safe (constant denominator)
```

**Solution via This Skill**:
```
User: "BPA flagged this as a violation, but dividing by 100 is safe. Right?"

Skill Response:
"You're correct! BPA's DAX_DIVISION_COLUMNS rule is conservative.

✅ Safe to ignore when:
- Denominator is a constant (100, 1000, etc.)
- Denominator is guaranteed non-zero by business logic
- Performance-critical code (DIVIDE has overhead)

⚠️ Must fix when:
- Denominator is a column reference
- Denominator could be zero/blank
- User-facing calculations (errors visible)

Your case: Dividing by 100 for percentage → Safe to ignore

Best practice: Add comment to suppress future warnings:
// BPA: DAX_DIVISION_COLUMNS - Safe constant denominator
Percentage = [Value] / 100
"
```

---

#### Issue 3: Auto-Fix Breaks Calculations

**Symptom**: Applied BPA auto-fix, reports now show errors

**Example**:
```dax
// Before (working)
Total = SUM(Table[Amount]) + SUM(Table[Tax])

// After BPA auto-fix (broken)
Total = [Amount] + [Tax]  // ❌ Changed SUM() to column reference!
```

**Solution**: Escalate to skill for analysis

```
User: "I applied BPA auto-fixes and now my Total measure is broken"

Skill (@dax-mastery invoked):
"The auto-fix incorrectly converted your measure. Here's what happened:

Root Cause:
- BPA detected unqualified column references
- Auto-fix assumed you wanted measure references
- But your original code was correct (SUM aggregation)

Correct Fix:
Total = SUM(Sales[Amount]) + SUM(Sales[Tax])
// Fully qualified column references in SUM context

⚠️ Lesson: Always review auto-fixes before saving!

Rollback Plan:
1. Undo changes in Tabular Editor (Ctrl+Z)
2. Manually apply fixes one-by-one
3. Test each change in Performance Analyzer
"
```

---

#### Issue 4: Too Many Low-Severity Violations

**Symptom**: BPA shows 200+ Severity 1 violations, overwhelming

**Solution**: Triage with this skill

```
User: "BPA found 247 violations, mostly Severity 1. Should I fix all of them?"

Skill Response:
"No! Focus on high-impact items. Let me triage:

🔴 Fix Now (Severity 3-4): 12 issues
- Impact: Correctness, critical performance
- Effort: 2-3 hours
- ROI: High

🟡 Next Sprint (Severity 2): 35 issues  
- Impact: Moderate performance, UX
- Effort: 1 day
- ROI: Medium

⚪ Technical Debt (Severity 1): 200 issues
- Impact: Code quality, maintainability
- Effort: 2-3 weeks (if doing all)
- ROI: Low (unless scaling to large team)

Recommendation:
1. Fix all Severity 3-4 today (critical)
2. Create backlog items for Severity 2
3. Address Severity 1 during refactoring cycles (not urgently)

Want me to prioritize the Severity 3-4 issues by business impact?"
```

---

## Advanced Topics

### Custom BPA Rules for Your Organization

Create organization-specific rules:

```json
[
  {
    "ID": "ACME_MEASURE_PREFIX",
    "Name": "[ACME] Measures must start with 'm_'",
    "Category": "Naming Conventions",
    "Description": "Company standard: All measures use 'm_' prefix",
    "Severity": 2,
    "Scope": "Measure",
    "Expression": "IsVisible and not Name.StartsWith(\"m_\")",
    "CompatibilityLevel": 1200
  },
  {
    "ID": "ACME_NO_DIRECTQUERY_CALC_COLUMNS",
    "Name": "[ACME] No calculated columns in DirectQuery tables",
    "Category": "Performance",
    "Description": "DirectQuery tables must not have calculated columns (breaks query folding)",
    "Severity": 4,
    "Scope": "CalculatedColumn",
    "Expression": "Table.Partitions.Any(Mode = PartitionMode.DirectQuery)",
    "CompatibilityLevel": 1200
  }
]
```

**Integration with Skill**:
```
User: "We created custom BPA rules. Can you help test them?"

Skill Response:
"I'll help validate your custom rules. Share the JSON and I'll check:

✅ Validation Checklist:
1. **Expression Syntax**: Valid Dynamic LINQ
2. **Scope**: Matches target objects (Measure, Table, etc.)
3. **Severity**: Appropriate for impact (1-5)
4. **False Positives**: Edge cases where rule fires incorrectly
5. **Performance**: Complex expressions may slow analysis

Example test:
- Create a test model with violations
- Run BPA with your rules
- Verify only intended objects are flagged
- Check if auto-fix works as expected

Send me your rule JSON and sample model, I'll analyze."
```

---

## Summary

### BPA + Skill: Best Together

| Use Case | Tool | Why |
|----------|------|-----|
| **Automated quality gates** | BPA | Fast, consistent, CI/CD friendly |
| **Strategic optimization** | This Skill | Context-aware, explains trade-offs |
| **Code formatting** | BPA | Enforces standards automatically |
| **Algorithm design** | This Skill | Requires understanding business logic |
| **Team onboarding** | BPA + Skill | BPA for rules, Skill for education |
| **Production monitoring** | BPA | Continuous compliance checking |
| **Troubleshooting** | This Skill | Investigates root causes |
| **Documentation** | This Skill | Explains why rules exist |

**💡 Recommended Workflow**:
1. ✅ Run BPA first (5 minutes)
2. 🎯 Fix obvious auto-fixes (10 minutes)
3. 💬 Bring complex issues to this skill (conversational)
4. ✅ Validate with BPA again (2 minutes)
5. 🔄 Repeat in CI/CD pipeline

---

**Questions? Ask the skill!**

```
@workspace "I need help integrating BPA into my workflow. 
Current setup: [describe your environment]
Goal: [what you want to achieve]"
```

---

**Related Resources**:
- [Tabular Editor BPA Documentation](https://docs.tabulareditor.com/Best-Practice-Analyzer.html)
- [BPA Rules Repository](https://github.com/TabularEditor/BestPracticeRules)
- [Dynamic LINQ Expression Reference](https://github.com/otykier/TabularEditor/wiki/Best-Practice-Analyzer#rule-expression-samples)
