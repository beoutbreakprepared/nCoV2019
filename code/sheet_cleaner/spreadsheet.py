'''
GoogleSheet Object
'''
import os
import pickle
import re
import string

from apiclient import errors
from google_auth_oauthlib.flow import InstalledAppFlow
from googleapiclient.discovery import build
from googleapiclient.errors import HttpError
from retry import retry

from google.auth.transport.requests import Request
from google.oauth2 import service_account


class GoogleSheet(object):
    '''
    Simple object to help added when we started getting multiple sheets.
    Attributes:
    :spreadsheetid:-> str, Google Spreadsheet ID (from url).
    :base_id: -> str, base string to generate IDs from.
    :name: -> str, sheet name.
    '''
    def __init__(self, spreadsheetid, name, base_id, token, credentials, is_service_account):
        self.spreadsheetid = spreadsheetid 
        self.name = name
        self.base_id = base_id
        self.token = token
        self.credentials = credentials
        self.is_service_account = is_service_account
        self.columns = self.get_columns()
        self.column_dict = {c:self.index2A1(i) for i,c in enumerate(self.columns)}


    def Auth(self):
        '''Gets credentials for sheet and drive API access'''

        SCOPES = ['https://www.googleapis.com/auth/spreadsheets', 
                  'https://www.googleapis.com/auth/drive']
        
        TOKEN  = self.token 
        CREDENTIALS = self.credentials 

        creds = None
        if os.path.exists(TOKEN):
            with open(TOKEN, 'rb') as token:
                creds = pickle.load(token)

        if not creds or not creds.valid:
            if creds and creds.expired and creds.refresh_token:
                creds.refresh(Request())
            else:
                if self.is_service_account:
                    creds = service_account.Credentials.from_service_account_file(
                        CREDENTIALS, scopes=SCOPES)
                else:
                    flow = InstalledAppFlow.from_client_secrets_file(
                        CREDENTIALS, SCOPES)
                    creds = flow.run_local_server(port=0)

            with open(TOKEN, 'wb') as token:
                pickle.dump(creds, token)

        return creds
	

    @retry(HttpError, tries=5, delay=10)
    def read_values(self, range_):
        '''
        Read values from Sheet and return as is
        Args : 
            range_ (str)  : range to read in A1 notation.
    
        Returns : 
            list: values from range_

    	'''
    
        service = build('sheets', 'v4', credentials=self.Auth(), cache_discovery=False)
        sheet = service.spreadsheets()
        values  = sheet.values().get(spreadsheetId=self.spreadsheetid, range=range_).execute().get('values', [])	
        if not values:
            raise ValueError("Sheet data not found")
        else:
          return values

    def insert_values(self, body, **kwargs):

        inputoption = kwargs.get('inputoption', 'USER_ENTERED')

        # Call the Sheets API
        service = build('sheets', 'v4', credentials = self.Auth())
        sheet   = service.spreadsheets()
        request = sheet.values().update(spreadsheetId=self.spreadsheetid,
                                    range=body['range'],
                                    body=body,
                                    valueInputOption=inputoption)
        response = request.execute()
        return response

    def get_columns(self):
        r = f'{self.name}!A1:AG1'
        columns = self.read_values(r)[0]
        for i, c in enumerate(columns):
                # 'country' column had disappeared
                if c.strip() == '' and columns[i-1] == 'province':
                    columns[i] = 'country'

                # some white space gets added unoticed sometimes 
                columns[i] = c.strip()
        return columns
        
    def fix_cells(self, error_table):
        ''' 
        Fix specific cells on the private sheet, based on error table. 
        Error table also needs to provide the "fix" column which is what 
        we are replacing the current value with. 
        :column_dict: map from 'column_name' to A1 notation. 
        '''
        assert 'fix' in error_table.columns
        assert 'value' in error_table.columns 
           
        fixed = 0 
        for _, error in error_table.iterrows():    
            row       = error['row']
            a1 = self.column_dict[error['column']] + row 
            range_    = '{}!{}'.format(self.name, a1) 
            
            fetch = self.read_values(f'{self.name}!A{row}') # fetch ID to ensure that it is the same.
            assert error['ID'] == fetch[0][0]
            body = { 
                'range': range_,
                'majorDimension': 'ROWS',
                'values': [[error['fix']]]
            }   
            self.insert_values(body)
            fixed += 1
        
        return fixed

    def index2A1(self, num: int) -> str:
        '''
        Converts column index to A1 notation. 
    
        Args: 
            num (int) : column index
        Returns :
            A1 notation (str)
    
        '''
        alpha = string.ascii_uppercase
        if 0 <= num <= 25:
            return alpha[num]
        elif 26 <= num <= 51:
            return 'A{}'.format(alpha[num%26])
        elif 52 <= num <= 77:
            return 'B{}'.format(alpha[num%26])
        else:
            raise ValueError('Could not convert index "{}" to A1 notation'.format(num))



class Template(GoogleSheet):
    def __init__(self, spreadsheetid, token, credentials, is_service_account): 
        super().__init__(spreadsheetid, "", "", token, credentials, is_service_account)
        self.responses = {}

    def copy(self, copy_title, worksheet,  emailto):
        """Copy an existing file.

        Args:
            service: Drive API service instance.
            origin_file_id: ID of the origin file to copy.
            copy_title: Title of the copy.

        Returns:
        The copied file if successful, None otherwise.
         """
        service =  build('drive', 'v3', credentials=self.Auth(), cache_discovery=False)
        body = {
                'name': copy_title, 
                'title': copy_title,
                'writersCanShare': True, 
                }
        request = service.files().copy(fileId=self.spreadsheetid, body=body)
        create_response = request.execute()
        
        
        message = "A new COVID-19 Sheet has been created!\n"
        message += f"https://docs.google.com/spreadsheets/d/{create_response['id']}/"

        permissions = {
            "type": "group", 
            "role": "writer",
            "emailAddress": emailto,
        }

        request = service.permissions().create(
            fileId=create_response['id'],
            body=permissions,
            fields='id',
            emailMessage=message,
            sendNotificationEmail = True
        )
        print(create_response)
        permissions_response = request.execute()
        name_response = self.rename_sheet(create_response['id'],
                            worksheet)

        return {'create': create_response, 
                'permissions': permissions_response,
                'name' : name_response}
        
    def rename_sheet(self, spreadsheetId, new_name, sheet_id=0):
        
        body = {
            'requests': [
                {
                    'updateSheetProperties': {
                        "properties": {
                            "sheetId": sheet_id,
                            "title": new_name
                        },
                        "fields": "title"
                    }
                }
            ]
        }

        service = build('sheets', 'v4', credentials=self.Auth(),
                        cache_discovery=False).spreadsheets()
        request = service.batchUpdate(spreadsheetId=spreadsheetId, body=body)
        return request.execute()
