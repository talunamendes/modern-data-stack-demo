from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.models import Variable
import json

airbyte_airbnb_listing = Variable.get("AIRBYTE_AIRBNB_LISTING_CONNECTION_ID")

with DAG(dag_id='trigger_airbyte_airbnb_listing_dbt_job',
         default_args={'owner': 'airflow'},
         schedule_interval='@daily',
         start_date=days_ago(1)
         ) as dag:
    airbyte_sync = AirbyteTriggerSyncOperator(
        task_id='airbyte_airbnb_listing',
        airbyte_conn_id='airbyte_airbnb_listing',
        connection_id=airbyte_airbnb_listing,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )
