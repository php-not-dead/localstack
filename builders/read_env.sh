#!/bin/bash

env() {
  local KEY="$1"
  local VALUE

  VALUE=$(grep -E "^${KEY}=" "$ENV_FILE" | sed -e "s/^${KEY}=//")

  sed -E 's/^"(.*)"$/\1/; s/^'\''(.*)'\''$/\1/' <<< "$VALUE"
}

env_array() {
  local KEY="$1"
  local OUT_VAR="$2"
  local RAW
  local IFS=','

  RAW=$(env "$KEY")
  read -ra VALUES <<< "$RAW"

  eval "$OUT_VAR=(\"\${VALUES[@]}\")"
}