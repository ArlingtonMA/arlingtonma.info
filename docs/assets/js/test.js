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
