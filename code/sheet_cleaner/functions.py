'''
Library for Google Sheets functions. 
'''
import configparser
import os
import pickle
import logging
import re
import math
from string import ascii_uppercase 

from typing import List

import pandas as pd
import numpy as np 

from constants import rgx_age, rgx_sex, rgx_date, rgx_lives_in_wuhan, date_columns, column_to_type
from spreadsheet import GoogleSheet


def get_GoogleSheets(config: configparser.ConfigParser, creds_file: str, is_service_account: bool) -> List[GoogleSheet]:
    '''
    Loop through different sheets in config file, and init objects.

    Args : 
        config (ConfigParser) : configuration

    Returns :
        values (list) : list of GoogleSheet objects.
    '''
    # Fetch all sections in config referring to sheets.
    sheets = []
    pattern = r'^SHEET\d*$'
    sections = config.sections()
    for s in sections:
        if re.match(pattern, s):
            id_ = config[s]['ID']
            sid = config[s]['SID']
            name = config[s]['NAME']
            googlesheet = GoogleSheet(sid, name, id_, 
                    creds_file + '.pickle',
                    creds_file,
                    is_service_account)

            sheets.append(googlesheet)
    return sheets

    

def values2dataframe(values: list) -> pd.DataFrame:
    '''
    Convert raw values as retrieved from read_values to a pandas dataframe.
    Adds empty values so that all lists have the same length. 
    
    Args:
        values (list) : list of lists with values from read_values

    Returns:
        data (pd.DataFrame): same data with stripped column names.
    
    '''
    columns = values[0] 
    for i, c in enumerate(columns):
        # added when column name disappeared.
        if c.strip() == '' and columns[i-1] == 'province':
            columns[i] = 'country'

    ncols = len(columns)
    data = values[1:]
    for d in data:
        if len(d) < ncols:
            extension = ['']*(ncols-len(d))
            d.extend(extension)
    data = pd.DataFrame(data=data, columns=columns)
    for col in column_to_type:
        if col in columns:
            data[col] = data[col].astype(column_to_type[col], errors="ignore")
    # keeping row number (+1 for 1 indexing +1 for column headers in sheet)
    data['row'] = list(range(2, len(data)+2))
    data['row'] = data['row'].astype(str)
        
    # added the strip due to white space getting inputed somehow. 
    return data.rename({c : c.strip() for c in data.columns}, axis=1)

def index2A1(num: int) -> str:
    '''
    Converts column index to A1 notation. 

    Args: 
        num (int) : column index
    Returns :
        A1 notation (str)

    TODO: expand this for any number of columns (recursive function?)
    '''
    if 0 <= num <= 25:
        return ascii_uppercase[num]
    elif 26 <= num <= 51:
        return 'A{}'.format(ascii_uppercase[num%26])
    elif 52 <= num <= 77:
        return 'B{}'.format(ascii_uppercase[num%26])
    else:
        raise ValueError('Could not convert index "{}" to A1 notation'.format(num))

def get_NA_errors(data: pd.DataFrame) -> pd.DataFrame:
    '''
    Generate error table for mispelled NA values.  
    We chose to write them as "NA", and so far we only
    fix = replace "N/A" with "NA"
    return error_table[row, ID, column, value, fix
    '''
    df = data.copy()
    table = pd.DataFrame(columns=['row', 'ID', 'column', 'value', 'fix'])
    for c in df.columns:
        if c == 'row':
            continue
        else:
            test   = df[c].str.match('N/A')
            errors = df[test][['row', 'ID']]
            errors['column'] = c
            errors['value'] = df[test][c]
            errors['fix'] = df[test][c].replace('N/A', 'NA')
            table = table.append(errors, ignore_index=True, sort=True)
    return table

def ErrorTest(data, columns, rgx, table):
    '''
    Test a regex pattern on passed columns, generate error table
    for things that did not pass the test. 
    Note this does not generate the fix.  We do this after.
    '''
    df = data.copy()
    for c in columns:
        test = df[c].str.match(rgx)
        invalid = df[~test][['row', "ID"]].copy()
        invalid['column'] = c
        invalid['value']  = df[~test][c]
        table = table.append(invalid, ignore_index=True, sort=False)
    return table

def generate_error_tables(data):
    '''
    Generate table for fields that don't pass the rgex tests. 
    For easy fixes (e.g. spacing) we can do it automatically, for tricker ones we save the table (fixed ones are omitted in error_report)
    '''
    table = pd.DataFrame(columns=['row', 'ID', 'value'])
    table = ErrorTest(data, ['age'], rgx_age, table)
    table = ErrorTest(data, ['sex'], rgx_sex, table)
    table = ErrorTest(data, date_columns, rgx_date, table)
    table = ErrorTest(data, ['lives_in_Wuhan'], rgx_lives_in_wuhan, table)
    fixable_errors = pd.DataFrame(columns=['row', 'ID', 'column', 'value', 'fix'])

    not_fixable = []
    for _, r in table.iterrows():
        row = r.copy()
        fix = False
        col = row['column']
        if col == 'lives_in_Wuhan':
            s = row['value']
            test1 = bool(re.match(rgx_lives_in_wuhan, s.lower().strip()))
            test2 = True if s in ['1', '0'] else False
            if test1:
                fix = s.lower().strip()
            elif test2:
                fix = 'yes' if s == '1' else 'no'


        if fix:
            row['fix'] = fix
            fixable_errors = fixable_errors.append(row, ignore_index=True, sort=False)
        else:
            not_fixable.append(r.name)
      
    fixable   = fixable_errors.reset_index(drop=True)
    unfixable = table.loc[not_fixable].copy().reset_index(drop=True)
    
    return [fixable, unfixable]



def duplicate_rows_per_column(df: pd.DataFrame, col: str) -> pd.DataFrame:
    """Duplicate rows based on the integer number in 'col' if > 0.
    Changes the data frame in place, returned col will only contain nan."""
    concats = []
    for i, row in df.iterrows():
        if math.isnan(row[col]) or row[col] <= 0:
            continue
        num = int(row[col])
        row[col] = np.nan
        df.at[i, 'aggr'] = np.nan
        # Only append if num is > 1, curators input 1 sometimes.
        if num > 1:
            dupes = [row] * (num - 1)
            concats.extend(dupes)
    if concats:
        return df.append(concats, ignore_index=True)
    return df

def trim_df(df: pd.DataFrame) -> pd.DataFrame:
    """Trims whitespace from all columns/rows in the dataframe."""
    for col in df.convert_dtypes().select_dtypes("string"):
        df[col] = df[col].str.strip()
    return df

def _fix_sex(val: str) -> str:
    low_val = val.lower()
    if low_val == "m":
        return "male"
    elif low_val == "f":
        return "female"
    elif low_val == "female" or low_val == "male":
        return low_val
    return val

def fix_sex(sex_col: pd.Series) -> pd.Series:
    """Fixes various ways of spelling male/female."""
    return sex_col.map(_fix_sex)

def _fix_na(val: str) -> str:
    up_val = val.upper()
    if up_val == "N/A":
        return "NA"
    elif up_val == "NA":
        return "NA"
    return val

def fix_na(col: pd.Series) -> pd.Series:
    return col.map(_fix_na)