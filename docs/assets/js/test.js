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
addCSVTable('#csvtable', '/data/finance/GenFundExpenditures2019-comps.csv', expenseHeaders)
