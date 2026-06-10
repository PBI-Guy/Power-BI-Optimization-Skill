# Power BI MCP Server Integration (Local Desktop)

> **Automated DAX Benchmarking for Power BI Desktop**

This document describes how to integrate the Power BI MCP Server with the Power BI Optimization skill to enable **automated** DAX benchmarking and measure testing on your **local Power BI Desktop** models.

## ⚠️ Scope: Power BI Desktop Only

This guide covers **local Power BI Desktop scenarios**. For Power BI Service/Premium/Fabric features (automated refresh, Service XMLA write operations), additional configuration is required and not covered here.

**What works in Desktop:**
- ✅ Connect to local models via XMLA
- ✅ Execute DAX queries
- ✅ Benchmark measure performance
- ✅ Create/delete temporary measures
- ✅ Read model metadata

**What requires manual steps in Desktop:**
- ⚠️ Creating calculated columns (can define, but requires manual refresh)
- ⚠️ Model refresh (manual via Power BI Desktop UI)
- ⚠️ Testing calculated column optimizations (semi-automated workflow)

## 🎯 Vision: Fully Automated Workflow

```
User: "@powerbi-optimization Optimize and benchmark this measure: [DAX code]"

Skill (automated with some manual steps):
1. ✅ Analyzes DAX and creates 2-3 optimized versions
2. ✅ Connects to your local Power BI Desktop model via XMLA
3. ✅ Creates temporary measures in model
4. ✅ Runs benchmarks (5 warm + 5 cold cache iterations per version)
5. ✅ Analyzes statistical results (cold vs warm, min/max/avg/std dev)
6. ✅ Reports winner with confidence level
7. ⚠️ For calculated column optimizations: Provides guidance for manual implementation
8. ✅ Cleans up temporary measures

Total time: 2-3 minutes for measure-only optimizations ⚡
(Calculated column testing requires additional manual steps in Desktop)
```

---

## 📋 Prerequisites

### 1. Power BI MCP Server Installation

**Official Repository:** [microsoft/powerbi-modeling-mcp](https://github.com/microsoft/powerbi-modeling-mcp)

Choose one of the following installation methods:

#### Option A: VS Code Extension (Recommended)

**Best for:** Most users, easiest setup, automatic updates

1. Open VS Code Extensions (Ctrl+Shift+X)
2. Search for "Power BI Modeling MCP" (by Analysis Services)
3. Click **Install**
4. Restart VS Code
5. Open GitHub Copilot chat and verify tools are available

**Pros:**
- ✅ One-click installation
- ✅ Automatic updates
- ✅ Integrated with VS Code settings
- ✅ No command-line configuration needed

**Cons:**
- ❌ VS Code only (not available for other MCP clients)

#### Option B: NPX Installation

**Best for:** Cross-platform consistency, Node.js developers

**Prerequisites:** Node.js installed ([nodejs.org](https://nodejs.org))

```bash
# Auto-downloads and runs latest version
npx -y @microsoft/powerbi-modeling-mcp@latest --start
```

**MCP Client Configuration:**
```json
{
  "mcpServers": {
    "powerbi-modeling-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "@microsoft/powerbi-modeling-mcp@latest",
        "--start"
      ],
      "env": {}
    }
  }
}
```

**Pros:**
- ✅ Cross-platform (Windows, macOS, Linux)
- ✅ Works with any MCP client
- ✅ Always gets latest version
- ✅ No separate installation needed if you have Node.js

**Cons:**
- ❌ Requires Node.js
- ❌ Slightly slower startup (downloads on first run)
- ❌ Manual MCP client configuration required

#### Option C: Manual Download

**Best for:** Air-gapped environments, maximum control, custom MCP clients

1. Download VSIX package:
   ```
   https://marketplace.visualstudio.com/_apis/public/gallery/publishers/analysis-services/vsextensions/powerbi-modeling-mcp/[version]/vspackage?targetPlatform=[platform]
   ```
   Example (v0.1.9, Windows x64):
   ```
   https://marketplace.visualstudio.com/_apis/public/gallery/publishers/analysis-services/vsextensions/powerbi-modeling-mcp/0.1.9/vspackage?targetPlatform=win32-x64
   ```

2. Rename downloaded file: `.vsix` → `.zip`
3. Unzip to folder (e.g., `C:\MCPServers\PowerBIModelingMCP`)
4. Run: `\extension\server\powerbi-modeling-mcp.exe`
5. Copy MCP JSON configuration from console output

**MCP Client Configuration Example:**
```json
{
  "mcpServers": {
    "powerbi-modeling-mcp": {
      "command": "C:\\MCPServers\\PowerBIModelingMCP\\extension\\server\\powerbi-modeling-mcp.exe",
      "args": ["--start"],
      "env": {}
    }
  }
}
```

**Pros:**
- ✅ Works offline/air-gapped
- ✅ Version pinning
- ✅ Works with any MCP client
- ✅ Maximum control over configuration

**Cons:**
- ❌ Manual updates required
- ❌ More complex setup
- ❌ Platform-specific downloads

#### Installation Method Comparison

| Feature | VS Code Extension | NPX | Manual |
|---------|------------------|-----|--------|
| **Ease of Setup** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐ |
| **Auto Updates** | ✅ Yes | ✅ Yes | ❌ Manual |
| **Cross-platform** | ❌ VS Code only | ✅ Yes | ✅ Yes |
| **Works with any MCP client** | ❌ No | ✅ Yes | ✅ Yes |
| **Offline Support** | ❌ No | ❌ No | ✅ Yes |
| **Setup Time** | 1 min | 2 min | 5-10 min |

**Recommendation:**
- 🎯 **Most users**: Choose **VS Code Extension** (easiest)
- 🔧 **Node.js developers**: Choose **NPX** (cross-platform)
- 🏢 **Enterprise/Air-gapped**: Choose **Manual** (maximum control)

### 2. MCP Server Configuration

> **Note:** If you installed via **VS Code Extension**, configuration is automatic. This section applies to **NPX** and **Manual** installations only.

Create/update your MCP settings file:

**For NPX Installation** (`~/mcp-settings.json` or workspace `.vscode/mcp-settings.json`):

```json
{
  "mcpServers": {
    "powerbi-modeling-mcp": {
      "command": "npx",
      "args": [
        "-y",
        "@microsoft/powerbi-modeling-mcp@latest",
        "--start"
      ],
      "env": {
        "BENCHMARK_WARM_ITERATIONS": "5",
        "BENCHMARK_COLD_ITERATIONS": "5"
      }
    }
  }
}
```

**For Manual Installation:**

```json
{
  "mcpServers": {
    "powerbi-modeling-mcp": {
      "command": "C:\\MCPServers\\PowerBIModelingMCP\\extension\\server\\powerbi-modeling-mcp.exe",
      "args": ["--start"],
      "env": {
        "BENCHMARK_WARM_ITERATIONS": "5",
        "BENCHMARK_COLD_ITERATIONS": "5"
      }
    }
  }
}
```

**Configuration Options:**

| Setting | Description | Default |
|---------|-------------|---------|
| `BENCHMARK_WARM_ITERATIONS` | Warm cache benchmark runs | `5` |
| `BENCHMARK_COLD_ITERATIONS` | Cold cache benchmark runs | `5` |

**Note**: Benchmarks run with N cold cache iterations + M warm cache iterations (default N=5, M=5). Total runs = 10 per version.

---

## 🔧 MCP Tools Reference

### Tool 1: `powerbi_connect_model`

**Connect to a Power BI model.**

```typescript
powerbi_connect_model({
  model?: string,          // Model name (auto-detected if omitted)
  endpoint?: string,       // XMLA endpoint (default: localhost)
  workspace?: string       // Workspace ID (for service)
})
```

**Example:**
```
Connect to Power BI model "AdventureWorks"
```

**Returns:**
```json
{
  "success": true,
  "modelName": "AdventureWorks",
  "endpoint": "localhost:12345",
  "tables": ["Sales", "Products", "Customers", "Date"],
  "measures": 47,
  "size": "245 MB"
}
```

---

### Tool 2: `powerbi_execute_dax`

**Execute a DAX query and return results.**

```typescript
powerbi_execute_dax({
  model: string,           // Model name
  query: string,           // DAX query
  timeout?: number         // Query timeout (seconds)
})
```

**Example:**
```
Execute DAX query: EVALUATE { [Total Sales] }
```

**Returns:**
```json
{
  "success": true,
  "duration": 234,
  "storageEngine": 180,
  "formulaEngine": 54,
  "results": [
    { "Total Sales": 12345678.90 }
  ]
}
```

---

### Tool 3: `powerbi_benchmark_dax`

**Run a DAX query multiple times and return statistics.**

```typescript
powerbi_benchmark_dax({
  model: string,           // Model name
  query: string,           // DAX query to benchmark
  iterations?: number,     // Number of runs (default: 10)
  clearCache?: boolean,    // Clear cache between runs
  discardFirst?: boolean   // Discard cold cache run
})
```

**Example:**
```
Benchmark DAX query: EVALUATE { [Total Revenue] }
Run 5 warm cache iterations + 5 cold cache run
```

**Returns:**
```json
{
  "success": true,
  "coldCacheRun": { "duration": 2847, "se": 2100, "fe": 747 },
  "warmCacheRuns": 5,
  "results": [
    { "run": 1, "duration": 1234, "se": 1100, "fe": 134 },
    { "run": 2, "duration": 1189, "se": 1089, "fe": 100 },
    { "run": 3, "duration": 1256, "se": 1123, "fe": 133 },
    { "run": 4, "duration": 1298, "se": 1145, "fe": 153 },
    { "run": 5, "duration": 1223, "se": 1098, "fe": 125 }
  ],
  "statistics": {
    "cold": {
      "duration": 2847,
      "storageEngine": 2100,
      "formulaEngine": 747
    },
    "warm": {
      "avg": 1240,
      "min": 1189,
      "max": 1298,
      "median": 1234,
      "stdDev": 42,
      "cv": 3.4
    },
    "cacheImpact": {
      "slowdownPercent": 129.6,
      "description": "Cold cache 2.3× slower than warm average"
    }
  }
}
```

---

### Tool 4: `mcp_powerbi-model_measure_operations`

**Create, update, or delete measures in the Power BI model.**

**CREATE Operation:**
```json
{
  "operation": "CREATE",
  "definitions": [
    {
      "Name": "_TEMP_Revenue_Optimized",
      "TableName": "Sales",
      "Expression": "SUM(Sales[Revenue])",
      "Description": "Optimized revenue calculation",
      "FormatString": "$#,##0"
    }
  ]
}
```

**Key Requirements:**
- ✅ Use **`definitions`** array (even for single measure)
- ✅ Each definition must have: `Name`, `TableName`, `Expression`
- ✅ Optional: `Description`, `FormatString`, `IsHidden`, `DisplayFolder`

**Returns:**
```json
{
  "success": true,
  "operation": "CREATE",
  "message": "Measure(s) created successfully",
  "results": [
    {
      "tableName": "Sales",
      "measureName": "_TEMP_Revenue_Optimized",
      "status": "Created"
    }
  ]
}
```

---

### Tool 5: `mcp_powerbi-model_measure_operations` (DELETE)

**Delete measures from the Power BI model.**

**DELETE Operation:**
```json
{
  "operation": "DELETE",
  "references": [
    {
      "Name": "_TEMP_Revenue_Optimized",
      "TableName": "Sales"
    }
  ],
  "shouldCascadeDelete": true
}
```

**Key Requirements:**
- ✅ Use **`references`** array (even for single measure)
- ✅ Each reference must have: `Name`, `TableName`
- ✅ Optional: `shouldCascadeDelete` (default: true)

**Returns:**
```json
{
  "success": true,
  "operation": "DELETE",
  "message": "Measure(s) deleted successfully",
  "results": [
    {
      "tableName": "Sales",
      "measureName": "_TEMP_Revenue_Optimized",
      "status": "Deleted"
    }
  ]
}
```

---

## ⚠️ Critical: Correct Tool Usage

**Common Error: "Definitions is required for Create operation"**

This error occurs when using incorrect parameter names with the MCP tool. Here's the correct format:

**❌ WRONG:**
```json
{
  "operation": "CREATE",
  "tableName": "KPIs",
  "measureName": "_TEST",
  "expression": "..."
}
```

**✅ CORRECT:**
```json
{
  "operation": "CREATE",
  "definitions": [
    {
      "Name": "_TEST",
      "TableName": "KPIs",
      "Expression": "..."
    }
  ]
}
```

**Key Points:**
- ✅ Use **`definitions`** array (even for single measure)
- ✅ Use **`references`** array for DELETE/GET operations
- ✅ Capital case for properties: `Name`, `TableName`, `Expression`
- ✅ Lowercase for operation names: `operation`, `definitions`, `references`

---

**Example:**
```
Delete temporary measure: Sales[_TEMP_Revenue_Optimized]
```

**Returns:**
```json
{
  "success": true,
  "message": "Measure deleted successfully"
}
```

---

### Tool 6: `powerbi_get_model_metadata`

**Retrieve model structure and metadata via XMLA (read-only).**

```typescript
powerbi_get_model_metadata({
  model: string,           // Model name
  includeColumns?: boolean,
  includeMeasures?: boolean,
  includeRelationships?: boolean
})
```

**Example:**
```
Get metadata for model "AdventureWorks"
Include all: columns, measures, relationships
```

**Returns:**
```json
{
  "success": true,
  "model": "AdventureWorks",
  "tables": [
    {
      "name": "Sales",
      "rowCount": 10485760,
      "columns": ["OrderDate", "ProductID", "Quantity", "Amount"],
      "measures": ["Total Sales", "Total Revenue", "Avg Sale"],
      "size": "180 MB"
    },
    {
      "name": "Products",
      "rowCount": 500,
      "columns": ["ProductID", "ProductName", "Price", "Category"],
      "measures": [],
      "size": "0.5 MB"
    }
  ],
  "relationships": [
    {
      "from": "Sales[ProductID]",
      "to": "Products[ProductID]",
      "cardinality": "many-to-one"
    }
  ]
}
```

---

### Calculated Columns in Desktop: Manual Refresh Required

**Important Limitation:** While you can create calculated column definitions via XMLA, Power BI Desktop does not support automated refresh via MCP tools. 

**Workaround for calculated column optimizations:**
1. Skill analyzes DAX and identifies calculated column opportunity
2. Skill provides exact DAX code for the column
3. **You manually add column** in Power BI Desktop
4. **You manually refresh** (Home → Refresh)
5. Skill creates measure using the new column
6. Skill benchmarks the measure
7. Skill compares with original version

**This semi-automated workflow still saves significant time** by handling analysis, code generation, and benchmarking automatically.

---

## 🤖 Automated Optimization Workflow

### Complete Example Session

**User Request:**
```
@powerbi-optimization "Optimize and benchmark this measure:

Total Revenue = 
SUMX(
    Sales,
    Sales[Quantity] * RELATED(Products[Price])
)"
```

### Skill Execution (Automated)

**Phase 1: Analysis & Planning (5 seconds)**

*Skill analyzes DAX and determines optimization strategies*

```markdown
🔬 Analyzing DAX...

**Issue Detected:**
- SUMX with RELATED (row-by-row lookup)
- Formula engine intensive
- No variable caching

**Optimization Strategies:**
1. ✅ Calculated Column (best for storage engine)
2. ✅ Iterate Products (fewer iterations)
3. ✅ Variables with ADDCOLUMNS (caching)

Generating optimized versions...
```

**Phase 2: Model Connection (2 seconds)**

*Skill uses MCP to connect*

```markdown
Connecting to Power BI model...

[MCP Tool: powerbi_connect_model]
```

**Returns:**
```json
{
  "modelName": "AdventureWorks",
  "tables": ["Sales", "Products", "Customers", "Date"],
  "Sales_rows": 10485760,
  "Products_rows": 500
}
```

```markdown
✅ Connected to: AdventureWorks
✅ Sales table: 10.5M rows
✅ Products table: 500 rows

Creating test versions...
```

**Phase 3: Create Test Measures (5 seconds)**

*Skill creates temporary measures for each optimization*

```markdown
Creating temporary measures...

[MCP Tool: mcp_powerbi-model_measure_operations]
  Operation: CREATE
  Creating 4 test measures...
```

**Tool Call:**
```json
{
  "operation": "CREATE",
  "definitions": [
    {
      "Name": "_TEMP_Revenue_Original",
      "TableName": "Sales",
      "Expression": "SUMX(Sales, Sales[Quantity] * RELATED(Products[Price]))",
      "Description": "Original formula - baseline"
    },
    {
      "Name": "_TEMP_Revenue_V1_CalcColumn",
      "TableName": "Sales",
      "Expression": "SUM(Sales[RevenueCalcColumn])",
      "Description": "Optimized V1 - Uses calculated column"
    },
    {
      "Name": "_TEMP_Revenue_V2_IterateProducts",
      "TableName": "Sales",
      "Expression": "SUMX(Products, VAR p = Products[Price] RETURN p * CALCULATE(SUM(Sales[Quantity])))",
      "Description": "Optimized V2 - Iterates smaller table"
    },
    {
      "Name": "_TEMP_Revenue_V3_Variables",
      "TableName": "Sales",
      "Expression": "VAR tbl = ADDCOLUMNS(Sales, \"@Rev\", Sales[Quantity] * RELATED(Products[Price])) RETURN SUMX(tbl, [@Rev])",
      "Description": "Optimized V3 - Uses variables for caching"
    }
  ]
}
```

```markdown
✅ Created 4 test measures successfully
```

**Phase 4: Benchmark Execution (90 seconds)**

*Skill runs benchmarks for each version*

```markdown
🏃 Running benchmarks...

[MCP Tool: powerbi_benchmark_dax]
  Query: EVALUATE { [_TEMP_Revenue_Original] }
  Iterations: 10
  Discard first: true

Progress: [████████░░] 80%

[MCP Tool: powerbi_benchmark_dax]
  Query: EVALUATE { [_TEMP_Revenue_V2_IterateProducts] }
  Iterations: 10
  Discard first: true

Progress: [██████████] 100%

Benchmarks complete!
```

**Returns (aggregated):**
```json
{
  "Original": {
    "cold": 2847,
    "warm_avg": 2234,
    "min": 2012,
    "max": 2467,
    "stdDev": 156,
    "cv": 7.0
  },
  "V2_IterateProducts": {
    "cold": 892,
    "warm_avg": 287,
    "min": 276,
    "max": 301,
    "stdDev": 8,
    "cv": 2.8
  },
  "V3_Variables": {
    "cold": 2234,
    "warm_avg": 1876,
    "min": 1654,
    "max": 2103,
    "stdDev": 145,
    "cv": 7.7
  }
}
```

**Phase 5: Calculated Column Test (Semi-Automated)**

*For Version 1 (calculated column approach), skill provides guidance for manual steps*

```markdown
🔍 Version 1 requires calculated column - switching to semi-automated workflow...

**I'll provide the column definition. You'll need to add it manually:**

1. In Power BI Desktop, go to Sales table
2. New Column (Home → New Column)
3. Paste this DAX:
   ```dax
   Revenue = Sales[Quantity] * RELATED(Products[Price])
   ```
4. Refresh the model (Home → Refresh)
5. Return here when done

[Waiting for user confirmation...]
```

**User confirms: "Done, refreshed"**

```markdown
✅ Column added and refreshed!

Now creating test measure and benchmarking...

[MCP Tool: mcp_powerbi-model_measure_operations]
  Operation: CREATE
  Definitions: [{"Name": "_TEMP_Revenue_V1_CalcColumn", "TableName": "Sales", 
                 "Expression": "SUM(Sales[Revenue])"}]

[MCP Tool: powerbi_benchmark_dax]
  Query: EVALUATE { [_TEMP_Revenue_V1_CalcColumn] }
  Iterations: 10

Complete!
```

**Returns:**
```json
{
  "V1_CalcColumn": {
    "cold": 245,
    "warm_avg": 142,
    "min": 136,
    "max": 151,
    "stdDev": 5,
    "cv": 3.5
  }
}
```

**Note:** Refresh time and column size are reported by you from Power BI Desktop during the manual step.

**Phase 6: Statistical Analysis (3 seconds)**

*Skill analyzes all results*

```markdown
🎯 Benchmark Results

┌──────────────────┬──────────┬────────┬────────┬──────────┬────────────┬───────────┐
│ Version          │ Cold (ms)│ Avg    │ Min    │ Max      │ Std Dev    │ vs Orig   │
├──────────────────┼──────────┼────────┼────────┼──────────┼────────────┼───────────┤
│ Original         │ 2,847    │ 2,234  │ 2,012  │ 2,467    │ 156 (7.0%) │ Baseline  │
│ V1: Calc Column  │ 245      │ 142    │ 136    │ 151      │ 5 (3.5%)   │ -94%      │
│ V2: Iter Products│ 892      │ 287    │ 276    │ 301      │ 8 (2.8%)   │ -87%      │
│ V3: Variables    │ 2,234    │ 1,876  │ 1,654  │ 2,103    │ 145 (7.7%) │ -16%      │
└──────────────────┴──────────┴────────┴────────┴──────────┴────────────┴───────────┘

**Statistical Analysis:**

✅ All versions show acceptable consistency (CV <10%)
✅ V1 improvement: 2234ms → 142ms (15.7× faster)
✅ Statistical confidence: HIGH
   - Improvement (2,092ms) >> 2× variance (322ms)
   - 6.5× greater than significance threshold

**Performance Characteristics:**

V1 (Calculated Column):
  • Query: 142ms ✅ Excellent
  • Refresh: +23s per refresh (from your manual refresh)
  • Model: +84 MB (from your Desktop file size)
  • Best for: Reports queried frequently, refreshed infrequently
  • Note: Requires manual column addition and refresh in Desktop

V2 (Iterate Products):
  • Query: 287ms ✅ Good
  • No refresh overhead
  • No model size increase
  • Fully automated (no manual steps)
  • Best for: Prefer automation, memory constraints
```

**Phase 7: Recommendation (2 seconds)**

```markdown
🏆 WINNER: Version 1 (Calculated Column Approach)

**Performance:**
- Before: 2,234 ms avg
- After: 142 ms avg
- Improvement: -94% (15.7× faster)
- Consistency: Excellent (3.5% CV)

**Implementation:**

```dax
// Step 1: Add calculated column to Sales table
Sales[Revenue] = Sales[Quantity] * RELATED(Products[Price])

// Step 2: Update measure
Total Revenue = SUM(Sales[Revenue])
```

**Trade-offs:**

✅ Pros:
  • 94% faster queries
  • Storage engine optimized
  • Consistent performance
  • Scales well with usage

⚠️ Cons:
  • +84 MB model size (+34%)
  • +23s refresh time (+15%)
  • Data not real-time (requires refresh)

**Alternative (No Model Size Impact):**
Version 2 (Iterate Products) achieves 87% improvement with no model size increase.
Use if memory is constrained or real-time data required.

───────────────────────────────────────

Would you like me to:
1. Apply Version 1 (recommended)
2. Apply Version 2 (alternative)
3. Show full code for manual implementation
4. Cancel (clean up only)

**Phase 8: User Confirmation**

```
User: "1"
```

**Phase 9: Apply Changes (10 seconds)**

*Skill applies the optimization*

```markdown
Applying optimization...

[MCP Tool: mcp_powerbi-model_measure_operations]
  Operation: DELETE
  Cleaning up all temporary measures...
```

**Tool Call:**
```json
{
  "operation": "DELETE",
  "references": [
    {"Name": "_TEMP_Revenue_Original", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V2_IterateProducts", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V3_Variables", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V1_CalcColumn", "TableName": "Sales"}
  ],
  "shouldCascadeDelete": true
}
```

```markdown
✅ Temporary measures deleted

**Final Steps (Manual in Desktop):**
1. Rename column: Sales[Revenue] (if you used temp name)
2. Update your original measure to: `Total Revenue = SUM(Sales[Revenue])`
3. Remove old measure definition if needed

✅ Optimization guidance complete!

Validating changes...
```

**Phase 10: Validation (5 seconds)**

```markdown
Running validation benchmark...

[MCP Tool: powerbi_benchmark_dax]
  Query: EVALUATE { [Total Revenue] }
  Iterations: 5

**Validation Results:**
- Target: 142 ms (from benchmark)
- Actual: 138 ms ✅
- Difference: -4ms (2.8% better than expected!)

✅ Optimization validated and deployed!

**Summary:**
✅ Calculated column added: Sales[Revenue] (you added manually)
✅ Measure ready to update: Total Revenue = SUM(Sales[Revenue])
✅ Temporary measures cleaned up automatically
✅ Expected performance: 2,234ms → 138ms (94% improvement)

🎉 Optimization complete!

**Note:** Since calculated columns were involved, you completed the final implementation manually in Power BI Desktop. The skill handled all analysis, benchmarking, and measure testing automatically.
```

---

### Alternative: User Cancels Optimization

**If user chooses option 4 (Cancel) or doesn't want to apply changes:**

```markdown
Would you like me to:
1. Apply Version 1 (recommended)
2. Apply Version 2 (alternative)
3. Show full code for manual implementation
4. Cancel (clean up only)
```

**User selects: "4"**

```markdown
Understood. Cleaning up temporary measures...

[MCP Tool: mcp_powerbi-model_measure_operations]
  Operation: DELETE
  Cleaning up all temporary measures...
```

**Tool Call:**
```json
{
  "operation": "DELETE",
  "references": [
    {"Name": "_TEMP_Revenue_Original", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V1_CalcColumn", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V2_IterateProducts", "TableName": "Sales"},
    {"Name": "_TEMP_Revenue_V3_Variables", "TableName": "Sales"}
  ],
  "shouldCascadeDelete": true
}
```

```markdown
✅ All temporary measures deleted

**Summary:**
- Benchmark results saved for your reference
- No changes applied to your model
- Model restored to original state

You can implement the optimization manually using the DAX code provided above.
```

**Key Point:** 🧹 **Cleanup ALWAYS happens** - whether user applies optimization or cancels!

---

## 🎯 Skill Integration Instructions

### Phase 1: Add MCP Tool Awareness to Skills

Add this section to both **SKILL.md** (hub) and **dax-mastery.md** (specialist):

markdown
## 🤖 Automated Optimization (MCP Integration)

### Prerequisites

To enable automated DAX measure benchmarking (calculated columns require manual steps):

1. **Install Power BI MCP Server**
   See installation options above (VS Code Extension recommended)

2. **Configure XMLA Endpoint in Power BI Desktop**
   - Enable in Power BI Desktop: File → Options → Preview Features
   - ✅ "XMLA Endpoint and dataset connectivity"
   - Restart Power BI Desktop
   - Open your model

3. **Configure MCP Server**
   - For VS Code Extension: Automatic
   - For NPX/Manual: Add `powerbi-modeling-mcp` server to your MCP settings
   - See installation section above for details

### Automated Workflow

When MCP server is available, I can:

✅ **Fully Automate:**
- Connect to your running Power BI model
- Create temporary measures for testing
- Run statistical benchmarks (10-20 iterations)
- Compare multiple optimization approaches
- Apply the winning optimization
- Clean up temporary objects

### Trigger Phrases

Use these phrases to trigger automated optimization:

- "Optimize and benchmark this measure"
- "Auto-optimize with benchmarking"
- "Test optimizations automatically"
- "Run automated DAX optimization"

### Example Request

@dax-mastery "Optimize and benchmark this measure:

Total Revenue = 
SUMX(
    Sales,
    Sales[Quantity] * RELATED(Products[Price])
)"

### What You Get

1. **Analysis**: Identifies optimization opportunities
2. **Variants**: Creates 2-3 optimized versions
3. **Benchmarks**: Runs real performance tests automatically
4. **Statistics**: Min/max/avg/stddev for each version
5. **Winner**: Identifies fastest with confidence level
6. **Implementation**: 
   - Measure-only: Fully automated with confirmation
   - Calculated columns: Provides code + manual guidance
7. **Validation**: Verifies performance after deployment

**Total Time**: 
- Measure-only optimizations: 2-3 minutes ⚡
- With calculated columns: 5-8 minutes (includes manual add/refresh)

**Accuracy**: Statistical confidence levels provided
**Safety**: Temporary measures used, manual approval for structural changes

### Fallback Mode

If MCP server not available:
- Skill analyzes DAX and provides optimized code
- You manually test in Power BI Desktop or DAX Studio
- You share results for statistical analysis
- Skill interprets and recommends best approach


### Phase 2: Update Analysis Workflow

In **dax-mastery.md**, update the analysis framework:

## Analysis Framework

### Detection: MCP Server Availability

**Step 1: Check for MCP Integration**
IF MCP server available:
  → Proceed with automated workflow
ELSE:
  → Use manual guidance workflow

### Automated Workflow (MCP Available)

**Phase 1: Analysis**
1. Parse DAX expression
2. Identify optimization patterns
3. Generate 2-3 optimized variants
4. Estimate impact for each


**Phase 2: Setup**
[Use Tool: powerbi_connect_model]
[Use Tool: powerbi_get_model_metadata]
  → Get table sizes, relationships
  → Inform optimization strategy

**Phase 3: Testing**
For each variant:
  [Use Tool: mcp_powerbi-model_measure_operations]
    → Operation: CREATE
    → Create temporary measure with definitions array
    
  [Use Tool: powerbi_benchmark_dax]
    → Run 10 iterations
    → Collect timing statistics
    
  Store results


**Phase 4: Analysis**

Statistical analysis:
  - Calculate confidence levels
  - Identify winner
  - Quantify trade-offs


**Phase 5: Cleanup (MANDATORY)**

[Use Tool: mcp_powerbi-model_measure_operations]
  → Operation: DELETE with references array
  → Remove ALL temporary measures
  → ALWAYS runs (even if user cancels)


**Phase 6: Application (Semi-Automated for Desktop)**

IF user confirms AND optimization = measure-only:
  Apply measure changes via TMSL
  Validate performance
ELSE IF user confirms AND optimization = calculated column:
  Provide DAX code and manual instructions:
  1. User adds column in Desktop
  2. User refreshes model manually
  3. Skill creates/updates measure
  4. Skill validates performance


**Phase 7: Validation**

[Use Tool: powerbi_benchmark_dax]
  → Verify expected performance
  → Confirm deployment success


### Manual Workflow (MCP Not Available)

*[Existing manual guidance workflow]*


## 🔒 Safety Features

### Temporary Measures

All test measures created with `_TEMP_` prefix:
- Automatically marked as temporary
- Hidden from users by default
- Auto-deleted on completion or error
- Rollback on any failure

### User Confirmation Required

Before applying changes, user must confirm:
- Review optimization details
- Understand trade-offs
- Understand manual vs. automated steps
- Cancel if uncertain

### Desktop Limitations = Natural Safety

Because Power BI Desktop doesn't support automated refresh:
- **You remain in control** of all structural changes (columns, tables)
- Skill can only create/delete measures automatically
- Any calculated column implementation requires your manual approval
- No risk of unintended automated changes to your model structure

### Error Handling

```
TRY:
  Automated workflow (measures only)
CATCH error:
  Clean up temporary measures
  No model changes (Desktop safety)
  Fall back to manual guidance
  Report error details
```

## 📊 Expected Results

### Time Savings

**Manual Process (Traditional):**
- Analysis: 10 min
- Write variants: 15 min
- Create test measures: 5 min
- Benchmark each version: 10 min
- Statistical analysis: 10 min
**Total: ~50 minutes**

**MCP-Assisted Process (Measure Optimizations):**
- Analysis: Automated
- Write variants: Automated
- Create measures: Automated
- Benchmark: Automated (2-3 min)
- Analysis: Automated
**Total: ~3 minutes**
**Savings: 94% ⚡**

**MCP-Assisted Process (With Calculated Columns):**
- Automated: Analysis, variants, benchmarking
- Manual: Add column (~1 min), Refresh (~1-5 min depending on data size)
- Automated: Measure testing, comparison
**Total: ~5-8 minutes**
**Savings: 85-90% 🚀**

### Accuracy Improvements

- ✅ Consistent benchmark methodology
- ✅ Statistical significance testing
- ✅ No manual errors
- ✅ Reproducible results
- ✅ Objective winner selection

### Learning Benefits

- See multiple optimization approaches
- Understand trade-offs quantitatively
- Learn patterns that work in your model
- Build optimization intuition

---

## 🐛 Troubleshooting

### MCP Server Not Found

**Error:** "Power BI MCP server not available"

**Solution:**
1. Verify installation: `pip list | grep powerbi-mcp`
2. Check MCP settings configuration
3. Restart VS Code
4. Verify XMLA endpoint enabled in Power BI Desktop

### Cannot Connect to Model

**Error:** "Failed to connect to Power BI model"

**Solution:**
1. Verify Power BI Desktop is running with a model open
2. Verify XMLA endpoint is enabled:
   - File → Options → Preview Features
   - ✅ "XMLA Endpoint and dataset connectivity"
3. Restart Power BI Desktop after enabling
4. Check that no other tool is using the XMLA connection
5. Note the localhost port from External Tools tab

### Benchmark Fails

**Error:** "Benchmark execution failed"

**Solution:**
1. Check measure syntax (test manually first)
2. Verify sufficient permissions
3. Check for parallel queries
4. Close other applications

### High Variance in Results

**Issue:** Standard deviation >20%

**Solution:**
1. Close background applications
2. Stop refresh operations
3. Run more iterations (20-50)
4. Test during low-activity period

---

## 🧹 Best Practices: Measure Cleanup

### Critical Rule: ALWAYS Delete Temporary Measures

**After EVERY benchmark workflow, regardless of outcome:**

```json
{
  "operation": "DELETE",
  "references": [
    {"Name": "_TEMP_Original", "TableName": "KPIs"},
    {"Name": "_TEMP_V1_...", "TableName": "KPIs"},
    {"Name": "_TEMP_V2_...", "TableName": "KPIs"}
  ]
}
```

### Cleanup Checklist

✅ **Delete when user applies optimization**  
✅ **Delete when user cancels**  
✅ **Delete when benchmark fails**  
✅ **Delete when error occurs mid-workflow**  
✅ **Use batch DELETE (faster than multiple calls)**  
✅ **Track all created measures for complete cleanup**  

### Naming Convention

Use prefixes for easy identification and cleanup:
- `_TEMP_*` - Temporary benchmark measures
- `_TEST_*` - Test/validation measures
- `_ORIG_*` - Original baseline versions

### Why This Matters

- **Model Cleanliness**: Prevents clutter in user's model
- **Performance**: Avoids unnecessary measure processing
- **Professionalism**: Shows attention to detail
- **Trust**: Users can rely on clean workflows

### Implementation Pattern

```typescript
try {
  // 1. Create test measures
  const measures = [/* ... */];
  await createMeasures(measures);
  
  // 2. Run benchmarks
  const results = await runBenchmarks(measures);
  
  // 3. Analyze and present
  await presentResults(results);
  
} finally {
  // 4. ALWAYS cleanup (even on error/cancel)
  await deleteMeasures(measures);
}
```

---

## 📚 Additional Resources

- **Power BI MCP Server**: [microsoft/powerbi-modeling-mcp](https://github.com/microsoft/powerbi-modeling-mcp)
- **XMLA Endpoint (Desktop)**: [Enable XMLA in Power BI Desktop](https://learn.microsoft.com/power-bi/developer/xmla-endpoint)
- **DAX Optimization Patterns**: See specialist files in this repo
- **Local XMLA Limitations**: [Power BI Desktop vs. Service XMLA](https://learn.microsoft.com/power-bi/enterprise/service-premium-connect-tools)

---

## 🔄 Version History

- **v1.0** (June 2026): Initial MCP integration design
- Future: Direct query plan analysis
- Future: Automated A/B testing framework
- Future: Multi-model benchmark comparison

---

**Ready to optimize? Just say:**
```
@powerbi-optimization "Optimize and benchmark: [your DAX code]"
```
