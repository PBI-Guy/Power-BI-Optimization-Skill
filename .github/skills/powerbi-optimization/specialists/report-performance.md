---
name: report-performance
description: |
  Report design, visual optimization, UX: visual performance, layout, navigation, accessibility (WCAG 2.1),
  mobile optimization, custom visuals, cross-filtering, interaction design.
  Trigger: "visual performance", "report layout", "too many visuals", "accessibility", "mobile layout",
  "navigation", "drill-through", "bookmarks", "slow rendering", "pie chart"
metadata:
  maturity: stable
  lastReviewed: 2026-06-10
  dependencies: [dax-mastery, model-design]
applyTo:
  - "**/*.Report/**"
  - "**/*.pbix"
  - "**/*.pbit"
---

# Report Performance Specialist

> **🎯 Focus**: Deep report design & visual optimization. For comprehensive analysis, use @powerbi-optimization.

**Use for:** Slow visuals | Layout/navigation | Too many visuals | Accessibility (WCAG 2.1) | Mobile optimization | Custom visual evaluation | Interaction optimization  
**Escalate to hub:** DAX/model issues, comprehensive triage

---

## Visual Selection

**Choose by analytical question, not preference**

**Comparison** (which larger?) → Bar/Column | **Trend** (change over time?) → Line | **Distribution** (spread?) → Histogram/Box | **Composition** (parts?) → Stacked Bar/Waterfall | **Relationship** (correlate?) → Scatter/Heatmap

**Pie Charts: NEVER** (except: 2-5 categories, one dominant 70%+, true 100%, clear differences) → **Use Bar Charts Instead**

**Why avoid pies:** Angle estimation inaccurate (25-50% worse than bars) | Poor mobile (small slices) | Accessibility issues | Slower rendering | Label crowding

**Alternatives:** Bar chart (comparison) | Donut chart (single metric with context) | Treemap (hierarchy) | 100% Stacked Bar (composition)

---

## Performance Limits

**2-Second Rule**: Pages load <2s | **7-15 Visuals/Page**: Max 15 (ideal 7-10) | **3-5 Filters/Page**: Essential only | **<100K Rows/Visual**: Reduce granularity | **Progressive Disclosure**: Details on drill-through

**Slow Visual Fixes**: Reduce rows (Top N) | Aggregate higher (monthly vs daily) | Remove custom visuals (built-in faster) | Disable cross-filter (Edit Interactions) | Split complex visuals | Use aggregations

**Performance Profiler**: Help → Performance Analyzer → Start → Interact → Analyze → Fix slowest visuals (>500ms)

---

## Layout Patterns

**F-Pattern**: KPIs top-left → Main chart center → Supporting visuals right/bottom | Eyes scan: Top-left → Across → Down-left → Across

**Z-Pattern**: Landing page flow: Logo top-left → CTA top-right → Content diagonal → Action bottom-right

**Dashboard Grid**: KPIs top row (3-5 cards) → Main chart (50% width) → Supporting (2-4 smaller) → Filters left/top

**Grid Alignment**: 8px/16px/24px spacing | Align edges (invisible lines) | 16-24px page margins | White space intentional

**Visual Count**: Executive (3-5) | Analyst (8-12) | Operations (10-15 max)

---

## Color & Accessibility

**Meaning Not Decoration**: Red (negative/danger) | Green (positive/success) | Yellow (warning) | Blue (neutral/info) | Gray (context/inactive)

**WCAG 2.1 Compliance**: 4.5:1 contrast ratio (text) | Black on white = 21:1 ✅ | Dark gray (#595959) on white = 7:1 ✅ | Light gray (#999999) on white = 2.8:1 ❌

**Color Blindness** (8% men): Avoid red/green alone | Use blue/orange OR color+icon (✅/❌/⚠️) | Test: Grayscale export

**Categorical Palette**: 6-8 colors max | Sequential: Light→dark (heat) | Diverging: Negative←neutral→positive

---

## Interaction Design

**Cross-Filtering**: Default ON for related visuals | OFF for: KPIs (shouldn't filter), unrelated visuals, performance issues | Edit Interactions tool

**Slicers**: 3-5 max/page | Dropdown (long lists) | Tiles (3-7 items) | Hierarchy (single-select) | Date range (between) | Sync across pages (View → Sync slicers)

**Drill-Through**: Right-click → Drill through → Detail page | **Setup**: Target page → Drill-through field | **Best**: Product → Product Details | Region → Regional Breakdown

**Bookmarks**: View → Bookmarks → Capture state | **Scenarios**: Default view | Top Products | Bottom Regions | YTD vs YoY | Use buttons to navigate

**Tooltips**: Custom tooltip pages (small, <15 visuals) | Report page tooltip | Show: Context, trends, details | Fast loading (<1s)

---

## Mobile Optimization

**Mobile Layout**: View → Mobile Layout → Drag 5-10 key visuals | Portrait (9:16) | Large touch targets (44px min) | 16px text min | <3s load

**Prioritize**: KPIs | Primary chart | 2-3 essential filters | **Skip**: Detail tables, complex matrices, advanced drill visuals

**Visual Substitution**: Table (100 rows) → Top 10 bar | Matrix (large) → Simple table | Map → Bar by region | Multiple slicers → 1-2 dropdowns

**Touch-Friendly**: Large tap targets | Dropdown slicers (not vertical) | Swipe navigation (bookmarks) | No hover interactions

---

## Navigation

**Tab Navigation**: Pages as tabs (top) | Max 7 tabs (cognitive load) | Group: Overview | Analysis | Details | Admin

**Buttons**: Navigation, bookmarks, external links | Icons + text | Consistent placement | Hover state | Action = "Navigate to page"

**Home Page**: Landing page with: Purpose statement | Key insights | Navigation to sections | Last refresh time

**Breadcrumbs**: Show current location | "Home > Sales > Product Details" | Use buttons with "Back" action

---

## Accessibility (WCAG 2.1)

**Alt Text**: All visuals → Format → Alt text | Describe insight, not visual type | "Sales increased 23% in Q4" (NOT "Bar chart showing sales")

**Tab Order**: View → Selection pane → Reorder (top-down) | Logical flow | Test: Tab through report

**Keyboard Navigation**: All interactions keyboard-accessible | Tab (next) | Shift+Tab (previous) | Enter (activate)

**Screen Readers**: Descriptive names | Data labels on key visuals | Clear headers | Focus indicators visible

**Contrast Check**: WebAIM Contrast Checker | Text 4.5:1 | Large text (18pt+) 3:1 | Test: Grayscale export

---

## Custom Visuals

**Evaluation Criteria**: Performance (render <500ms) | Security (certified only) | Accessibility (keyboard/screen reader) | Mobile support | Maintenance (active updates)

**Built-In First**: Always consider built-in alternative → Faster | More secure | Better supported | Better accessibility

**Custom Visual Issues**: Slow rendering | Security risks (non-certified) | Compatibility (version breaks) | Accessibility gaps | Mobile issues

**Certified Visuals**: AppSource → Certified badge | Microsoft/partner verified | Security reviewed | Use when: Built-in insufficient, certified available

---

## Anti-Patterns

**❌ Data Dump**: 50+ visuals, no narrative → Fix: 3-5 questions, 8-12 visuals, clear story

**❌ Chart Junk**: Unnecessary decorations, 3D, gradients → Fix: Minimal design, focus on data, remove noise

**❌ Too Many Filters**: 10+ slicers → Fix: 3-5 essential, move others to drill-through

**❌ Rainbow Colors**: No meaning, overwhelming → Fix: Purposeful palette, 6-8 colors max

**❌ No White Space**: Visuals touching, claustrophobic → Fix: 16-24px spacing, breathing room

**❌ Tiny Text**: <10px font → Fix: 12px min (14px better), 16px mobile

**❌ Hover-Only Info**: Key data only on hover → Fix: Show key info always, details on hover

**❌ No Mobile Layout**: Desktop-only → Fix: Custom mobile layout, 5-10 visuals, portrait

---

## Design Process

**Phase 1 (Week 1)**: MVP → 1-2 pages, 5-8 core visuals, simple layout, get feedback

**Phase 2 (Week 2)**: User Testing → Watch 3-5 users (don't explain!), note clicks, identify confusion

**Phase 3 (Week 3)**: Iterate → Add missing, remove unused, improve navigation, fix confusing

**Phase 4 (Week 4+)**: Expand → Drill-through pages, mobile layouts, bookmarks, tooltips

**Don't Over-Engineer**: Ship v1.0 in 2 weeks → Iterate based on usage (NOT 2-month "perfect" report)

---

## Troubleshooting

**Slow Rendering**: Performance Analyzer → Visuals >500ms → Fix: Reduce rows (Top N), aggregate higher, disable cross-filter, built-in visuals, split complex

**Too Cluttered**: >15 visuals → Fix: 7-15 max, split pages, drill-through for details, remove unused

**Hard to Navigate**: No clear path → Fix: Home page, tabs (max 7), breadcrumbs, consistent layout

**Poor Mobile**: Unreadable → Fix: Mobile layout, 5-10 visuals, 44px touch targets, dropdown slicers

**Accessibility Fails**: Low contrast, no alt text → Fix: 4.5:1 contrast, alt text all visuals, tab order, keyboard test

---

## Output Format

```markdown
## 📊 Report Design Analysis
**Pages**: [N] | **Visuals/Page**: [Avg] ([Status]) | **Mobile Layout**: [Y/N] | **Load Time**: [Sec] ([Status])

**Page**: [Name] | **Visuals**: [N] ([Status]) | **Load**: [Sec] | **Issues**: [Count]

**Visual**: [Type] | **Load**: [Ms] ([Status]) | **Rows**: [N] | **Issue**: [Description]

**P0**: [Issue] → [Fix] → [Impact] | **P1**: [Issue] → [Fix] → [Impact]

**Design Score**: [N]/10 | **Performance**: [N]/10 | **Accessibility**: [N]/10 | **Mobile**: [N]/10

**Checklist**: [ ] <2s load [ ] 7-15 visuals [ ] Mobile layout [ ] WCAG 2.1 [ ] No pies [ ] Alt text [ ] Cross-filter optimized
```
