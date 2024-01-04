---
title: Local Nonprofit News Finances
excerpt: Reporting basic comparative finances for local nonprofits.
classes: wide
categories:
  - Finance
tags:
  - Budgets
  - Comparable
---

Building the [metadata directory of local nonprofit news sites](https://arlingtonma.info/local-news-orgs/), we've also compiled some rough financial data from IRS reported 990 tax forms, or in a few cases from organization's own annual reports (when 990s aren't yet posted to [Propublica](https://projects.propublica.org/nonprofits/)).

## Data Quality Reminders

Data below is captured from IRS 990/990-EZ forms, or in select cases from MA PC charitable tax forms, or an organization's own published reports.  Thus while these columns are *likely* comparable, they are not necessarily *exactly* compatible.  A few examples of likely subtle differences:

- IRS 990 and 990-EZ fields sometimes have very similar, but not identical definitions.  For example, the *"Contributions, gifts, grants, and similar amounts received"* field differs because one version includes *"Membership Dues"*, and the other form does not.  For more details, see the [Propublica Nonprofit Explorer API](https://projects.propublica.org/nonprofits/api#filing-object) and read the various links discussing IRS field mapping.
- 990 filings are often made late, and take time to show up publicly; thus data for different orgs may be reported for different years.
- Where 990 filings are not available, we've used the MA AGO's PC forms, or reports from the organization directly.  Thus some of these values may be subtly different from what gets put on their final 990.
- **Contributions** is a large category; in particular, nonprofit news sites often think of grants and leading/major gifts separately from individual, sustaining, or regular subscriber donations.

## Comparative Financials Of Selected Local News

<div id="csvtable"></div>

<!-- Load d3/c3 tools and our visualizations -->
<link href="/assets/css/c3.css" rel="stylesheet">
<script src="/assets/js/d3.min.js" charset="utf-8"></script>
<script src="/assets/js/c3.min.js"></script>
<script src="/assets/js/dataread.js"></script>
<script>
    const expenseHeaders = [
    'ein', 'commonName','location','irsdate','population','incomepercapita','eqvpercapita','EIN','Tax_Year','Tax_Period_End','Form_Type_Filed','Contributions','Investment_Income','Program_Service_Revenue','Total_Revenue','Total_Expenses','Total_Assets','Total_Liabilities','Net_Assets','contribpercapita','revpercapita','expensepercapita'
  ]
  const csvpromise = addCSVTable('#csvtable', '/data/newsorgs/finance/news-finances.csv', expenseHeaders)
</script>
