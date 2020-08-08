---
title: APS Demographics By Grade
excerpt: Racial/Ethnic demographics of Arlington and APS student populations by grade. 
classes: wide
categories:
  - Education
tags:
  - Race
---

The [Massachusetts Department of Elementary and Secondary Education](https://www.doe.mass.edu/) (ESE) tracks a wide variety of data about school policies, populations, and performance.  The data includes racial and ethnic demographics broken down per grade from Pre-K thru 12th grade within a public school district.

## APS Student Demographics By Grade

Using the most recent ESE data for student populations by grade level in 2019 shows likely trends changing the racial and ethnic makeup of the student body in future enrollments as younger classes graduate and move up each year.  

<figure>
  <div id="studentsbygrade"></div>
  <figcaption></figcaption>
</figure>

## Data Sources

Data from [MA ESE Student Population by Grade](/education/#Student%20population%20by%20Grade), see also the [Education data catalog](/catalog#datasets-about-schools) for other sources derived from MA ESE data.  Race/Ethnicity names have been normalized to use full versions from the Staffing data.  MA ESE data includes male/female breakdowns for staff and students, as well as other categories for student populations including English Learner, Economically disadvantaged, Students w/disabilities, and High needs.  Read the [FAQ on MA ESE racial and ethnic classifications](http://www.doe.mass.edu/infoservices/data/guides/race-faq.html).


<!-- Load d3/c3 tools and our visualizations -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
// Headers to output in order (sort descending by APS Student population for Grade 12)
// Ensure colors are identical across charts
const colors = {
  Enrollment: 'black',
  White: 'red',
  Asian: 'orange',
  'Multi-Race, Non-Hispanic': 'yellow',
  'Hispanic/Latino': 'green',
  'African American': 'blue',
  'Native Hawaiian, Pacific Islander': 'indigo',
  'Native American': 'violet'
}
const demographics = [
  'White',
  'Asian',
  'Multi-Race, Non-Hispanic',
  'Hispanic/Latino',
  'African American',
  'Native Hawaiian, Pacific Islander',
  'Native American'
]
const studentsbygrade = [
  {
    Grade: 'PK',
    Enrollment: 89,
    White: '57.30',
    Asian: '22.47',
    'Hispanic/Latino': '3.37',
    'African American': '4.49',
    'Multi-Race, Non-Hispanic': '12.36',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'K',
    Enrollment: 524,
    White: '62.98',
    Asian: '15.84',
    'Hispanic/Latino': '5.92',
    'African American': '2.29',
    'Multi-Race, Non-Hispanic': '12.79',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.19'
  },
  {
    Grade: 'Gr.1',
    Enrollment: 594,
    White: '65.49',
    Asian: '15.15',
    'Hispanic/Latino': '6.57',
    'African American': '2.53',
    'Multi-Race, Non-Hispanic': '10.27',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.2',
    Enrollment: 517,
    White: '69.83',
    Asian: '12.96',
    'Hispanic/Latino': '4.64',
    'African American': '2.90',
    'Multi-Race, Non-Hispanic': '9.67',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.3',
    Enrollment: 533,
    White: '70.36',
    Asian: '19.51',
    'Hispanic/Latino': '5.25',
    'African American': '2.81',
    'Multi-Race, Non-Hispanic': '1.88',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.19'
  },
  {
    Grade: 'Gr.4',
    Enrollment: 487,
    White: '71.87',
    Asian: '13.35',
    'Hispanic/Latino': '4.93',
    'African American': '3.49',
    'Multi-Race, Non-Hispanic': '5.95',
    'Native Hawaiian, Pacific Islander': '0.41',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.5',
    Enrollment: 507,
    White: '69.03',
    Asian: '13.02',
    'Hispanic/Latino': '6.31',
    'African American': '4.14',
    'Multi-Race, Non-Hispanic': '6.90',
    'Native Hawaiian, Pacific Islander': '0.20',
    'Native American': '0.39'
  },
  {
    Grade: 'Gr.6',
    Enrollment: 486,
    White: '73.25',
    Asian: '8.23',
    'Hispanic/Latino': '8.23',
    'African American': '4.12',
    'Multi-Race, Non-Hispanic': '6.17',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.7',
    Enrollment: 455,
    White: '70.55',
    Asian: '11.65',
    'Hispanic/Latino': '7.25',
    'African American': '3.30',
    'Multi-Race, Non-Hispanic': '6.81',
    'Native Hawaiian, Pacific Islander': '0.22',
    'Native American': '0.22'
  },
  {
    Grade: 'Gr.8',
    Enrollment: 444,
    White: '73.87',
    Asian: '11.49',
    'Hispanic/Latino': '6.98',
    'African American': '2.70',
    'Multi-Race, Non-Hispanic': '4.73',
    'Native Hawaiian, Pacific Islander': '0.23',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.9',
    Enrollment: 368,
    White: '73.91',
    Asian: '9.78',
    'Hispanic/Latino': '5.43',
    'African American': '4.62',
    'Multi-Race, Non-Hispanic': '6.25',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.10',
    Enrollment: 364,
    White: '73.90',
    Asian: '10.44',
    'Hispanic/Latino': '5.22',
    'African American': '4.40',
    'Multi-Race, Non-Hispanic': '6.04',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.11',
    Enrollment: 342,
    White: '73.68',
    Asian: '11.99',
    'Hispanic/Latino': '6.73',
    'African American': '3.22',
    'Multi-Race, Non-Hispanic': '4.39',
    'Native Hawaiian, Pacific Islander': '0.00',
    'Native American': '0.00'
  },
  {
    Grade: 'Gr.12',
    Enrollment: 337,
    White: '77.15',
    Asian: '9.79',
    'Hispanic/Latino': '6.53',
    'African American': '3.86',
    'Multi-Race, Non-Hispanic': '2.37',
    'Native Hawaiian, Pacific Islander': '0.30',
    'Native American': '0.00'
  }
]

c3.generate({
  bindto: '#studentsbygrade',
  data: {
    x: 'Grade',
    type: 'bar',
    json: studentsbygrade,
    groups: [demographics],
    colors: colors,
    order: null,
    keys: {
      x: 'Grade', // it's possible to specify 'x' when category axis
      value: demographics.concat('Enrollment')
    },
    axes: {
      Enrollment: 'y2'
    },
    types: {
      Enrollment: 'line'
    }
  },
  grid: {
    y: {
      max: 1,
      padding: {
        top: 0,
        bottom: 0
      },
      tick: {
        format: d3.format('.0000')
      }
    }
  },
  axis: {
    x: {
      type: 'category',
      categories: demographics,
      tick: {
        centered: true
      }
    },
    y: {
      show: true,
      max: 100,
      label: {
        text: 'Percent of population',
        position: 'outer-middle'
      }
    },
    y2: {
      show: true,
      max: 700,
      label: {
        text: 'Enrollment per grade',
        position: 'outer-middle'
      }
    }
  }
})
</script>