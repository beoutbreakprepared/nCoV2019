from gs_quant.session import GsSession, Environment
from gs_quant.data import Dataset
from datetime import date
import os

client_id = os.environ['GS_CLIENT_ID']
client_secret = os.environ['GS_CLIENT_SECRET']

GsSession.use(Environment.PROD, client_id=client_id, client_secret=client_secret, scopes=('read_product_data'))

datasets = [('COVID19_COUNTRY_DAILY_WHO', 'daily_who_by_country'),
            ('COVID19_US_DAILY_CDC', 'daily_cdc_us'),
            # ('COVID19_SUBDIVISION_DAILY_CDC', 'daily_cdc_state'), I got a 403 error on this data set
            ('COVID19_COUNTRY_DAILY_ECDC', 'daily_ecdc_by_country'),
            ('COVID19_COUNTRY_DAILY_WIKI', 'daily_wikipedia_by_country'),
            ('COVID19_COUNTRY_INTRADAY_WIKI', 'intraday_wikipedia_by_country'),
            ('COVID19_ONLINE_ASSESSMENTS_NHS', 'nhs_online_assessments'),
            ('COVID19_PHONE_TRIAGES_NHS', 'nhs_phone_triages'),
            ('COVID19_US_DAILY_NYT', 'daily_nyt_us'),
            ('COVID19_KOREA_DAILY_KCDC', 'daily_kcdc_korea'),
            # ('COVID19_JAPAN_DAILY_MHLW', 'daily_mhlw_japan'), I got a 403 error
            ('COVID19_ITALY_DAILY_DPC', 'daily_italy_hpc'),
            ('COVID19_COUNTRY_DAILY_GOOGLE', 'daily_google_by_country')]

for (id,name) in datasets:
    dataset = Dataset(id)
    data_frame = dataset.get_data()
    data_frame.to_csv(f"output/{name}.tsv", sep='\t', encoding='utf-8')
