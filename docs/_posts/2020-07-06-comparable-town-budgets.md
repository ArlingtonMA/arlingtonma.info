---
title: Comparable Town Expenses By Department
excerpt: Town Budgets as a percentage of total budget for comparable towns. 
classes: wide
categories:
  - Finance
tags:
  - Budgets
  - Comparable
---

The [Massachusetts Division of Local Services](https://www.mass.gov/orgs/division-of-local-services) (DLS) provides a variety of data about Massachusetts municipalities, along with other financial visualizations and tools for local governments to use.

One useful comparison is where towns and cities spend their budget, especially when looking at roughly comparable municipalities.  **Comparable towns** to Arlington (Belmont, Brookline, Medford, Melrose, Milton, Natick, Needham, North Andover, Reading, Stoneham, Watertown, Winchester) are defined in the [Town Manager's Annual Reports](https://www.arlingtonma.gov/departments/town-manager/town-manager-s-annual-budget-financial-report).  See also a [listing of comparable towns websites](https://menotomymatters.com/comparable/) - with school, police, budget, and more links about each town or city.

## Town Expenses By Department

This data is drawn from the DLS' Schedule A figures, which all towns report to the state annually, breaking down expenditures and revenues in broad categories.  Note that this is not a completely accurate comparison, because there are some minor expenses that different towns may book under different categories.  For example, depending on the town, costs for Crossing Guards may be in the Education budget, or may be in the Police budget category.  Similarly, various insurance costs for town employees are sometimes included in a general budget, vs. in departmental budgets.  Nonetheless, it's can still be useful to consider overall comparisons across a towns.

### Where Arlington's Budget Goes By Department

<div class='chartfigure'>
  <div id="arlington"></div>
</div>

For a more in depth look, see [Arlington Visual Budget](http://arlingtonvisualbudget.org/).

### Where Comparable Town Budgets Go By Department

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Belmont - 2019 Expenses By Dept.</h3>
    <div id="belmont"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Brookline - 2019 Expenses By Dept.</h3>
    <div id="brookline"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Melrose - 2019 Expenses By Dept.</h3>
    <div id="melrose"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Medford - 2019 Expenses By Dept.</h3>
    <div id="medford"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Milton - 2019 Expenses By Dept.</h3>
    <div id="milton"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Natick - 2019 Expenses By Dept.</h3>
    <div id="natick"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Needham - 2019 Expenses By Dept.</h3>
    <div id="needham"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>North Andover - 2019 Expenses By Dept.</h3>
    <div id="northandover"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Reading - 2019 Expenses By Dept.</h3>
    <div id="reading"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Stoneham - 2019 Expenses By Dept.</h3>
    <div id="stoneham"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Watertown - 2019 Expenses By Dept.</h3>
    <div id="watertown"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Winchester - 2019 Expenses By Dept.</h3>
    <div id="winchester"></div>
  </div>
</figure>

## Data Sources

[Download this data as a CSV spreadsheet](/data/finance/GenFundExpenditures2019-comps.csv), or find the [original source data on mass.gov](https://dlsgateway.dor.state.ma.us/reports/rdPage.aspx?rdReport=ScheduleA.GenFund_MAIN) as reported using standard classifications [from the MA Department of Revenue](https://www.mass.gov/orgs/division-of-local-services).  Or simply view the spreadsheet here!

<div id="csvtable"></div>

<!-- Load d3/c3 tools and our visualizations -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
  // Reformat /data/finance/GenFundExpenditures2019-comps.csv to make charts simpler
  // Headers to output in order (sort descending by Amount for Arlington's own expenses)
  const expenseHeaders = [
    'Municipality',
    'Education',
    'Fixed Costs',
    'Debt Service',
    'Public Works',
    'Police',
    'Fire',
    'General Government',
    'Culture and Recreation',
    'Intergovernmental Assessments',
    'Human Services',
    'Other Public Safety'
  ]
  // Ensure colors for all towns are identical
  const expenseColors = {
    'General Government': 'tan',
    Education: 'chocolate',
    'Public Works': 'olivedrab',
    Police: 'indigo',
    Fire: 'magenta',
    'Other Public Safety': 'plum',
    'Human Services': 'yellowgreen',
    'Culture and Recreation': 'forestgreen',
    'Fixed Costs': 'slategray',
    'Debt Service': 'lightgray',
    'Intergovernmental Assessments': 'gray',
    'Other Expenditures': 'darkgray'
  }
  const donutTitle = 'Expenses (2019)'
  const donutSize = 400
  // Build our page TODO: draw directly from csv instead of hardcoding
  addDonutChart('#arlington', [
      ['Education', '65792139'],
      ['Fixed Costs', '28816899'],
      ['Debt Service', '16582686'],
      ['Public Works', '9077803'],
      ['Police', '8191760'],
      ['Fire', '7565639'],
      ['General Government', '6136498'],
      ['Culture and Recreation', '3894551'],
      ['Intergovernmental Assessments', '3272899'],
      ['Human Services', '1218442'],
      ['Other Public Safety', '503117'],
      ['Other Expenditures', '33028']
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#belmont', [
      ['Education', '50138431'],
      ['Fixed Costs', '8547462'],
      ['Debt Service', '4655051'],
      ['Public Works', '6324537'],
      ['Police', '7006411'],
      ['Fire', '5623612'],
      ['General Government', '8923717'],
      ['Culture and Recreation', '3254686'],
      ['Intergovernmental Assessments', '1836276'],
      ['Human Services', '828031'],
      ['Other Public Safety', '550924'],
      ['Other Expenditures', '19900']
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#brookline', [
      ['Education', '116389275'],
      ['Fixed Costs', '59972119'],
      ['Debt Service', '15631274'],
      ['Public Works', '13321964'],
      ['Police', '16738310'],
      ['Fire', '15771245'],
      ['General Government', '12444751'],
      ['Culture and Recreation', '7353301'],
      ['Intergovernmental Assessments', '6656579'],
      ['Human Services', '2318926'],
      ['Other Public Safety', '2074485'],
      ['Other Expenditures', '0'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#medford', [
    ['Education', '58680558'],
    ['Fixed Costs', '32798178'],
    ['Debt Service', '6722970'],
    ['Public Works', '12870245'],
    ['Police', '13791821'],
    ['Fire', '13498506'],
    ['General Government', '4584312'],
    ['Culture and Recreation', '2721043'],
    ['Intergovernmental Assessments', '10286228'],
    ['Human Services', '1293611'],
    ['Other Public Safety', '1301949']
  ], donutTitle, donutSize, expenseColors)
  addDonutChart('#melrose', [
      ['Education', '32463997'],
      ['Fixed Costs', '18331091'],
      ['Debt Service', '5696883'],
      ['Public Works', '9072056'],
      ['Police', '4978150'],
      ['Fire', '4560380'],
      ['General Government', '3718827'],
      ['Culture and Recreation', '1621639'],
      ['Intergovernmental Assessments', '3631893'],
      ['Human Services', '1470738'],
      ['Other Public Safety', '343880'],
      ['Other Expenditures', '989830'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#milton', [
      ['Education', '50551792'],
      ['Fixed Costs', '8503732'],
      ['Debt Service', '3969189'],
      ['Public Works', '5045146'],
      ['Police', '7274406'],
      ['Fire', '5657134'],
      ['General Government', '4462729'],
      ['Culture and Recreation', '2003642'],
      ['Intergovernmental Assessments', '3876553'],
      ['Human Services', '573038'],
      ['Other Public Safety', '614154'],
      ['Other Expenditures', '0'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#natick', [
      ['Education', '67522977'],
      ['Fixed Costs', '25053777'],
      ['Debt Service', '9386226'],
      ['Public Works', '7273669'],
      ['Police', '8052329'],
      ['Fire', '9398580'],
      ['General Government', '12100299'],
      ['Culture and Recreation', '3033627'],
      ['Intergovernmental Assessments', '1507563'],
      ['Human Services', '1884459'],
      ['Other Public Safety', '174946'],
      ['Other Expenditures', '0'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#needham', [
      ['Education', '78619687'],
      ['Fixed Costs', '29149912'],
      ['Debt Service', '9996903'],
      ['Public Works', '5486429'],
      ['Police', '6630729'],
      ['Fire', '8053946'],
      ['General Government', '8315446'],
      ['Culture and Recreation', '2485696'],
      ['Intergovernmental Assessments', '1389486'],
      ['Human Services', '1747253'],
      ['Other Public Safety', '2386779'],
      ['Other Expenditures', '556798'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#northandover', [
      ['Education', '49857184'],
      ['Fixed Costs', '15783342'],
      ['Debt Service', '5325697'],
      ['Public Works', '5517037'],
      ['Police', '5105693'],
      ['Fire', '5041999'],
      ['General Government', '4568242'],
      ['Culture and Recreation', '1077111'],
      ['Intergovernmental Assessments', '606945'],
      ['Human Services', '1198761'],
      ['Other Public Safety', '351341'],
      ['Other Expenditures', '852765'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#reading', [
      ['Education', '47701011'],
      ['Fixed Costs', '17401913'],
      ['Debt Service', '4478865'],
      ['Public Works', '5481588'],
      ['Police', '6041337'],
      ['Fire', '5238394'],
      ['General Government', '6016699'],
      ['Culture and Recreation', '2481219'],
      ['Intergovernmental Assessments', '759218'],
      ['Human Services', '606862'],
      ['Other Public Safety', '186104'],
      ['Other Expenditures', '26182'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#stoneham', [
      ['Education', '30354467'],
      ['Fixed Costs', '15735022'],
      ['Debt Service', '4488541'],
      ['Public Works', '2671179'],
      ['Police', '4223967'],
      ['Fire', '3380322'],
      ['General Government', '2728209'],
      ['Culture and Recreation', '1472984'],
      ['Intergovernmental Assessments', '1814909'],
      ['Human Services', '597535'],
      ['Other Public Safety', '789081'],
      ['Other Expenditures', '195387'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#watertown', [
      ['Education', '48695534'],
      ['Fixed Costs', '33033733'],
      ['Debt Service', '6168042'],
      ['Public Works', '9482053'],
      ['Police', '9724629'],
      ['Fire', '10415738'],
      ['General Government', '5233875'],
      ['Culture and Recreation', '3638681'],
      ['Intergovernmental Assessments', '2661170'],
      ['Human Services', '1345444'],
      ['Other Public Safety', '23855'],
      ['Other Expenditures', '4100'],
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#winchester', [
    ['Education', '49974412'],
    ['Fixed Costs', '17500519'],
    ['Debt Service', '12993748'],
    ['Public Works', '8452015'],
    ['Police', '4827686'],
    ['Fire', '4551327'],
    ['General Government', '7798467'],
    ['Culture and Recreation', '1959049'],
    ['Intergovernmental Assessments', '573680'],
    ['Human Services', '647889'],
    ['Other Public Safety', '274465']
  ], donutTitle, donutSize, expenseColors)
  const csvpromise = addCSVTable('#csvtable', '/data/finance/GenFundExpenditures2019-comps.csv', expenseHeaders)
</script>