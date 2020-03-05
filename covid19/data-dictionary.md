# Data Dictionary

## Variable Names

| Variable                   | Description                                                                 |
|----------------------------|-----------------------------------------------------------------------------|
| `id`                       | Unique identifier of case                                                   |
| `age`                      | Age or age range of case                                                    |
| `sex`                      | Sex of the case                                                             |
| `city`                     | City of the case                                                            |
| `province`                 | Province of the case                                                        |
| `country`                  | Country of the case                                                         |
| `latitude`                 | The latitude of the location of the case                                    |
| `longitude`                | The longitude of the location of the case                                   |
| `geo_resolution`           | The resolution to which the location of the case is known                   |
| `date_onset_symptoms`      | The date when the patient started to experience symptoms                    |
| `date_admission_hospital`  | The date when the patient was admitted to hospital                          |
| `date_confirmation`        | The date at which infection with SARS-COV-2 was confirmed                   |
| `symptoms`                 | Symptoms of the patient                                                     |
| `lives_in_wuhan`           | Whether the individual lives in Wuhan                                       |
| `travel_history_dates`     | Dates at which the individual was travelling                                |
| `travel_history_location`  | Locations the individual traveled to                                        |
| `reported_market_exposure` | Whether the individual was known to have been exposed at the seafood market |
| `additional_information`   | Additional information data curators have found                             |
| `chronic_disease_binary`   | Whether the patient had a preexisting chronic disease                       |
| `chronic_disease`          | The nature of a preexisting chronic disease                                 |
| `source`                   | The source where the information was obtained                               |
| `sequence_available`       | Whether a sequence of the virus is available                                |
| `outcome`                  | How the infection resolved in the patient                                   |
| `date_death_or_discharge`  | Whether the patient was discharged or died                                  |
| `notes_for_discussion`     | Further free form notes                                                     |
| `location`                 | Additional location data                                                    |
| `admin3`                   | Additional location data                                                    |
| `admin2`                   | Additional location data                                                    |
| `admin1`                   | Additional location data                                                    |
| `country_new`              | Additional location data                                                    |
| `admin_id`                 | Additional location data                                                    |

## Variable Coding

### `hubei-20200301.csv`

| Variable                   | Code                                                                           |
|----------------------------|--------------------------------------------------------------------------------|
| `id`                       | Integer                                                                        |
| `age`                      | String: `AGE` or `AGE-AGE` where `AGE` matches `[0-9]{1,2}`                    |
| `sex`                      | String: either `male` or `female`                                              |
| `city`                     | String                                                                         |
| `province`                 | String: `Hubei`                                                                |
| `country`                  | String: `China`                                                                |
| `latitude`                 | Double                                                                         |
| `longitude`                | Double                                                                         |
| `geo_resolution`           | String: `point`                                                                |
| `date_onset_symptoms`      | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `date_admission_hospital`  | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `date_confirmation`        | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `symptoms`                 | String                                                                         |
| `lives_in_wuhan`           | String: `yes` or `no`                                                          |
| `travel_history_dates`     | String                                                                         |
| `travel_history_location`  | String                                                                         |
| `reported_market_exposure` | String                                                                         |
| `additional_information`   | String                                                                         |
| `chronic_disease_binary`   | Integer: `0` or `1`                                                            |
| `chronic_disease`          | String                                                                         |
| `source`                   | String: URL                                                                    |
| `sequence_available`       | String: `yes` or `no`                                                          |
| `outcome`                  | String: `discharged` or `died`                                                 |
| `date_death_or_discharge`  | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `notes_for_discussion`     | String                                                                         |
| `location`                 |                                                                                |
| `admin3`                   |                                                                                |
| `admin2`                   |                                                                                |
| `admin1`                   |                                                                                |
| `country_new`              |                                                                                |
| `admin_id`                 |                                                                                |

## Missing Codes

| Value | Meaning            |
|-------|--------------------|
| NA    | Data not available |
