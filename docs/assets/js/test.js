// Ensure colors for all towns are identical
var expenseColors = {
  "General Government": "tan",
  "Education": "chocolate",
  "Public Works": "olivedrab",
  "Police": "indigo",
  "Fire": "magenta",
  "Other Public Safety": "plum",
  "Human Services": "yellowgreen",
  "Culture and Recreation": "forestgreen",
  "Fixed Costs": "slategray",
  "Debt Service": "lightgray",
  "Intergovernmental Assessments": "gray",
  "Other Expenditures": "darkgray"
}

// Obviously, these should all be loaded dynamically from our source data; this is just an example
var arlington = [
  ["Education", "65792139"],
  ["Fixed Costs", "28816899"],
  ["Debt Service", "16582686"],
  ["Public Works", "9077803"],
  ["Police", "8191760"],
  ["Fire", "7565639"],
  ["General Government", "6136498"],
  ["Culture and Recreation", "3894551"],
  ["Intergovernmental Assessments", "3272899"],
  ["Human Services", "1218442"],
  ["Other Public Safety", "503117"],
  ["Other Expenditures", "33028"]
]

var belmont = [
  ["Education", "50138431"],
  ["Fixed Costs", "8547462"],
  ["Debt Service", "4655051"],
  ["Public Works", "6324537"],
  ["Police", "7006411"],
  ["Fire", "5623612"],
  ["General Government", "8923717"],
  ["Culture and Recreation", "3254686"],
  ["Intergovernmental Assessments", "1836276"],
  ["Human Services", "828031"],
  ["Other Public Safety", "550924"],
  ["Other Expenditures", "19900"],
]

var medford = [
  ["Education", "58680558"],
  ["Fixed Costs", "32798178"],
  ["Debt Service", "6722970"],
  ["Public Works", "12870245"],
  ["Police", "13791821"],
  ["Fire", "13498506"],
  ["General Government", "4584312"],
  ["Culture and Recreation", "2721043"],
  ["Intergovernmental Assessments", "10286228"],
  ["Human Services", "1293611"],
  ["Other Public Safety", "1301949"],
]

var winchester = [
  ["Education", "49974412"],
  ["Fixed Costs", "17500519"],
  ["Debt Service", "12993748"],
  ["Public Works", "8452015"],
  ["Police", "4827686"],
  ["Fire", "4551327"],
  ["General Government", "7798467"],
  ["Culture and Recreation", "1959049"],
  ["Intergovernmental Assessments", "573680"],
  ["Human Services", "647889"],
  ["Other Public Safety", "274465"],  
]

function buildChart(id, data) {
  var chart = c3.generate({
    bindto: id,
    data: {
      columns: data,
      type: "donut",
      colors: expenseColors,
    },
    donut: {
      title: "Expenses (2019)"
    },
    size: {
      width: 400
    },
    legend: {
      position: 'right'
    }
  });
}

function displayTable(id, csvfile) {
  d3.csv(csvfile)
    .then(function(data) {
    var csvtable = d3table(id, data, [
      "Municipality", 
      "Education",
      "Fixed Costs",
      "Debt Service",
      "Public Works",
      "Police",
      "Fire",
      "General Government",
      "Culture and Recreation",
      "Intergovernmental Assessments",
      "Human Services",
      "Other Public Safety",
    ]
    );
  })
  .catch(function(error){
    console.log("Sorry, no can do: " + error);
  })
}

function d3table(div, data, columns) {
  console.log("DEBUG here")
  var table = d3.select(div).append("table");
  var thead = table.append("thead");
  thead.append("tr")
    .selectAll("th")
    .data(columns)
    .enter()
    .append("th")
    .text(function(column) { return column; });
  var tbody = table.append("tbody");
  var rows = tbody.selectAll("tr")
    .data(data)
    .enter()
    .append("tr");
  var cells = rows.selectAll("td")
    .data(function(row) {
      return columns.map(function(column) {
        return {column: column, value: row[column]};
      });
    })
    .enter()
    .append("td")
    .text(function(d) { return d.value; });
  return table;
}

// Build our page (obviously, this is just a concept; should all be data-driven)
buildChart('#arlington', arlington);
buildChart('#belmont', belmont);
buildChart('#medford', medford);
buildChart('#winchester', winchester);
displayTable('#csvtable', '/data/finance/GenFundExpenditures2019-comps.csv')
