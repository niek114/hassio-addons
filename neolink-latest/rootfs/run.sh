#!/bin/bash
set -e

CONFIG_PATH=/data/options.json
CONFIG_DIR=/config
CONFIG_NAME=neolink.toml
CONFIG_FILE=${CONFIG_DIR}/${CONFIG_NAME}

MODE=$(jq --raw-output '.mode // empty' $CONFIG_PATH)
LOG=$(jq --raw-output '.log // empty' $CONFIG_PATH)

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Missing configuration file at ${CONFIG_FILE}"
    exit 1
fi

cd "$CONFIG_DIR"

case "$LOG" in
  debug)
    export RUST_LOG="neolink=debug"
    ;;
  info)
    export RUST_LOG="neolink=info"
    ;;
  warn)
    export RUST_LOG="neolink=warn"
    ;;
  error)
    export RUST_LOG="neolink=error"
    ;;
esac

case "$MODE" in
  rtsp)
    neolink rtsp --config "$CONFIG_NAME"
    ;;
  mqtt)
    neolink mqtt --config "$CONFIG_NAME"
    ;;
  dual)
    neolink mqtt-rtsp --config "$CONFIG_NAME"
    ;;
  *)
    echo "Unknown mode option"
    exit 1
    ;;
esac
