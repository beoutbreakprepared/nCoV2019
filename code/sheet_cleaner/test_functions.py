import unittest

import pandas as pd
import numpy as np
from pandas._testing import assert_frame_equal, assert_series_equal

from functions import duplicate_rows_per_column, trim_df, fix_sex, fix_na


class TestFunctions(unittest.TestCase):

    def test_duplicate_rows(self):
        df = pd.DataFrame(
            {"country": ["FR", "CH", "US", "JP"],
            "aggr": [np.nan, 3.0, np.nan, 2.0]})
        dup = duplicate_rows_per_column(df, col="aggr")
        want_df = pd.DataFrame(
            {"country": ["FR", "CH", "US", "JP", "CH", "CH", "JP"],
            "aggr":[np.nan] * 7})
        assert_frame_equal(dup, want_df)

    def test_duplicate_rows_one_aggr(self):
        df = pd.DataFrame(
            {"country": ["FR", "CH", "US"],
            "aggr": [np.nan, 1.0, np.nan]})
        dup = duplicate_rows_per_column(df, col="aggr")
        want_df = pd.DataFrame(
            {"country": ["FR", "CH", "US"],
            "aggr":[np.nan] * 3})
        assert_frame_equal(dup, want_df)
    
    def test_duplicate_rows_empty(self):
        df = pd.DataFrame(
            {"country": ["FR", "CH", "US"],
            "aggr":[np.nan] * 3})
        dup = duplicate_rows_per_column(df, col="aggr")
        want_df = pd.DataFrame(
            {"country": ["FR", "CH", "US"],
            "aggr":[np.nan] * 3})
        assert_frame_equal(dup, want_df)

    def test_trim_df(self):
        df = pd.DataFrame({"country": ["FR ", "  CH", " US  "]})
        dup = trim_df(df)
        want_df = pd.DataFrame({"country": ["FR", "CH", "US"]})
        assert_frame_equal(dup, want_df)

    def test_fix_sex(self):
        df = pd.DataFrame({"sex": ["NA", "", "M", "F", "male", "FEMALE"]})
        dup = fix_sex(df.sex)
        want_df = pd.DataFrame({"sex": ["NA", "", "male", "female", "male", "female"]})
        assert_series_equal(dup, want_df.sex)

    def test_fix_na(self):
        df = pd.DataFrame({"country": ["NA", "na", "", "foo", "n/A", "N/A"]})
        dup = fix_na(df.country)
        want_df = pd.DataFrame({"country": ["NA", "NA", "", "foo", "NA", "NA"]})
        assert_series_equal(dup, want_df.country)