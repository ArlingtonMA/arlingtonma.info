---
permalink: /test/
title: Comparable Town Expenses By Department (prototype)
classes: wide
---

<!-- Load d3/c3 resources TODO: move to header -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>

## Police Spending Per Capita

_Approximate_ police budgets per capita and as a %age of total budget for Arlington versus **comparable towns**.  

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Police Spending Per Capita</h3>
    <div id="ppercapita"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Police Spending As %age Of Total Budget</h3>
    <div id="ppercent"></div>
  </div>
</figure>

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

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Medford - 2019 Expenses By Dept.</h3>
    <div id="medford"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Winchester - 2019 Expenses By Dept.</h3>
    <div id="winchester"></div>
  </div>
  <figcaption>A couple of other towns</figcaption>
</figure>

[Download this data as a CSV spreadsheet](/data/finance/GenFundExpenditures2019-comps.csv), or find the [original source data on mass.gov](https://dlsgateway.dor.state.ma.us/reports/rdPage.aspx?rdReport=ScheduleA.GenFund_MAIN) as reported using standard classifications [from the MA Department of Revenue](https://www.mass.gov/orgs/division-of-local-services).  **Comparable towns** to Arlington (Belmont, Brookline, Medford, Melrose, Milton, Natick, Needham, North Andover, Reading, Stoneham, Watertown, Winchester) are defined in the [Town Manager's Annual Reports](https://www.arlingtonma.gov/departments/town-manager/town-manager-s-annual-budget-financial-report).

<div id="csvtable"></div>

<!-- Actually load our charts/tables -->
<script src="/assets/js/dataread.js"></script>
<script src="/assets/js/test.js"></script>