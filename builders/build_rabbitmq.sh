#!/bin/bash

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${WORK_DIR}/read_env.sh"

ENV_FILE="${WORK_DIR}/../.env"
TEMPLATE_FILE="${WORK_DIR}/../.build/rabbitmq/definitions.template.json"
DEFINITIONS_FILE="${WORK_DIR}/../.build/rabbitmq/definitions.json"

if [ "$1" == "--rebuild=1" ]; then
  REBUILD=true
fi

if [ -f "$DEFINITIONS_FILE" ] && [ "$REBUILD" != true ]; then
  echo 'RabbitMQ definitions.json file is already build. Skipping.'

  exit
fi

if [ -f "$DEFINITIONS_FILE" ] && [ "$REBUILD" == true ]; then
  echo 'Re-building RabbitMQ definitions.json file'

  rm "$DEFINITIONS_FILE"
else
  echo 'Building RabbitMQ definitions.json file'
fi

RABBITMQ_VERSION=$(env RABBITMQ_VERSION)
RABBITMQ_USER=$(env RABBITMQ_DEFAULT_USER)
RABBITMQ_PASS=$(env RABBITMQ_DEFAULT_PASS)

RABBITMQ_VHOSTS_LIST=()
env_array RABBITMQ_VHOSTS RABBITMQ_VHOSTS_LIST

VHOSTS_LIST=''
PERMISSIONS_LIST=''
for VHOST in "${RABBITMQ_VHOSTS_LIST[@]}"; do
    if [[ "$VHOSTS_LIST" != "" ]]; then
        VHOSTS_LIST+=","
        PERMISSIONS_LIST+=","
    fi

    VHOSTS_LIST+="{\"name\": \"${VHOST}\"}"

    PERMISSIONS_LIST+="{\"user\": \"guest\",\"vhost\": \"${VHOST}\",\"configure\": \".*\",\"write\": \".*\",\"read\": \".*\"}"
done

DELIM=$'\x1F'

sed \
    -e "s${DELIM}{RABBITMQ_VERSION}${DELIM}${RABBITMQ_VERSION}${DELIM}g" \
    -e "s${DELIM}{RABBITMQ_USER}${DELIM}${RABBITMQ_USER}${DELIM}g" \
    -e "s${DELIM}{RABBITMQ_PASS}${DELIM}${RABBITMQ_PASS}${DELIM}g" \
    -e "s${DELIM}{VHOSTS_LIST}${DELIM}${VHOSTS_LIST}${DELIM}g" \
    -e "s${DELIM}{PERMISSIONS_LIST}${DELIM}${PERMISSIONS_LIST}${DELIM}g" \
    "$TEMPLATE_FILE" > "$DEFINITIONS_FILE"
