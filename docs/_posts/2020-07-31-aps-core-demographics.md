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

## APS Staff And Student Demographics

Using the most recent ESE data for 2019 we can show the disparity in relative percentages of different racial/ethnic categores between the diverse student population and relatively less-diverse staff population here in Arlngton Public Schools (APS).  

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Students By Race/Ethnicity - 2019</h3>
    <div id="arl-students-2019"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Staffing By Race/Ethnicity - 2019</h3>
    <div id="arl-staff-2019"></div>
  </div>
</figure>

<figure class="half">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Students By Race/Ethnicity 2013-2019</h3>
    <div id="arl-students-hist"></div>
  </div>
  <div class='chartfigure'>
    <h3 style='text-align: center;'>APS Staffing By Race/Ethnicity 2013-2019</h3>
    <div id="arl-staff-hist"></div>
  </div>
  <figcaption>Over the 6 years of available data for APS demographics, the change of percentage of non-white students has increased slightly, while the percentages of white staff remain high.</figcaption>
</figure>

## Data Sources

See our [Education data catalog](/catalog#datasets-about-schools) for sources derived from MA ESE data.  Race/Ethnicity names have been normalized to use full versions from the Staffing data.  MA ESE data includes male/female breakdowns for staff and students, as well as other categories for student populations including English Learner, Economically disadvantaged, Students w/disabilities, and High needs.


<!-- Load d3/c3 tools and our visualizations -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
// Reformat /data/education/MADOE-StaffingData.csv and MADOE-StudentDiscipline.csv to make charts simpler
// Headers to output in order (sort descending by APS Student population)
// Ensure colors are identical across charts
const colors = {
  'White': 'red',
  'Asian': 'orange',
  'Multi-Race, Non-Hispanic': 'yellow',
  'Hispanic/Latino': 'green',
  'African American': 'blue',
  'Native Hawaiian, Pacific Islander': 'indigo',
  'Native American': 'violet'
}
const donutTitle = 'Demographics (2019)'
// Build current donut charts
addDonutChart('#arl-students-2019', [
    ['White', '70.44'],
    ['Asian', '13.21'],
    ['Multi-Race, Non-Hispanic', '6.33'],
    ['Hispanic/Latino', '6.28'],
    ['African American', '3.54'],
    ['Native Hawaiian, Pacific Islander', '0.13'],
    ['Native American', '0.07']
  ], donutTitle, colors)
addDonutChart('#arl-staff-2019', [
    ['White', '92.17'],
    ['Asian', '2.24'],
    ['Multi-Race, Non-Hispanic', '1.17'],
    ['Hispanic/Latino', '2.60'],
    ['African American', '1.69'],
    ['Native Hawaiian, Pacific Islander', '0.13'],
    ['Native American', '0.00']
  ], donutTitle, colors)

// Build historical timeseries charts
const yopts = {
  max: 1,
  min: 0.50, // Make differences more obvious
  padding: { 
    top: 0, 
    bottom: 0 
  },
  tick: {
    format: d3.format('.0000%')
  }
}
addTimeseriesPercentChart('#arl-students-hist', [
    // Arbitrarily use end of school year, since c3.js doesn't like plain years as timeseries data
    ['Date', '2019-06-30', '2018-06-30', '2017-06-30', '2016-06-30', '2015-06-30', '2014-06-30', '2013-06-30'],
    ['White', '0.7044', '0.7111', '0.725', '0.7373', '0.7398', '0.7568', '0.7629'],
    ['Asian', '0.1321', '0.128', '0.127', '0.1183', '0.1165', '0.1107', '0.11'],
    ['Multi-Race, Non-Hispanic', '0.0633', '0.0534', '0.0436', '0.0462', '0.0452', '0.0403', '0.0383'],
    ['Hispanic/Latino', '0.0628', '0.0665', '0.0634', '0.0575', '0.0579', '0.0529', '0.0531'],
    ['African American', '0.0354', '0.0386', '0.0384', '0.038', '0.0384', '0.0374', '0.0341'],
    ['Native Hawaiian, Pacific Islander', '0.0013', '0.0017', '0.0019', '0.002', '0.0015', '0.0016', '0.0012'],
    ['Native American', '0.0007', '0.0007', '0.0007', '0.0007', '0.0007', '0.0004', '0.0004']
  ], yopts, colors)

addTimeseriesPercentChart('#arl-staff-hist', [
    ['Date', '2019-06-30', '2018-06-30', '2017-06-30', '2016-06-30', '2015-06-30', '2014-06-30', '2013-06-30'],
    ['White', '0.9217', '0.9344', '0.9013', '0.9141', '0.93', '0.9243', '0.9422'],
    ['Asian', '0.0224', '0.0201', '0.0219', '0.0179', '0.0173', '0.0187', '0.0166'],
    ['Multi-Race, Non-Hispanic', '0.0117', '0.0088', '0.0091', '0.0015', '0', '0', '0'],
    ['Hispanic/Latino', '0.026', '0.0204', '0.0536', '0.0473', '0.0124', '0.0118', '0.006'],
    ['African American', '0.0169', '0.0149', '0.0127', '0.0177', '0.0209', '0.0192', '0.0126'],
    ['Native Hawaiian, Pacific Islander', '0.0013', '0.0014', '0.0014', '0.0015', '0.0193', '0.026', '0.0212'],
    ['Native American', '0', '0', '0', '0', '0', '0', '0.0016']
  ], yopts, colors)
</script>