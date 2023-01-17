from airflow import DAG
from airflow.utils.dates import days_ago
from airflow.providers.airbyte.operators.airbyte import AirbyteTriggerSyncOperator
from airflow.models import Variable
import json

airbyte_airbnb_neighbourhood = Variable.get("AIRBYTE_AIRBNB_NEIGHBOURHOOD_CONNECTION_ID")
airbyte_airbnb_listing = Variable.get("AIRBYTE_AIRBNB_LISTING_CONNECTION_ID")
airbyte_airbnb_calendar = Variable.get("AIRBYTE_AIRBNB_CALENDAR_CONNECTION_ID")

with DAG(dag_id='trigger_airbyte_airbnb_dbt_job',
         default_args={'owner': 'airflow'},
         schedule_interval='@daily',
         start_date=days_ago(1)
         ) as dag:
    airbyte_sync = AirbyteTriggerSyncOperator(
        task_id='airbyte_airbnb_neighbourhood',
        airbyte_conn_id='airbyte_airbnb_neighbourhood',
        connection_id=airbyte_airbnb_neighbourhood,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    airbyte_sync2 = AirbyteTriggerSyncOperator(
        task_id='airbyte_airbnb_listing',
        airbyte_conn_id='airbyte_airbnb_listing',
        connection_id=airbyte_airbnb_listing,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )

    airbyte_sync3 = AirbyteTriggerSyncOperator(
        task_id='airbyte_airbnb_calendar',
        airbyte_conn_id='airbyte_airbnb_calendar',
        connection_id=airbyte_airbnb_calendar,
        asynchronous=False,
        timeout=3600,
        wait_seconds=3
    )
