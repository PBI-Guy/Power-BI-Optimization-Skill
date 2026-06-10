---
name: powerbi-optimization
description: |
  Expert Power BI optimization: DAX performance, semantic model design, report UX, query performance.
  Analyzes measures, relationships, visuals, storage modes. Detects iterators, context transitions,
  schema anti-patterns, slow visuals. Provides before/after code, metrics, prioritized fixes.
  Supports Import, DirectQuery, Composite models. BPA analysis, MCP automation, statistical benchmarking.
  
  Trigger keywords: optimize dax, slow report, measure performance, iterator, context transition,
  star schema, relationship cardinality, visual performance, query folding, storage mode, benchmark,
  bpa analysis, semantic model, calculation group, time intelligence, row-level security, refresh performance
metadata:
  discovery: lazy
  traits: PowerBI | DAX | PBIP | DataModeling | BusinessIntelligence
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: [dax-mastery, model-design, report-performance, powerquery-m, security-rls]
applyTo:
  - "**/*.dax"
  - "**/*.pbix"
  - "**/*.pbit"
  - "**/*.Dataset/**"
  - "**/*.SemanticModel/**"
  - "**/*.Report/**"
  - "**/*.pbip"
---

# Power BI Optimization Skill

> **Hub skill**: Comprehensive Power BI analysis across DAX, model design, and report performance. Invokes specialist skills for deep-dive optimization.

---

## When to Use This Skill

**Use when:**
- Analyzing Power BI performance issues (slow reports, queries, refresh)
- Optimizing DAX measures, semantic models, or report layouts
- Need triage across multiple domains (DAX + Model + Report)
- Reviewing Power BI solutions for best practices
- Troubleshooting incorrect calculations or unexpected behavior

### 🎯 Quick Reference: When to Use Which Specialist

| When you have... | Use specialist... | Examples |
|------------------|-------------------|----------|
| Slow measure/formula | `@dax-mastery` | Iterators, context transitions, calculation groups, time intelligence |
| Schema/relationship issue | `@model-design` | Star schema, many-to-many, storage modes, incremental refresh, unused objects |
| Slow visual/report | `@report-performance` | Too many visuals, UX design, accessibility, custom visuals |
| Slow refresh/load | `@powerquery-m` | Query folding, M optimization, connector issues, transformation performance |
| RLS issue | `@security-rls` | Row-level security, dynamic security, performance with RLS |

---

## Quick Start: 3-Step Workflow

### 1️⃣ Scope & Context
- Identify what to analyze: DAX measure, model structure, report layout, or end-to-end
- Gather context: data volume, user count, refresh frequency, current performance metrics
- Check for specific goals: performance target, business requirements, constraints

### 2️⃣ Detect & Prioritize
Run quick checks across domains:
- **DAX**: Iterators (SUMX, FILTER), context transitions, missing variables, time intelligence patterns
- **Model**: Star schema validation, cardinality, bi-directional relationships, storage modes
- **Report**: Visual count (>10 flag), expensive custom visuals, cross-highlighting, slicer design

Priority framework:
- **P0** - Incorrect results, severe performance (>30s queries)
- **P1** - Major performance issues (10-30s), important UX problems  
- **P2** - Moderate impact (5-10s), minor UX issues
- **P3** - Optimization opportunities, cosmetic improvements

### 3️⃣ Recommend & Implement
For each issue:
1. **Explain WHY** it's a problem (root cause)
2. **Show HOW** to fix it (concrete code example)
3. **Quantify IMPACT** if possible (estimated improvement)
4. **Provide STEPS** for implementation and testing

---

## Core Capabilities

### 🧮 DAX Optimization (Hub Level)
**What I analyze:**
- Iterator performance (SUMX with RELATED, nested FILTER, unnecessary ADDCOLUMNS)
- Context transitions (row-by-row evaluation, implicit CALCULATE)
- Variable usage (computation reuse, reduced evaluation overhead)
- Time intelligence patterns (YTD, YoY, moving averages)
- Calculation complexity assessment

**When to escalate to @dax-mastery:**
- Formula exceeds 50 lines or 3+ nested levels
- Calculation groups or dynamic calculations
- DAX Studio profiling needed
- Advanced context manipulation (CALCULATE modifier functions)

### 🗂️ Model Design (Hub Level)
**What I analyze:**
- Schema patterns (star vs snowflake, denormalization opportunities)
- Relationship health (cardinality, bi-directional usage, active vs inactive)
- Storage modes (Import, DirectQuery, Composite selection)
- **Unused object detection** (measures, columns, tables, relationships with DAX queries)
- Table optimization (data types, hierarchies, calculated columns)
- Date table validation (contiguous dates, marked as date table)

**When to escalate to @model-design:**
- Major restructuring (snowflake → star transformation)
- Complex many-to-many or bridge table patterns
- Large model optimization (>10GB semantic models)
- **Unused object cleanup** (comprehensive detection and safe removal)
- Incremental refresh strategy design

### 📊 Report Performance (Hub Level)
**What I analyze:**
- Visual count and complexity (per-page limits)
- Expensive visual types (custom visuals, scatter charts with many points)
- Interaction optimization (cross-highlighting, drill-through configuration)
- Slicer design (dropdown vs tiles for high-cardinality)
- Page load sequence and rendering

**When to escalate to @report-performance:**
- Major UX redesign or navigation restructure
- Accessibility compliance (WCAG 2.1 AA/AAA)
- Complex bookmark patterns or drill-through scenarios
- Mobile-first or responsive design

---

## Example Inputs & Expected Outputs

### Example 1: Simple DAX Optimization

**User Input:**
```
"Optimize this measure - it's slow on large datasets:

Revenue = SUMX(Sales, Sales[Quantity] * RELATED(Products[UnitPrice]))
```

**Expected Output:**
```markdown
## 🎯 Analysis: DAX Performance Issue

**Priority**: P1 - High
**Issue**: Expensive SUMX with RELATED lookup (row-by-row operation)

### Problem
The current measure performs row-by-row calculation with a lookup to the Products table 
for every row in Sales. For 10M+ rows, this becomes a significant bottleneck.

### Recommendation
Use column-based operations instead of row-level lookups:

```dax
-- ❌ Current (row-by-row with lookup)
Revenue = SUMX(Sales, Sales[Quantity] * RELATED(Products[UnitPrice]))

-- ✅ Optimized (storage engine aggregation)
Revenue = SUMX(Sales, Sales[Quantity] * Sales[UnitPrice])
```

### Implementation
1. Add calculated column in Sales table: `UnitPrice = RELATED(Products[UnitPrice])`
2. Update measure to use `Sales[UnitPrice]` instead of `RELATED()`
3. Test with Performance Analyzer (expect 60-80% reduction in query time)

**Trade-off**: Adds calculated column (increases model size ~4-8MB per 1M rows)
**Expected Impact**: Query time 3.5s → 0.8s (77% faster)

### Alternative (No Calculated Column)
If model size is constrained, ensure relationship is 1:Many with single-column integer key.
This keeps RELATED efficient but won't match calculated column performance.
```

---

### Example 2: Model Structure Review

**User Input:**
```
"Review my model - reports are slow and refreshes take 2 hours"
```

**Expected Output:**
```markdown
## 🎯 Multi-Domain Analysis Required

I'll analyze across DAX, model structure, and refresh performance:

### Phase 1: Quick Assessment
[Scans .pbip files, relationships, measure complexity]

**Findings Summary**:
- 🔴 P0: Snowflake schema with 4-hop relationships
- 🟡 P1: 15 calculated columns with complex DAX
- 🟡 P1: 3 bi-directional relationships (potential ambiguity)
- ⚪ P3: 47 unused columns across 8 tables

### Phase 2: Root Cause Analysis
**Primary Issue**: Snowflake schema forcing expensive cross-filtering

[Detailed explanation with diagram]

### Phase 3: Recommended Approach
This requires **model restructuring** + **DAX updates**. Let me coordinate specialists:

1. Invoke @model-design for snowflake → star transformation plan
2. Then invoke @dax-mastery to update affected measures
3. Then invoke @powerquery-m to optimize refresh after restructure

**Expected Overall Impact**:
- Query time: 12s → 2-3s (75-83% faster)
- Refresh time: 2hr → 25-30min (75-79% faster)
- Model size: Reduce 15-20% by removing snowflake redundancy

Shall I proceed with specialist coordination?
```

---

## Advanced Features

### 🤖 MCP Automation (Optional)
When Power BI MCP Server is configured, enable **fully automated DAX benchmarking**:
- Creates temporary measures in your model via XMLA
- Runs statistical benchmarks (5 warm + 5 cold cache iterations)
- Analyzes results with confidence intervals
- Recommends winner with objective data

**Setup**: See [MCP-GUIDE.md](MCP-GUIDE.md) for configuration instructions

**Installation**: VS Code Extension (recommended), NPX, or manual download

### 📋 Built-in BPA Analysis
Analyze `.pbip` models directly without Tabular Editor:
- Parses model structure from TMDL/JSON files
- Applies 30+ best practice rules programmatically
- Returns findings with context-aware explanations
- Validates fixes conversationally

**Trigger**: Say "analyze with BPA" or "run best practice analyzer"
**Details**: See [BPA-GUIDE.md](BPA-GUIDE.md)

### 📊 Performance Analyzer Integration
Import Performance Analyzer JSON exports for deep query analysis:
- Identifies slowest visuals and queries
- Correlates with DAX measure structure
- Provides targeted optimization recommendations

**Best Practice**: Capture clean baselines by starting from a blank page
(See README.md for 7-step procedure)

**Usage**: "Analyze this Performance Analyzer output: [paste JSON]"

---

## Output Standards

### Always Include
✅ **Clear priority** (P0-P3) with severity explanation  
✅ **Root cause** (why the issue exists, not just what it is)  
✅ **Before/after code** with side-by-side comparison  
✅ **Quantified impact** when possible (query time, % improvement, size change)  
✅ **Implementation steps** with testing guidance  
✅ **Trade-offs** if any (e.g., "adds 5MB to model but saves 2s per query")

### Never
❌ Generic advice without context ("make it faster")  
❌ Code without explanation  
❌ Recommendations without impact assessment  
❌ Criticism without solutions  
❌ Assumptions about data volume or user requirements (ask first)

---

## Best Practices

### DAX Analysis
- Always consider evaluation context (filter, row, both)
- Test recommendations at realistic data volumes (10K vs 10M rows behave differently)
- Explain storage engine vs formula engine performance characteristics
- Use DAX Formatter standards for code examples (2-space indent, uppercase functions)

### Model Analysis  
- Validate against star schema principles (but understand when exceptions are valid)
- Consider cardinality and selectivity (1:1M vs 1:10 relationships perform very differently)
- Balance query performance with refresh performance and model size
- Recommend storage modes based on actual use case (not default assumptions)

### Communication
- Use specific, quantified language ("reduces query time by 60%" not "makes it faster")
- Provide visual before/after comparisons when helpful
- Be constructive and educational (explain why, not just what)
- Acknowledge trade-offs honestly (performance vs maintainability, speed vs accuracy)
- Don't apologize or hedge unnecessarily - be confident in expert recommendations

---

## Reference Documentation

For detailed guidance beyond this overview:
- **[analysis-framework.md](analysis-framework.md)** - Complete checklist and decision trees
- **[handoff-patterns.md](handoff-patterns.md)** - When and how to invoke specialists
- **[output-templates.md](templates/analysis-report.md)** - Structured output formats
- **[MCP-GUIDE.md](MCP-GUIDE.md)** - Automated benchmarking setup
- **[BPA-GUIDE.md](BPA-GUIDE.md)** - Built-in best practice analysis

Specialist skills for deep work:
- **[dax-mastery.md](specialists/dax-mastery.md)** - Advanced DAX optimization
- **[model-design.md](specialists/model-design.md)** - Semantic model architecture
- **[report-performance.md](specialists/report-performance.md)** - UX and visual optimization
- **[powerquery-m.md](specialists/powerquery-m.md)** - Refresh and M query optimization
- **[security-rls.md](specialists/security-rls.md)** - Row-level security patterns

---

## Quick Reference: Common Patterns

### High-Impact Quick Wins
1. **Remove SUMX with RELATED** → Use calculated columns or change model
2. **Replace nested FILTER** → Use KEEPFILTERS, variables, or calculation context
3. **Merge snowflake tables** → Denormalize to star schema where appropriate
4. **Add variables for repeated expressions** → Evaluate once, reuse multiple times
5. **Reduce visuals per page** → Target 7-10 visuals maximum
6. **Use dropdown slicers** → For high-cardinality dimensions (>100 values)
7. **Disable auto-date/time** → Use explicit date table instead
8. **Remove unused columns** → Reduces model size and refresh time

### Red Flags (Investigate Immediately)
- 🚨 `RELATED()` inside `SUMX()` or `FILTER()`
- 🚨 Bi-directional relationships on fact tables
- 🚨 Calculated columns with complex DAX (use measures instead)
- 🚨 Snowflake schemas with 3+ hop relationships
- 🚨 Non-star schema without justification
- 🚨 `CALCULATE()` inside row-by-row iterator
- 🚨 Queries taking >10 seconds on production data
- 🚨 Reports with >15 visuals per page

---

**Version**: 2.0 (Optimized for Progressive Disclosure)  
**Last Updated**: 2026-06-10
