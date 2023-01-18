#!/usr/bin/env bash
up() {
  echo "Starting Airbyte..."
  docker-compose -f docker-compose-airbyte.yaml down -v
  docker-compose -f docker-compose-airbyte.yaml up -d

  echo "Starting Airflow..."
  docker-compose -f docker-compose-airflow.yaml down -v
  mkdir -p ./dags ./logs ./plugins
  echo -e "AIRFLOW_UID=$(id -u)\nAIRFLOW_GID=0" >> .env
  docker-compose -f docker-compose-airflow.yaml up airflow-init
  docker-compose -f docker-compose-airflow.yaml up -d
  
  echo "Starting Superset..."
  # shellcheck disable=SC2164
  cd superset
  docker-compose -f docker-compose-superset.yaml down -v
  docker-compose -f docker-compose-superset.yaml up -d
  cd ..

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte COVID connection."
  echo "Enter your Airbyte COVID connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_COVID_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_covid' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Neighbourhood connection."
  echo "Enter your Airbyte AIRBNB NEIGHBOURHOOD connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_NEIGHBOURHOOD_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_neighbourhood' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Listing connection."
  echo "Enter your Airbyte AIRBNB LISTING connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_LISTING_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_listing' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Calendar 00  connection."
  echo "Enter your Airbyte AIRBNB CALENDAR 00 connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_CALENDAR_00_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_calendar_00' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Calendar 01  connection."
  echo "Enter your Airbyte AIRBNB CALENDAR 01 connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_CALENDAR_01_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_calendar_01' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Calendar 02  connection."
  echo "Enter your Airbyte AIRBNB CALENDAR 02 connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_CALENDAR_02_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_calendar_02' --conn-uri 'airbyte://host.docker.internal:8000'

  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Calendar 03  connection."
  echo "Enter your Airbyte AIRBNB CALENDAR 03 connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_CALENDAR_03_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_calendar_03' --conn-uri 'airbyte://host.docker.internal:8000'


  echo "Access Airbyte at http://localhost:8000 and set up Airbyte Airbnb Calendar 04  connection."
  echo "Enter your Airbyte AIRBNB CALENDAR 04 connection ID: "
  read connection_id
  # Set connection ID for DAG.
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow variables set 'AIRBYTE_AIRBNB_CALENDAR_04_CONNECTION_ID' "$connection_id"
  docker-compose -f docker-compose-airflow.yaml run airflow-webserver airflow connections add 'airbyte_airbnb_calendar_04' --conn-uri 'airbyte://host.docker.internal:8000'





  echo "Access Airflow at http://localhost:8080 to kick off your Airbyte sync DAG."
  echo "Access Superset at http://localhost:8088 to set up your dashboards."
}

down() {
  echo "Stopping Airbyte..."
  docker-compose -f docker-compose-airbyte.yaml down -v
  echo "Stopping Airflow..."
  docker-compose -f docker-compose-airflow.yaml down -v
  echo "Stopping Superset..."
  docker-compose -f superset/docker-compose-superset.yaml down -v
}

case $1 in
  up)
    up
    ;;
  down)
    down
    ;;
  *)
    echo "Usage: $0 {up|down}"
    ;;
esac
