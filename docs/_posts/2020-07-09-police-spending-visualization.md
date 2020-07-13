---
title: Police Spending In Comparable Towns
excerpt: Comparing police budget and staffing levels with nearby towns.
classes: wide
categories:
  - Finance
tags:
  - Police
  - Budgets
  - Comparable
---

When discussing Police budgets, it's informative to understand how Arlington's budget - and staffing level of officers - compares to other municipalities.

## Police Spending Per Capita

_Approximate_ police budgets per capita and as a %age of total budget for Arlington versus **comparable towns**.  For notes on how budget data is calculated, see the [Comparable Town Budgets](http://arlingtonma.info/finance/comparable-town-budgets/#town-expenses-by-department) note.  This comparison shows both the raw spending in the Schedule A budget for police departments by capita (total residents of a town), and as a percentage of the total town budget.  The green line is Arlington's level.

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

## Police Staffing Per Capita

While not all comparable towns post detailed police staffing numbers, we have gathered _approximate_ staffing levels for most towns.  These are sourced from annual reports or budget documents from either the most reecnt posted year or a year earlier.  Similarly, not all towns use the same exact categories for "patrol officers" versus other officers, so this is not a strict apples-to-apples comparison.  Nonetheless, this is a useful way to compare staffing levels.  The green line is Arlington's number of total police department FTE staff per 1,000 residents. 

<div id="policestaff"></div>

## Data Sources

[Download this data as a CSV spreadsheet](/data/police/police-staffing-levels.csv), or see the specific data sources (page numbers within annual reports or budget documents) in the [policing data catalog](/police).




<!-- Actually load our charts/tables -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
  // Hack: static data for police expenditures per town / per capita
const towns = [
  'Arlington',
  'Belmont',
  'Brookline',
  'Medford',
  'Melrose',
  'Milton',
  'Natick',
  'Needham',
  'North Andover',
  'Reading',
  'Stoneham',
  'Watertown',
  'Winchester'
]
const policePerCapita = [ // Figures rounded
  ['Municipality', 'Police $ Per Capita'],
  ['North Andover', '164'],
  ['Stoneham', '175'],
  ['Melrose', '178'],
  ['Arlington', '180'],
  ['Needham', '211'],
  ['Winchester', '212'],
  ['Natick', '223'],
  ['Reading', '238'],
  ['Medford', '241'],
  ['Milton', '264'],
  ['Belmont', '268'],
  ['Watertown', '271'],
  ['Brookline', '283']
]
const policePercent = [
  ['Municipality', 'Police Budget %'],
  ['Needham', '0.0428'],
  ['Winchester', '0.0441'],
  ['North Andover', '0.0536'],
  ['Arlington', '0.0542'],
  ['Natick', '0.0554'],
  ['Melrose', '0.0573'],
  ['Stoneham', '0.0617'],
  ['Brookline', '0.0623'],
  ['Reading', '0.0627'],
  ['Belmont', '0.0717'],
  ['Watertown', '0.0746'],
  ['Milton', '0.0786'],
  ['Medford', '0.0870']
]
c3.generate({
  bindto: '#ppercapita',
  data: {
    x: 'Municipality',
    rows: policePerCapita,
    type: 'bar',
    colors: {
      Arlington: '#008000'
    },
    labels: {
      format: {
        'Police $ Per Capita': d3.format('$')
      }
    }
  },
  grid: {
    y: {
      lines: [
        {
          value: 180,
          class: 'gridGreen',
          text: ''
        }
      ]
    }
  },
  axis: {
    rotated: true,
    x: {
      type: 'category',
      categories: towns,
      tick: {
        centered: true
      }
    },
    y: {
      show: false
    }
  }
})
c3.generate({
  bindto: '#ppercent',
  data: {
    x: 'Municipality',
    rows: policePercent,
    type: 'bar',
    labels: {
      format: {
        'Police Budget %': d3.format('.2%')
      }
    }
  },
  grid: {
    y: {
      lines: [
        {
          value: 0.0542,
          class: 'gridGreen',
          text: ''
        }
      ]
    }
  },
  axis: {
    rotated: true,
    x: {
      type: 'category',
      categories: towns,
      tick: {
        centered: true
      }
    },
    y: {
      show: false,
      label: {
        text: '% of Total Expense'
      }
    }
  }
})
const policeStaff = [
  {
    Town: 'Watertown',
    Chief: 1,
    'Captains or superintendents': 2,
    Lieutenants: 5,
    Sergeants: 6,
    'Patrol officers': 26,
    'Total Sworn': 40,
    Other: 7,
    Dispatch: 9,
    'Total Civilian': 16,
    'Total All': 56,
    Population: 35939,
    'All Police Staff per 1000 residents': 1.56,
    'Patrol officers per 1000 residents': 0.72
  },
  {
    Town: 'Melrose',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 4,
    Sergeants: 8,
    'Patrol officers': 30,
    'Total Sworn': 43,
    Other: 4,
    Dispatch: '',
    'Total Civilian': 4,
    'Total All': 47,
    Population: 28016,
    'All Police Staff per 1000 residents': 1.68,
    'Patrol officers per 1000 residents': 1.07
  },
  {
    Town: 'North Andover',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 2,
    Sergeants: 8,
    'Patrol officers': 29,
    'Total Sworn': 40,
    Other: 4,
    Dispatch: 9,
    'Total Civilian': 13,
    'Total All': 53,
    Population: 31188,
    'All Police Staff per 1000 residents': 1.7,
    'Patrol officers per 1000 residents': 0.93
  },
  {
    Town: 'Arlington',
    Chief: 1,
    'Captains or superintendents': 3,
    Lieutenants: 6,
    Sergeants: 9,
    'Patrol officers': 50,
    'Total Sworn': 69,
    Other: 6.7,
    Dispatch: 10,
    'Total Civilian': 16.7,
    'Total All': 85.7,
    Population: 45531,
    'All Police Staff per 1000 residents': 1.88,
    'Patrol officers per 1000 residents': 1.1
  },
  {
    Town: 'Natick',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 4,
    Sergeants: 10,
    'Patrol officers': 40,
    'Total Sworn': 55,
    Other: 9,
    Dispatch: 10,
    'Total Civilian': 19,
    'Total All': 74,
    Population: 36050,
    'All Police Staff per 1000 residents': 2.05,
    'Patrol officers per 1000 residents': 1.11
  },
  {
    Town: 'Needham',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 4,
    Sergeants: 7,
    'Patrol officers': 35,
    'Total Sworn': 47,
    Other: 13,
    Dispatch: 5,
    'Total Civilian': 18,
    'Total All': 65,
    Population: 31388,
    'All Police Staff per 1000 residents': 2.07,
    'Patrol officers per 1000 residents': 1.12
  },
  {
    Town: 'Medford',
    Chief: 1,
    'Captains or superintendents': 3,
    Lieutenants: 9,
    Sergeants: 16,
    'Patrol officers': 73,
    'Total Sworn': 0,
    Other: 7,
    Dispatch: 12,
    'Total Civilian': 102,
    'Total All': 121,
    Population: 57341,
    'All Police Staff per 1000 residents': 2.11,
    'Patrol officers per 1000 residents': 1.27
  },
  {
    Town: 'Stoneham',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 2,
    Sergeants: 7,
    'Patrol officers': 30,
    'Total Sworn': 40,
    Other: 7.8,
    Dispatch: 6,
    'Total Civilian': 13.8,
    'Total All': 53.8,
    Population: 24126,
    'All Police Staff per 1000 residents': 2.23,
    'Patrol officers per 1000 residents': 1.24
  },
  {
    Town: 'Reading',
    Chief: 1,
    'Captains or superintendents': 1,
    Lieutenants: 4,
    Sergeants: 7,
    'Patrol officers': 31,
    'Total Sworn': 44,
    Other: 3,
    Dispatch: 11,
    'Total Civilian': 14,
    'Total All': 58,
    Population: 25400,
    'All Police Staff per 1000 residents': 2.28,
    'Patrol officers per 1000 residents': 1.22
  },
  {
    Town: 'Belmont',
    Chief: 1,
    'Captains or superintendents': 1,
    Lieutenants: 4,
    Sergeants: 10,
    'Patrol officers': 31,
    'Total Sworn': 47,
    Other: 4,
    Dispatch: 10,
    'Total Civilian': 14,
    'Total All': 61,
    Population: 26116,
    'All Police Staff per 1000 residents': 2.34,
    'Patrol officers per 1000 residents': 1.19
  },
  {
    Town: 'Brookline',
    Chief: 1,
    'Captains or superintendents': 5,
    Lieutenants: 11,
    Sergeants: 16,
    'Patrol officers': 106,
    'Total Sworn': 139,
    Other: 31.7,
    Dispatch: 15,
    'Total Civilian': 46.7,
    'Total All': 185.7,
    Population: 59121,
    'All Police Staff per 1000 residents': 3.14,
    'Patrol officers per 1000 residents': 1.79
  },
  {
    Town: 'Winchester',
    Chief: 1,
    'Captains or superintendents': 0,
    Lieutenants: 12,
    Sergeants: 0,
    'Patrol officers': 27,
    'Total Sworn': 40,
    Other: 31.5,
    Dispatch: 8,
    'Total Civilian': 39.5,
    'Total All': 79.5,
    Population: 22799,
    'All Police Staff per 1000 residents': 3.49,
    'Patrol officers per 1000 residents': 1.18
  }
]
// Multi bar chart for staffing levels
c3.generate({
  bindto: '#policestaff',
  data: {
    x: 'Municipality',
    json: policeStaff,
    type: 'bar',
    keys: {
      x: 'Town', // it's possible to specify 'x' when category axis
      value: ['All Police Staff per 1000 residents', 'Patrol officers per 1000 residents']
    }
  },
  grid: {
  y: {
    lines: [
      {
        value: 1.88,
        class: 'gridGreen',
        text: ''
      }
    ]
  }
},
 axis: {
    rotated: true,
    x: {
      type: 'category',
      categories: towns,
      tick: {
        centered: true
      }
    },
    y: {
      show: true
    }
  }
})
</script>