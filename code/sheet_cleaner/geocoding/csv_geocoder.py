"""This package contains a geocoder based on the former sheets VLOOKUP impl.

It uses a dump of the geo_admin sheet to csv to load all the locations in
memory and allows for fast access.
"""

from typing import NamedTuple, Dict
from collections import Counter
import csv
import logging

class Triple(NamedTuple):
    """Triple used in input and misses lookup."""
    city: str
    province: str
    country: str

class Geocode(NamedTuple):
    """Geocode contains geocoding information about a location."""
    lat: float
    lng: float
    geo_resolution: str
    country_new: str
    admin_id: int
    location: str
    admin3: str
    admin2: str
    admin1: str

_INPUT_ROW = 0
_LAT_ROW = 1
_LNG_ROW = 2
_GEO_RESOLUTION_ROW = 3
_LOCATION_ROW = 4
_ADMIN3_ROW = 5
_ADMIN2_ROW = 6
_ADMIN1_ROW = 7
_COUNTRY_NEW_ROW = 8

class CSVGeocoder:
    def __init__(self, init_csv_path: str, fallback):
        # Build a giant map of concatenated strings for fast lookup.
        # Do not try to be smart, just replicate whatever the spreadsheet was
        # doing. Data's so small it can all fit in memory and allow for fast
        # lookups.
        # Args:
        #  - init_csv_path: file to read geocodes from
        #  - fallback: function to geocode missing places.
        self.geocodes :Dict[str, Geocode] = {}
        # Geocodes that were added during this run.
        self.new_geocodes :Dict[Geocode]= {}
        self._fallback = fallback
        self._init_csv_path = init_csv_path
        with open(init_csv_path, newline="", encoding='utf-8') as csvfile:
            # Delimiter is \t instead of , because google spreadsheets were
            # exporting lat,lng with commas, leading to an invalid number of
            # columns per row :(
            rows = csv.reader(csvfile, delimiter="\t")
            for i, row in enumerate(rows):
                geocode = Geocode(
                    float(row[_LAT_ROW]),
                    float(row[_LNG_ROW]),
                    row[_GEO_RESOLUTION_ROW],
                    row[_COUNTRY_NEW_ROW],
                    i+1,
                    row[_LOCATION_ROW],
                    row[_ADMIN3_ROW],
                    row[_ADMIN2_ROW],
                    row[_ADMIN1_ROW])
                self.geocodes[row[_INPUT_ROW].lower()] = geocode
        logging.info("Loaded %d geocodes from %s", len(self.geocodes), init_csv_path)
        self.misses = Counter()

    @property
    def tsv_path(self):
        return self._init_csv_path
        

    def geocode(self, city :str="", province :str="", country :str="") -> Geocode:
        """Geocode matches the given locations to their Geocode information
        
        At least one of city, province, country must be set.

        Returns:
            None if no exact match were found.
        """
        key = f"{city};{province};{country}".lower()
        geocode = self.geocodes.get(key)
        if not geocode:
            # Try to geocode.
            query = ", ".join([a for a in [city, province, country] if a])
            g = self._fallback(query)
            if not g or not g.ok:
                logging.warning("Could not geocode %s", query)
                self.misses.update([Triple(city, province, country)])
                return None
            new_geocode = Geocode(
                g.lat,
                g.lng,
                "point",
                country,
                len(self.geocodes) + len(self.new_geocodes),  # temp admin_id
                "", # location
                "", # admin3
                "",  # admin2
                "")  # admin1
            self.new_geocodes[key] = new_geocode
            self.geocodes[key] = new_geocode
            return new_geocode
        return geocode

    def write_misses_to_csv(self, file):
        """Writes misses as csv to a file.
        Columns are 'city', 'province', 'country', 'count'.
        """
        writer = csv.writer(file)
        for triple in self.misses:
            writer.writerow([triple.city, triple.province, triple.country, self.misses[triple]])

    def append_new_geocodes_to_init_file(self, file):
        """Writes newly geocoded places to the geo_admin master file."""
        writer = csv.writer(file, delimiter="\t")
        for key in self.new_geocodes:
            geocode = self.new_geocodes[key]
            writer.writerow([
                key,
                geocode.lat,
                geocode.lng,
                geocode.geo_resolution,
                geocode.location,
                geocode.admin3,
                geocode.admin2,
                geocode.admin1,
                geocode.country_new,
            ])