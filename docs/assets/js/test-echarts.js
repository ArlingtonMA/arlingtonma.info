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

var arlington = echarts.init(document.getElementById('arlington'))
// use configuration item and data specified to show chart
arlington.setOption(
  {
    title: {
      text: 'Town Expenses By Department'
    },
    legend: {
      data: ['Expenses (2019)']
    },
    series: [
      {
        name: 'Expenses1',
        type: 'pie',
        // roseType: 'angle', // Works better with less extreme data
        radius: '70%',
        data: [
          { name: 'Education', value: '65792139' },
          { name: 'Fixed Costs', value: '28816899' },
          { name: 'Debt Service', value: '16582686' },
          { name: 'Public Works', value: '9077803' },
          { name: 'Police', value: '8191760' },
          { name: 'Fire', value: '7565639' },
          { name: 'General Government', value: '6136498' },
          { name: 'Culture and Recreation', value: '3894551' },
          { name: 'Intergovernmental Assessments', value: '3272899' },
          { name: 'Human Services', value: '1218442' },
          { name: 'Other Public Safety', value: '503117' },
          { name: 'Other Expenditures', value: '33028' }
        ]
      }
    ]

  }
)

console.log('TESTING: charts done...')
