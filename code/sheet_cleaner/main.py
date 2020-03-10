'''
Run all sheet cleaning scripts.
'''
from functions import *
from constants import *
from datetime import datetime
import time
import os


config = {
    'token': 'path/to/google/api/token.pickle',
    'credentials' : 'path/to/google/api/credentials.json'
    'data_path'   : '../../dataset_archive/'
    'error_path'  : '../../error_reports/'
}



privateid = ''                         # Private sheet ID. 
publicid  = ''                         # Public sheet ID
sheets    = ['outside_Hubei', 'Hubei']




sleeptime = 10                         # time between api requests (for rate limiting)
add       = 5000                       # number of ID rows to prepare.

def main():
    for s in sheets:
        ### Input Functions ###
        update_id_column(privateid, s, config, new=add)
        time.sleep(sleeptime) # rest a bit incase of limits. 

        update_lat_long_columns(privateid, s, config)
        time.sleep(sleeptime)

        update_admin_columns(privateid, s, config)
        time.sleep(sleeptime)

      
        ### Clean Private Sheet Entries. ###
        # note : private sheet gets updated on the fly and redownloaded to ensure continuity between fixes (granted its slower).
        range_      = f'{s}!A:AG'
        values      = read_values(privateid, range_, config)
        columns     = values[0]
        column_dict = {c:index2A1(i) for i,c in enumerate(columns)} # to get A1 notation, doing it now to ensure proper order
        data        = values2dataframe(values)

        # Trailing Spaces
        trailing = get_trailing_spaces(data)
        if len(trailing) > 0:
            fix_cells(privateid, s, trailing, column_dict, config)
            values = read_values(privateid, range_, config)
            data   = values2dataframe(values)
            time.sleep(sleeptime)

        # fix N/A => NA
        na_errors = get_NA_errors(data)
        if len(na_errors) > 0:
            fix_cells(privateid, s, na_errors, column_dict, config)
            values = read_values(privateid, range_, config)
            data   = values2dataframe(values)
            time.sleep(sleeptime)

         # Regex fixes
        fixable, non_fixable = generate_error_tables(data)
        if len(fixable) > 0:
            fix_cells(privateid, s, fixable, column_dict, config)
            values = read_values(privateid, range_, config)
            data   = values2dataframe(values)
            time.sleep(sleeptime)

        # Save error_report and data to csv files
        dt = datetime.now().strftime('%d%m%YT%H%M%S')
        data_file   = os.path.join(config['data_path'],  f'{s}_data.{dt}.csv')
        error_file  = os.path.join(config['error_path'], f'{s}.error-report.csv')

        non_fixable.sort_values(by='row').to_csv(error_file, index=False, header=True)                                  
        data.drop('row', axis=1).sort_values(by='ID').to_csv(data_file, index=False, header=True)

        
        # Copy private to public
        # Read in 1 more time to be certain we have everything
        #private_values = read_values(privateid, s, config)
        #body = {
        #        'range': s,
        #        'majorDimension': 'ROWS',
        #        'values': values
        #    }
        #insert_values(publicid, body, config)
        
if __name__ == '__main__':
    main()
