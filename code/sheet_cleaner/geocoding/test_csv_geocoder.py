import unittest
from geocoding import csv_geocoder
import pathlib
import os
import io
import geocoder
from typing import NamedTuple

class FakeResult(NamedTuple):
    ok: bool
    lat: float
    lng: float

class TestCSVGeocoder(unittest.TestCase):

    def setUp(self):
        mapping = {
            "some, where, far": FakeResult(ok=True, lat=42.42, lng=43.43),
            "some, where, toofar": FakeResult(ok=False, lat=0, lng=0),
        }
        cur_dir = pathlib.Path(__file__).parent.absolute()
        self.geocoder = csv_geocoder.CSVGeocoder(
            os.path.join(cur_dir, "geo_admin.tsv"),
            mapping.get)

    def test_found(self):
        geo = self.geocoder.geocode("Sunac City, Shangcheng, Changchun City", "Jilin", "China")
        self.assertAlmostEqual(geo.lat, 43.8296097)
        self.assertAlmostEqual(geo.lng, 125.25924)
        self.assertEqual(geo.geo_resolution, "point")
        self.assertEqual(geo.country_new, "China")
        self.assertEqual(geo.location, "Sunac City, Shangcheng")
        self.assertEqual(geo.admin1, "Jilin")
        self.assertEqual(geo.admin2, "Changchun City")
        self.assertEqual(geo.admin3, "Chaoyang District")
        self.assertCountEqual(set(), self.geocoder.misses)

    def test_not_found(self):
        self.assertIsNone(self.geocoder.geocode("foo", "bar", "baz"))
        self.assertIsNone(self.geocoder.geocode("foo", "bar", "baz"))
        self.assertEqual(
            [(csv_geocoder.Triple("foo", "bar", "baz"), 2)],
            self.geocoder.misses.most_common(1))

    def test_fallback(self):
        geo = self.geocoder.geocode("some", "where", "far")
        self.assertAlmostEqual(geo.lat, 42.42)
        self.assertAlmostEqual(geo.lng, 43.43)
        self.assertEqual(geo.geo_resolution, "point")
        self.assertCountEqual(set(), self.geocoder.misses)
        # Check that we can append the new geocodes to a tsv file.
        file = io.StringIO("")
        self.geocoder.append_new_geocodes_to_init_file(file)
        self.assertEqual('some;where;far\t42.42\t43.43\tpoint\t\t\t\t\tfar\r\n', file.getvalue())
    
    def test_fallback_not_ok(self):
        self.assertIsNone(self.geocoder.geocode("some", "where", "toofar"))
        self.assertEqual(
            [(csv_geocoder.Triple("some", "where", "toofar"), 1)],
            self.geocoder.misses.most_common(1))

    def test_write_to_csv(self):
        self.assertIsNone(self.geocoder.geocode("foo", "bar", "baz"))
        file = io.StringIO("")
        self.geocoder.write_misses_to_csv(file)
        self.assertEqual('foo,bar,baz,1\r\n', file.getvalue())