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
console.log('DEBUG: charts done, building table')
const csvpromise = addCSVTable('#csvtable', '/data/finance/GenFundExpenditures2019-comps.csv', expenseHeaders)
csvpromise.then(function (x) {
  console.log('TESTING: How to get the underlying array from the CSV read above into local data - from the Promise!')
  console.log(JSON.stringify(x))
})
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
const policeComps = [
  ['Municipality', 'Police $ Per Capita', 'Police Budget %'],
  ['Arlington', '179.92', '0.0542'],
  ['Belmont', '268.28', '0.0717'],
  ['Brookline', '283.12', '0.0623'],
  ['Medford', '240.52', '0.0870'],
  ['Melrose', '177.69', '0.0573'],
  ['Milton', '263.63', '0.0786'],
  ['Natick', '223.37', '0.0554'],
  ['Needham', '211.25', '0.0428'],
  ['North Andover', '163.71', '0.0536'],
  ['Reading', '237.85', '0.0627'],
  ['Stoneham', '175.08', '0.0617'],
  ['Watertown', '270.59', '0.0746'],
  ['Winchester', '211.75', '0.0441']
]
c3.generate({
  bindto: '#pchart',
  data: {
    x: 'Municipality',
    rows: policeComps,
    type: 'bar',
    types: {
      'Police Budget %': 'line'
    },
    labels: {
      format: {
        'Police $ Per Capita': d3.format('$'),
        'Police Budget %': d3.format('.2%')
      }
    },
    axes: {
      'Police $ Per Capita': 'y',
      'Police Budget %': 'y2'
    }

  },
  axis: {
    x: {
      type: 'category',
      categories: towns,
      tick: {
        centered: true
      }
    },
    y: {
      label: {
        text: '$ Per capita',
        position: 'outer-middle'
      }
    },
    y2: {
      label: {
        text: '%age of budget',
        position: 'outer-middle'
      }
    }
  }
})
