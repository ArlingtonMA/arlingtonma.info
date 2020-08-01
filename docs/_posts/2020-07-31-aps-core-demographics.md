---
title: Arlington and APS Racial Demographics
excerpt: Racial demographics of Arlington and APS staff and student populations. 
classes: wide
categories:
  - Education
tags:
  - Race
---

The [Massachusetts Department of Elementary and Secondary Education](https://www.doe.mass.edu/) (ESE) tracks a wide variety of data about school policies, populations, and performance.  This includes some historical data from 5 to 10 years back, and includes data for every public school district in Massachusetts, meaning you can easily make comparisons across time and towns/cities.

One useful comparison is the population breakdown in Arlington Public Schools (APS), both in terms of staff and student populations.


## APS Staff And Student Demographics

This data is drawn from ESE reports for 2019, the most recent year that full staffing and student data is available.

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Students By Race - 2019</h3>
    <div id="arl-students-2019"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Staffing By Race - 2019</h3>
    <div id="arl-staff-2019"></div>
  </div>
</figure>

## Data Sources

See our [Education data catalog](/catalog#datasets-about-schools) for sources (all originally from ESE).

<!-- Load d3/c3 tools and our visualizations -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
  // Reformat /data/education/MADOE-StaffingData.csv and MADOE-StudentDiscipline.csv to make charts simpler
  // Headers to output in order (sort descending by APS Student population)
  const headers = [
    'White',
    'Asian',
    'Multi-Race, Non-Hispanic',
    'Hispanic/Latino',
    'African American',
    'Native Hawaiian, Pacific Islander',
    'Native American'
  ]
  // Ensure colors are identical
  const expenseColors = {
    'White': 'red',
    'Asian': 'orange',
    'Multi-Race, Non-Hispanic': 'yellow',
    'Hispanic/Latino': 'green',
    'African American': 'blue',
    'Native Hawaiian, Pacific Islander': 'indigo',
    'Native American': 'violet'
  }
  const donutTitle = 'Demographics (2019)'
  const donutSize = 400
  // Build our page TODO: draw directly from csv instead of hardcoding
  addDonutChart('#arl-students-2019', [
      ['White', '70.44'],
      ['Asian', '13.21'],
      ['Multi-Race, Non-Hispanic', '6.33'],
      ['Hispanic/Latino', '6.28'],
      ['African American', '3.54'],
      ['Native Hawaiian, Pacific Islander', '0.13'],
      ['Native American', '0.07']
    ], donutTitle, donutSize, expenseColors)
  addDonutChart('#arl-staff-2019', [
      ['White', '92.17'],
      ['Asian', '2.24'],
      ['Multi-Race, Non-Hispanic', '1.17'],
      ['Hispanic/Latino', '2.60'],
      ['African American', '1.69'],
      ['Native Hawaiian, Pacific Islander', '0.13'],
      ['Native American', '0.00']
    ], donutTitle, donutSize, expenseColors)

</script>