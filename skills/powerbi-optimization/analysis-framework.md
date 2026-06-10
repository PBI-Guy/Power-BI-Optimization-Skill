# Power BI Analysis Framework

> **Purpose**: Detailed checklists, decision trees, and methodologies for comprehensive Power BI analysis. Referenced by main SKILL.md for deep technical guidance.

---

## Table of Contents
1. [Phase 1: Scope Identification](#phase-1-scope-identification)
2. [Phase 2: Issue Detection](#phase-2-issue-detection)
3. [Phase 3: Impact Assessment](#phase-3-impact-assessment)
4. [Phase 4: Recommendations](#phase-4-recommendations)
5. [Phase 5: Implementation Guidance](#phase-5-implementation-guidance)

---

## Phase 1: Scope Identification

### Determine Analysis Scope

**Questions to Ask:**
1. What artifacts need analysis?
   - [ ] Single DAX measure
   - [ ] Multiple related measures
   - [ ] Calculation groups
   - [ ] Entire semantic model structure
   - [ ] Report layout and visuals
   - [ ] End-to-end solution (all layers)

2. What's the primary concern?
   - [ ] Performance (slow queries, rendering, refresh)
   - [ ] Correctness (wrong calculations, unexpected values)
   - [ ] Maintainability (complex code, hard to modify)
   - [ ] Best practices compliance
   - [ ] User experience issues

3. What context is available?
   - **Data Volume**: Row counts, table sizes, fact vs dimension cardinality
   - **User Count**: Concurrent users, peak usage times
   - **Refresh Frequency**: Hourly, daily, weekly; duration targets
   - **Performance Targets**: Acceptable query times, page load times
   - **Business Criticality**: Executive dashboard vs ad-hoc analysis

### Context Gathering Template

```markdown
## Analysis Context

**Model Information**:
- Fact table(s): [names] with [row counts]
- Dimension tables: [count] tables, largest has [rows]
- Total model size: [GB]
- Storage mode: Import / DirectQuery / Composite

**Performance Baseline**:
- Current query time: [seconds] for typical visual
- Page load time: [seconds]
- Refresh duration: [minutes/hours]

**Business Requirements**:
- Target audience: [executives/analysts/end users]
- SLA targets: [query time] / [refresh window]
- Concurrent users: [typical] peak [max]
- Critical scenarios: [list key use cases]

**Known Issues**:
1. [Specific problem]
2. [Specific problem]
```

---

## Phase 2: Issue Detection

### DAX Analysis Checklist

#### 🔴 Critical Performance Issues (P0-P1)

**Expensive Iterators**:
- [ ] `SUMX()` or `AVERAGEX()` with `RELATED()` lookup inside
  - **Detection**: Search for `RELATED(` inside iterator functions
  - **Impact**: Row-by-row foreign key lookup (storage engine can't optimize)
  - **Typical overhead**: 5-10x slower than calculated column approach

- [ ] Nested `FILTER()` within `FILTER()`
  - **Detection**: `FILTER( FILTER(`
  - **Impact**: Multiple table scans, exponential complexity
  - **Typical overhead**: 3-20x depending on table sizes

- [ ] `CALCULATE()` inside row-level iterator
  - **Detection**: `SUMX( table, CALCULATE(` or similar
  - **Impact**: Context transition per row (formula engine bottleneck)
  - **Typical overhead**: 10-50x on large fact tables

**Context Transition Issues**:
- [ ] Measure reference inside iterator without necessity
  - **Detection**: `SUMX( table, [MeasureName] )`
  - **Impact**: Row context → filter context transition per row
  - **When valid**: Intentional row-level calculation (e.g., running totals)

- [ ] Missing `VALUES()` or `SUMMARIZE()` wrapper
  - **Detection**: Direct table reference where distinct values needed
  - **Impact**: Processing more rows than necessary

**Calculation Redundancy**:
- [ ] Repeated expression not stored in variable
  - **Detection**: Same complex expression 2+ times in formula
  - **Impact**: Multiple evaluations, cache misses
  - **Threshold**: If expression takes >10ms, use variable

- [ ] Unnecessary data type conversions
  - **Detection**: `FORMAT()`, `VALUE()`, `TEXT()` in aggregations
  - **Impact**: Row-by-row conversion overhead

#### 🟡 Medium Priority Issues (P2)

**Time Intelligence Patterns**:
- [ ] Manual date filtering instead of time intelligence functions
  - **Detection**: `FILTER( ALL(Date), Date[Year] = ... )`
  - **Better**: `DATESYTD()`, `SAMEPERIODLASTYEAR()`

- [ ] Non-optimal year-over-year calculations
  - **Detection**: Complex nested `CALCULATE()` with date logic
  - **Better**: `VAR` for current value, `CALCULATE( [Measure], SAMEPERIODLASTYEAR() )`

**Formula Complexity**:
- [ ] Measure exceeds 50 lines
  - **Action**: Consider breaking into sub-measures or calculation groups
  - **Maintainability**: Hard to debug and modify

- [ ] Deeply nested logic (>4 levels of `IF()` or `SWITCH()`)
  - **Detection**: Count nested parentheses depth
  - **Better**: Calculation table or separate measures

#### ⚪ Low Priority (P3)

**Code Quality**:
- [ ] Missing comments for complex logic
- [ ] Inconsistent formatting (not DAX Formatter standard)
- [ ] Measures without clear naming convention
- [ ] Missing display folders or description metadata

---

### Semantic Model Analysis Checklist

#### 🔴 Critical Design Issues (P0-P1)

**Schema Patterns**:
- [ ] Snowflake schema (dimension tables joined to dimension tables)
  - **Detection**: Dimension table has relationship to another dimension
  - **Impact**: Multi-hop queries, poor compression, complex DAX
  - **Action**: Denormalize to star schema (fact → dimension, dimension independent)

- [ ] Many-to-many relationships without bridge table
  - **Detection**: Cardinality set to "many" on both sides
  - **Impact**: Ambiguous cross-filtering, unpredictable results
  - **Action**: Create bridge table or use CROSSFILTER() in DAX

- [ ] Bi-directional relationships on fact tables
  - **Detection**: Fact table with cross-filter direction "Both"
  - **Impact**: Performance degradation, potential ambiguity
  - **When valid**: Rarely; usually indicates model structure problem

**Relationship Health**:
- [ ] Wrong cardinality (one-to-many set as many-to-many)
  - **Detection**: Validate actual data uniqueness vs relationship setting
  - **Impact**: Incorrect aggregations, poor performance

- [ ] Missing relationships causing manual FILTER() workarounds
  - **Detection**: DAX uses `FILTER()` to join tables instead of relationships
  - **Action**: Add relationship if valid, or use TREATAS()

- [ ] Hidden foreign key columns not hidden
  - **Detection**: FK columns like ProductID in fact table visible
  - **Action**: Hide FK columns (use dimension table columns instead)

#### 🟡 Medium Priority Issues (P2)

**Storage Mode Optimization**:
- [ ] DirectQuery mode without query folding validation
  - **Detection**: Check if M queries generate efficient SQL
  - **Impact**: Row-by-row processing instead of pushdown
  - **Action**: Simplify Power Query, use native SQL where possible

- [ ] Import mode for slowly-changing large tables
  - **Detection**: Table >5GB, changes <1% daily
  - **Action**: Consider DirectQuery or incremental refresh

- [ ] Missing aggregation tables for DirectQuery
  - **Detection**: DirectQuery fact >10M rows without agg tables
  - **Action**: Create Import aggregations for common queries

**Table Optimization**:
- [ ] Calculated columns where measures would work
  - **Detection**: Calculated columns used only in visuals
  - **Impact**: Increases model size, slows refresh
  - **Action**: Convert to measures unless needed in slicers/axes

- [ ] Unused columns not removed
  - **Detection**: Columns never referenced in measures/visuals
  - **Impact**: Increases model size 5-20%, refresh overhead
  - **Action**: Hide or remove during Power Query

- [ ] Incorrect data types (text instead of integer/date)
  - **Detection**: Manual review of column types
  - **Impact**: Compression efficiency, sort performance, join efficiency

#### ⚪ Low Priority (P3)

**Metadata Quality**:
- [ ] Missing table descriptions
- [ ] No display folders for measures
- [ ] No format strings on measures
- [ ] Missing sort-by columns (e.g., month name sorted by month number)
- [ ] No hierarchies defined for drill-down scenarios

---

### Report Performance Checklist

#### 🔴 Critical UX Issues (P0-P1)

**Visual Overload**:
- [ ] More than 15 visuals on a single page
  - **Detection**: Count visuals in page
  - **Impact**: Long rendering time, overwhelmed users
  - **Threshold**: 7-10 visuals ideal, 15 maximum

- [ ] Multiple expensive custom visuals
  - **Detection**: Identify non-standard visuals (especially with external data loads)
  - **Impact**: 2-10x render time vs native visuals
  - **Action**: Replace with native alternatives or optimize data volume

**Interaction Problems**:
- [ ] All visuals cross-highlight each other unnecessarily
  - **Detection**: Check interaction settings (all bidirectional)
  - **Impact**: Clicking one visual triggers 10+ queries
  - **Action**: Disable cross-highlight where not needed

- [ ] No visual-level filters (relying only on page/report filters)
  - **Detection**: Complex measures doing filtering instead of visual filters
  - **Impact**: Query overhead, formula engine work
  - **Action**: Push filters to visual level where possible

**Slicer Design**:
- [ ] High-cardinality slicers using tiles (>50 values)
  - **Detection**: Slicer with 100+ checkboxes
  - **Impact**: Slow rendering, poor UX
  - **Action**: Use dropdown slicer or search-enabled slicer

#### 🟡 Medium Priority Issues (P2)

**Visual Type Selection**:
- [ ] Scatter charts with >5,000 points
  - **Impact**: Poor interactivity, long render
  - **Action**: Aggregate data or use sampling

- [ ] Tables/matrices with >1,000 rows without pagination
  - **Impact**: Scroll lag, memory overhead
  - **Action**: Enable pagination or add Top N filter

**Page Performance**:
- [ ] No page load optimization settings
  - **Detection**: Check advanced settings
  - **Action**: Enable "Reduce data for print", consider persistent filters

---

## Phase 3: Impact Assessment

### Priority Matrix

Use this framework to assign priority to each issue:

| Priority | Criteria | Example | Action Timeline |
|----------|----------|---------|-----------------|
| **P0 - Critical** | Incorrect results, data integrity issues | Division by zero showing as infinity | Fix immediately (same day) |
| **P1 - High** | Severe performance (>30s) or major UX issues | Report times out, unusable on mobile | Fix this week |
| **P2 - Medium** | Moderate performance (5-30s) or minor UX issues | Slow but usable, confusing navigation | Fix this sprint |
| **P3 - Low** | Optimization opportunities, cosmetic improvements | Could be 20% faster, inconsistent formatting | Fix when convenient |

### Impact Quantification

**When possible, provide concrete metrics:**

Performance improvements:
- "Reduces query time from 3.5s to 0.8s (77% faster)"
- "Decreases model size by 450MB (23% reduction)"
- "Cuts refresh time from 45min to 18min (60% faster)"

Model changes:
- "Adds 1 calculated column (8MB for 2M rows)"
- "Removes 47 unused columns (saves 180MB)"
- "Denormalization increases model by 12% but queries are 65% faster"

Report changes:
- "Reduces visuals from 18 to 9 (page load: 12s → 4s)"
- "Disabling cross-highlight: 8s → 2s per interaction"

---

## Phase 4: Recommendations

### Recommendation Template

For each issue, structure recommendations as:

```markdown
### Issue: [Clear descriptive title]

**Priority**: P[0-3] - [Critical/High/Medium/Low]
**Category**: DAX / Model / Report / Power Query
**Impact**: Performance / Correctness / Maintainability / UX

#### Problem
[2-3 sentences explaining what's wrong and why it exists]

#### Why It Matters
[Explain business impact: user frustration, wrong decisions, wasted compute]

#### Recommended Solution
[Specific, actionable fix]

#### Code Example
```dax
-- ❌ Current (problematic)
[Original code with issue highlighted]

-- ✅ Recommended (optimized)
[Improved code with changes highlighted]
```

#### Expected Impact
- Query time: [before] → [after] ([%] improvement)
- Model size: [change] if applicable
- Maintenance: [easier/unchanged/harder]

#### Trade-offs
[Honest discussion of any downsides: model size, complexity, edge cases]

#### Implementation Steps
1. [Specific step with example]
2. [Specific step with example]
3. [Validation step]

#### Testing Approach
- Verify correctness: [specific test]
- Measure performance: Use Performance Analyzer, compare before/after
- Edge cases: [scenarios to validate]
```

---

## Phase 5: Implementation Guidance

### Change Management Best Practices

1. **Test in Development First**
   - Create copy of production model
   - Apply changes incrementally
   - Validate results at each step

2. **Measure Before and After**
   - Use Performance Analyzer (DAX query timings)
   - Document baseline metrics
   - Run same test queries pre and post changes

3. **Validate Business Logic**
   - Compare totals against known good values
   - Test edge cases (nulls, zeros, boundary dates)
   - Get business user sign-off on correctness

4. **Rollback Plan**
   - Keep backup of original model
   - Document all changes for reversal
   - Have rollback trigger criteria (e.g., 10% variance in KPIs)

### Testing Strategy Template

```markdown
## Testing Checklist

### Functional Testing
- [ ] Key measures return same totals as baseline
- [ ] Cross-filtering behavior unchanged (unless intentional)
- [ ] Date filtering works correctly (YTD, MTD, etc.)
- [ ] Slicers filter correctly
- [ ] Edge cases handled: nulls, zeros, empty tables

### Performance Testing
- [ ] Baseline queries recorded with Performance Analyzer
- [ ] Post-change queries show improvement
- [ ] No regression in other visuals
- [ ] Page load time within target
- [ ] Refresh completes within window

### User Acceptance Testing
- [ ] Business users validate KPIs
- [ ] Visual layout acceptable
- [ ] Navigation intuitive
- [ ] Mobile experience acceptable (if applicable)

### Rollback Criteria
Rollback if:
- [ ] Any key measure differs >1% from baseline without explanation
- [ ] Performance degrades by >20% anywhere
- [ ] Business users identify critical functional issues
```

---

## Decision Trees

### When to Use Calculated Column vs Measure

```
Need value in slicer/axis/visual filter?
├─ YES → Calculated Column (only option)
└─ NO → Continue

Value used in row-level context (e.g., within SUMX)?
├─ YES → Consider calculated column (performance)
│   └─ Is formula complex or uses measures?
│       ├─ YES → Keep as measure, optimize iterator instead
│       └─ NO → Use calculated column
└─ NO → Use measure

Is table DirectQuery?
├─ YES → MUST use measure (calculated columns not allowed)
└─ NO → Continue

Is table very large (>10M rows) and changes frequently?
├─ YES → Prefer measure (calculated column increases refresh time)
└─ NO → Either works, slight preference for calculated column if used in many places

GENERAL RULE: Default to measures unless calculated column has clear benefit
```

### When to Invoke Specialist Skills

```
Issue Type: DAX Performance

Is formula >50 lines or deeply nested (>3 levels)?
├─ YES → Invoke @dax-mastery
└─ NO → Continue

Does it involve calculation groups or complex time intelligence?
├─ YES → Invoke @dax-mastery
└─ NO → Hub can handle

---

Issue Type: Model Design

Does it require schema restructuring (snowflake → star)?
├─ YES → Invoke @model-design
└─ NO → Continue

Is model >10GB or needs composite/incremental refresh?
├─ YES → Invoke @model-design
└─ NO → Hub can handle

---

Issue Type: Report Performance

Report has >15 visuals or needs major UX redesign?
├─ YES → Invoke @report-performance
└─ NO → Continue

Requires accessibility compliance (WCAG) or custom visual optimization?
├─ YES → Invoke @report-performance
└─ NO → Hub can handle

---

Issue Type: Refresh Performance

Refresh >30 minutes or query folding issues?
├─ YES → Invoke @powerquery-m
└─ NO → Hub can handle basic M optimization
```

---

**Version**: 1.0  
**Last Updated**: 2026-06-10  
**Parent**: SKILL.md (Power BI Optimization Hub)
