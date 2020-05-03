date_columns = [
    'date_onset_symptoms',
    'date_admission_hospital',
    'date_confirmation',
    'travel_history_dates',
    'date_death_or_discharge',
]


# REGEX PATTERNS
anchor_wrap = lambda s: f"^{s}$"
boolean_or  = lambda l : "|".join([f'({x})' for x in l])
na_string   = 'NA'
rgx_empty   = '^$'

rgx_na_value = anchor_wrap(na_string)

rgx_single_age = "(0|[1-9]{1}[0-9]{0,2})"
rgx_age_range  = "{}-{}".format(rgx_single_age, rgx_single_age)
rgx_date_      = r"[0-9]{2}\.[0-9]{2}\.20(19|20)"
rgx_date_range = f"{rgx_date_} - {rgx_date_}"
rgx_left_date_range  = f"- {rgx_date_}"
rgx_right_date_range = f"{rgx_date_} -"
date_patterns = [rgx_date_, rgx_date_range, rgx_left_date_range, rgx_right_date_range]

rgx_age        = anchor_wrap(boolean_or([rgx_single_age, rgx_age_range, na_string, rgx_empty]))
rgx_sex        = anchor_wrap(boolean_or(['male', 'female', na_string, rgx_empty]))
rgx_date       = anchor_wrap(boolean_or(date_patterns+[na_string, rgx_empty]))
rgx_lives_in_wuhan = anchor_wrap(boolean_or(["yes", "no", rgx_na_value, rgx_empty]))

column_to_type = {
    "age": "string",
    "sex": "string",
    "city": "string",
    "province": "string",
    "country": "string",
    "date_onset_symptoms": "string",
    "date_admission_hospital": "string",
    "date_confirmation": "string",
    "symptoms": "string",
    # Should be bool really but lot of info is on business trips to Wuhan
    # etc, better kept as a string.
    "lives_in_Wuhan": "string",
    "travel_history_dates": "string",
    "travel_history_location": "string",
    "additional_information": "string",
    "chronic_disease_binary": "bool",
    "chronic_disease": "string",
    "source": "string",
    "outcome": "string",
    "date_death_or_discharge": "string",
    "notes_for_discussion": "string",
    "travel_history_binary": "bool",
}