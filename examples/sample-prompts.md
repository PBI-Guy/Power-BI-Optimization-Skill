# Sample Prompts for Power BI Optimization Skill

This document provides example prompts you can use to trigger the Power BI Optimization Skill in GitHub Copilot. Copy these examples or adapt them to your specific scenarios.

## 🎯 Quick Reference

| Category | Complexity | Example Count |
|----------|------------|---------------|
| DAX Optimization | Basic → Advanced | 15 |
| Semantic Model Design | Basic → Advanced | 12 |
| Report Performance | Basic → Advanced | 10 |
| Best Practices | General | 8 |
| Troubleshooting | Problem-specific | 10 |

---

## 📊 DAX Optimization

### Basic DAX Questions

1. **"How can I optimize this DAX measure?"**
   ```dax
   Total Sales = SUM(Sales[Amount])
   ```

2. **"What's wrong with this calculation?"**
   ```dax
   YTD Sales = CALCULATE(SUM(Sales[Amount]), DATESYTD(Calendar[Date]))
   ```

3. **"Is there a better way to write this measure?"**
   ```dax
   Profit Margin = DIVIDE(SUM(Sales[Profit]), SUM(Sales[Revenue]))
   ```

### Iterator Optimization

4. **"This SUMX is slow. How can I improve performance?"**
   ```dax
   Revenue = SUMX(Sales, Sales[Quantity] * RELATED(Products[Price]))
   ```

5. **"Why is my FILTER function taking so long?"**
   ```dax
   Large Orders = CALCULATE(
       SUM(Sales[Amount]),
       FILTER(Sales, Sales[Amount] > 1000)
   )
   ```

6. **"Optimize this nested iterator:"**
   ```dax
   Complex Calc = 
   SUMX(
       Products,
       SUMX(
           FILTER(Sales, Sales[ProductID] = Products[ProductID]),
           Sales[Quantity] * Products[Price]
       )
   )
   ```

### Context Transition Issues

7. **"Why is this measure calculating incorrectly?"**
   ```dax
   Sales Per Customer = SUMX(Customers, SUM(Sales[Amount]))
   ```

8. **"Explain the context transition in this measure:"**
   ```dax
   Avg Order Value = 
   AVERAGEX(
       VALUES(Sales[OrderID]),
       [Total Sales]
   )
   ```

9. **"How do I avoid context transition performance issues?"**

### Time Intelligence

10. **"Create an optimized year-over-year growth measure"**

11. **"Why is my YTD calculation returning incorrect values?"**
    ```dax
    YTD Sales = 
    CALCULATE(
        SUM(Sales[Amount]),
        FILTER(
            ALL(Calendar),
            Calendar[Date] <= MAX(Calendar[Date])
            && YEAR(Calendar[Date]) = YEAR(MAX(Calendar[Date]))
        )
    )
    ```

12. **"Optimize this moving average calculation:"**
    ```dax
    Moving Avg = 
    AVERAGEX(
        DATESINPERIOD(Calendar[Date], LASTDATE(Calendar[Date]), -30, DAY),
        [Total Sales]
    )
    ```

### Advanced DAX Patterns

13. **"Review this calculation group for performance issues:"**
    ```dax
    Time Intelligence = 
    VAR CurrentDate = MAX(Calendar[Date])
    RETURN
    SWITCH(
        SELECTEDVALUE('Time Calc'[Calc]),
        "YTD", CALCULATE([_Base], DATESYTD(Calendar[Date])),
        "PY", CALCULATE([_Base], SAMEPERIODLASTYEAR(Calendar[Date])),
        [_Base]
    )
    ```

14. **"Optimize this dynamic ranking measure:"**
    ```dax
    Product Rank = 
    RANKX(
        ALL(Products[Product]),
        [Total Sales],
        ,
        DESC,
        Dense
    )
    ```

15. **"How can I improve this complex conditional measure?"**
    ```dax
    Sales Category = 
    IF(
        [Total Sales] > 1000000, "High",
        IF(
            [Total Sales] > 500000, "Medium",
            IF(
                [Total Sales] > 100000, "Low",
                "Minimal"
            )
        )
    )
    ```

---

## 🗂️ Semantic Model Design

### Schema Design

16. **"Review my data model for best practices"**

17. **"I have a snowflake schema. Should I convert it to a star schema?"**

18. **"What's the best way to model a many-to-many relationship between Orders and Products?"**

19. **"Should I use a bridge table or a many-to-many relationship?"**

### Relationship Issues

20. **"I'm getting cardinality warnings. What does this mean?"**

21. **"When should I use bi-directional filtering?"**

22. **"My relationships aren't filtering correctly. Help me debug."**

23. **"Explain one-to-many vs. many-to-one relationships in Power BI"**

### Storage Modes

24. **"Should I use Import, DirectQuery, or Composite mode?"**

25. **"When should I implement incremental refresh?"**

26. **"How do I optimize a large fact table with 100M+ rows?"**

27. **"What's the performance impact of DirectQuery vs Import mode?"**

### Calculated Columns vs Measures

28. **"Should this be a calculated column or a measure?"**
    ```dax
    Profit = Sales[Revenue] - Sales[Cost]
    ```

29. **"Convert this calculated column to a measure:"**
    ```dax
    Products[Category] = RELATED(Categories[CategoryName])
    ```

30. **"When should I use calculated columns instead of measures?"**

---

## 📈 Report Performance

### Visual Optimization

31. **"My report page with 20 visuals is slow. How can I speed it up?"**

32. **"What's the recommended number of visuals per page?"**

33. **"Which visual types are most performance-efficient?"**

34. **"Should I use bookmarks or multiple pages for navigation?"**

### Interaction Optimization

35. **"How do cross-filtering and cross-highlighting affect performance?"**

36. **"When should I disable visual interactions?"**

37. **"Optimize slicer performance for high-cardinality columns"**

### Report Load Time

38. **"My report takes 60 seconds to load. Diagnose the issue."**

39. **"What are common causes of slow report rendering?"**

40. **"How do I use Performance Analyzer to identify bottlenecks?"**

---

## ✅ Best Practices

### General Guidance

41. **"What are the top 10 Power BI best practices?"**

42. **"Review my Power BI project structure for best practices"**

43. **"What are the most common Power BI performance mistakes?"**

44. **"Explain the difference between storage engine and formula engine"**

### Code Quality

45. **"How should I format DAX code for readability?"**

46. **"What naming conventions should I use for measures and tables?"**

47. **"How do I make my Power BI solution maintainable?"**

48. **"Create a style guide for DAX development"**

---

## 🔧 Troubleshooting

### Performance Issues

49. **"My Power BI report is timing out. Help me troubleshoot."**

50. **"Why is my semantic model refresh taking 3 hours?"**

51. **"Debug this slow-running measure:"**
    ```dax
    Complex Calc = 
    SUMX(
        FILTER(
            ALL(Sales),
            Sales[Date] >= DATE(2020, 1, 1)
        ),
        Sales[Amount] * [Exchange Rate]
    )
    ```

52. **"Query is timing out in DirectQuery mode. What can I do?"**

### Incorrect Results

53. **"This measure returns blank values. Why?"**
    ```dax
    Sales Growth = 
    DIVIDE(
        [Total Sales] - [Total Sales PY],
        [Total Sales PY]
    )
    ```

54. **"My totals don't match the sum of rows. How do I fix this?"**

55. **"Why does my time intelligence function return incorrect dates?"**

### Relationship Issues

56. **"Relationships aren't filtering my visuals. Diagnose the problem."**

57. **"I see a circular dependency error. How do I resolve it?"**

58. **"Why can't I create a relationship between these two tables?"**

---

## 🎓 Learning & Education

### Understanding Concepts

59. **"Explain evaluation context in DAX with examples"**

60. **"What's the difference between CALCULATE and CALCULATETABLE?"**

61. **"When should I use variables in DAX measures?"**

62. **"Explain row context vs filter context"**

### Pattern Libraries

63. **"Show me common DAX patterns for time intelligence"**

64. **"What are the standard patterns for ranking and topN analysis?"**

65. **"Demonstrate the correct way to handle blank values in measures"**

---

## 🔬 Advanced Scenarios

### Complex Business Logic

66. **"Implement an ABC analysis measure with dynamic thresholds"**

67. **"Create a cohort analysis calculation for customer retention"**

68. **"Build a weighted average measure with multiple weights"**

### Performance Tuning

69. **"Analyze this entire semantic model for optimization opportunities"**

70. **"Generate a comprehensive performance report for my Power BI project"**

71. **"What's the optimal way to handle slowly changing dimensions in Power BI?"**

### Integration Questions

72. **"How do I optimize Power BI for Fabric integration?"**

73. **"Best practices for Power BI with Azure Analysis Services"**

74. **"Optimize Power BI Embedded performance for web applications"**

---

## 💡 Tips for Using These Prompts

### Make Prompts More Specific

Instead of generic questions, provide context:

❌ **Generic**: "Optimize this measure"

✅ **Specific**: "This measure calculates year-over-year growth but takes 15 seconds to run on a 10M row table. How can I optimize it?"

### Include Your Code

Always include the actual DAX code or model structure:

❌ **Vague**: "My measure is slow"

✅ **Clear**: 
```
"This measure is slow:
[Code here]

Data context:
- Sales table: 50M rows
- Products: 10K rows
- Query time: 30 seconds
```

### Ask Follow-up Questions

Don't hesitate to dig deeper:

1. First prompt: "Analyze this DAX measure"
2. Follow-up: "Explain why context transition is happening here"
3. Follow-up: "Show me an alternative approach without context transition"

### Request Specific Output

Tell Copilot what you need:

- "Provide a detailed analysis report"
- "Give me quick wins only"
- "Explain like I'm new to DAX"
- "Show me the performance impact of each change"

---

## 🎯 Real-World Scenarios

### Scenario 1: New Power BI Developer

**Prompt**: "I'm new to Power BI and created my first report. Can you review it for best practices? Here's my model structure: [describe structure]"

### Scenario 2: Performance Crisis

**Prompt**: "My production report suddenly became slow after adding 5M new rows. Query times went from 2s to 45s. Help me identify and fix performance bottlenecks."

### Scenario 3: Pre-Production Review

**Prompt**: "Before deploying this report to production, review all measures, relationships, and visuals for potential issues. Provide a comprehensive checklist."

### Scenario 4: Migration to Fabric

**Prompt**: "I'm migrating this Power BI solution to Microsoft Fabric. What optimizations should I consider for the new platform?"

---

## 📝 Custom Prompt Templates

### Template 1: DAX Optimization Request
```
"Optimize this DAX measure:

[Your DAX code]

Context:
- Table size: [row count]
- Current performance: [query time]
- Target performance: [desired time]
- Business logic: [what it calculates]

Focus on: [specific concern, e.g., iterator performance]"
```

### Template 2: Model Review Request
```
"Review my semantic model:

Tables:
- [Table 1]: [row count], [storage mode]
- [Table 2]: [row count], [storage mode]

Relationships:
- [Table A] to [Table B]: [cardinality]

Issues I'm experiencing:
- [Describe issues]

Focus areas: [DAX/relationships/performance/all]"
```

### Template 3: Report Performance Request
```
"My Power BI report performance analysis:

Report details:
- Pages: [count]
- Visuals per page: [count]
- Current load time: [seconds]
- Target load time: [seconds]

User experience issues:
- [Describe issues]

Please provide prioritized recommendations."
```

---

**Remember**: The more context you provide, the better and more specific the optimization recommendations will be!
