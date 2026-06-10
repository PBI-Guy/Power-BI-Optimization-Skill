# Specialist Handoff Patterns

> **Purpose**: Guidelines for when and how the hub skill should invoke specialized "spoke" skills for deep domain expertise. Supports the hub-and-spoke architecture.

---

## Table of Contents
1. [Overview](#overview)
2. [Decision Matrix](#decision-matrix)
3. [Handoff Communication](#handoff-communication)
4. [Multi-Specialist Coordination](#multi-specialist-coordination)
5. [Escalation Patterns](#escalation-patterns)

---

## Overview

The Power BI Optimization hub skill provides **broad analysis with moderate depth**. For complex, domain-specific work, invoke specialized skills:

- **@dax-mastery**: Advanced DAX formula optimization and performance profiling
- **@model-design**: Semantic model architecture and restructuring
- **@report-performance**: Report UX design, accessibility, and visual optimization
- **@powerquery-m**: Power Query M code and refresh optimization
- **@security-rls**: Row-level security design and performance

### When to Hand Off

**Hub handles** (80% of scenarios):
- ✅ Common anti-patterns with known fixes
- ✅ Initial triage and diagnosis
- ✅ Quick wins and standard optimizations
- ✅ Coordination across multiple domains

**Specialists handle** (20% requiring deep expertise):
- 🎯 Complex scenarios requiring advanced techniques
- 🎯 Major restructuring or architectural changes
- 🎯 Performance profiling with specialized tools
- 🎯 Compliance requirements (accessibility, security)
- 🎯 Edge cases and custom solutions

---

## Decision Matrix

### 🧮 DAX Mastery (@dax-mastery)

| Scenario | Hub | Specialist | Reason |
|----------|-----|------------|--------|
| Simple SUMX with RELATED | ✅ Hub | - | Standard pattern, known fix |
| Nested iterators (2 levels) | ✅ Hub | - | Common optimization |
| Complex calc groups | Initial analysis | 🎯 Specialist | Requires advanced context understanding |
| Formula >50 lines | Assessment | 🎯 Specialist | Needs careful refactoring |
| DAX Studio profiling needed | Identify issue | 🎯 Specialist | Requires tool expertise |
| Custom time intelligence | ✅ Hub | 🎯 for edge cases | Most patterns known |
| Calculation engine deep-dive | No | 🎯 Specialist | Requires SE/FE analysis |
| Statistical benchmarking | No | 🎯 Specialist | Requires methodology expertise |

**Invoke @dax-mastery when:**
- ✅ Formula exceeds 50 lines or has 3+ nesting levels
- ✅ Calculation groups with dynamic calculations
- ✅ Performance issue persists after hub-level optimizations
- ✅ Need DAX Studio query plans or VertiPaq Analyzer insights
- ✅ Complex context manipulation (CALCULATE modifiers, virtual relationships)
- ✅ Advanced time intelligence (custom calendars, non-standard periods)
- ✅ Statistical performance testing (A/B benchmarking, variance analysis)

**Hub keeps when:**
- ❌ Standard iterator patterns (SUMX, FILTER basics)
- ❌ Simple context transitions with known solutions
- ❌ Variable introduction for computation reuse
- ❌ Basic time intelligence (YTD, YoY, simple moving averages)

---

### 🗂️ Model Design (@model-design)

| Scenario | Hub | Specialist | Reason |
|----------|-----|------------|--------|
| Star schema validation | ✅ Hub | - | Checklist-based analysis |
| Snowflake → Star migration | Guide principles | 🎯 Specialist | Requires detailed planning |
| Relationship cardinality fix | ✅ Hub | - | Standard validation |
| Many-to-many pattern | Basic detection | 🎯 Specialist | Complex solutions |
| Storage mode selection | ✅ Hub | - | Decision matrix available |
| Composite model design | Basic guidance | 🎯 Specialist | Architecture complexity |
| Model >10GB optimization | Assessment | 🎯 Specialist | Requires specialized techniques |
| Incremental refresh config | Basic setup | 🎯 Specialist | Complex scenarios |

**Invoke @model-design when:**
- ✅ Major schema restructuring (snowflake → star, denormalization)
- ✅ Complex many-to-many relationships or bridge tables
- ✅ Large model optimization (>10GB semantic models)
- ✅ Composite model architecture (Import + DirectQuery hybrid)
- ✅ Incremental refresh with RangeStart/RangeEnd parameters
- ✅ Role-playing dimensions (multiple relationships, inactive relationships strategy)
- ✅ Parent-child hierarchies or ragged hierarchies
- ✅ Model security architecture (object-level security planning)

**Hub keeps when:**
- ❌ Simple star schema validation
- ❌ Basic cardinality corrections
- ❌ Hiding foreign key columns
- ❌ Standard storage mode recommendations (simple cases)
- ❌ Removing unused tables/columns

---

### 📊 Report Performance (@report-performance)

| Scenario | Hub | Specialist | Reason |
|----------|-----|------------|--------|
| Visual count assessment | ✅ Hub | - | Simple count & recommend |
| Page load optimization | ✅ Hub | - | Standard patterns |
| Major UX redesign | Suggest principles | 🎯 Specialist | Requires design expertise |
| Accessibility compliance | Awareness | 🎯 Specialist | WCAG 2.1 standards |
| Custom visual optimization | Identify issue | 🎯 Specialist | Requires deep investigation |
| Bookmark patterns | Basic | 🎯 for complex | Advanced navigation needs expert |
| Mobile layout | Guidelines | 🎯 Specialist | Responsive design expertise |
| Tooltip optimization | ✅ Hub | - | Standard best practices |

**Invoke @report-performance when:**
- ✅ Major report redesign or navigation restructure
- ✅ Accessibility compliance required (WCAG 2.1 AA or AAA)
- ✅ Custom visual performance issues (need code-level analysis)
- ✅ Complex bookmark and navigation patterns (page navigation, drill-through flows)
- ✅ Mobile-first or responsive design requirements
- ✅ Report has >15 visuals and needs consolidation strategy
- ✅ Advanced drill-through patterns (multiple targets, parameter passing)
- ✅ Report theme customization and branding

**Hub keeps when:**
- ❌ Visual count recommendations (under 15)
- ❌ Slicer type selection (dropdown vs tiles)
- ❌ Basic cross-highlighting optimization
- ❌ Standard tooltip best practices
- ❌ General page layout principles

---

### 🔄 Power Query M (@powerquery-m)

| Scenario | Hub | Specialist | Reason |
|----------|-----|------------|--------|
| Slow refresh detected | ✅ Hub | - | Can identify common causes |
| Query folding validation | Basic check | 🎯 Specialist | Requires SQL profiling |
| Refresh >30 minutes | Assessment | 🎯 Specialist | Deep M optimization needed |
| Complex M transformations | Identify issue | 🎯 Specialist | M code expertise |
| Incremental load setup | Guidance | 🎯 Specialist | Implementation details |
| Data source optimization | Principles | 🎯 Specialist | Source-specific knowledge |
| Memory errors on refresh | Diagnose | 🎯 Specialist | Requires memory profiling |

**Invoke @powerquery-m when:**
- ✅ Refresh duration exceeds 30 minutes
- ✅ Query folding issues (need to verify SQL generation)
- ✅ Complex M code with performance issues (nested merge, table.AddColumn chains)
- ✅ Incremental refresh configuration for large tables
- ✅ Data source specific optimization (SQL, APIs, files)
- ✅ Memory errors or resource exhaustion during refresh
- ✅ Parameterized queries and dynamic sources
- ✅ Bulk data loading from multiple sources

**Hub keeps when:**
- ❌ Basic M query simplification
- ❌ Removing unnecessary columns early in query
- ❌ Standard data type conversions
- ❌ Simple query folding awareness (filter pushdown basics)

---

### 🔒 Security & RLS (@security-rls)

| Scenario | Hub | Specialist | Reason |
|----------|-----|------------|--------|
| Basic RLS setup | ✅ Hub | - | Standard patterns |
| RLS performance issues | Identify | 🎯 Specialist | Optimization expertise |
| Dynamic RLS patterns | Principles | 🎯 Specialist | Complex implementation |
| Multi-table RLS | Basic guidance | 🎯 Specialist | Relationship propagation |
| OLS (object-level security) | Awareness | 🎯 Specialist | Advanced feature |
| RLS with bidirectional | Warning | 🎯 Specialist | Complex security implications |

**Invoke @security-rls when:**
- ✅ Dynamic row-level security with user tables
- ✅ RLS performance issues (security filters slow queries)
- ✅ Complex role hierarchies (managers see team data)
- ✅ Object-level security (column/table restrictions)
- ✅ RLS with bidirectional relationships
- ✅ Testing and validation strategy for RLS
- ✅ Combining RLS with report-level sharing/security

**Hub keeps when:**
- ❌ Simple static RLS (username() = 'xxx')
- ❌ Basic awareness of RLS impact on performance
- ❌ Recommendation to test RLS with "View as Role"

---

## Handoff Communication

### Handoff Template

When handing off to a specialist, provide structured context:

```markdown
## Specialist Handoff: [Specialist Name]

### Context from Hub Analysis
**Model**: [Name]
**Primary Issue**: [One-line description]
**Priority**: P[0-3]

### Current Performance Baseline
- [Key metric]: [Value] (e.g., "Query time: 8.5s")
- [Model size]: [Value if applicable]
- [Data volume]: [Row counts]

### Hub Findings
1. [Finding 1 with specifics]
2. [Finding 2 with specifics]
3. [Related observations]

### Why Specialist Needed
[Explanation of complexity that requires specialist expertise]

### Scope for Specialist
**Focus on**: [Specific area]
**Constraints**: [User requirements, limitations]
**Expected output**: [What user needs]

### User Requirements
- **Target performance**: [If specified]
- **Constraints**: [Don't change X, must work with Y]
- **Timeline**: [If urgent]

### Questions for Specialist
1. [Specific question requiring expert answer]
2. [Specific question requiring expert answer]

---

[@specialist-name]: Please analyze and provide:
1. Deep analysis of [specific issue]
2. Optimized solution meeting [requirements]
3. Implementation guidance with steps
4. Performance impact estimates
```

### Example Handoff 1: Complex DAX

```markdown
## Specialist Handoff: @dax-mastery

### Context from Hub Analysis
**Model**: Sales Analysis (FactSales: 12M rows)
**Primary Issue**: Complex time intelligence measure taking 8.5s per query
**Priority**: P1 - High (affects executive dashboard)

### Current Performance Baseline
- Query time: 8.5 seconds (target: <2s)
- Formula length: 127 lines
- Nesting level: 5 deep with multiple CALCULATE modifiers

### Hub Findings
1. Measure combines YTD, rolling 12-month, and same-period-last-year calculations
2. Uses nested CALCULATE with multiple date table filters
3. Contains redundant filter context modifications
4. No variable usage for repeated date calculations

### Why Specialist Needed
Formula complexity exceeds hub capability:
- 5-level nesting makes refactoring risky
- Custom fiscal calendar (July-June) with complex logic
- Context manipulation using CALCULATETABLE and TREATAS
- Need DAX Studio analysis to identify specific bottleneck (SE vs FE)

### Scope for Specialist
**Focus on**: Formula refactoring for performance + maintainability
**Constraints**: 
- Must maintain custom fiscal year logic
- Cannot change calendar table structure
- Must work with existing relationships

**Expected output**: 
- Refactored measure achieving <2s query time
- Explanation of optimizations for learning
- Testing approach to validate correctness

### User Requirements
- **Target performance**: <2 seconds per query
- **Constraints**: Fiscal year logic must remain accurate
- **Timeline**: High priority (executive dashboard impacted)

---

@dax-mastery: Please analyze and provide:
1. DAX Studio query plan analysis (storage vs formula engine)
2. Refactored measure with variable optimization
3. Explanation of each optimization technique used
4. Before/after performance comparison methodology
```

### Example Handoff 2: Model Restructure

```markdown
## Specialist Handoff: @model-design

### Context from Hub Analysis
**Model**: Enterprise ERP Import (8.2 GB, 18 tables)
**Primary Issue**: Snowflake schema causing performance issues
**Priority**: P1 - High (impacts 200+ users)

### Current Performance Baseline
- Query time: 12-18 seconds for typical report page
- Model size: 8.2 GB
- Refresh time: 3.5 hours
- Schema: 4-hop snowflake from fact to lowest dimension

### Hub Findings
1. Snowflake structure with 4 dimension-to-dimension chains:
   - Product → ProductCategory → CategoryGroup → BusinessUnit
   - Customer → Region → Territory → Country
2. 47 DAX measures reference these nested dimensions
3. Multiple fact tables all connect through snowflake paths
4. Poor compression due to dimension duplication across facts

### Why Specialist Needed
Major architectural redesign required:
- Multi-table denormalization impacting 18 tables
- Need to assess which dimensions to merge vs keep separate
- 47 DAX measures need impact analysis and potential updates
- Risk of breaking existing reports if not carefully planned
- Requires phased implementation strategy

### Scope for Specialist
**Focus on**: Star schema transformation plan with minimal disruption
**Constraints**: 
- Cannot change refresh schedule (must maintain overnight window)
- 15 published reports depend on current structure
- Business users cannot learn new dimension names (must maintain semantic layer)

**Expected output**: 
- Phase-by-phase transformation plan
- List of tables to merge with rationale
- DAX measure migration strategy
- Testing and rollback approach
- Performance improvement estimates

### User Requirements
- **Target performance**: <5 seconds per page (from 12-18s)
- **Constraints**: No user retraining, maintain existing report definitions where possible
- **Timeline**: Can implement over 2 sprints (4 weeks)

---

@model-design: Please analyze and provide:
1. Recommended star schema structure (which tables to merge)
2. Phased implementation plan (minimize disruption)
3. DAX measure migration analysis (which need updates)
4. Before/after performance estimates per phase
5. Testing strategy to ensure business logic preserved
```

---

## Multi-Specialist Coordination

For issues spanning multiple domains, hub coordinates parallel or sequential specialist engagement.

### Scenario 1: Model Restructure with Downstream Impacts

**User Request**: "Convert snowflake to star schema"

**Hub Coordination**:

```markdown
## Multi-Specialist Coordination Plan

### Issue: Snowflake Schema Transformation
**Complexity**: High - Impacts model, DAX, and potentially reports
**Estimated Duration**: 3-4 weeks with testing

### Phase 1: Model Analysis (@model-design)
**Timing**: Week 1
**Deliverable**: Star schema design, table merge plan

**Questions for Model Design**:
1. Which dimensions should be merged?
2. What's the optimal denormalization strategy?
3. How to maintain referential integrity?

### Phase 2: DAX Impact Assessment (@dax-mastery)  
**Timing**: Week 1-2 (overlaps with Phase 1)
**Deliverable**: List of affected measures with migration strategy

**Questions for DAX Mastery**:
1. Which of 47 measures reference dimension chains?
2. Can any measures be simplified after restructure?
3. Are there calculation groups that need updates?

**Dependencies**: Needs model design output to assess specific impacts

### Phase 3: Report Visual Assessment (@report-performance)
**Timing**: Week 2
**Deliverable**: List of visuals using affected columns, mitigation plan

**Questions for Report Performance**:
1. Which visuals use columns from tables being merged?
2. Will slicer configurations need updates?
3. Are there bookmarks depending on specific column names?

**Dependencies**: Needs model design output

### Phase 4: Hub Synthesis & Implementation Plan
**Timing**: Week 2-3
**Deliverable**: Integrated implementation roadmap

**Hub Role**:
1. Combine specialist recommendations
2. Identify conflicts or dependencies
3. Create phased implementation plan:
   - Phase 1: Model changes (1 week)
   - Phase 2: DAX updates (3 days)
   - Phase 3: Report validation (2 days)
   - Phase 4: User acceptance testing (3 days)
4. Define rollback triggers and procedures

### Phase 5: Validation Strategy
**Timing**: Week 3-4
**Deliverable**: Testing checklist and success criteria

**Combined from all specialists**:
- Functional tests (correctness)
- Performance tests (query times)
- Visual tests (no broken reports)
- User acceptance (business validation)
```

### Scenario 2: Performance Issue Root Cause Unknown

**User Request**: "My report is very slow, not sure why"

**Hub Triage Process**:

```markdown
## Diagnostic Triage

### Step 1: Hub Initial Assessment
**Actions**:
1. Analyze with Performance Analyzer (if provided)
2. Check visual count and types
3. Review DAX measure complexity
4. Validate model structure basics

**Findings**:
- Page load time: 45 seconds
- Visual count: 18 (above threshold)
- 3 measures taking >5 seconds each
- DirectQuery mode detected

### Step 2: Prioritize Root Causes
**Analysis**:
1. **Report level**: 18 visuals → Excess visual count (40% of problem)
2. **DAX level**: 3 slow measures → Complex iterators (30% of problem)
3. **Model level**: DirectQuery without aggregations (30% of problem)

### Step 3: Parallel Specialist Invocation

Invoke multiple specialists **in parallel** since issues are independent:

**@report-performance**:
- Reduce from 18 to 9-10 visuals
- Identify which visuals to consolidate or remove
- Optimize interactions

**@dax-mastery**:
- Optimize 3 slow measures (details below)
- Evaluate if DirectQuery limits optimizations

**@model-design** (lower priority):
- Assess if aggregation tables would help DirectQuery performance
- Evaluate storage mode alternatives

### Step 4: Hub Synthesis
**After specialists return**:
1. Calculate combined impact:
   - Visual reduction: 45s → 25s (44% improvement)
   - DAX optimization: 25s → 12s (52% improvement)
   - Aggregation tables: 12s → 6s (50% improvement)
   - **Total**: 45s → 6s (87% improvement)

2. Prioritize implementation:
   - **Quick win**: Report visual consolidation (2 hours work, 44% gain)
   - **Medium effort**: DAX optimization (4 hours, additional 52% gain)
   - **Longer term**: Aggregation tables (1-2 days, final 50% gain on remaining)

3. Create implementation roadmap with user
```

---

## Escalation Patterns

### Specialist → Hub Escalation

Specialists escalate **back to hub** when:

1. **Multi-domain impacts discovered**
   - "This DAX optimization requires model structure changes"
   - Hub coordinates with @model-design

2. **Broader architectural concerns**
   - "This RLS pattern conflicts with report navigation design"
   - Hub assesses trade-offs holistically

3. **User requirement clarification needed**
   - "Need to understand business priority: speed vs accuracy?"
   - Hub interfaces with user

4. **Scope expansion beyond initial request**
   - "Found 15 additional related issues during deep analysis"
   - Hub helps prioritize and scope

### Example Escalation

```markdown
## Escalation from @dax-mastery to Hub

### Original Request
Optimize complex time intelligence measure

### Findings During Analysis
While analyzing the measure, I discovered:

1. **Primary issue**: DAX optimization can achieve 60% improvement
2. **Secondary issue**: Fiscal calendar table has date gaps (weekends missing)
3. **Blocker**: Calendar table issues prevent some time intelligence functions from working correctly

### Escalation Reason
**Model structure issue** (date table) affects DAX optimization scope.

### Recommendation for Hub
1. Coordinate with @model-design to fix calendar table first
2. Then return to me for DAX optimization on corrected structure
3. Consider if report visuals are using workarounds for date gaps (report-performance)

### Impact of Not Addressing
- DAX optimization limited to 40% instead of 60% improvement
- Time intelligence functions will remain partially broken
- Future maintenance burden from workarounds

Hub: Please coordinate calendar table fix, then I'll complete DAX optimization.
```

---

## Best Practices for Handoffs

### Do's ✅
- ✅ Provide complete context (data volumes, current metrics, constraints)
- ✅ Explain why hub can't handle (complexity, tools needed, expertise required)
- ✅ Be specific about what specialist should focus on
- ✅ Share all relevant findings from hub analysis
- ✅ Set clear expectations for deliverables
- ✅ Include user requirements and constraints explicitly

### Don'ts ❌
- ❌ Hand off without initial triage (waste specialist time)
- ❌ Provide vague requests ("make it better")
- ❌ Omit performance baselines or data volumes
- ❌ Forget to mention user constraints or timeline
- ❌ Hand off when hub could easily handle it
- ❌ Hand off without explaining why specialist is needed

---

**Version**: 1.0  
**Last Updated**: 2026-06-10  
**Parent**: SKILL.md (Power BI Optimization Hub)
