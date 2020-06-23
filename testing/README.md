# COVID-19 Testing Data

Our aim is to supplement the existing global data openly available for testing for COVID-19

Two excellent resources that host a large amount of data are:

 - Our World in Data (https://github.com/owid/covid-19-data) - global coverage
 - The COVID Tracking Project (https://covidtracking.com/api) - United States state level data

 We hope to complement these resources by provisioning two types of additional testing data: (a) for those countries currently absent from these sources and (b) provide further geographic granularity where reported

## Testing Data Schema
Files should have the following columns in common:

nid - a unique identifier cross-referencing a source within the Global Health Data Exchange (http://ghdx.healthdata.org/) [numeric]

location_id - a unique identifier ID consistent with IHME hierarchies [numeric]

location - name of the location for which testing data is collected [character]

date - date for which data is relevant for in format dd.mm.yyyy

total_cases - total number of cases as evaluated by the source

total_tests - total cumulative tests conducted in the location as evaluated by the source

daily_tests - daily test numbers conducted on that day

tests_units - information as to the units used for the tests e.g. total tests processed, individuals tested, tests process in state laboratories

### Use notes

total_tests and daily_tests are mutually exclusive fields

Days of no report are indicated with blank cells and should not be interpreted as zero

Other columns may be present in the location-specific csvs

## Source acknowledgement

We are indebted to the hard work of those individuals and organizations across the world who have been willing and able to report data in an open and timely manner.

Armenia - NCDC https://ncdc.am/coronavirus/confirmed-cases-by-days/

Barbados - Barbados Government Information Service https://gisbarbados.gov.bb/covid-19/

Bermuda - Government of Bermuda https://www.gov.bm/news

Democratic Republic of the Congo - Comité multisectoriel de la riposte à la Pandémie du Covid-19 en RDC https://us3.campaign-archive.com/home/?u=b34a30571d429859fb249533d&id=1d019331c1

Saint Kitts and Nevis - Government of St Kitts and Nevis https://www.covid19.gov.kn/daily-reports/
