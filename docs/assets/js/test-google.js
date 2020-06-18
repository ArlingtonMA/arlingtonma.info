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
const arlingtonPie = [
  ['Education', 65792139],
  ['Fixed Costs', 28816899],
  ['Debt Service', 16582686],
  ['Public Works', 9077803],
  ['Police', 8191760],
  ['Fire', 7565639],
  ['General Government', 6136498],
  ['Culture and Recreation', 3894551],
  ['Intergovernmental Assessments', 3272899],
  ['Human Services', 1218442],
  ['Other Public Safety', 503117],
  ['Other Expenditures', 33028]
]
const belmontPie = [
  ['Education', 50138431],
  ['Fixed Costs', 8547462],
  ['Debt Service', 4655051],
  ['Public Works', 6324537],
  ['Police', 7006411],
  ['Fire', 5623612],
  ['General Government', 8923717],
  ['Culture and Recreation', 3254686],
  ['Intergovernmental Assessments', 1836276],
  ['Human Services', 828031],
  ['Other Public Safety', 550924],
  ['Other Expenditures', 19900]
]
// Load Google Charts and set callback
google.charts.load('current', { packages: ['corechart'] })
google.charts.setOnLoadCallback(drawCharts)

// Callback that creates and populates each of our charts
function drawCharts () {
  c = addPieChart('arlington', arlingtonPie, 'Expenses (2019)', 400, 400) // TODO fix API
  c = addPieChart('belmont', belmontPie, 'Expenses (2019)', 400, 400) // TODO fix API
  console.log('TESTING: charts done, returned belmont chart is:')
  console.log(c)
}

/**
 * Insert a pie chart
 * @param {string} id to insert in
 * @param {string[]} rows to chart [ ['name', '123], ...]
 * @param {string} title to display inside donut
 * @param {number} width to display at
 * @param {hash} colorHash for mapping 'name' to html color
 */
function addPieChart (id, rows, title, width, height) { // TODO fix API
  var data = new google.visualization.DataTable()
  data.addColumn('string', 'Expense') // TODO pass in full data instead of hardcode
  data.addColumn('number', 'Amount')
  data.addRows(rows)
  var options = {
    title: title,
    width: width,
    height: 300
  }
  // Instantiate and draw our chart, passing in some options.
  var chart = new google.visualization.PieChart(document.getElementById(id))
  chart.draw(data, options)
  return chart
}
