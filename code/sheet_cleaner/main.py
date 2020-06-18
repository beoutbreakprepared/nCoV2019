#!/usr/bin/env python3

'''
Run all sheet cleaning scripts.
'''
testing = False

import argparse
import configparser
import logging
import socket

import geocoder
from geocoder import arcgis

import sheet_processor
from geocoding import csv_geocoder
from functions import get_GoogleSheets

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
    # Increase default timeout, 60s isn't enough for big sheets.
    socket.setdefaulttimeout(600)
    sheets = get_GoogleSheets(config)

    # Load geocoder early so that invalid tsv paths errors are caught early on.
    geocoder = csv_geocoder.CSVGeocoder(
        config['GEOCODING'].get('TSV_PATH'),
        arcgis)
    sp = sheet_processor.SheetProcessor(sheets, geocoder, config)
    sp.process()
    
    if args.push_to_git:
        sp.push_to_github()


if __name__ == '__main__':
    main()
