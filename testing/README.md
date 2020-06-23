# COVID-19 Testing Data

# Testing Data Schema
Files should have the following columns in common:

nid - a unique identifier cross-referencing a source within the Global Health Data Exchange (http://ghdx.healthdata.org/) [numeric]

location_id - a unique identifier ID consistent with IHME hierarchies [numeric]

location - name of the location for which testing data is collected [character]

date - date for which data is relevant for in format dd.mm.yyyy

total_cases - total number of cases as evaluated by the source

total_tests - total cumulative tests conducted in the location as evaluated by the source

daily_tests - daily test numbers conducted on that day

tests_units - information as to the units used for the tests e.g. total tests processed, individuals tested, tests process in state laboratories

Use notes

total_tests and daily_tests are mutually exclusive fields
Days of no report are indicated with blank cells and should not be interpreted as zero
Other columns may be present in the location-specific csvs
