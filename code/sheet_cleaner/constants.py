alpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'  # for a1 notation conversion


date_columns = ['date_onset_symptoms', 'date_admission_hospital', 'date_confirmation',
                'travel_history_dates', 'date_death_or_discharge']


# REGEX PATTERNS
anchor_wrap = lambda s: f"^{s}$"
boolean_or  = lambda l : "|".join([f'({x})' for x in l])
na_string   = 'NA'
rgx_empty   = '^$'

rgx_na_value = anchor_wrap(na_string)

rgx_single_age = "(0|[1-9]{1}[0-9]{0,2})"
rgx_age_range  = "{}-{}".format(rgx_single_age, rgx_single_age)
rgx_date_      = "[0-9]{2}\\.[0-9]{2}\\.20(19|20)"
rgx_date_range = f"{rgx_date_} - {rgx_date_}"
rgx_left_date_range  = f"- {rgx_date_}"
rgx_right_date_range = f"{rgx_date_} -"
date_patterns = [rgx_date_, rgx_date_range, rgx_left_date_range, rgx_right_date_range]

rgx_age        = anchor_wrap(boolean_or([rgx_single_age, rgx_age_range, na_string, rgx_empty]))
rgx_sex        = anchor_wrap(boolean_or(['male', 'female', na_string, rgx_empty]))
rgx_country    = anchor_wrap(boolean_or(["[A-Z]{1}[a-z]+(\\s[A-Z]{1}[a-z]+)*", na_string, rgx_empty]))
rgx_latlong    = anchor_wrap(boolean_or(["-?[0-9]+(\\.[0-9]+)?", na_string, rgx_empty]))
rgx_geo_res    = anchor_wrap(boolean_or(["point", "admin[0123]{0,1}", na_string, rgx_empty]))
rgx_date       = anchor_wrap(boolean_or(date_patterns+[na_string, rgx_empty]))
rgx_lives_in_wuhan = anchor_wrap(boolean_or(["yes", "no", rgx_na_value, rgx_empty]))
