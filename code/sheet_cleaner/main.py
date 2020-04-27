#!/usr/bin/env python3

'''Run all sheet cleaning scripts.'''
import argparse
import configparser
import logging
import os
import time

import pandas as pd

from functions import (duplicate_rows_per_column, fix_na, fix_sex,
                       generate_error_tables, get_GoogleSheets, trim_df,
                       values2dataframe)
from geocoding import csv_geocoder
from sheet_processor import SheetProcessor

parser = argparse.ArgumentParser(
    description='Cleanup sheet and output generation script')
parser.add_argument('-c', '--config_file', type=str, default="CONFIG",
                    help='Path to the config file')
parser.add_argument('-p', '--push_to_git', default=False, const=True, action="store_const", dest='push_to_git',
                    help='Whether to push to the git repo specified in the config')

def main():
    args = parser.parse_args()
    config = configparser.ConfigParser()
    config.optionxform=str # to preserve case
    config.read(args.config_file) 
    logging.basicConfig(
        format='%(asctime)s %(filename)s:%(lineno)d %(message)s',
        filename='cleanup.log', filemode="w", level=logging.INFO)
    
    geocoder = csv_geocoder.CSVGeocoder(config['GEOCODING'].get('TSV_PATH'))
    sheets = get_GoogleSheets(config)

    processor = SheetProcessor(sheets, geocoder, config)
    processor.process()

    if args.push_to_git:
        processor.push_to_github()


if __name__ == '__main__':
    main()
