#!/bin/bash

WORK_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "${WORK_DIR}/read_env.sh"

ENV_FILE="${WORK_DIR}/../.env"
INIT_FILE="${WORK_DIR}/../.build/mysql/init.sql"

if [ "$1" == "--rebuild=1" ]; then
  REBUILD=true
fi

if [ -f "$INIT_FILE" ] && [ "$REBUILD" != true ]; then
  echo 'MySQL init.sql file is already build. Skipping.'

  exit
fi

if [ -f "$INIT_FILE" ] && [ "$REBUILD" == true ]; then
  echo 'Re-building MySQL init.sql file'

  rm "$INIT_FILE"
else
  echo 'Building MySQL init.sql file'
fi

DB_USERNAME=$(env DB_USERNAME)
DB_PASSWORD=$(env DB_PASSWORD)
DB_SCHEMAS_LIST=()

SOURCE=''

# Create schemas and grant master user privileges
env_array DB_SCHEMAS DB_SCHEMAS_LIST
for DB_SCHEMA in "${DB_SCHEMAS_LIST[@]}"; do
  SOURCE="$SOURCE"$"CREATE DATABASE IF NOT EXISTS ${DB_SCHEMA};"$'\n'
  SOURCE="$SOURCE"$"GRANT ALL PRIVILEGES ON ${DB_SCHEMA}.* TO '${DB_USERNAME}'@'%';"$'\n\n'
done;

# Flush privileges
SOURCE="$SOURCE"$'FLUSH PRIVILEGES;'

echo "$SOURCE" > "$INIT_FILE"