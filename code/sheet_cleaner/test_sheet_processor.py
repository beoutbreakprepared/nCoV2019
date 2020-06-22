import configparser
import os
import pathlib
import tempfile
import unittest
import tarfile
from collections import defaultdict
from typing import NamedTuple
from unittest.mock import MagicMock, patch

from geocoding import csv_geocoder
from sheet_processor import SheetProcessor
from spreadsheet import GoogleSheet


class FakeResult(NamedTuple):
    ok: bool
    lat: float
    lng: float

class TestSheetProcessor(unittest.TestCase):

    @patch('spreadsheet.GoogleSheet')
    def test_ok(self, mock_sheet):
        with tempfile.TemporaryDirectory() as tmpdirname:
            os.mkdir(os.path.join(tmpdirname, 'latest_data'))
            os.mkdir(os.path.join(tmpdirname, 'error_reports'))
            open(os.path.join(tmpdirname, "latestdata.csv"), 'w').close()
            with tarfile.open(os.path.join(tmpdirname, "latestdata.tar.gz"), "w:gz") as tar:
                tar.add(os.path.join(tmpdirname, "latestdata.csv"), arcname="latestdata.csv")

            mapping = defaultdict(FakeResult)

            cur_dir = pathlib.Path(__file__).parent.absolute()
            geocoder = csv_geocoder.CSVGeocoder(os.path.join(cur_dir, "geocoding", "geo_admin.tsv"), mapping.get)
            
            mock_sheet.name = "sheet-name"
            mock_sheet.base_id = "000"
            mock_sheet.read_values = MagicMock(side_effect=[
                # Only one read is done in this test.
                # First row has columns only, voluntarily in a random order so that we check that the code doesn't depend on column ordering.
                # Second row has the data.
                [
                    ["age","sex","city","province","country","aggregated_num_cases","date_onset_symptoms","date_admission_hospital","date_confirmation","symptoms","lives_in_Wuhan","travel_history_dates","travel_history_location","reported_market_exposure","additional_information","chronic_disease_binary","chronic_disease","source","sequence_available","outcome","date_death_or_discharge","notes_for_discussion","data_moderator_initials","travel_history_binary", 'longitude', 'latitude', 'admin1', 'location', 'admin3', 'admin2', 'geo_resolution', 'country_new', 'admin_id'],
                    ["24", "male","cit","pro","coun","4","20.04.2020","21.04.2020","20.04.2020","symp","no","","","","handsome guy","0","","fake","0","discharged","25.04.2020","","TF","0", '14.15', '16.17', 'admin1', 'loc', 'admin3', 'admin2', 'point', 'France', '42'],
                ],
            ])
            processor = SheetProcessor([mock_sheet], geocoder, tmpdirname)
            processor.process()
            # Checking that no exception is raised is fine for now.
            # We could also check for output files in tmpdirname later on.
