---
permalink: /test-google/
title: Comparable Town Expenses By Department (prototype of Google Charts)
classes: wide
---

## Town Expenses By Department

A comparison of annual (2019) expenses by department between Arlington and selected local towns.  We should update this page to better allow people to compare to different local comparable towns as defined in the annual report.  Note that the data for department spending in these charts may differ subtly between towns (by small amounts, proportionally) due to how different towns classify expenses per department in their top-level reporting to the state.

For example, depending on the town, costs for Crossing Guards may be in the Education budget, or another public safety budget category.

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Arlington - 2019 Expenses By Dept.</h3>
    <div id="arlington"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Belmont - 2019 Expenses By Dept.</h3>
    <div id="belmont"></div>
  </div>
  <figcaption>Arlington vs. Other Towns</figcaption>
</figure>

[Download this data as a CSV spreadsheet](/data/finance/GenFundExpenditures2019-comps.csv), or find the [original source data on mass.gov](https://dlsgateway.dor.state.ma.us/reports/rdPage.aspx?rdReport=ScheduleA.GenFund_MAIN) as reported using standard classifications [from the MA Department of Revenue](https://www.mass.gov/orgs/division-of-local-services).  **Comparable towns** to Arlington (Belmont, Brookline, Medford, Melrose, Milton, Natick, Needham, North Andover, Reading, Stoneham, Watertown, Winchester) are defined in the [Town Manager's Annual Reports](https://www.arlingtonma.gov/departments/town-manager/town-manager-s-annual-budget-financial-report).

<!-- Actually load our charts/tables -->
<script type="text/javascript" src="https://www.gstatic.com/charts/loader.js"></script>
<script src="/assets/js/test-google.js"></script>