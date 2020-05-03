# LINE LIST DATA INPUT PROTOCOLS FOR DATA CURATORS

EFFECTIVE DATE: 14.04.2020

**Author**

Name: Bernardo Gutierrez

Title: Regional Data Coordinator

Date: 14.04.2020

**Reviewed by**

Name: Alexander Zarebski

Title: Data Validation Moderator

Date: 14.04.2020

**Authorised by**

Name: Bernardo Gutierrez

Title: Regional Data Coordinator

Date: 14.04.2020

- [LINE LIST DATA INPUT PROTOCOLS FOR DATA CURATORS](#line-list-data-input-protocols-for-data-curators)
  - [Objective](#objective)
  - [Protocol](#protocol)
    - [SOURCES OF INFORMATION](#sources-of-information)
      - [Task list system](#task-list-system)
      - [Areas of responsibility system](#areas-of-responsibility-system)
    - [PROCEDURES](#procedures)
      - [General formats](#general-formats)
      - [Data input in the line list](#data-input-in-the-line-list)
        - [Backfilling aggregated->per-case data](#backfilling-aggregated-per-case-data)
      - [Information registration in the Task list](#information-registration-in-the-task-list)
      - [Contributor details](#contributor-details)

## Objective

This Standard Operating Procedure (SOP) describes the protocols for inputting data of individual confirmed cases of COVID-19 directly into our shared online spreadsheets (currently hosted as Google Spreadsheets).

## Protocol

### SOURCES OF INFORMATION

#### Task list system
The Task list is a centralised list of tasks to be completed by the data curators. Based on this task list, curators enter the detailed information into the line list. This task list simplifies assigning particular data sources to particular curators, a.k.a. the Areas of responsibility system. Under this system, data curators are NOT responsible for the maintenance and editing of the Task list. Managing the task list is the responsibility of the file coordinator, and the details are described in a separate SOP.

#### Areas of responsibility system
The Areas of responsibility system is based on the assignment of specific
regions/countries/states/provinces as a direct responsibility of an individual data curator, who is in charge of maintaining up-to-date data for the assigned areas. In these instances, the Task list tab (on the spreadsheet) is used as a log where each curator inputs the information of the data that has been included in the line list, for auditing purposes.

- The file coordinator assigns each data curator one or several regions, countries, states and/or provinces, which are agreed upon by both parties.
- The file coordinator and data curator determine the appropriate official or unofficial sources for the data to be recorded:
  - This system favours the use of official daily reports of new cases or other official sources of disaggregated information.
  - Alternatively, or in addition to official reports, unofficial sources of information can also be used, including news sources or social media posts from verified Public Health agencies if they are are deemed reliable by the file coordinator.
- The data curator will input the new case report data of their area of responsibility daily, following the format described in Section 2.
  - Upon completing the daily update, the data curator will summarise the information registered in the Task list to maintain an updated log of the information available in the line list.

### PROCEDURES

#### General formats
Here are some general formats to be used in all of the tables:

- **Language**: in order to homogenise data input across multiple regions, we’re logging all information in English (this applies to the terminology used and spelling; e.g.: spelling `Brazil` instead of `Brasil`).
- **Accentos and special characters**: No accents or special characters are to be used in the data input, this guarantees the universal applicability of the codes that automatically update our public data bases and maps (e.g.: spell `Tucuman` instead of `Tucumán`, `Braco do Norte` instead of `Braço do Norte`, `Sudliche Weinstrasse` instead of `Südliche Weinstraße`).
- **Dates**: the date format used is `DD.MM.YYYY` (e.g., the 26th of March, 2020 is logged as `26.03.2020`). If there is a range of dates used, then separate these values by a hyphen (e.g., `25.03.2020-27.03.2020`).
- **Location names**: where possible, please ensure that the spelling and capitalisation of countries, provinces and cities follows that of any existing instances in the table.
- **Ages**: represented as an digits or, if an age bracket, then digits separated by a hyphen, e.g., `3`, for three years of age or `40-49` if the patient is in their 40s.
- **Sex**: use either `male` or `female`.
- **Symptoms and chronic disease**: entered as a colon separated list, for example, a patient with fever and cough would have their symptoms entered as “fever:cough”. A patient with pre-existing hypertension and diabetes would be described with `hypertension:diabetes`. Colons are used instead of commas so it is easy to export this data as CSV.

#### Data input in the line list

The procedure to log individual case data is the following:

- Identify the information regarding new cases for a specific date (either from the Task list or the curator’s area(s) of responsibility), and enter the name of
the country under country in a number of cells which is equivalent to the count of new cases. Each row corresponds to a new, individual case.
- Based on the available information from the data source, fill in the remaining cells corresponding to these key columns:
  - `city`: the city where the new case is registered (leave blank if the city is
not known).
  - `province`: the province, department or state where the new case is
registered (leave blank if not known).
  - `country`: the country where the new case is registered following the
information above
  - `date_confirmation`: the date in which the new case was confirmed as explicitly stated in the report, or the date of the report from which the information is obtained in the format described above.
  - `source`: the source of information from which the information is
obtained (web address/URL or the name of the report, if it is not available
online).
  - `aggregated_num_cases`: number of cases that this row refers to. Only enter this if no case-level data is available, they all share the same available information and chances of being able to go back in time to fill-in more demographic data is very unlikely.
- Additionally, add the demographic and/or clinical information available for each individual new case in the remaining fields (it’s important to consider that each individual line contains information about a particular case, so the priority is to maintain consistency in the logged information to an individual level – if information is presented in an aggregated manner and there is no way to disaggregate in a logical and consistent way, refrain from adding this information):
  - `age`: the age of the patient. If this information is presented as an approximation, log the age range (e.g. for a patient in their 40s, the age information is logged as 40-49). See above for details.
  - `sex`: whether the patient is male or female.
  - `date_onset_symptoms`: date in which the patient presented disease symptoms. See details above
  - `date_admission_hospital`: date in which the patient was admitted to a hospital or healthcare facility.
  - `symptoms`: list (separated by colons) of symptoms reported for the patient. See above for details
  - `travel_history_binary`: log a value of one `1` if the report mentions the patient’s recent travel history, a value of zero `0` if the report states that the patient has NO recent travel history, and leave blank if the report makes no mention of the patient’s travel history.
  - `travel_history_dates`: reported date in which the patient returned from their travel, or range of dates that encompass the patient’s travel history separated by a hyphen `-`, with no added blank spaces.
  - `travel_history_location`: location(s) that the patient visited recently under the format `{city]/{region}:{country}`. If multiple locations are mentioned, separate these with hyphens `-`, with no added blank spaces.
  - `additional_information`: any additional information presented for the case.
  - `chronic_disease_binary`: log a value of one `1` if the report mentions any chronic disease or pre-existing health condition for the patient, a value of zero `0` if the report explicitly states that the patient had no chronic diseases of pre-existing health conditions or leave blank if the report doesn’t mention any chronic disease or pre-existing health conditions.
  - `chronic_disease`: describe the chronic disease(s) or pre-existing health condition(s) mentioned in the report, using the same format as for symptoms, see above for details.

##### Backfilling aggregated->per-case data

In the event per-case data is made available for cases that were inputed using the `aggregated_num_cases`, you should for each case:
1. copy the corresponding row containing the aggregated_num_cases column set
1. set per-case information that was missing in the new row
1. clear aggregated_num_cases in new row
1. decrease original aggregated_num_cases by one

#### Information registration in the Task list

After logging the information in the line list, register the summarised logged information in the Task list following this procedure:

- When using the Areas of responsibility system, add a new line under the correct date under the Task column, indicating the number of new cases and the country where they were registered.
- Add the website/URL or name of the report where the information was obtained (if not available online) under the Source column.
- Add an indicator (i.e. ‘Yes’) signalling that the information was added in its totality under the Resolved column. If there are any unsolved or pending information or any issues that came up, describe them here.
- Add the initials of the data curator who logged the information I the line list under the Curator column.
- When using the Task list system, only follow steps 3 and 4.

#### Contributor details

To ensure that people get credited for the work they do, we keep a table of the contributors’ details: name, affiliation, ORCID, and email address. This will not be made public and is only kept for administrative tasks.
