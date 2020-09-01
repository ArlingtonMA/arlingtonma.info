/**
 * Various utilities for reading common data fields, or static copies of common data
 *
 * Useful data we should add static copies of (for quicker lookup)
 * getDemographics from sub-est2019_25.csv esimated population
 * getLandArea - TBD
 * getRoadMiles - TBD Mass DOT Road miles as technical PDF https://www.mass.gov/files/documents/2017/09/13/2016_ri_ye_rpt.pdf or newer https://www.mass.gov/doc/2018-road-inventory-year-end-report/download
 * Land use by acreage https://docs.digital.mass.gov/dataset/massgis-data-land-use-summary-statistics
 * Simplified demographics (various types) from 2010 Census by massgis https://docs.digital.mass.gov/dataset/massgis-data-datalayers-2010-us-census
 */

/**
 * Insert a C3 donut chart
 * @param {string} id to insert in
 * @param {string[]} data to chart [ ['name', '123'], ...]
 * @param {string} title to display inside donut
 * @param {hash} colors for mapping 'name' to html color
 */
function addDonutChart (id, data, title, colors) {
  var datahash = {
    type: 'donut',
    columns: data
  }
  if (colors) {
    datahash.colors = colors
  }
  var chart = c3.generate({
    bindto: id,
    data: datahash,
    donut: {
      title: title
    },
    legend: {
      position: 'bottom'
    }
  })
  return chart
}

/**
 * Insert a C3 timeseries area chart using 'Date' as axis of dates
 * @param {string} id to insert in
 * @param {string[]} data to chart [ ['name', '123'], ...]
 * @param {hash} yopts for options y axis
 * @param {hash} colors for mapping 'name' to html color
 */
function addTimeseriesPercentChart (id, data, yopts, colors) {
  var chart = c3.generate({
    bindto: id,
    data: {
      x: 'Date',
      type: 'area',
      columns: data,
      groups: [Object.keys(colors)],
      colors: colors,
      order: null
    },
    axis: {
      y: yopts,
      x: {
        type: 'timeseries',
        tick: {
          format: '%Y '
        }
      }
    }
  })
  return chart
}

/**
 * Use D3 to read a csv and display html table
 * @param {string} id to insert in
 * @param {string} csvfile url/path to csv file
 * @param {string[]} headerArr ['Headers', 'to', 'include']
 * @return Promise including data structure read
 */
function addCSVTable (id, csvfile, headerArr) {
  return d3.csv(csvfile)
    .then(function (data) {
      addD3table(id, data, headerArr)
      return data
    })
    .catch(function (error) {
      console.log('ERROR addCSVTable(): ' + error)
    })
}

/**
 * Use D3 to display a table
 * @param {string} id to insert in
 * @param {*} data array to read
 * @param {string[]} headerArr ['Headers', 'to', 'include']
 */
function addD3table (id, data, headerArr) {
  var table = d3.select(id).append('table')
  var thead = table.append('thead')
  thead.append('tr')
    .selectAll('th')
    .data(headerArr)
    .enter()
    .append('th')
    .text(function (column) { return column })
  var rows = table.append('tbody').selectAll('tr')
    .data(data)
    .enter()
    .append('tr')
  rows.selectAll('td')
    .data(function (row) {
      return headerArr.map(function (column) {
        return { column: column, value: row[column] }
      })
    })
    .enter()
    .append('td')
    .text(function (d) { return d.value })
  return table
}

/**
 * Static Copies Of Common Datasets
 */
census2019 = { // Source: sub-est2019_25.csv, columns NAME, POPESTIMATE2019
  Abington: {
    population: 16668
  },
  Acton: {
    population: 23662
  },
  Acushnet: {
    population: 10625
  },
  Adams: {
    population: 8010
  },
  Agawam: {
    population: 28613
  },
  Alford: {
    population: 488
  },
  Amesbury: {
    population: 17532
  },
  Amherst: {
    population: 39924
  },
  Andover: {
    population: 36356
  },
  Aquinnah: {
    population: 320
  },
  Arlington: {
    population: 45531
  },
  Ashburnham: {
    population: 6348
  },
  Ashby: {
    population: 3219
  },
  Ashfield: {
    population: 1717
  },
  Ashland: {
    population: 17807
  },
  Athol: {
    population: 11732
  },
  Attleboro: {
    population: 45237
  },
  Auburn: {
    population: 16766
  },
  Avon: {
    population: 4549
  },
  Ayer: {
    population: 8196
  },
  Barnstable: {
    population: 44477
  },
  Barre: {
    population: 5578
  },
  Becket: {
    population: 1716
  },
  Bedford: {
    population: 14123
  },
  Belchertown: {
    population: 15098
  },
  Bellingham: {
    population: 17270
  },
  Belmont: {
    population: 26116
  },
  Berkley: {
    population: 6851
  },
  Berlin: {
    population: 3240
  },
  Bernardston: {
    population: 2090
  },
  Beverly: {
    population: 42174
  },
  Billerica: {
    population: 43367
  },
  Blackstone: {
    population: 9288
  },
  Blandford: {
    population: 1252
  },
  Bolton: {
    population: 5426
  },
  Boston: {
    population: 692600
  },
  Bourne: {
    population: 19762
  },
  Boxborough: {
    population: 5793
  },
  Boxford: {
    population: 8332
  },
  Boylston: {
    population: 4712
  },
  Braintree: {
    population: 37190
  },
  Brewster: {
    population: 9775
  },
  Bridgewater: {
    population: 27619
  },
  Brimfield: {
    population: 3680
  },
  Brockton: {
    population: 95708
  },
  Brookfield: {
    population: 3452
  },
  Brookline: {
    population: 59121
  },
  Buckland: {
    population: 1850
  },
  Burlington: {
    population: 28627
  },
  Cambridge: {
    population: 118927
  },
  Canton: {
    population: 23805
  },
  Carlisle: {
    population: 5252
  },
  Carver: {
    population: 11767
  },
  Charlemont: {
    population: 1233
  },
  Charlton: {
    population: 13713
  },
  Chatham: {
    population: 5982
  },
  Chelmsford: {
    population: 35391
  },
  Chelsea: {
    population: 39690
  },
  Cheshire: {
    population: 3129
  },
  Chester: {
    population: 1369
  },
  Chesterfield: {
    population: 1249
  },
  Chicopee: {
    population: 55126
  },
  Chilmark: {
    population: 922
  },
  Clarksburg: {
    population: 1638
  },
  Clinton: {
    population: 14000
  },
  Cohasset: {
    population: 8548
  },
  Colrain: {
    population: 1661
  },
  Concord: {
    population: 18918
  },
  Conway: {
    population: 1873
  },
  Cummington: {
    population: 874
  },
  Dalton: {
    population: 6525
  },
  Danvers: {
    population: 27549
  },
  Dartmouth: {
    population: 34188
  },
  Dedham: {
    population: 25219
  },
  Deerfield: {
    population: 4991
  },
  Dennis: {
    population: 13871
  },
  Dighton: {
    population: 7967
  },
  Douglas: {
    population: 9038
  },
  Dover: {
    population: 6127
  },
  Dracut: {
    population: 31634
  },
  Dudley: {
    population: 11773
  },
  Dunstable: {
    population: 3403
  },
  Duxbury: {
    population: 15921
  },
  'East Bridgewater': {
    population: 14526
  },
  'East Brookfield': {
    population: 2210
  },
  'East Longmeadow': {
    population: 16192
  },
  Eastham: {
    population: 4906
  },
  Easthampton: {
    population: 15829
  },
  Easton: {
    population: 25105
  },
  Edgartown: {
    population: 4348
  },
  Egremont: {
    population: 1205
  },
  Erving: {
    population: 1750
  },
  Essex: {
    population: 3799
  },
  Everett: {
    population: 46451
  },
  Fairhaven: {
    population: 16078
  },
  'Fall River': {
    population: 89541
  },
  Falmouth: {
    population: 30993
  },
  Fitchburg: {
    population: 40638
  },
  Florida: {
    population: 715
  },
  Foxborough: {
    population: 18399
  },
  Framingham: {
    population: 74416
  },
  Franklin: {
    population: 34087
  },
  Freetown: {
    population: 9394
  },
  Gardner: {
    population: 20683
  },
  Georgetown: {
    population: 8768
  },
  Gill: {
    population: 1465
  },
  Gloucester: {
    population: 30430
  },
  Goshen: {
    population: 1059
  },
  Gosnold: {
    population: 75
  },
  Grafton: {
    population: 18883
  },
  Granby: {
    population: 6291
  },
  Granville: {
    population: 1611
  },
  'Great Barrington': {
    population: 6945
  },
  Greenfield: {
    population: 17258
  },
  Groton: {
    population: 11325
  },
  Groveland: {
    population: 6849
  },
  Hadley: {
    population: 5342
  },
  Halifax: {
    population: 7896
  },
  Hamilton: {
    population: 8051
  },
  Hampden: {
    population: 5177
  },
  Hancock: {
    population: 696
  },
  Hanover: {
    population: 14570
  },
  Hanson: {
    population: 10914
  },
  Hardwick: {
    population: 3057
  },
  Harvard: {
    population: 6620
  },
  Harwich: {
    population: 12142
  },
  Hatfield: {
    population: 3251
  },
  Haverhill: {
    population: 64014
  },
  Hawley: {
    population: 334
  },
  Heath: {
    population: 695
  },
  Hingham: {
    population: 24679
  },
  Hinsdale: {
    population: 1911
  },
  Holbrook: {
    population: 11033
  },
  Holden: {
    population: 19303
  },
  Holland: {
    population: 2482
  },
  Holliston: {
    population: 14912
  },
  Holyoke: {
    population: 40117
  },
  Hopedale: {
    population: 5951
  },
  Hopkinton: {
    population: 18470
  },
  Hubbardston: {
    population: 4829
  },
  Hudson: {
    population: 19864
  },
  Hull: {
    population: 10475
  },
  Huntington: {
    population: 2169
  },
  Ipswich: {
    population: 14074
  },
  Kingston: {
    population: 13863
  },
  Lakeville: {
    population: 11561
  },
  Lancaster: {
    population: 8082
  },
  Lanesborough: {
    population: 2940
  },
  Lawrence: {
    population: 80028
  },
  Lee: {
    population: 5664
  },
  Leicester: {
    population: 11341
  },
  Lenox: {
    population: 4944
  },
  Leominster: {
    population: 41716
  },
  Leverett: {
    population: 1837
  },
  Lexington: {
    population: 33132
  },
  Leyden: {
    population: 715
  },
  Lincoln: {
    population: 7052
  },
  Littleton: {
    population: 10227
  },
  Longmeadow: {
    population: 15705
  },
  Lowell: {
    population: 110997
  },
  Ludlow: {
    population: 21233
  },
  Lunenburg: {
    population: 11736
  },
  Lynn: {
    population: 94299
  },
  Lynnfield: {
    population: 12999
  },
  Malden: {
    population: 60470
  },
  'Manchester-by-the-Sea': {
    population: 5434
  },
  Mansfield: {
    population: 24470
  },
  Marblehead: {
    population: 20555
  },
  Marion: {
    population: 5188
  },
  Marlborough: {
    population: 39597
  },
  Marshfield: {
    population: 25967
  },
  Mashpee: {
    population: 14229
  },
  Mattapoisett: {
    population: 6401
  },
  Maynard: {
    population: 11336
  },
  Medfield: {
    population: 12955
  },
  Medford: {
    population: 57341
  },
  Medway: {
    population: 13479
  },
  Melrose: {
    population: 28016
  },
  Mendon: {
    population: 6223
  },
  Merrimac: {
    population: 6960
  },
  Methuen: {
    population: 50706
  },
  Middleborough: {
    population: 25463
  },
  Middlefield: {
    population: 534
  },
  Middleton: {
    population: 10110
  },
  Milford: {
    population: 29101
  },
  Millbury: {
    population: 13947
  },
  Millis: {
    population: 8310
  },
  Millville: {
    population: 3257
  },
  Milton: {
    population: 27593
  },
  Monroe: {
    population: 115
  },
  Monson: {
    population: 8787
  },
  Montague: {
    population: 8212
  },
  Monterey: {
    population: 924
  },
  Montgomery: {
    population: 866
  },
  'Mount Washington': {
    population: 157
  },
  Nahant: {
    population: 3513
  },
  Nantucket: {
    population: 11399
  },
  Natick: {
    population: 36050
  },
  Needham: {
    population: 31388
  },
  'New Ashford': {
    population: 223
  },
  'New Bedford': {
    population: 95363
  },
  'New Braintree': {
    population: 1024
  },
  'New Marlborough': {
    population: 1458
  },
  'New Salem': {
    population: 1021
  },
  Newbury: {
    population: 7148
  },
  Newburyport: {
    population: 18289
  },
  Newton: {
    population: 88414
  },
  Norfolk: {
    population: 12003
  },
  'North Adams': {
    population: 12730
  },
  'North Andover': {
    population: 31188
  },
  'North Attleborough': {
    population: 29364
  },
  'North Brookfield': {
    population: 4792
  },
  'North Reading': {
    population: 15865
  },
  Northampton: {
    population: 28451
  },
  Northborough: {
    population: 15109
  },
  Northbridge: {
    population: 16679
  },
  Northfield: {
    population: 2958
  },
  Norton: {
    population: 19948
  },
  Norwell: {
    population: 11153
  },
  Norwood: {
    population: 29725
  },
  'Oak Bluffs': {
    population: 4667
  },
  Oakham: {
    population: 1957
  },
  Orange: {
    population: 7582
  },
  Orleans: {
    population: 5788
  },
  Otis: {
    population: 1539
  },
  Oxford: {
    population: 14009
  },
  Palmer: {
    population: 12232
  },
  Paxton: {
    population: 4963
  },
  Peabody: {
    population: 53070
  },
  Pelham: {
    population: 1313
  },
  Pembroke: {
    population: 18509
  },
  Pepperell: {
    population: 12114
  },
  Peru: {
    population: 834
  },
  Petersham: {
    population: 1250
  },
  Phillipston: {
    population: 1746
  },
  Pittsfield: {
    population: 42142
  },
  Plainfield: {
    population: 661
  },
  Plainville: {
    population: 9293
  },
  Plymouth: {
    population: 61528
  },
  Plympton: {
    population: 2987
  },
  Princeton: {
    population: 3488
  },
  Provincetown: {
    population: 2961
  },
  Quincy: {
    population: 94470
  },
  Randolph: {
    population: 34362
  },
  Raynham: {
    population: 14470
  },
  Reading: {
    population: 25400
  },
  Rehoboth: {
    population: 12385
  },
  Revere: {
    population: 53073
  },
  Richmond: {
    population: 1416
  },
  Rochester: {
    population: 5687
  },
  Rockland: {
    population: 17986
  },
  Rockport: {
    population: 7282
  },
  Rowe: {
    population: 389
  },
  Rowley: {
    population: 6473
  },
  Royalston: {
    population: 1277
  },
  Russell: {
    population: 1792
  },
  Rutland: {
    population: 8938
  },
  Salem: {
    population: 43226
  },
  Salisbury: {
    population: 9534
  },
  Sandisfield: {
    population: 891
  },
  Sandwich: {
    population: 20169
  },
  Saugus: {
    population: 28361
  },
  Savoy: {
    population: 675
  },
  Scituate: {
    population: 18924
  },
  Seekonk: {
    population: 15770
  },
  Sharon: {
    population: 18895
  },
  Sheffield: {
    population: 3129
  },
  Shelburne: {
    population: 1837
  },
  Sherborn: {
    population: 4335
  },
  Shirley: {
    population: 7636
  },
  Shrewsbury: {
    population: 38526
  },
  Shutesbury: {
    population: 1754
  },
  Somerset: {
    population: 18129
  },
  Somerville: {
    population: 81360
  },
  'South Hadley': {
    population: 17625
  },
  Southampton: {
    population: 6171
  },
  Southborough: {
    population: 10208
  },
  Southbridge: {
    population: 16878
  },
  Southwick: {
    population: 9740
  },
  Spencer: {
    population: 11935
  },
  Springfield: {
    population: 153606
  },
  Sterling: {
    population: 8174
  },
  Stockbridge: {
    population: 1890
  },
  Stoneham: {
    population: 24126
  },
  Stoughton: {
    population: 28915
  },
  Stow: {
    population: 7234
  },
  Sturbridge: {
    population: 9597
  },
  Sudbury: {
    population: 19655
  },
  Sunderland: {
    population: 3629
  },
  Sutton: {
    population: 9582
  },
  Swampscott: {
    population: 15298
  },
  Swansea: {
    population: 16834
  },
  Taunton: {
    population: 57464
  },
  Templeton: {
    population: 8138
  },
  Tewksbury: {
    population: 31178
  },
  Tisbury: {
    population: 4096
  },
  Tolland: {
    population: 508
  },
  Topsfield: {
    population: 6641
  },
  Townsend: {
    population: 9506
  },
  Truro: {
    population: 2008
  },
  Tyngsborough: {
    population: 12527
  },
  Tyringham: {
    population: 312
  },
  Upton: {
    population: 8065
  },
  Uxbridge: {
    population: 14195
  },
  Wakefield: {
    population: 27045
  },
  Wales: {
    population: 1874
  },
  Walpole: {
    population: 25200
  },
  Waltham: {
    population: 62495
  },
  Ware: {
    population: 9711
  },
  Wareham: {
    population: 22745
  },
  Warren: {
    population: 5222
  },
  Warwick: {
    population: 769
  },
  Washington: {
    population: 541
  },
  Watertown: {
    population: 35939
  },
  Wayland: {
    population: 13835
  },
  Webster: {
    population: 16949
  },
  Wellesley: {
    population: 28670
  },
  Wellfleet: {
    population: 2724
  },
  Wendell: {
    population: 878
  },
  Wenham: {
    population: 5278
  },
  'West Boylston': {
    population: 8077
  },
  'West Bridgewater': {
    population: 7281
  },
  'West Brookfield': {
    population: 3727
  },
  'West Newbury': {
    population: 4714
  },
  'West Springfield': {
    population: 28517
  },
  'West Stockbridge': {
    population: 1257
  },
  'West Tisbury': {
    population: 2904
  },
  Westborough: {
    population: 19144
  },
  Westfield: {
    population: 41204
  },
  Westford: {
    population: 24817
  },
  Westhampton: {
    population: 1637
  },
  Westminster: {
    population: 7997
  },
  Weston: {
    population: 12124
  },
  Westport: {
    population: 16034
  },
  Westwood: {
    population: 16400
  },
  Weymouth: {
    population: 57746
  },
  Whately: {
    population: 1567
  },
  Whitman: {
    population: 15216
  },
  Wilbraham: {
    population: 14689
  },
  Williamsburg: {
    population: 2466
  },
  Williamstown: {
    population: 7434
  },
  Wilmington: {
    population: 23445
  },
  Winchendon: {
    population: 10905
  },
  Winchester: {
    population: 22799
  },
  Windsor: {
    population: 866
  },
  Winthrop: {
    population: 18544
  },
  Woburn: {
    population: 40228
  },
  Worcester: {
    population: 185428
  },
  Worthington: {
    population: 1175
  },
  Wrentham: {
    population: 12023
  },
  Yarmouth: {
    population: 23203
  }
}
