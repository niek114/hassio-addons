#!/bin/bash
set -e

CONFIG_PATH=/data/options.json
CONFIG_DIR=/config
CONFIG_NAME=neolink.toml
CONFIG_FILE=${CONFIG_DIR}/${CONFIG_NAME}

MODE=$(jq --raw-output '.mode // empty' $CONFIG_PATH)
LOG=$(jq --raw-output '.log // empty' $CONFIG_PATH)

if [ -f "/homeassistant/addons/neolink.toml" ]; then
    echo "Migrating '/homeassistant/addons/neolink.toml' to '/addon_configs/a14d3924_neolink-latest/neolink.toml'"
    cp /homeassistant/addons/neolink.toml /config/
    mv /homeassistant/addons/neolink.toml /homeassistant/addons/neolink.toml.migrated
fi

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Missing configuration file at ${CONFIG_FILE}"
    exit 1
fi

cd "$CONFIG_DIR"

echo "--- VERSIONS ---"
echo "App version: 0.1.0"
echo -n "neolink version: " && neolink --version
echo "neolink mode: ${MODE}"
echo "neolink log: ${LOG}"
echo "ATTENTION: if you expected a newer Neolink version, please reinstall this App!"
echo "--- Neolink ---"

case $LOG in
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
  *)
    echo -n "Unknown log level"
    ;;
esac

case $MODE in
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
    echo -n "Unknown mode option"
    ;;
esac
