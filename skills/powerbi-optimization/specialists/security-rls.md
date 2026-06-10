---
name: security-rls
description: |
  Deep security & RLS: static/dynamic patterns, performance, OLS, embedding, B2B, compliance.
  Trigger: "row level security", "RLS", "USERNAME", "USERPRINCIPALNAME", "security roles", 
  "dynamic security", "object level security", "OLS", "embedding security", "service principal"
metadata:
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: [dax-mastery, model-design]
applyTo:
  - "**/*.Dataset/definition/roles/**"
  - "**/*.SemanticModel/definition/roles/**"
  - "**/*.bim"
---

# Security & RLS Specialist

> **🎯 Focus**: Deep RLS/security expertise. For holistic analysis, use @powerbi-optimization.

**Use for:** RLS implementation, performance, dynamic security, OLS, embedding, workspace permissions, testing, B2B guests  
**Escalate to hub:** DAX/model issues, comprehensive analysis

---

## RLS Fundamentals

**Import**: Filters cached data in-memory (10-50% overhead) | **DirectQuery**: Pushes to SQL WHERE (must fold, DB-critical) | **Composite**: Import dimensions (fast) or DirectQuery facts (must fold)

**CRITICAL**: Multiple roles **additive** (union). User in "Sales" + "Marketing" sees BOTH. Best Practice: Single role per user.

---

## RLS Patterns

**1. Static**: `[Region] = "North America"` (10-20% overhead, avoid >100 roles)

**2. Dynamic Security Table** (Recommended): SecurityMapping (UserEmail | Region), `[UserEmail] = USERPRINCIPALNAME()` on SecurityMapping → relationship to Sales. Single role, 30-50% overhead. Optimize: Index UserEmail, <10K rows, Import.

**3. Manager Hierarchy**: Pre-compute in Power Query → EmployeeSecurity (ManagerEmail | CanSeeEmployeeID), RLS: `[ManagerEmail] = USERPRINCIPALNAME()`. 10x faster than PATHCONTAINS().

**4. Many-to-Many**: SecurityAccess (UserEmail | Region | Category, * = all), 40-60% overhead.

**5. Partial RLS**: Unsecured summary for benchmarks. `Revenue % All = DIVIDE(SUM(Sales[Revenue]), SUM(SummaryTable[RevenueAll]))`. RLS on Sales only.

---

## Performance

**Priorities**: RLS on dimensions not facts | Simple filters (`[Col] = "Value"` not LOOKUPVALUE) | Avoid bi-directional large tables (5-10x slower) | Pre-compute Power Query | Index columns (DirectQuery)

**DirectQuery**: MUST fold. SQL Profiler → WHERE clause + indexes. `[Region] = "NA"` ✅ | Complex CALCULATE/FILTER ❌. Use DB RLS + Power BI.

**Targets**: Simple <30% | Complex <50% | DirectQuery: optimize source

---

## USERNAME() vs USERPRINCIPALNAME()

**USERNAME()**: Desktop `DOMAIN\User` | Service UPN | **USERPRINCIPALNAME()**: Always UPN - **Recommended** for cloud, B2B, DirectQuery

---

## Validation & Testing

**Test as Role**: Uses YOUR identity (not simulated). For B2B/service principals, sign in as actual user.

**Measures**: `Current User = USERNAME() & " | " & USERPRINCIPALNAME()` | `Access % = DIVIDE(COUNTROWS(Fact), CALCULATE(COUNTROWS(Fact), ALL(Fact)))`

**Default Deny**: `IF(USERNAME() = "Worker", [Type] = "Y", IF(USERNAME() = "Manager", TRUE(), FALSE()))` ✅ | `IF(..., TRUE())` ❌

---

## B2B Guests

**Entra Groups**: B2B in groups may not resolve. **Fix**: Add directly to role OR dynamic RLS.

**UPN Format**: `user@partner.com` OR `user_partner.com#EXT#@tenant.onmicrosoft.com`. Test: `Guest UPN = USERPRINCIPALNAME()`

**No Data?**: Display UPN → guest views → EXACT security table match → role → cross-tenant access

---

## Embedding

**App Owns Data**: Service principal + EffectiveIdentity (Username, Roles, CustomData) → GenerateToken. `[AppRole] = CUSTOMDATA()` for flexibility. Service Principal + UPN returns app ID (not user) - use EffectiveIdentity.

**User Owns Data**: Azure AD → Power BI applies RLS to user identity.

---

## OLS

**Hide columns/tables** (Tabular Editor/TMDL): `{"name": "Role", "tablePermissions": [{"name": "Customers", "columnPermissions": [{"name": "SSN", "metadataPermission": "none"}]}]}`. RLS + OLS = defense-in-depth.

---

## Anti-Patterns

**❌ Default Allow**: `TRUE()` → Fix: FALSE | **❌ Complex**: Time/nested → Fix: Security table | **❌ Bi-directional Large Facts**: 50M rows → Fix: One-way via dimension | **❌ LOOKUPVALUE**: Slow → Fix: Relationship | **❌ Calc Columns DirectQuery**: Per query → Fix: Source DB

---

## Workspace Permissions

**RLS applies**: Viewer | **Bypassed**: Admin, Member, Contributor | **Enforce**: Assign Viewer or share app

---

## Compliance

**Labels**: Public | General | Confidential | Highly Confidential (watermarks, restrictions, audit)  
**DLP**: Purview blocks PII sharing  
**Monitoring**: Audit logs | Quarterly reviews | Document model | Incident response  
**Audit**: `Unusual = IF(UserCount > Avg * 3, "⚠️", "Normal")`

---

## Troubleshooting

**RLS 5-10x slower**: DAX Studio → High Formula Engine → Fix: Simplify, pre-compute, single-direction, index  
**No data**: Role assigned? | UPN exact match? | Relationships active? | Test actual user  
**DirectQuery fails**: SQL Profiler → WHERE + indexes → Fix: Fold, index, DB RLS

---

## Output Format

```markdown
## 🔒 Security Analysis
**Dataset**: [Name] | **Roles**: [N] | **Pattern**: [Type] | **Perf**: [%]

**Role**: [Name] | **Filter**: `[DAX]` | **Tables**: [X] | **Perf**: [ms]→[ms] ([%])

**P0**: [Issue] → [Fix] → [Impact] | **P1**: [Issue] → [Fix] → [Impact]

**Test**: [ ] View as [ ] Actual users [ ] <50% [ ] Edge cases  
**Compliance**: [ ] Labels [ ] OLS [ ] DLP [ ] Audit [ ] Docs
```

---

## Best Practices (Top 15)

1. Security table (flexible) | 2. USERPRINCIPALNAME() (cloud, B2B) | 3. RLS dimensions (not facts) | 4. Default deny | 5. Pre-compute (Power Query) | 6. Avoid bi-directional large (5-10x slower) | 7. Single role/user | 8. Index columns (DirectQuery) | 9. Test actual users | 10. B2B: Direct assignment (not groups) | 11. RLS + OLS (defense-in-depth) | 12. <50% overhead | 13. Sensitivity labels | 14. Audit logs | 15. EffectiveIdentity embed

---

## Specialist Metadata

**Type**: Specialist | **Hub**: @powerbi-optimization | **Version**: 1.0.0 | **Updated**: June 10, 2026

**Related**: @dax-mastery (RLS DAX) | @model-design (security tables) | @report-performance (embedding)

**Sources**: MS Learn RLS Guidance | Fabric Security Admin | GitHub Copilot Best Practices

**Best Practices**:

**RLS applies**: Viewer role | **RLS bypassed**: Admin, Member, Contributor | **Enforce RLS**: Assign Viewer or share app
---

## Troubleshooting

**RLS 5-10x slower**: DAX Studio → High Formula Engine → Fix: Simplify, pre-compute, single-direction, index  
**User sees no data**: Role assigned? | UPN matches exactly? | Relationships active? | Test as actual user  
**DirectQuery not working**: SQL Profiler → WHERE clause + index seeks → Fix: Simplify fold, add indexes, DB
**Impact**: [ms] → [ms] ([%] faster)

### Recommendations
**P0**: [Action] → [Expected outcome]  
**P1**: [Action] → [Expected outcome]

### Testing
- [ ] "View as role" for all roles
- [ ] Actual user testing (esp. B2B guests)
- [ ] Performance Analyzer (<50% overhead)
- [ ] Edge cases (no role, multiple roles, special chars)

### Compliance
- [ ] Sensitivity labels applied
- [ ] OLS for PII columns
- [ ] DLP policies configured
- [ ] Audit logging enabled
- [ ] Documented for auditors
```

---

## Best Practices (Top 20)

1. **Security table pattern** (most flexible)
2. **USERPRINCIPALNAME() over USERNAME()** (cloud-first, B2B)
3. **RLS on dimensions, not facts** (propagates via relationships)
4. **Default deny** (FALSE if user unexpected)
5. **Pre-compute hierarchy** (Power Query, not DAX)
6. **Avoid bi-directional on large tables** (5-10x slower)
7. **Single role per user** (avoid additive complexity)
8. **Index columns** (DirectQuery critical)
9. **Verify folding** (DirectQuery - SQL Profiler)
10. **Test with actual users** (Test as role limitations)
11. **B2B: Direct role 15)

1. **Security table** (most flexible) | 2. **USERPRINCIPALNAME()** (cloud, B2B) | 3. **RLS on dimensions** (not facts) | 4. **Default deny** (FALSE) | 5. **Pre-compute hierarchy** (Power Query) | 6. **Avoid bi-directional large tables** (5-10x slower) | 7. **Single role per user** (avoid additive) | 8. **Index columns** (DirectQuery) | 9. **Test actual users** (Test as role limits) | 10. **B2B: Direct role assignment** (not Entra groups) | 11. **RLS + OLS** (defense-in-depth) | 12. **<50% overhead** (optimize if exceeded) | 13. **Sensitivity labels** (all datasets) | 14. **Audit logs** (compliance) | 15. **EffectiveIdentity for embed** (not UPN
**Sources**: Microsoft Learn RLS Guidance, Fabric Security Admin RLS, GitHub Copilot Power BI Security Best Practices
