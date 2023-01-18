from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.models import Variable
import json

airbyte_airbnb_calendar_04 = Variable.get("AIRBYTE_AIRBNB_CALENDAR_04_CONNECTION_ID")

with DAG(dag_id='trigger_airbyte_airbnb_calendar_04_dbt_job',
         default_args={'owner': 'airflow'},
         schedule_interval='@daily',
         start_date=days_ago(1)
         ) as dag:
    airbyte_sync = AirbyteTriggerSyncOperator(
        task_id='airbyte_airbnb_calendar_04',
        airbyte_conn_id='airbyte_airbnb_calendar_04',
        connection_id=airbyte_airbnb_calendar_04,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )
