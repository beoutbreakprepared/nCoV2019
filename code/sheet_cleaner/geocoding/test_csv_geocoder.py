import unittest
from geocoding import csv_geocoder
import pathlib
import os
import io

class TestCSVGeocoder(unittest.TestCase):

    def setUp(self):
        cur_dir = pathlib.Path(__file__).parent.absolute()
        self.geocoder = csv_geocoder.CSVGeocoder(os.path.join(cur_dir, "geo_admin.tsv"))

    def test_found(self):
        geo = self.geocoder.Geocode("Sunac City, Shangcheng, Changchun City", "Jilin", "China")
        self.assertAlmostEqual(geo.lat, 43.8296097)
        self.assertAlmostEqual(geo.lng, 125.25924)
        self.assertEqual(geo.geo_resolution, "point")
        self.assertEqual(geo.country_new, "China")
        self.assertEqual(geo.admin_id, 220104)
        self.assertEqual(geo.location, "Sunac City, Shangcheng")
        self.assertEqual(geo.admin1, "Jilin")
        self.assertEqual(geo.admin2, "Changchun City")
        self.assertEqual(geo.admin3, "Chaoyang District")
        self.assertCountEqual(set(), self.geocoder.misses)

    def test_not_found(self):
        self.assertIsNone(self.geocoder.Geocode("foo", "bar", "baz"))
        self.assertIsNone(self.geocoder.Geocode("foo", "bar", "baz"))
        self.assertEqual(
            [(csv_geocoder.Triple("foo", "bar", "baz"), 2)],
            self.geocoder.misses.most_common(1))
    
    def test_write_to_csv(self):
        self.assertIsNone(self.geocoder.Geocode("foo", "bar", "baz"))
        file = io.StringIO("")
        self.geocoder.WriteMissesToFile(file)
        self.assertEqual('foo,bar,baz,1\r\n', file.getvalue())