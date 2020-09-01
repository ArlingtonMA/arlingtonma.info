---
title: Arlington's Top Landowners By Zone
excerpt: Charting who owns what in different Zoning Areas of Arlington.
classes: wide
categories:
  - Property
tags:
  - Property
  - Assessments
  - Zoning
---

While Arlington is primarily a residential town, there are plenty of business even industrial districts here.  But who owns what kind of land - that is, in which zoning areas?

## Top Landowners In Arlington

Unlike our [earlier comparison of the top landowners in Arlington](https://arlingtonma.info/property/largest-property-owners/), these charts include the Town of Arlington itself in calculations.  Charts include the top 10 owners by land size in each zoning area.  For example, in zone _B4 - Vehicular Oriented Business_, the Mirak family's various auto properties comprise 13% of all _B4_-zoned land in Arlington by size.  The percentage of **All Others** is then shown in black for all smaller holders combined in each zone's chart.

See [Business districts](#business), [Industrial or Other districts](#industrial), [Residential districts](#residential), or [Data Sources](#data-sources).  Not shown is the Transportation district (MBTA, mainly) or W/WATER areas (like Spy pond or the Res).  Note that the _MU - Multi-Use_ and _PUD - Planned Unit Development_ zones are effectively only single owners.

## Business Districts

<figure class="half" id="business">
<div class='chartfigure'><h3 style='text-align: center;'>B1 - Neighborhood Office</h3><div id='zoneB1'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>B2 - Neighborhood Business</h3><div id='zoneB2'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>B2A - Major Business</h3><div id='zoneB2A'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>B3 - Village Business</h3><div id='zoneB3'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>B4 - Vehicular Oriented Business</h3><div id='zoneB4'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>B5 - Central Business</h3><div id='zoneB5'></div></div>
</figure>

## Industrial Or Other Districts

<figure class="half" id="industrial">
<div class='chartfigure'><h3 style='text-align: center;'>I - Industrial</h3><div id='zoneI'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>MU - Multi-Use</h3><div id='zoneMU'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>OS - Open Space</h3><div id='zoneOS'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>PUD - Planned Unit Development</h3><div id='zonePUD'></div></div>
</figure>

# Residential Districts

<figure class="half" id="residential">
<div class='chartfigure'><h3 style='text-align: center;'>R0 - Large Lot Single Family</h3><div id='zoneR0'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>R1 - Single Family</h3><div id='zoneR1'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>R2 - Two Family</h3><div id='zoneR2'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>R3 - Three Family</h3><div id='zoneR3'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>R4 - Town House</h3><div id='zoneR4'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>R5 - Apartments Low Density</h3><div id='zoneR5'></div></div>
</figure>
<figure class="half">
<div class='chartfigure'><h3 style='text-align: center;'>R6 - Apartments Med Density</h3><div id='zoneR6'></div></div>
<div class='chartfigure'><h3 style='text-align: center;'>R7 - Apartments High Density</h3><div id='zoneR7'></div></div>
</figure>

## Data Sources

All figures are derived from [official data sources from the Town's GIS department](/property) including the most recently _assessed_ value of parcels.  Using a simple [Ruby programming script](https://github.com/ArlingtonMA/arlingtonma.info/blob/master/src/assessorparser.rb), we have analyzed the core ArlingtonMA_Assessor table of all owners of land in town to sum up overall ownership records.  Since many commercial properties are owned by trusts or LLC corporations, we have also consolidated beneficial ownership in selected cases for some major property owners in town.  Entries in _UPPERCASE_ are exact parcel owners directly in Assessor rolls; entries _In Mixed Case_ are beneficial owners of various companies or realty trusts.  Note that our beneficial owner research may be incomplete or inaccurate depending on actual ownership structures.

Property size percentage of a zone is calculated against a summing up of all property LOT_SIZE within a zone.  Note that comparisons against the separate ArlingtonMA_Zoning file don't work (not sure why; we've asked the GIS department for comment).


<!-- Actually load our charts/tables -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script src="/assets/js/largest-zone-owners.js"></script>
