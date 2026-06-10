---
name: dax-mastery
description: |
  Deep DAX optimization: formula performance, iterators, context transitions, calculation groups, time intelligence.
  Trigger: "analyze dax", "optimize measure", "dax performance", "context transition", "iterator optimization",
  "formula engine", "calculation group", "time intelligence", "dax review", "measure complexity", "slow measure"
metadata:
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: [model-design]
applyTo:
  - "**/*.dax"
  - "**/*.Dataset/definition/tables/*.tmdl"
  - "**/*.SemanticModel/definition/tables/*.tmdl"
---

# DAX Mastery Specialist

> **🎯 Focus**: Deep DAX optimization & advanced patterns. For holistic analysis, use @powerbi-optimization.

**Use for:** Complex DAX formulas | Iterator optimization | Context transitions | Calculation groups | Time intelligence | Formula engine analysis | Measure complexity  
**Escalate to hub:** Model structure issues, comprehensive triage, visual performance

---

## Performance Fundamentals

**Storage Engine (SE)**: Fast columnar scan, filters, aggregations → Vertipaq compressed, highly optimized  
**Formula Engine (FE)**: Row-by-row iteration, complex logic → Slow, CPU-bound, avoid when possible

**Goal**: Push work to SE (80%+), minimize FE (20%)

**SE Operations** (fast): `SUM`, `COUNT`, `MIN`, `MAX`, `DISTINCTCOUNT`, simple filters  
**FE Operations** (slow): `SUMX`, `FILTER`, `ADDCOLUMNS`, `IF` in iterators, complex calculations

---

## Iterator Optimization (CRITICAL)

**Iterators** (row-by-row FE): `SUMX`, `AVERAGEX`, `MAXX`, `MINX`, `COUNTROWS`, `FILTER`, `ADDCOLUMNS`, `SELECTCOLUMNS`, `GENERATE`, `CONCATENATEX`

**Rule**: Reduce iteration table size BEFORE iterating

```dax
❌ Slow (iterates ALL Sales)
Total = SUMX(Sales, Sales[Qty] * Sales[Price])

✅ Fast (pre-filter in SE)
Total = SUMX(FILTER(Sales, Sales[Date] >= DATE(2024,1,1)), Sales[Qty] * Sales[Price])

✅ Faster (calculated column if rarely changes)
Total = SUM(Sales[Revenue]) -- Revenue = Qty * Price (calc column)

✅ Fastest (physical column from source)
Total = SUM(Sales[Revenue]) -- Revenue from SQL/source
```

**Optimization Ladder**: Physical column (best) → Calc column → Measure with variables → Measure with iterators (worst)

---

## Context Transitions

**Filter Context**: Filters from visuals, slicers, CALCULATE | Acts on columns | Fast (SE)  
**Row Context**: Iterating row-by-row | `SUMX`, calc columns | Slow (FE)

**Context Transition**: Convert row context → filter context | **Cost**: Creates context for every row | **Trigger**: Measures in iterators, `CALCULATE`, `RELATEDTABLE`

```dax
❌ Context transition (SLOW if many rows)
Total = SUMX(Products, [Total Sales]) -- [Total Sales] measure causes transition

✅ Avoid transition
Total = SUMX(Products, CALCULATE(SUM(Sales[Amount]))) -- Explicit CALCULATE, same result

✅ Better: No iteration
Total = CALCULATE(SUM(Sales[Amount])) -- Use filter context directly
```

**Rule**: Avoid measures inside `SUMX`/iterators → 10-100x slower with context transitions

---

## Variables (Performance + Readability)

**VAR**: Materializes expression once, reuses result | Prevents recalculation | Essential for complex formulas

```dax
❌ Recalculates 3x
Margin% = 
DIVIDE(
    SUM(Sales[Revenue]) - SUM(Sales[Cost]),
    SUM(Sales[Revenue])
)

✅ Calculates once
Margin% = 
VAR Revenue = SUM(Sales[Revenue])
VAR Cost = SUM(Sales[Cost])
VAR Profit = Revenue - Cost
RETURN DIVIDE(Profit, Revenue)
```

**Benefits**: 30-50% faster (complex formulas) | Readable | Debuggable | Required for iterator optimization

---

## CALCULATE Mastery

**CALCULATE**: Modifies filter context | Most powerful DAX function | 80% of measures use it

**Syntax**: `CALCULATE(<expression>, <filter1>, <filter2>, ...)`

**Filter Argument Types**:
1. **Boolean**: `Sales[Amount] > 100` → Row-by-row evaluation (SLOW, avoid)
2. **Table**: `FILTER(Sales, Sales[Amount] > 100)` → Returns filtered table (better)
3. **Column Filter**: `Sales[Region] = "North"` → Native filter (FAST, prefer)
4. **ALL/ALLEXCEPT**: Remove filters → `ALL(Sales[Region])`
5. **KEEPFILTERS**: Add filter without removing → `KEEPFILTERS(Sales[Region] = "North")`

```dax
❌ Boolean filter (slow, row-by-row)
Total = CALCULATE(SUM(Sales[Amount]), Sales[Amount] > 100)

✅ Table filter (better)
Total = CALCULATE(SUM(Sales[Amount]), FILTER(Sales, Sales[Amount] > 100))

✅ Column filter (best for simple conditions)
Total = CALCULATE(SUM(Sales[Amount]), Sales[Region] = "North")
```

**ALL Variations**: `ALL` (remove all filters) | `ALLEXCEPT` (keep specified) | `ALLSELECTED` (keep visual filters) | `ALLNOBLANKROW` (ignore blank)

---

## Time Intelligence

**Requirements**: Continuous date table | Date column | Relationship to fact table

**Common Patterns**:

```dax
-- Year-to-Date
YTD Sales = TOTALYTD(SUM(Sales[Amount]), 'Date'[Date])

-- Previous Year
PY Sales = CALCULATE(SUM(Sales[Amount]), SAMEPERIODLASTYEAR('Date'[Date]))

-- Year-over-Year %
YoY% = 
VAR CY = SUM(Sales[Amount])
VAR PY = CALCULATE(SUM(Sales[Amount]), SAMEPERIODLASTYEAR('Date'[Date]))
RETURN DIVIDE(CY - PY, PY)

-- Rolling 12 Months
R12M = 
CALCULATE(
    SUM(Sales[Amount]),
    DATESINPERIOD('Date'[Date], MAX('Date'[Date]), -12, MONTH)
)

-- Month-to-Date
MTD = TOTALMTD(SUM(Sales[Amount]), 'Date'[Date])
```

**Performance**: `TOTALYTD`/`TOTALMTD` (fast, built-in) > `CALCULATE` + `FILTER` (flexible but slower)

---

## FILTER vs KEEPFILTERS vs ALL

**Scenario**: Calculate sales for specific region while respecting slicer

```dax
-- Base measure
Total Sales = SUM(Sales[Amount])

-- Ignore slicer (replace filter)
North Sales = CALCULATE([Total Sales], Sales[Region] = "North")
-- User selects "South" → Still shows North

-- Respect slicer (add filter)
North Sales = CALCULATE([Total Sales], KEEPFILTERS(Sales[Region] = "North"))
-- User selects "South" → Shows blank (North + South = no overlap)

-- Show North% of total
North% = 
VAR NorthSales = CALCULATE([Total Sales], Sales[Region] = "North")
VAR TotalSales = CALCULATE([Total Sales], ALL(Sales[Region]))
RETURN DIVIDE(NorthSales, TotalSales)
```

**Rule**: `CALCULATE` replaces filters by default | Use `KEEPFILTERS` to add without replacing | Use `ALL` to remove filters

---

## Calculation Groups

**Purpose**: Apply calculations dynamically without creating multiple measures | Time intelligence, currency conversion, aggregations

**Structure**: Special table type | Name column (calculation items) | Calculation expressions | Precedence (priority)

**Example**: Time Intelligence Group

```dax
-- Calculation Group: Time Intelligence
-- Calculation Item: YTD
CALCULATE(SELECTEDMEASURE(), DATESYTD('Date'[Date]))

-- Calculation Item: PY
CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))

-- Calculation Item: YoY%
VAR Current = SELECTEDMEASURE()
VAR Previous = CALCULATE(SELECTEDMEASURE(), SAMEPERIODLASTYEAR('Date'[Date]))
RETURN DIVIDE(Current - Previous, Previous)
```

**Usage**: Drag calculation group to visual → Applies to all measures | One time intelligence group > 50 individual measures

**Precedence**: Higher number = later evaluation | Use to control calculation order (e.g., currency before time intelligence)

---

## Top N Optimization

```dax
❌ TOPN without variables (recalculates)
Top 10 Products = 
CONCATENATEX(
    TOPN(10, ALL(Products[Name]), [Total Sales], DESC),
    Products[Name],
    ", "
)

✅ With variables (calculates once)
Top 10 Products = 
VAR TopProducts = TOPN(10, ALL(Products[Name]), [Total Sales], DESC)
VAR Names = CONCATENATEX(TopProducts, Products[Name], ", ")
RETURN Names
```

**Rule**: Use `VAR` before `CONCATENATEX`, `TOPN`, any expensive iteration

---

## RELATED vs RELATEDTABLE

**RELATED**: Many → One (follow relationship, get single value) | Fast, no iteration  
**RELATEDTABLE**: One → Many (get related rows) | Returns table, often slow

```dax
-- Calculated Column: Get product category (Many → One)
Sales[Category] = RELATED(Products[Category]) -- ✅ Fast

-- Measure: Count related sales (One → Many)
Product Sales Count = COUNTROWS(RELATEDTABLE(Sales)) -- ⚠️ Slower (iteration)

-- Better: Use relationship filter
Product Sales Count = CALCULATE(COUNTROWS(Sales)) -- ✅ Faster
```

**Rule**: Prefer `RELATED` (fast) | Avoid `RELATEDTABLE` in measures (use `CALCULATE` instead)

---

## Measure vs Calculated Column

**Calculated Column**: Computed at refresh, stored in model | Fast query, slow refresh, increases model size  
**Measure**: Computed at query time | Slow query (complex formulas), no refresh cost, no storage

**Use Calc Column When**:
- ✅ Rarely changes (Product[Category])
- ✅ Used in slicers/filters
- ✅ Simple calculation (`Price * Quantity`)
- ✅ String operations (text manipulation)

**Use Measure When**:
- ✅ Aggregation (`SUM`, `COUNT`, `AVERAGE`)
- ✅ Time intelligence (YTD, YoY)
- ✅ Complex business logic (changes frequently)
- ✅ Model size critical

**Trade-off**: Calc column = +storage, -query time | Measure = -storage, +query time

---

## BLANK() Handling

**BLANK() ≠ 0** | Blank propagates through math | Use `DIVIDE` (handles blanks) or `IF(ISBLANK())`

```dax
❌ Shows error if Cost = BLANK
Margin = (Revenue - Cost) / Revenue

✅ Handles blanks
Margin = DIVIDE(Revenue - Cost, Revenue)

✅ Custom blank handling
Margin = IF(ISBLANK(Revenue) || ISBLANK(Cost), BLANK(), (Revenue - Cost) / Revenue)
```

**Rule**: Use `DIVIDE` (auto blank handling) | Check `ISBLANK` before operations | `COALESCE` for first non-blank

---

## Error Handling

**IFERROR**: Catch errors, return alternative | **ISERROR**: Check if error

```dax
-- Safe division
Safe Margin = IFERROR([Margin], 0)

-- Conditional handling
Safe Margin = IF(ISERROR([Margin]), "Error", [Margin])
```

**Performance**: `IFERROR` has minimal cost | Use liberally for production measures

---

## Anti-Patterns

**❌ Measures in Iterators**: Context transition → 10-100x slower → Fix: Variables, expand calculation inline

**❌ Boolean Filters in CALCULATE**: Row-by-row evaluation → Fix: Table filters or column filters

**❌ No Variables**: Recalculation → Fix: VAR for reused expressions

**❌ FILTER(ALL())**: Scans full table → Fix: Remove unnecessary filters first, use KEEPFILTERS

**❌ Nested CALCULATE**: Multiple filter modifications → Fix: Single CALCULATE with all filters

**❌ String Operations in Measures**: Slow → Fix: Calculated columns for strings

**❌ RELATED in Measures**: Can be slow → Fix: Use filter context propagation

---

## Performance Checklist

**Query Time**:
- [ ] Iterators on smallest table possible
- [ ] Variables for reused expressions
- [ ] No measures in iterators (context transitions)
- [ ] Column filters (not boolean) in CALCULATE
- [ ] Physical columns > calc columns > measures
- [ ] DIVIDE (not manual division)

**Model Size**:
- [ ] Calc columns for simple, stable calculations
- [ ] Measures for aggregations and time intelligence
- [ ] Remove unused columns
- [ ] Integer data types (smaller than decimal)

**Readability**:
- [ ] Descriptive variable names
- [ ] Comments for complex logic
- [ ] Consistent formatting
- [ ] Break into sub-measures if >30 lines

---

## Troubleshooting

**Slow Measure**: Performance Analyzer → Visual >500ms → Check DAX → Variables? Iterators? Context transitions? → Optimize: Calc column, filter early, variables

**Incorrect Results**: Check filter context → `ALL`, `ALLSELECTED`, `KEEPFILTERS` → Verify relationships → Test with simple visual

**Blank Results**: `ISBLANK` check → Filter context issue? → Missing relationship? → `ALL` removing needed filters?

**Timeout**: Measure too complex → Simplify: Pre-aggregate in source, calc columns, split calculation, reduce granularity

---

## Output Format

```dax
-- ❌ Original (Slow)
[Original DAX formula]
-- Issues: [List issues]
-- Duration: [Ms] | SE: [%] | FE: [%]

-- ✅ Optimized (Fast)
[Optimized DAX formula]
-- Improvements: [List improvements]
-- Expected: [Ms] | SE: [%] | FE: [%] | Speedup: [X]x

-- Trade-offs: [Storage/Refresh/Complexity impact if any]
```
