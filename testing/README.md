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

## Source acknowledgements and descriptions

We are indebted to the hard work of those individuals and organizations across the world who have been willing and able to report data in an open and timely manner.

[Albania](data/albania_tests.csv)
* Source: [Ministria e Shendetesise dhe Mbrojtjes Sociale](https://new.shendetesia.gov.al/category/lajme/)

[Armenia](data/armenia_tests.csv)
* Source: [NCDC](https://ncdc.am/coronavirus/confirmed-cases-by-days/)

* Short description: The number of tests performed (positive cases + negative test results)

* Long description: Official testing data is reported by the NCDC [website](https://ncdc.am/coronavirus/confirmed-cases-by-days/). Since the 3rd February, the number of confirmed cases, recovered individuals, deaths, and negative test results are reported.
We report the cumulative number of total tests performed, as the sum of the daily numbers of confirmed cases (Հաստատված դեպքեր) and negative test results (Բացասական թեստերի արդյունքներ). While not explicitly stated, we are confident that all tests have been reported and are captured by this arithmetic given that the sum of all daily confirmed cases and negative test results corresponds to the daily cumulative total of general tests (Ընդհանուր թեստեր) reported in a separate part of the dashboard.

[Barbados](data/barbados_tests.csv)
* Source: [Barbados Government Information Service](https://gisbarbados.gov.bb/covid-19/)

[Belize](data/belize_tests.csv)
* Source: [Ministry of Health](https://www.facebook.com/pg/dhsbelize/posts/)

[Bermuda](data/bermuda_tests.csv)
* Source: [Government of Bermuda](https://www.gov.bm/news)

[Bosnia and Herzegovina](data/bosnia_and_herzegovina_tests.csv)
* Source: [Ministarstvo civilnih poslova Bosne i Hercegovine](http://mcp.gov.ba/publication/read/epidemioloska-slika-covid-19?lang=bs)

* Short description: The number of people tested

* Long description: Official testing data is reported by the Ministry of Civil Affairs of Bosnia and Herzergovina on their [website](http://mcp.gov.ba/publication/read/epidemioloska-slika-covid-19?lang=bs). Since the 1st of April, this resource has reported the number of confirmed cases in the country, the number of people tested, the number of people currently under investigation, and the number of deaths. All measures report at a national level, as well as the three main administrative regions: Brčko District (BD), Federation of Bosnia and Herzegovina (FBiH), and Republika Srpska (RS). 
We report the cumulative number of people tested ("Broj testiranih") each day.
Reporting begins on the 1st April, with the cumulative total persons tested standing at 3,458. It is unclear from this source when the first tests were conducted. Since the 6th of June, this source no longer updates on weekends and these dates are blank.

[Canada](data/canada_tests.csv)
* Source: [Government of Canada](https://www.canada.ca/en/public-health/services/diseases/2019-novel-coronavirus-infection.html)

[Cape Verde](data/cape_verde_tests.csv)
* Source: [Governo de Cabo Verde](https://covid19.cv/)

[Central African Republic](data/central_african_republic_tests.csv)
* Source: [Ministère de la santé publique](http://www.msp-centrafrique.net/index.php?query=covid&id=home)

[Costa Rica](data/costa_rica_tests.csv)
* Source: [Ministerio de Salud](http://geovision.uned.ac.cr/oges/#descargas)

[Cote d'Ivoire](data/cote_d'ivoire_tests.csv)
* Source: [Ministère de la Santé et de l'Hygiène Publique](https://www.facebook.com/Mshpci/)

[Cyprus](data/cyprus_tests.csv)
* Source: [Press and Information Office](https://www.pio.gov.cy/coronavirus/press.html)

[Democratic Republic of the Congo](data/democratic_republic_of_the_congo_tests.csv)
* Source: [Comité multisectoriel de la riposte à la Pandémie du Covid-19 en RDC](https://us3.campaign-archive.com/home/?u=b34a30571d429859fb249533d&id=1d019331c1)

[Dominican Republic](data/dominican_republic_tests.csv)
* Source: [Ministerio de Salud Publica](http://digepisalud.gob.do/documentos/?drawer=Vigilancia%20Epidemiologica*Alertas%20epidemiologicas*Coronavirus*Nacional*Boletin%20Especial%20COVID-19)

[Eswatini](data/eswatini_tests.csv) 
* Source: Ministry of Health of the Kingdom of Eswatini via [source 1](http://www.gov.sz/index.php/covid-19-corona-virus/covid-19-press-statements-2020) and [source 2](https://datastudio.google.com/embed/u/0/reporting/b847a713-0793-40ce-8196-e37d1cc9d720/page/2a0LB)

[Fiji](data/fiji_tests.csv)
* Source: [Ministry of Health & Medical Services](http://www.health.gov.fj/covid-19-updates/)

[Gabon](data/gabon_tests.csv) 
* Source: [Comité de Pilotage du Plan de Veille et de Riposte Contre L'Épidemié à Coronavirus](https://infocovid.ga/lactualite-covid-19/)

[Gambia](data/gambia_tests.csv)
* Source: [Ministry of Health](http://www.moh.gov.gm/covid-19-report/)

[Guinea](data/guinea_tests.csv) 
* Source: [Agence National de la Securite Sanitaire](https://anss-guinee.org/welcome)

[Guinea Bissau](data/guineabissau_tests.csv)
* Source: [INFOCOVID-19](https://covid19gb.com/noticias/)

[Guyana](data/guyana_tests.csv)
* Source: [Ministry of Public Health](https://health.gov.gy/)

[Honduras](data/honduras_tests.csv)
* Source: [Gobierno de la Republica de Honduras](http://www.salud.gob.hn/site/index.php/covid19)

[Madagascar](data/madagascar_tests.csv)
* Source: [Ministere Sante Publique](http://www.sante.gov.mg/ministere-sante-publique/category/coronavirus/)

[Malawi](data/malawi_tests.csv)
* Source: [Ministry of Health](https://covid19.health.gov.mw/)

[Mali](data/mali_tests.csv)
* Source: [Ministere de la Sante et des Affaires Sociales](http://www.sante.gov.ml/index.php/actualites/communiques)

[Mauritius](data/mauritius_tests.csv)
* Source [Republic of Mauritius](http://www.govmu.org/English/Pages/ViewAllCommuniquecovid19.aspx)

[Mozambique](data/mozambique_tests.csv)
* Source [National Institute of Health](https://covid19.ins.gov.mz/documentos/)

[Namibia](data/namibia_tests.csv)
* Source [Ministry of Health and Social Services](https://namibiacovid19.gov.na/app-statistics)

[Niger](data/niger_tests.csv)
* Source [Ministère de la santé publique du Niger](https://twitter.com/minsanteniger?lang=en)

[Oman](data/oman_tests.csv)
* Source [Ministry of Health](https://twitter.com/OmaniMOH?ref_src=twsrc%5Etfw%7Ctwcamp%5Eembeddedtimeline%7Ctwterm%5Eprofile%3AOmaniMOH&ref_url=https%3A%2F%2Fcovid19.moh.gov.om%2F%23%2Fhome)

[Saint Kitts and Nevis](data/saint_kitts_tests.csv)
* Source [Government of St Kitts and Nevis](https://www.covid19.gov.kn/daily-reports/)

[Togo](data/togo_tests.csv)
* Source [Republique Togolaise](https://covid19.gouv.tg/situation-au-togo/)

[Zambia](data/zambia_tests.csv)
* Source [Zambia National Public Health Institute](http://znphi.co.zm/news/situation-reports-new-coronavirus-covid-19-sitreps/)
