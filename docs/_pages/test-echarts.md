---
permalink: /test-echarts/
title: Comparable Town Expenses By Department (prototype using eCharts)
classes: wide
---

<!-- Load eCharts resources - another charting library TODO: move to header -->
<script src="/assets/js/echarts.min.js"></script>

## Town Expenses By Department (eCharts version)

A comparison of annual (2019) expenses by department between Arlington and selected local towns.  We should update this page to better allow people to compare to different local comparable towns as defined in the annual report.  Note that the data for department spending in these charts may differ subtly between towns (by small amounts, proportionally) due to how different towns classify expenses per department in their top-level reporting to the state.

For example, depending on the town, costs for Crossing Guards may be in the Education budget, or another public safety budget category.

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Arlington - 2019 Expenses By Dept.</h3>
    <div id="arlington" style="width: 600px;height:400px;"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>TBD - 2019 Expenses By Dept.</h3>
    <div id="belmont"></div>
  </div>
  <figcaption>Arlington vs. Other Towns</figcaption>
</figure>


<!-- Actually load our charts/tables -->
<script src="/assets/js/test-echarts.js"></script>