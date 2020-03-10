'''
Library for Google Sheets functions. 
'''
from constants import *
from googleapiclient.discovery import build
from google_auth_oauthlib.flow import InstalledAppFlow
from google.auth.transport.requests import Request
import pickle
import os
import pandas as pd
import re 


def read_values(sheetid, range_, config):
    # returns values read from a google sheet, as is. 
    
    SCOPES = ['https://www.googleapis.com/auth/spreadsheets.readonly']
    TOKEN  = config['token']
    CREDENTIALS = config['credentials']
    
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(TOKEN): 
        with open(TOKEN, 'rb') as token:
            creds = pickle.load(token)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                CREDENTIALS, SCOPES)
            creds = flow.run_local_server(port=0)

        # Save the credentials for the next run
        with open(TOKEN, 'wb') as token:
            pickle.dump(creds, token)

    service = build('sheets', 'v4', credentials=creds)

    # Call the Sheets API
    sheet   = service.spreadsheets()
    values  = sheet.values().get(spreadsheetId=sheetid, range=range_).execute().get('values', [])

    if not values:
        raise ValueError('Sheet data not found')
    else:
        return values
    
def insert_values(sheetid, body, config, **kwargs):
    '''
    Insert values into spreadsheet. 
    range should be included in body. 
    example body:
    body = {
        'range': 'SheetName!A1:A3',
        'majorDimension': 'ROWS',
        'values': [[1], [2], [3]]
    }
    '''
    
    SCOPES = ['https://www.googleapis.com/auth/spreadsheets']
    TOKEN       = config['token']
    CREDENTIALS = config['credentials']
    INPUTOPTION = kwargs['inputoption'] if 'inputoption' in kwargs.keys() else 'USER_ENTERED'
    
    # values = list
    # placement = A1 notation range.
    creds = None
    # The file token.pickle stores the user's access and refresh tokens, and is
    # created automatically when the authorization flow completes for the first
    # time.
    if os.path.exists(TOKEN): 
        with open(TOKEN, 'rb') as token:
            creds = pickle.load(token)

    # If there are no (valid) credentials available, let the user log in.
    if not creds or not creds.valid:
        if creds and creds.expired and creds.refresh_token:
            creds.refresh(Request())
        else:
            flow = InstalledAppFlow.from_client_secrets_file(
                CREDENTIALS, SCOPES)
            creds = flow.run_local_server(port=0)

        # Save the credentials for the next run
        with open(TOKEN, 'wb') as token:
            pickle.dump(creds, token)

    service = build('sheets', 'v4', credentials=creds)

    # Call the Sheets API
    sheet   = service.spreadsheets()
    request = sheet.values().update(spreadsheetId=sheetid,
                                    range=body['range'],
                                    body=body, 
                                    valueInputOption=INPUTOPTION)
    response = request.execute()
    return response

def values2dataframe(values):
    '''
    Convert raw values as retrieved from read_values to a pandas dataframe
    Adds a "row" number going off the assumption that we are reading from the top. 
    '''
    columns = values[0] 
    ncols   = len(columns)
    data    = values[1:]
    for d in data:
        if len(d) < ncols:
            extension = ['']*(ncols-len(d))
            d.extend(extension)
    data    = pd.DataFrame(data=data, columns=columns)
    data['row'] = list(range(2, len(data)+2)) # keeping row number (+1 for 1 indexing +1 for column headers in sheet)
    data['row'] = data['row'].astype(str)
        
    return data

def index2A1(num):
    if 0 <= num <= 25:
        return alpha[num]
    elif 26 <= num <= 51:
        return 'A{}'.format(alpha[num%26])
    elif 52 <= num <= 77:
        return 'B{}'.format(alpha[num%26])
    else:
        raise ValueError('Could not convert index "{}" to A1 notation'.format(num))
        
def get_trailing_spaces(data):
    '''
    Generate error table for trailing whitespaces (front and back).
    return: error_table[row, ID, column_name, value].
    '''
    # fix trailing spaces.  This applies to all columns except "row"
    df = data.copy() 
    
    error_table = pd.DataFrame(columns=['row', 'ID', 'column', 'value', 'fix'])
    for c in df.columns:
        if c == 'row':
            continue
        else:
            stripped = df[c].str.strip()
            invalid_bool = stripped != df[c]
            invalid      = df[invalid_bool][['row', 'ID']].copy()
            invalid['column'] = c
            invalid['value'] = df[c][invalid_bool].copy()
            invalid['fix'] = stripped[invalid_bool]
        error_table = error_table.append(invalid, ignore_index=True, sort=True)        
    return error_table


def get_NA_errors(data):
    '''
    Generate error table for mispelled NA values.  
    We chose to write them as "NA", and so far we only
    replace "N/A" with "NA"
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

def fix_cells(sheetid, sheetname, error_table, column_dict, config):
    '''
    Fix specific cells on the private sheet, based on error table. 
    Error table also needs to provide the "fix" column which is what 
    we are replacing the current value with. 
    :column_dict: map from 'column_name' to A1 notation. 
    '''
    assert 'fix' in error_table.columns
    assert 'value' in error_table.columns 
    
    fixed = 0
    for i,error in error_table.iterrows():      
        row       = error['row']
        a1 = column_dict[error['column']] + row
        range_    = '{}!{}'.format(sheetname, a1)
        try:
            fetch = read_values(sheetid, f'{sheetname}!A{row}', config) # fetch ID to ensure that it is the same.
            assert error['ID'] == fetch[0][0]
            body = {
                'range': range_,
                'majorDimension': 'ROWS',
                'values': [[error['fix']]]
            }
            insert_values(sheetid, body, config)
            fixed += 1
            
        except Exception as E:
            print(error)
            print(fetch)
            raise E
    return fixed


def generate_error_tables(data):
    '''
    Generate table for fields that don't pass the rgex tests. 
    For easy fixes (e.g. spacing) we can do it automatically, for tricker ones we save the table (fixed ones are omitted in error_report)
    '''
    table = pd.DataFrame(columns=['row', 'ID', 'value'])
    table = ErrorTest(data, ['age'], rgx_age, table)
    table = ErrorTest(data, ['sex'], rgx_sex, table)
    table = ErrorTest(data, ['city', 'province', 'country'], rgx_country, table)
    table = ErrorTest(data, ['latitude', 'longitude'], rgx_latlong, table)
    table = ErrorTest(data, ['geo_resolution'], rgx_geo_res, table)
    table = ErrorTest(data, date_columns, rgx_date, table)
    table = ErrorTest(data, ['lives_in_Wuhan'], rgx_lives_in_wuhan, table)
    fixable_errors = pd.DataFrame(columns=['row', 'ID', 'column', 'value', 'fix'])

    not_fixable = []
    for i, r in table.iterrows():
        row = r.copy()
        fix = False
        col = row['column']
        if col == 'sex':
            test = row['value'].lower().strip() in ['male', 'female', '']
            if test:
                fix = row['value'].lower().strip()

        elif col == 'age':
            test = bool(re.match(rgx_age, row['value'].replace(' ', '')))
            if test:
                fix = row['value'].replace(' ', '')

        elif col  == 'country':
            pass

        elif col in ['latitude', 'longitude']:
            pass

        elif col == 'geo_resolution':
            s = row['value']
            test = bool(re.match(rgx_geo_res, s.replace(' ', '')))
            if test:
                fix = s.replace(' ', '')

        elif col in date_columns:
            pass

        elif col == 'lives_in_Wuhan':
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
      
    fixable   = fixable_errors.reset_index()
    unfixable = table.loc[not_fixable].copy().reset_index()
    
    return [fixable, unfixable]

def update_id_column(sheetid, sheetname, config, new=5000):
    '''
    Updates the ID column in private sheet. 
    --> inputs function in to 5000 next blank cells. 
    '''
    range_ = f'{sheetname}!A:A' # ID column
    ids    = read_values(sheetid, range_, config)
    nrows  = len(ids)  # 2
    
    start = nrows + 1
    end   = start + new
    
    entries  = []
    template = "=IF(NOT(ISBLANK({}!F{})), A{}+1, )"
    for i in range(start, end+1):
        string = template.format(sheetname, i, i-1)
        entries.append(string)
    
    body = {
        'range': f'{sheetname}!A{start}:A{end}',
        'majorDimension': 'ROWS',
        'values': [[x] for x in entries]
    }
    
    response = insert_values(sheetid, body, config)
    
    return response


def update_lat_long_columns(sheetid, sheetname, config):
    '''
    Input Lookup function into lat/long columns that have associated IDs
    '''
    # figure out range, based on ids I guess. 
    id_range_  = f'{sheetname}!A:A'
    lat_range_ = f'{sheetname}!H:H'
    lon_range_ = f'{sheetname}!I:I'
    geo_range_ = f'{sheetname}!J:J'
    
    ids  = read_values(sheetid, id_range_, config)
    lats = read_values(sheetid, lat_range_, config)
    lons = read_values(sheetid, lon_range_, config)
    geos = read_values(sheetid, geo_range_, config)
    
    assert len(geos) == len(lats) == len(lons), 'columns H-J have different lengths'
    assert len(ids) >= len(geos), 'ID column has less values than coordinate columns'
 
    # figure out how many new entries we need. 
    N_new = len(ids) - len(geos)
    start = len(geos) + 1 # number for first row to insert in. 
    end   = start + N_new # last row. 
    
    # make entries 
    htemplate = '=IFNA(VLOOKUP(D{}&";"&E{}&";"&F{},geo_admin!I:S,3, false),)'
    itemplate = '=IFNA(VLOOKUP(D{}&";"&E{}&";"&F{},geo_admin!I:S,4, false),)'
    jtemplate = '=IFNA(VLOOKUP(D{}&";"&E{}&";"&F{},geo_admin!I:S,5, false),)'
    entries = []
    for row in range(start, end):
        h = htemplate.format(row, row, row)
        i = itemplate.format(row, row, row)
        j = jtemplate.format(row, row, row)
        entries.append([h, i, j])
        
    body = {
        'range': f'{sheetname}!H{start}:J{end}',
        'majorDimension': 'ROWS',
        'values': entries
    }
        
    response = insert_values(sheetid, body, config)
    
    return response

def update_admin_columns(sheetid, sheetname, config):
    '''
    Input function into columns AA-AF.
    '''
    range0 = f'{sheetname}!A:A' # ids
    ranges = ['{}!A{}:A{}'.format(sheetname, x, x) for x in ['A', 'B', 'C', 'D', 'E', 'F']]
        
    ids    = read_values(sheetid, range0, config)
    values = [read_values(sheetid, r, config) for r in ranges]
    max_   = max([len(x) for x in values])
    
    N_new = len(ids) - max_
    start = max_  + 1
    end   = start + N_new
    
    template = '=IFNA(VLOOKUP(D{}&";"&E{}&";"&F{},geo_admin!I:S,REPLACEME, false), )'
    templates = [template.replace('REPLACEME', str(i)) for i in range(6,12)]
    
  
    entries = []
    for row in range(start, end):
        entry = [t.format(row, row, row) for t in templates]
        entries.append(entry)
        
    body = {
        'range': f'{sheetname}!AA{start}:AF{end}',
        'majorDimension': 'ROWS',
        'values': entries
    }
        
    response = insert_values(sheetid, body, config)
    
    return response
