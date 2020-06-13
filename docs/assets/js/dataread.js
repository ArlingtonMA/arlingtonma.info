// Various utilities for reading common data fields

function addDonutChart (id, data, title, width, colorHash) {
  var chart = c3.generate({
    bindto: id,
    data: {
      columns: data,
      type: 'donut',
      colors: colorHash
    },
    donut: {
      title: title
    },
    size: {
      width: width
    },
    legend: {
      position: 'right'
    }
  })
  return chart
}

function addCSVTable (id, csvfile, headerArr) {
  d3.csv(csvfile)
    .then(function (data) {
      return d3table(id, data, headerArr)
    })
    .catch(function (error) {
      console.log('Sorry, no can do: ' + error)
    })
}

function d3table (div, data, columns) {
  var table = d3.select(div).append('table')
  var thead = table.append('thead')
  thead.append('tr')
    .selectAll('th')
    .data(columns)
    .enter()
    .append('th')
    .text(function (column) { return column })
  var rows = table.append('tbody').selectAll('tr')
    .data(data)
    .enter()
    .append('tr')
  rows.selectAll('td')
    .data(function (row) {
      return columns.map(function (column) {
        return { column: column, value: row[column] }
      })
    })
    .enter()
    .append('td')
    .text(function (d) { return d.value })
  return table
}
