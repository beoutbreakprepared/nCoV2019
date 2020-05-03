#!/usr/bin/env python3

import argparse
import logging
import configparser
from spreadsheet import Template, GoogleSheet
import re

parser = argparse.ArgumentParser(
    description='Create new sheet from template')
parser.add_argument('-c', '--config_file', type=str, default="CONFIG",
                    help='Path to the config file')
parser.add_argument('-n', '--name', type=str, default='COVID-19 Open Line List',
                    help='name of new spreadsheet')
parser.add_argument('-w', '--worksheet', type=str, default='Data',
        help='name of new (work)sheet')

args = parser.parse_args()
config = configparser.ConfigParser()
config.optionxform=str # preserve case
config.read(args.config_file)

def main():
    token = config['SHEETS'].get('TOKEN')
    credentials = config['SHEETS'].get('CREDENTIALS')
    temp_sid = config['TEMPLATE'].get('SID')
    is_service_account = True
    email = config['TEMPLATE'].get('EMAILTO')

    # Create new sheet
    TEMPLATE = Template(temp_sid, token, credentials, is_service_account)
    response = TEMPLATE.copy(args.name, args.worksheet, email)

    # Update Config file 
    sheet_sections = []
    for s in config.sections():
        if s not in ['SHEET0', 'SHEET1'] and re.match(r'^SHEET\d*$', s):
            sheet_sections.append(s)
    
    max_num = max([int(re.search(r'SHEET(\d*)', s).group(1)) for s in sheet_sections])
    max_id  = max([int(config[s]['ID']) for s in sheet_sections])
    sheet_str = 'SHEET' + str(max_num + 1)
    new_id    = (str(max_id + 1)).zfill(3)
    
    config.add_section(sheet_str)
    config[sheet_str]['NAME'] = args.name 
    config[sheet_str]['SID'] = response['create']['id']
    config[sheet_str]['ID'] = new_id
    with open(args.config_file, 'w') as F:
        config.write(F)
    
    # Update reference sheet 
    ref_info = config['REFERENCE']
    ref_sid  = ref_info.get('SID')
    ref_name = ref_info.get('NAME')
    ref = GoogleSheet(ref_sid, ref_name, None,
            token, credentials, is_service_account)
    rowNum = len(ref.read_values(ref.name + '!A:A')) + 1
    URL = 'https://docs.google.com/spreadsheets/d/{}/'.format(response['create']['id'])
    new_values = [
            args.name, 
            args.worksheet,
            "'" + new_id, # "'" keeps 00
            response['create']['id'],
            URL
    ]

    body = {
        'range': f'{ref_name}!A{rowNum}:E{rowNum}',
        'majorDimension': 'ROWS',
        'values': [new_values]
    }
    ref.insert_values(body)
    

if __name__ == '__main__':
    main()
