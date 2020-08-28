---
title: Arlington's Largest Landowners
excerpt: Charting the largest landowners in Arlington.
classes: wide
categories:
  - Property
tags:
  - Property
  - Assessments
  - Zoning
---

As one of the most densely built towns in the Commonwealth, it's interesting to see who the major commercial, non-profit, or other organizational landowners are, and what kinds of effects they may have on our town.

## Top Land Owners In Arlington

Note that the Town of Arlington itself is by far the largest holder of land in town by an order of magnitude, and is not included in the below charts.  For comparison, the Town and its various departments (including DPW, Schools, parks, cemetery, public safety, and more) holds 351.63 acres of land (out of ~4,300 acres of land in town total) with an assessed value of over $571,000,000!

See [By Assessed Value](#assessment), [By Size (Acres)](#acres), or [Data Sources](#data-sources).

<figure id="assessment">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Land Owners By Assessment ($)</h3>
    <div id="landval"></div>
  </div>
</figure>

<figure id="acres">
  <div class='chartfigure'>
    <h3 style='text-align: center;'>Land Owners By Acreage</h3>
    <div id="landsize"></div>
  </div>
</figure>

## Data Sources

All figures are derived from [official data sources from the Town's GIS department](/property) including the most recently _assessed_ value of parcels.  Using a simple [Ruby programming script](https://github.com/ArlingtonMA/arlingtonma.info/blob/master/src/assessorparser.rb), we have analyzed the core ArlingtonMA_Assessor table of all owners of land in town to sum up overall ownership records.  Since many commercial properties are owned by trusts or LLC corporations, we have also consolidated beneficial ownership in selected cases for some major property owners in town.  Entries in _UPPERCASE_ are exact parcel owners directly in Assessor rolls; entries _In Mixed Case_ are beneficial owners of various companies or realty trusts.  Note that our beneficial owner research may be incomplete or inaccurate depending on actual ownership structures.

Property ownership records are public.  However data being public and publishing that data are not the same thing.  Therefore we have focused our analysis on large property owners only - who are all commercial organizations, non-profits, or major family holdings of commercial developers or landlords.  While we would not want to needlessly publish personal information like a home address, analyzing and publishing commercially-focused property ownership helps residents understand the impact that new developments can have on our town.

<!-- Actually load our charts/tables -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
const landval = [
  ['Beneficial Owner', 'Assessed Valuation'],
  ["Mirak Family", 82444000],
  ["FHF 1 ARLINGTON 360 LLC", 77839500],
  ["ARLINGTON HOUSING AUTHORITY", 53547800],
  ["ROMAN CATHOLIC ARCH OF BOS", 47729400],
  ["US REIF BRIGHAM SQUARE", 47352400],
  ["NOSTALGIA PROPERTIES LLC", 42307900],
  ["OLD COLONY REALTY PARTNERS LLC", 35668400],
  ["BRENTWOOD REALTY PARTNERS LLC", 32345200],
  ["MILLBROOK SQ APARTMENTS CO", 22719400],
  ["CLAREMONT ARLINGTON SUITES LLC", 22326400],
  ["BROOKS AVENUE LLC", 18647100],
  ["Henry E. Davidson, Jr.", 16661400],
  ["CONSERVATION FOOD & HEALTH", 16281100],
  ["JOHNSON ARTHUR W TR", 14424300],
  ["WINCHESTER COUNTRY CLUB", 14123862],
  ["GALVIN SEAN D/TRUSTEE", 13953700],
  ["BRIGHTVIEW ARLINGTON LLC", 13446200],
  ["SUNRISE ASSISTED LIVING INC", 13027200],
  ["Paul Caruso", 11960000],
  ["Mugar Family", 11789500]
]
c3.generate({
  bindto: '#landval',
  size: {
    height: 600, // Force bars to be wider
  },
  data: {
    x: 'Beneficial Owner',
    rows: landval,
    type: 'bar',
    labels: {
      format: {
        'Assessed Valuation': d3.format('$')
      }
    },
    bar: {
      width: 40
    }
  },
  axis: {
    rotated: true,
    x: {
      type: 'category',
      categories: landval.map(function(v,i) { return v[0]; }).slice(1),
      tick: {
        centered: true
      }
    },
    y: {
      show: false
    }
  }
})

const landsize = [
  ['Beneficial Owner', 'Size in Acres'],
  ['WINCHESTER COUNTRY CLUB', 48.22],
  ['Mirak Family', 20.11],
  ['ROMAN CATHOLIC ARCH OF BOS', 19.92],
  ['ARLINGTON HOUSING AUTHORITY', 19.48],
  ['Mugar Family', 17.83],
  ['FHF 1 ARLINGTON 360 LLC', 16.17],
  ['CATHOLIC CEMETARY ASSOC', 14.92],
  ['BELMONT COUNTRY CLUB INC', 11.32],
  ['NOSTALGIA PROPERTIES LLC', 5.74],
  ['CONSERVATION FOOD & HEALTH', 5.29],
  ['US REIF BRIGHAM SQUARE', 3.87],
  ['Paul Caruso', 3.43],
  ['HOUSING CORP OF ARLINGTON', 3.32],
  ['THE GREEK ORTHODOX CHURCH', 3.31],
  ['GALVIN SEAN D/TRUSTEE', 3.09],
  ['ARLINGTON COAL & LUMBER CO', 3.09],
  ['30 PARK AVE ASSOC LLP', 2.95],
  ['JOHNSON ARTHUR W TR', 2.48],
  ['MILLBROOK SQ APARTMENTS CO', 2.43],
  ['MARLEY WILLIAM GNC', 2.32]
]
c3.generate({
  bindto: '#landsize',
  size: {
    height: 600, // Force bars to be wider
  },
  data: {
    x: 'Beneficial Owner',
    rows: landsize,
    type: 'bar',
    bar: {
      width: 40
    }
  },
  axis: {
    rotated: true,
    x: {
      type: 'category',
      categories: landval.map(function(v,i) { return v[0]; }).slice(1),
      tick: {
        centered: true
      }
    },
    y: {
      show: false
    }
  }
})
</script>