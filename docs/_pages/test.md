---
permalink: /test/
title: Comparable Town Expenses By Department (prototype)
classes: wide
---

<!-- Load d3/c3 resources TODO: move to header -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>

## Town Expenses By Department

A comparison of annual (2019) expenses by department between Arlington and selected local towns.  We should update this page to better allow people to compare to different local comparable towns as defined in the annual report.

<table>
  <tr>
    <td>Arlington - 2019 Expenses By Dept.</td><td>Belmont - 2019 Expenses By Dept.</td>
  </tr>
  <tr>
    <td>
      <div id="arlington" style='width: 450px;'></div>
    </td>
    <td>
      <div id="belmont" style='width: 450px;'></div>
    </td>
  </tr>
  <tr>
    <td>Medford - 2019 Expenses By Dept.</td><td>Winchester - 2019 Expenses By Dept.</td>
  </tr>
  <tr>
    <td>
      <div id="medford" style='width: 450px;'></div>
    </td>
    <td>
      <div id="winchester" style='width: 450px;'></div>
    </td>
  </tr>
</table>

[View the data](/data/finance/GenFundExpenditures2019-comps.csv) for expenses per town department for all comparable towns, as reported using standard classifications [from the MA Department of Revenue](https://www.mass.gov/orgs/division-of-local-services).  

Download this data, or find the [original source data on mass.gov](https://dlsgateway.dor.state.ma.us/reports/rdPage.aspx?rdReport=ScheduleA.GenFund_MAIN).  Comparable towns to Arlington (Belmont, Brookline, Medford, Melrose, Milton, Natick, Needham, North Andover, Reading, Stoneham, Watertown, Winchester) are defined in the [Town Manager's Annual Reports](https://www.arlingtonma.gov/departments/town-manager/town-manager-s-annual-budget-financial-report).

<div id="csvtable"></div>

<!-- Actually load our charts -->
<script src="/assets/js/test.js"></script>