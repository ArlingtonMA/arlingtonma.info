/**
 * Prototype code for using C3 to make simple charts
 * Since this is an early prototype, I'm just hardcoding a lot of the data here
 */
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

// Build our page (obviously, this is just a concept; should all be data-driven)
addDonutChart('#arlington',
  [
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
  ], 'Expenses (2019)', 400, expenseColors)
addDonutChart('#belmont',
  [
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
  ], 'Expenses (2019)', 400, expenseColors)
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
], 'Expenses (2019)', 400, expenseColors)
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
], 'Expenses (2019)', 400, expenseColors)
console.log('TESTING: charts done, building table')
// addCSVTable returns a Promise from the underlying d3.csv function...
const csvpromise = addCSVTable('#csvtable', '/data/finance/GenFundExpenditures2019-comps.csv', expenseHeaders)
// ... which we can ask to wait for, and .then we will get called once it's done ...
csvpromise.then(function (x) {
  console.log('TESTING: How to get the underlying array from the CSV read above into local data - from the Promise!')
  console.log(JSON.stringify(x))
})
// ... but our script execution will continue while d3.csv loads in the background
console.log('TESTING: execution continues after promises')

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

// Combo bar and line chart (but missing extra y axis)
// c3.generate({
//   bindto: '#pchart',
//   data: {
//     x: 'Municipality',
//     rows: policeComps,
//     type: 'bar',
//     types: {
//       'Police Budget %': 'line'
//     },
//     labels: {
//       format: {
//         'Police $ Per Capita': d3.format('$'),
//         'Police Budget %': d3.format('.2%')
//       }
//     },
//     axes: {
//       'Police $ Per Capita': 'y',
//       'Police Budget %': 'y2'
//     }

//   },
//   axis: {
//     x: {
//       type: 'category',
//       categories: towns,
//       tick: {
//         centered: true
//       }
//     },
//     y: {
//       label: {
//         text: '$ Per capita',
//         position: 'outer-middle'
//       }
//     },
//     y2: {
//       label: {
//         text: '%age of budget',
//         position: 'outer-middle'
//       }
//     }
//   }
// })

const policeStaff = [ // NOTE: Data not fully sourced yet
  {
    Town: 'Milton',
    Chief: 0,
    'Captains or superintendents': 0,
    Lieutenants: 0,
    Sergeants: 0,
    'Patrol officers': 0,
    'Total Sworn': 0,
    Other: 0,
    Dispatch: 0,
    'Total Civilian': 0,
    'Total All': 0,
    Population: 27593,
    'All Police Staff per 1000 residents': 0,
    'Patrol officers per 1000 residents': 0
  },
  {
    Town: 'Medford',
    Chief: 0,
    'Captains or superintendents': 0,
    Lieutenants: 0,
    Sergeants: 0,
    'Patrol officers': 0,
    'Total Sworn': 0,
    Other: 0,
    Dispatch: 0,
    'Total Civilian': 0,
    'Total All': 0,
    Population: 57341,
    'All Police Staff per 1000 residents': 0,
    'Patrol officers per 1000 residents': 0
  },
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
