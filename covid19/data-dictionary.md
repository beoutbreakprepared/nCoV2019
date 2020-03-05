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

| Variable                   | Code                                                                           |
|----------------------------|--------------------------------------------------------------------------------|
| `id`                       | Integer                                                                        |
| `age`                      | String: `AGE` or `AGE-AGE` where `AGE` matches `[0-9]{1,2}`                    |
| `sex`                      | String: either `male` or `female`                                              |
| `city`                     | String                                                                         |
| `province`                 | String                                                                         |
| `country`                  | String                                                                         |
| `latitude`                 | Double                                                                         |
| `longitude`                | Double                                                                         |
| `geo_resolution`           | String: `point` or matches `admin[0123]{1}`                                    |
| `date_onset_symptoms`      | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `date_admission_hospital`  | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `date_confirmation`        | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
| `symptoms`                 | String                                                                         |
| `lives_in_wuhan`           | String: `yes` or `no`                                                          |
| `travel_history_dates`     | String: `DATE` or `DATE - DATE*` or `- DATE` where `DATE` matches `DD.MM.YYYY` |
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

## Data Completeness

| Variable                   | Proportion Complete | Dataset                          |
|----------------------------|---------------------|----------------------------------|
| `id`                       |            1.000000 | `data/clean-hubei.csv`           |
| `id`                       |            1.000000 | `data/clean-outside-hubei.csv`   |
| `age`                      |            0.023187 | `data/clean-hubei.csv`           |
| `age`                      |            0.095426 | `data/clean-outside-hubei.csv`   |
| `sex`                      |            0.009768 | `data/clean-hubei.csv`           |
| `sex`                      |            0.088961 | `data/clean-outside-hubei.csv`   |
| `city`                     |            1.000000 | `data/clean-hubei.csv`           |
| `city`                     |            1.000000 | `data/clean-outside-hubei.csv`   |
| `province`                 |            1.000000 | `data/clean-hubei.csv`           |
| `province`                 |            0.991020 | `data/clean-outside-hubei.csv`   |
| `country`                  |            1.000000 | `data/clean-hubei.csv`           |
| `country`                  |            0.998563 | `data/clean-outside-hubei.csv`   |
| `latitude`                 |            1.000000 | `data/clean-hubei.csv`           |
| `latitude`                 |            1.000000 | `data/clean-outside-hubei.csv`   |
| `longitude`                |            1.000000 | `data/clean-hubei.csv`           |
| `longitude`                |            1.000000 | `data/clean-outside-hubei.csv`   |
| `geo_resolution`           |            1.000000 | `data/clean-hubei.csv`           |
| `geo_resolution`           |            0.999401 | `data/clean-outside-hubei.csv`   |
| `date_onset_symptoms`      |            0.009373 | `data/clean-hubei.csv`           |
| `date_onset_symptoms`      |            0.057471 | `data/clean-outside-hubei.csv`   |
| `date_admission_hospital`  |            0.004045 | `data/clean-hubei.csv`           |
| `date_admission_hospital`  |            0.063099 | `data/clean-outside-hubei.csv`   |
| `date_confirmation`        |            0.918204 | `data/clean-hubei.csv`           |
| `date_confirmation`        |            0.989344 | `data/clean-outside-hubei.csv`   |
| `symptoms`                 |            0.003848 | `data/clean-hubei.csv`           |
| `symptoms`                 |            0.037835 | `data/clean-outside-hubei.csv`   |
| `lives_in_wuhan`           |            0.003848 | `data/clean-hubei.csv`           |
| `lives_in_wuhan`           |            0.054239 | `data/clean-outside-hubei.csv`   |
| `travel_history_dates`     |            0.000000 | `data/clean-hubei.csv`           |
| `travel_history_dates`     |            0.047055 | `data/clean-oGAutside-hubei.csv` |
| `travel_history_location`  |            0.000000 | `data/clean-hubei.csv`           |
| `travel_history_location`  |            1.000000 | `data/clean-outside-hubei.csv`   |
| `reported_market_exposure` |            0.000099 | `data/clean-hubei.csv`           |
| `reported_market_exposure` |            0.008980 | `data/clean-outside-hubei.csv`   |
| `additional_information`   |            0.002171 | `data/clean-hubei.csv`           |
| `additional_information`   |            0.068127 | `data/clean-outside-hubei.csv`   |
| `chronic_disease_binary`   |            0.002171 | `data/clean-hubei.csv`           |
| `chronic_disease_binary`   |            0.001796 | `data/clean-outside-hubei.csv`   |
| `chronic_disease`          |            0.002072 | `data/clean-hubei.csv`           |
| `chronic_disease`          |            0.002035 | `data/clean-outside-hubei.csv`   |
| `source`                   |            1.000000 | `data/clean-hubei.csv`           |
| `source`                   |            0.991739 | `data/clean-outside-hubei.csv`   |
| `sequence_available`       |            0.000197 | `data/clean-hubei.csv`           |
| `sequence_available`       |            0.000120 | `data/clean-outside-hubei.csv`   |
| `outcome`                  |            0.004144 | `data/clean-hubei.csv`           |
| `outcome`                  |            0.009339 | `data/clean-outside-hubei.csv`   |
| `date_death_or_discharge`  |            0.004045 | `data/clean-hubei.csv`           |
| `date_death_or_discharge`  |            0.006346 | `data/clean-outside-hubei.csv`   |
| `notes_for_discussion`     |            0.000000 | `data/clean-hubei.csv`           |
| `notes_for_discussion`     |            0.010177 | `data/clean-outside-hubei.csv`   |
| `location`                 |            0.000000 | `data/clean-hubei.csv`           |
| `location`                 |            0.020235 | `data/clean-outside-hubei.csv`   |
| `admin3`                   |            0.025555 | `data/clean-hubei.csv`           |
| `admin3`                   |            0.112428 | `data/clean-outside-hubei.csv`   |
| `admin2`                   |            0.974544 | `data/clean-hubei.csv`           |
| `admin2`                   |            0.835848 | `data/clean-outside-hubei.csv`   |
| `admin1`                   |            1.000000 | `data/clean-hubei.csv`           |
| `admin1`                   |            0.991379 | `data/clean-outside-hubei.csv`   |
| `country_new`              |            1.000000 | `data/clean-hubei.csv`           |
| `country_new`              |            1.000000 | `data/clean-outside-hubei.csv`   |
| `admin_id`                 |            1.000000 | `data/clean-hubei.csv`           |
| `admin_id`                 |            1.000000 | `data/clean-outside-hubei.csv`   |
| `dataset`                  |            1.000000 | `data/clean-hubei.csv`           |
| `dataset`                  |            1.000000 | `data/clean-outside-hubei.csv`   |
