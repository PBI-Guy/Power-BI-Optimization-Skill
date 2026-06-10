---
name: powerquery-m
description: |
  Power Query M optimization: query folding, refresh performance, modular design, memory efficiency.
  Trigger: "power query", "m code", "slow refresh", "query folding", "refresh timeout", "merge slow",
  "memory error refresh", "incremental load", "data loading", "transformation", "append performance"
metadata:
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: []
applyTo:
  - "**/*.pq"
  - "**/*.m"
  - "**/*.Dataset/definition/tables/**"
  - "**/*.SemanticModel/definition/tables/**"
---

# Power Query M Specialist

> **🎯 Focus**: Deep Power Query & refresh optimization. For holistic analysis, use @powerbi-optimization.

**Use for:** Slow refresh | M code optimization | Query folding | Merge/append performance | Incremental patterns | Memory errors | Timeouts  
**Escalate to hub:** Model/DAX issues, comprehensive analysis, not sure what's causing slowness

---

## Fundamentals

**Query Folding**: Translates M steps to source SQL/native query → 10-100x faster | **Verify**: Right-click step → "View Native Query" (SQL shows = ✅ | grayed = ❌)

**Import**: Executes during refresh, loads to memory → Optimize: Folding (faster extract), remove columns (smaller model), incremental (large tables)

**DirectQuery**: Executes per visual query (no refresh!) → **MANDATORY**: 100% folding OR performance disaster

---

## Architecture Patterns

**Modular (3-Layer)**: Raw → Staging → Final | Separates concerns, reusable, maintainable | **Raw**: Source connection only | **Staging**: Clean/transform | **Final**: Load to model

**Naming**: `STG_` prefix (staging) | `FINAL_` (reporting) | Short stable names | Rename steps | Title Case columns | Avoid spaces in identifiers (Regular > Quoted)

**Organization**: Group queries (folders) | Minimize dependencies (parallel load) | Document steps/queries

---

## Query Folding (CRITICAL)

**Folding Steps**: Filter (`Table.SelectRows`) | Select columns (`Table.SelectColumns`) | Join (`Table.NestedJoin`) | Sort | Group By | Native SQL (`Value.NativeQuery`)

**Breaking Steps**: Add Column (custom) | Merge with non-DB source | Text functions (Upper/Lower/Trim) | Pivot/Unpivot | Table.Buffer

**Strategy**: Folding steps first → Non-folding last | **DirectQuery**: Only folding steps (verify ALL)

```m
// ✅ Folds
Source = Sql.Database("srv","db"),
Filtered = Table.SelectRows(Source, each [Date] >= #date(2024,1,1)),
Columns = Table.SelectColumns(Filtered, {"ID","Amount"})

// ❌ Breaks
AddCol = Table.AddColumn(Source, "Upper", each Text.Upper([Name])), // Breaks here
Filtered = Table.SelectRows(AddCol, ...) // Won't fold
```

---

## Performance

**Filter Early**: Remove rows/columns ASAP → Reduces network transfer, processing, memory | Use "Remove Other Columns" (future-proof) NOT "Remove Columns"

**Expensive Last**: Sort, Pivot, Unpivot, Distinct, Buffer → Scan full dataset → Place at end | Use `Table.Buffer` only for: Sort before Remove Duplicates, Reuse data multiple times

**Subset Development**: Parameter `IsDevelopment = true` → `if IsDevelopment then Table.FirstN(Source,1000) else Source` → Test fast, deploy full

**Merge Optimization**: Reduce columns before merge | `Table.AddKey` for index | Avoid chaining merges | Use native SQL for complex joins

---

## Data Quality

**Data Types**: Set explicitly (not "Any") | Dates as Date (NOT DateTime unless time needed) | Integer > Decimal (compression) | **Parameters**: Text/Number (NOT "Any" or disabled in Service)

**Clean Text**: `Text.Trim` (spaces) | `Text.Clean` (non-printable) | Avoid duplicates/join issues | **Case Sensitive**: Text.Upper/Lower before compare/replace | `Comparer.OrdinalIgnoreCase` for case-insensitive

**Validation**: Column quality/distribution/profile | Remove errors (`Table.RemoveRowsWithErrors`) | Choose columns (not Remove) for future-proofing

---

## Import vs DirectQuery

### Import

**Goal**: Fast refresh, small model | **Tactics**: Folding (faster extract) | Remove columns early | Incremental refresh (`RangeStart/RangeEnd` params) | Native SQL for complex logic | Parallel queries (minimize dependencies)

**Incremental**: 10M rows: Full=2hrs ❌ | Incremental (100K/day)=5min ✅ | 96% faster | Configure: Archive 5yr, Refresh 2yr

### DirectQuery

**Goal**: 100% folding (MANDATORY) | **Tactics**: Simple filters only | No calculated columns (computed per query!) | No custom functions | Optimize source (indexes, stats) | Verify every step folds

---

## Common Patterns

**Incremental**: `Filtered = Table.SelectRows(Source, each [Date] >= RangeStart and [Date] < RangeEnd)` | Power BI: Configure range

**Native SQL**: `Value.NativeQuery(Source, "SELECT ... WHERE ...")` | Guarantees folding | Complex logic at source

**Sort + Dedup**: `Sorted = Table.Sort(...), Buffered = Table.Buffer(Sorted), Distinct = Table.Distinct(Buffered, {"ID"})` | Buffer preserves sort

**Parameters**: File paths, date ranges, environments | Switch dev/prod | `Web.Contents(Domain, [RelativePath="..."])` | One connection

**Custom Function**: Create from query+parameter → Reuse transformations | Invoke on multiple queries

---

## Anti-Patterns

**❌ Rounding**: `Number.Round([Val],0)` = Bankers (24.5→24) → Fix: `Number.Round([Val],0,RoundingMode.AwayFromZero)` (24.5→25)

**❌ No Regex**: M has no regex → Use Fabric Notebooks (pyspark.sql.functions.regexp) OR pre-process source

**❌ Formula.Firewall**: Joining cross-domain → Fix: Gen1/Gen2 Dataflows per source, join in model

**❌ Slow Merges**: Large tables + complex logic → Fix: Reduce columns first, native SQL, avoid chaining

**❌ "Any" Parameters**: Disabled in Service → Fix: Set Text/Number type

**❌ API Loops**: Slow development → Fix: IsDevelopment parameter (sample), Dataflows (cache raw)

---

## Troubleshooting

**Slow Refresh**: Query Diagnostics → High duration step → Fix: Folding (View Native Query), remove columns, filter early, incremental

**Memory Errors**: Table.Buffer overuse, large datasets → Fix: Remove buffers, incremental refresh, reduce columns/rows early

**No Folding**: Right-click grayed → Fix: Move non-folding steps last, use native SQL, simplify logic, check connector (specific > ODBC)

**Timeout**: Large extract, no folding → Fix: Incremental parameters, native SQL with WHERE, source indexes

---

## Output Format

```markdown
## ⚡ Power Query Refresh Analysis
**Queries**: [N] | **Total Time**: [Min] | **Folding %**: [%] | **Memory**: [GB]

**Query**: [Name] | **Source**: [Type] | **Rows**: [N] | **Time**: [Min] ([Status]) | **Folding**: [%] ([Status])

**Step**: [Name] ([Type]) | **Duration**: [Sec] | **Folds**: [Y/N] | **Rows**: [Before→After]

**P0**: [Issue] → [Fix] → [Impact] | **P1**: [Issue] → [Fix] → [Impact]

**Checklist**: [ ] Folding verified [ ] Columns removed [ ] Filters early [ ] Types explicit [ ] Incremental [ ] Documented
```
