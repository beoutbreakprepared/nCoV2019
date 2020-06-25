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

Belize - Ministry of Health https://www.facebook.com/pg/dhsbelize/posts/

Bermuda - Government of Bermuda https://www.gov.bm/news

Bosnia and Herzegovina - Ministarstvo civilnih poslova Bosne i Hercegovine http://mcp.gov.ba/publication/read/epidemioloska-slika-covid-19?lang=bs

Cyprus - Press and Information Office https://www.pio.gov.cy/coronavirus/press.html

Democratic Republic of the Congo - Comité multisectoriel de la riposte à la Pandémie du Covid-19 en RDC https://us3.campaign-archive.com/home/?u=b34a30571d429859fb249533d&id=1d019331c1

Dominican Republic - Ministerio de Salud Publica http://digepisalud.gob.do/documentos/?drawer=Vigilancia%20Epidemiologica*Alertas%20epidemiologicas*Coronavirus*Nacional*Boletin%20Especial%20COVID-19

Eswatini - Ministry of Health of the Kingdom of Eswatini http://www.gov.sz/index.php/covid-19-corona-virus/covid-19-press-statements-2020 and https://datastudio.google.com/embed/u/0/reporting/b847a713-0793-40ce-8196-e37d1cc9d720/page/2a0LB

Gabon - Comité de Pilotage du Plan de Veille et de Riposte Contre L'Épidemié à Coronavirus https://infocovid.ga/lactualite-covid-19/

Gambia - Ministry of Health http://www.moh.gov.gm/covid-19-report/

Guinea - Agence National de la Securite Sanitaire https://anss-guinee.org/welcome

Mali - Ministere de la Sante et des Affaires Sociales http://www.sante.gov.ml/index.php/actualites/communiques

Saint Kitts and Nevis - Government of St Kitts and Nevis https://www.covid19.gov.kn/daily-reports/

Zambia - Zambia National Public Health Institute http://znphi.co.zm/news/situation-reports-new-coronavirus-covid-19-sitreps/
