#!/usr/bin/env bash
set -e

# Directory where this script is located
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"


IDF_PATH="$(realpath "$SCRIPT_DIR/../../v5.5/esp-idf")"

# Use the standard ESP-IDF hello_world example
PROJECT_DIR="$IDF_PATH/examples/get-started/hello_world"

# Serial port used for flashing
PORT="${1:-/dev/ttyACM0}"

echo "Script dir:    $SCRIPT_DIR"
echo "Using ESP-IDF: $IDF_PATH"
echo "Using project: $PROJECT_DIR"
echo "Using port:    $PORT"

source "$IDF_PATH/export.sh"

# Disable ESP-WHO extra actions for normal ESP-IDF projects
unset IDF_EXTRA_ACTIONS_PATH

# Copy project-specific defaults into the hello_world example
cp "$SCRIPT_DIR/sdkconfig.defaults" "$PROJECT_DIR/sdkconfig.defaults"

cd "$PROJECT_DIR"

idf.py fullclean || true

# Set the build target to ESP32-P4
idf.py set-target esp32p4
idf.py build

# Flash the firmware and open the serial monitor
idf.py -p "$PORT" flash monitor