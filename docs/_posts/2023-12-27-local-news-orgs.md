---
title: Local Nonprofit News Organizations
excerpt: Basic IRS 990 tax data of locally-owned news orgs.
layout: newsorgs
classes: wide
---

The US is witnessing a rebirth of locally-owned, hyperlocal news organizations made up of journalists and volunteers reporting on happenings in their town or city.  [Your Arlington](https://yourarlington.com/) is one such local newspaper, which has recently [turned into a non-profit organization](https://yourarlington.com/about.html) with an independent board.

While detailed nonprofit finances are often hard to find - volunteer-run organizations don't often post balance sheets - the IRS and [Propublica's Nonprofit Explorer](https://projects.propublica.org/nonprofits/) make it easy to see a high-level overview of nonprofit finances by reading their 990 tax forms.

## Metadata Directory Of Local News Orgs

We've built a metadata listing of locally-owned news organizations in eastern MA and in select other places in the US - read on below!  As an open source project, we'd love additions and corrections to the data, as well as people to help organize the data and tie it more directly into other data sources.  If you're familiar with GitHub, submit a PR.  If GitHub is a mystery, ask us for help: I'd love to teach any local journalists how to use the simpler web-based features of GitHub to build super-simple and zero maintenance websites.

 For a more comprehensive list of Massachusetts based news organizations, follow [Dan Kennedy's Media Nation blog](https://dankennedy.net/2021/12/24/boston-globe-media-eyes-expanding-into-tv-films-broadcast-and-radio/).

## Other Data Available: Nonprofit Finances

Along with the below listing of organizational data, we've collected basic IRS 990 and 990-EZ data from Propublica for all of the non-profit organizations below.  The raw data is [available as a CSV file](https://github.com/ArlingtonMA/arlingtonma.info/tree/master/docs/data/localnews/localnews-990s.csv).  Note that Propublica's data extracts may have occasional errors, like on the Carlisle Mosquito's 2019 filing, which erroneously showed 0's for all finances (we've manually typed in the correct numbers).

If you're a data vis wizard and would like to help, I'd love to learn how to create better charts.  I'm happy to use any low-maintenance, permissively licensed software that can display and export charts to deploy on at static GitHub Pages website.  One specific example of a visualization we'd like to show:

```pseudocode
for all *.json in data/newsorgs/990
  read all [organization][ein] fields and [organization][name] fields
  allow user to select two EINs by selecting their NAME
  display a chart comparing finances of the two NAMEs:
    for [organization where ein=EIN][filings_with_data]
      NAME is series label
      categorize by [filings_with_data][tax_prd_yr]
      show data fields [totrevenue] and [totassetsend]
```

## Locally Owned Nonprofit News Orgs

Note this includes a selection of Massachusetts based orgs, as well as a number of potentially comparable news orgs across the US.  For more data on nonprofit news, see [Project News Oasis](https://www.projectnewsoasis.com/publications).
