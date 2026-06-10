---
name: model-design
description: |
  Semantic model architecture optimization: star schema, relationships, storage modes, large models, cardinality, unused object detection.
  Trigger: "star schema", "model design", "relationship issues", "storage mode", "many-to-many", "bridge table",
  "snowflake to star", "model architecture", "incremental refresh", "large model", "cardinality", "bi-directional",
  "unused measures", "unused columns", "unused tables", "remove unused", "detect unused"
metadata:
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: [powerquery-m]
applyTo:
  - "**/*.Dataset/definition/**"
  - "**/*.SemanticModel/definition/**"
  - "**/*.bim"
  - "**/*.pbit"
---

# Model Design Specialist

> **🎯 Focus**: Deep semantic model architecture & schema optimization. For holistic analysis, use @powerbi-optimization.

**Use for:** Schema restructuring (snowflake→star) | Complex relationships (many-to-many, bridge tables) | Large models (>5GB) | Storage mode strategy | Relationship optimization | Incremental refresh | Data type optimization  
**Escalate to hub:** DAX issues, comprehensive triage, visual performance

---

## Star Schema (CRITICAL)

**Star Schema** (best): Fact table center, dimension tables around | One relationship hop | Fast filtering | Simple DAX

**Snowflake** (avoid): Dimensions normalized into multiple tables | Multiple hops | Slow filters | Complex DAX (RELATED chains)

```
❌ Snowflake: Sales → Products → SubCategories → Categories (3 hops)
✅ Star: Sales → Products (with Category columns denormalized) (1 hop)
```

**Denormalize**: Merge SubCategories/Categories into Products | Power Query: `Table.ExpandTableColumn` | Result: Single Products dimension

**When Snowflake OK**: Dimension >1GB AND rarely filtered (keep normalized, relationship on denormalized key column only)

---

## Relationships

**Types**:
- **One-to-Many** (1:*): Best performance | Dimension → Fact | Primary key → Foreign key | Single direction (dimension→fact)
- **Many-to-Many** (*:*): Use bridge table | Direct many-to-many = slow, unexpected results | Example: Students ↔ Courses → Students ← Enrollments → Courses
- **One-to-One** (1:1): Rare, consider merging tables | Use for: Security (separate table with RLS), large dimension (split hot/cold columns)

**Cardinality**: Must match data reality | Mismatch = wrong results | Check: `COUNTROWS(FILTER(Fact, ISBLANK(RELATED(Dim[Key]))))` → Should be 0

**Cross-Filter Direction**:
- **Single** (default): Dimension → Fact | Fast, safe
- **Both**: Fact ↔ Dimension | **Danger**: Slow, ambiguous paths, use sparingly | Valid use: Many-to-many bridge table, specific measure with `CROSSFILTER()`

**Active vs Inactive**: One active relationship per table pair | Multiple relationships → Others inactive → Activate in DAX: `CALCULATE([Measure], USERELATIONSHIP(Table1[Col], Table2[Col]))`

**Assume Referential Integrity**: DirectQuery only | Tells PBI: No orphaned fact rows → Inner join (faster) vs outer join | Enable if: Source enforces FK constraints

---

## Storage Modes

### Import

**Best for**: <10GB models | Daily+ refresh OK | Fast queries needed | Complex DAX | Most use cases (80%+)

**Pros**: Fastest queries (in-memory) | All DAX functions | No source load  
**Cons**: Static until refresh | Model size limits (Pro: 1GB, Premium: 10GB+) | Refresh time

**Optimization**: Remove columns | Data types (Integer > Decimal, Date > DateTime) | Incremental refresh (>10M rows) | Calc columns for expensive DAX

### DirectQuery

**Best for**: Real-time (<5min latency) | >100GB source | Data governance (stay in source) | Limited PBI capacity

**Pros**: Always current | No model size limit | Source security  
**Cons**: Slow queries (each visual hits source) | Limited DAX (no calc columns!) | Source load (10 concurrent connection limit)

**Optimization**: Source indexes (critical!) | Reduce visuals (7-15 max) | Query reduction ON | Aggregations (Composite)

**DAX Restrictions**: No calc columns | Limited time intelligence | Iterators often fail | Use source views/computed columns instead

### Composite (Import + DirectQuery)

**Best for**: Large historical data + recent detail | Core aggregated + drill-through detail

**Pattern 1**: Fact (DirectQuery) + Dimensions (Import/Dual) → Real-time fact, fast dimension filtering  
**Pattern 2**: Aggregations (Import) + Detail (DirectQuery) → Fast summary, detail on demand

**Dual Storage**: Table available in Import AND DirectQuery → PBI chooses best | Use for: Dimensions in Composite models

---

## Large Model Optimization

**>5GB Models**:

**1. Remove Unused Objects** (first step - highest ROI):

**Detection Queries** (DAX Studio or via MCP):

```dax
// Unused Measures: No dependencies, not in visuals
EVALUATE
FILTER(
    INFO.MEASURES(),
    [USED_IN_RELATIONSHIPS] = FALSE() &&
    [USED_IN_VISUAL] = FALSE() &&
    [USED_IN_MEASURE] = FALSE()
)

// Unused Columns: Not in measures, visuals, relationships, RLS, hierarchies
EVALUATE
SELECTCOLUMNS(
    FILTER(INFO.COLUMNS(), [USED] = FALSE()),
    "Table", [TABLE_NAME],
    "Column", [COLUMN_NAME],
    "Size MB", [SIZE_MB]
)

// Unused Tables: No relationships, no columns used
EVALUATE
FILTER(
    INFO.TABLES(),
    [RELATIONSHIP_COUNT] = 0 && [USED_COLUMN_COUNT] = 0
)

// Orphaned Relationships: Inactive and never used via USERELATIONSHIP
EVALUATE
FILTER(
    INFO.RELATIONSHIPS(),
    [IS_ACTIVE] = FALSE() && [REFERENCED_COUNT] = 0
)
```

**Manual Check** (PBIP files):
- Parse `model.bim` or `.Dataset/definition/**` for object lists
- Cross-reference with visuals in `.Report/definition/pages/*.json`
- Check measure dependencies (recursive scan)

**Priority**: Columns (biggest size impact) → Measures (complexity) → Tables (rare) → Relationships (be cautious!)

**Safety Checks**:
- ⚠️ RLS filters may reference "unused" columns → Check roles before deleting
- ⚠️ Hidden visuals/bookmarks may use objects → Test all bookmarks
- ⚠️ Drillthrough pages may reference measures → Check all pages
- ⚠️ Field parameters dynamically reference measures → Check definitions
- ✅ Test after deletion: Refresh model, verify reports, check RLS

**Impact**: 100 unused columns (10MB each) = 1GB reduction | 50 unused measures = reduced complexity

**2. Data Types** (30-50% reduction):
- Integer (4 bytes) > Decimal (8 bytes) > Text (variable)
- Date (8 bytes) > DateTime (16 bytes) unless time needed
- Boolean (1 byte) > Text ("Yes"/"No" = 32+ bytes)
- Whole Number > Decimal Number (compression better)

**3. Calculated Columns → Measures**: Calc column = stored | Measure = computed on demand | Trade-off: Query time vs model size

**4. Incremental Refresh** (>10M rows):
- Archive: 5 years (full refresh once)
- Incremental: Last 2 years (refresh daily/hourly)
- Detect changes: Optional (timestamp column)
- **Setup**: `RangeStart/RangeEnd` parameters in Power Query | Filter: `[Date] >= RangeStart AND [Date] < RangeEnd`
- **Result**: 2hr full refresh → 5min incremental

**5. Aggregations** (Premium):
- Import aggregation table (monthly/yearly)
- DirectQuery detail table (daily/hourly)
- PBI routes queries automatically
- **Example**: Sales_Monthly (Import, 100K rows) + Sales_Detail (DirectQuery, 100M rows)

**6. Remove High-Cardinality Text**: TransactionID, Comments, URLs → Move to source, fetch on-demand

**7. Partitioning** (Premium): Split tables by date range → Parallel refresh

---

## Incremental Refresh

**Setup**:

```m
// Power Query parameters (required names)
RangeStart = #datetime(2019, 1, 1, 0, 0, 0) meta [IsParameterQuery=true, Type="DateTime"]
RangeEnd = #datetime(2024, 12, 31, 0, 0, 0) meta [IsParameterQuery=true, Type="DateTime"]

// Query filter
Filtered = Table.SelectRows(Source, each [Date] >= RangeStart and [Date] < RangeEnd)
```

**Power BI Service Configuration**:
- Settings → Incremental Refresh
- Archive: 5 years (historical)
- Refresh: 2 years (recent)
- Frequency: Daily
- Detect changes: Optional (column with LastModified timestamp)

**Impact**: 10M rows: Full=2hrs → Incremental (100K/day)=5min | 96% faster

---

## Many-to-Many Patterns

**❌ Direct Many-to-Many** (avoid): Slow, ambiguous, unexpected results

**✅ Bridge Table Pattern**:

```
Students ← StudentEnrollments → Courses
         (Bridge Table)

StudentEnrollments:
- StudentID (many)
- CourseID (many)
- EnrollmentDate

Relationships:
- Students[StudentID] → StudentEnrollments[StudentID] (1:many)
- Courses[CourseID] → StudentEnrollments[CourseID] (1:many)

Both relationships: Cross-filter = Both directions
```

**DAX for Many-to-Many**:

```dax
// Count students per course
Student Count = 
CALCULATE(
    DISTINCTCOUNT(StudentEnrollments[StudentID]),
    USERELATIONSHIP(Courses[CourseID], StudentEnrollments[CourseID])
)

// Filter students by course selection
Students in Selected Courses = 
CALCULATE(
    COUNTROWS(Students),
    TREATAS(VALUES(Courses[CourseID]), StudentEnrollments[CourseID])
)
```

---

## Role-Playing Dimensions

**Problem**: Single Date table, multiple date relationships (Order Date, Ship Date, Due Date)

**Solution**: One active, others inactive | Activate in DAX with `USERELATIONSHIP`

```dax
// Active relationship: OrderDate
Sales by Order Date = SUM(Sales[Amount])

// Inactive relationship: ShipDate
Sales by Ship Date = 
CALCULATE(
    SUM(Sales[Amount]),
    USERELATIONSHIP('Date'[DateKey], Sales[ShipDateKey])
)

// Inactive relationship: DueDate
Sales by Due Date = 
CALCULATE(
    SUM(Sales[Amount]),
    USERELATIONSHIP('Date'[DateKey], Sales[DueDateKey])
)
```

**Alternative**: Duplicate Date table (Date_Ship, Date_Due) | Not recommended: More complex, harder maintenance

---

## Data Types

**Integer Types**:
- Whole Number: -9,223,372,036,854,775,808 to 9,223,372,036,854,775,807 (8 bytes)
- Use for: IDs, counts, quantities

**Decimal Types**:
- Decimal Number: 15 digits precision (8 bytes)
- Fixed Decimal: 4 decimal places (8 bytes)
- Use for: Currency (Fixed Decimal), calculations (Decimal)

**Date/Time**:
- Date: Day precision (8 bytes) → Use when time NOT needed
- DateTime: Second precision (16 bytes) → Only when time needed
- Impact: DateTime = 2x storage vs Date

**Text**:
- Text: Variable length, UTF-16 (2 bytes/char minimum)
- High compression for repeated values
- Use Integer for: Codes ("US"→1, "UK"→2), Status ("Active"→1, "Inactive"→0)

**Boolean**:
- True/False: 1 byte
- Better than: Text ("Yes"/"No"), Integer (1/0)

**Optimization Ladder**: Boolean < Integer < Date < Decimal < DateTime < Text (large cardinality)

---

## Date Table Best Practices

**Requirements**:
- Contiguous dates (no gaps)
- Mark as Date Table (Model → Mark as Date Table)
- Includes all dates in fact tables
- Starts before, ends after fact date range

**Standard Columns**:

```dax
// Essential
Year = YEAR([Date])
Quarter = QUARTER([Date])
Month = MONTH([Date])
MonthName = FORMAT([Date], "MMMM")
Day = DAY([Date])

// Fiscal (if needed)
FiscalYear = IF(MONTH([Date]) >= 7, YEAR([Date]) + 1, YEAR([Date]))
FiscalQuarter = QUARTER(DATE(YEAR([Date]), MONTH([Date]) - 6, 1))

// Sorting
YearMonth = YEAR([Date]) * 100 + MONTH([Date])  // For sorting
Sort MonthName by: Month (ensures Jan→Dec not alphabetical)

// Week (ISO 8601)
WeekNum = WEEKNUM([Date], 2)  // Monday start
```

**Hierarchy**: Year → Quarter → Month → Date | Enables drill-down in visuals

**Single Date Table**: One date table for all facts (unless different calendars needed: Gregorian + Fiscal + Custom)

---

## Aggregations (Premium)

**Use Case**: Large fact table (100M+ rows) | Common queries on aggregated data (monthly, yearly)

**Pattern**:

```
Sales_Agg (Import, monthly aggregation, 100K rows)
├─ Date (Month level)
├─ Product (Category level)
└─ Amount (SUM)

Sales_Detail (DirectQuery, daily detail, 100M rows)
├─ Date (Day level)
├─ Product (SKU level)
└─ Amount

Configuration:
1. Create Sales_Agg from Sales_Detail (Power Query aggregation)
2. Set Sales_Detail = DirectQuery
3. Set Sales_Agg = Import
4. Manage Aggregations → Map columns:
   - Sales_Agg[Date] → Sales_Detail[Date] (GroupBy)
   - Sales_Agg[Product] → Sales_Detail[Product] (GroupBy)
   - Sales_Agg[Amount] → Sales_Detail[Amount] (SUM)

Result: Query monthly sales → Routes to Sales_Agg (fast Import)
        Query daily sales → Routes to Sales_Detail (DirectQuery)
```

**Hit Rate**: Monitor Premium metrics → Aggregation hit % → Optimize aggregation granularity if <80%

---

## Anti-Patterns

**❌ Snowflake Schema**: Multiple hops → Fix: Denormalize dimensions

**❌ Bi-Directional Filters (overused)**: Slow, ambiguous → Fix: Single direction, specific measures with `CROSSFILTER()`

**❌ Direct Many-to-Many**: Unexpected results → Fix: Bridge table

**❌ Calculated Columns (large tables)**: Model bloat → Fix: Measures (or source computed columns)

**❌ DateTime (no time needed)**: 2x storage → Fix: Date type

**❌ Text for codes**: Large storage → Fix: Integer lookup

**❌ No Incremental Refresh (>10M rows)**: Slow refresh → Fix: Implement incremental

**❌ No Aggregations (>100M rows DirectQuery)**: Slow queries → Fix: Composite with aggregations

---

## Troubleshooting

**Slow Queries**: Check schema (snowflake?) | Relationship cardinality | Storage mode (DirectQuery needs source indexes) | Many bi-directional filters?

**Wrong Results**: Cardinality mismatch | Many-to-many without bridge | Circular relationships | Bi-directional ambiguity

**Refresh Timeout**: Large tables → Incremental refresh | Source slow → Power Query folding | Too much data → Aggregate at source

**Model Too Large**: Remove columns/tables | Data types (Integer, Date) | Calc columns → measures | Aggregations | Archive old data

---

## Output Format

```markdown
## 📐 Model Design Analysis
**Schema**: [Star/Snowflake/Hybrid] | **Tables**: [N] (Fact: [N], Dim: [N]) | **Relationships**: [N] | **Size**: [GB] | **Mode**: [Import/DirectQuery/Composite]

**Table**: [Name] ([Type]) | **Rows**: [N] | **Size**: [MB] ([%]) | **Mode**: [Import/DQ/Dual] | **Issues**: [N]

**Relationship**: [Table1] → [Table2] | **Cardinality**: [1:*/etc] | **Direction**: [Single/Both] | **Active**: [Y/N] | **Issue**: [Description if any]

**P0**: [Issue] → [Fix] → [Impact] | **P1**: [Issue] → [Fix] → [Impact]

**Schema Score**: [N]/10 | **Relationship Health**: [N]/10 | **Storage Efficiency**: [N]/10

**Checklist**: [ ] Star schema [ ] 1:* relationships [ ] Single direction [ ] Incremental refresh [ ] Data types optimized [ ] <10GB (or aggregations)
```
