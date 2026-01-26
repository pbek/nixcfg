#!/usr/bin/env nix-shell
#!nix-shell -i bash -p lm_sensors bc
# shellcheck shell=bash
# CPU Temperature and Fan Speed Monitor
# Displays CPU temperatures and fan speeds every 2 seconds

set -e

# Log file configuration
LOG_FILE="${HOME}/.cache/cpu-monitor.log"
MAX_LOG_ENTRIES=60

# Ensure log directory exists
mkdir -p "$(dirname "$LOG_FILE")"

# Colors for better readability
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color
BOLD='\033[1m'

# Check if sensors command is available
if ! command -v sensors &>/dev/null; then
  echo -e "${RED}Error: 'sensors' command not found.${NC}"
  echo "Please ensure lm_sensors is installed."
  echo "On NixOS, add 'lm_sensors' to your system packages."
  exit 1
fi

# Function to display header
print_header() {
  clear
  echo -e "${BOLD}${BLUE}╔════════════════════════════════════════════════════════════╗${NC}"
  echo -e "${BOLD}${BLUE}║         CPU Temperature & Fan Speed Monitor               ║${NC}"
  echo -e "${BOLD}${BLUE}║                   Press Ctrl+C to exit                    ║${NC}"
  echo -e "${BOLD}${BLUE}╚════════════════════════════════════════════════════════════╝${NC}"
  echo -e "${BOLD}Log file:${NC} $LOG_FILE"
  echo ""
}

# Function to log measurement to file (keep only last 20)
log_measurement() {
  local timestamp="$1"
  shift
  local temp_values=("$@")

  # Separate temps and fans
  local temps=""
  local fans=""
  local collecting_temps=true

  for item in "${temp_values[@]}"; do
    if [[ "$item" == "FANS_START" ]]; then
      collecting_temps=false
      continue
    fi

    if [ "$collecting_temps" = true ]; then
      # Keep format as "Label:value°C"
      if [ -z "$temps" ]; then
        temps="${item}"
      else
        temps="${temps}, ${item}"
      fi
    else
      # Keep format as "Label:valueRPM" or "Label:N/A"
      # Remove "RPM" suffix if present for cleaner format
      item="${item//RPM/}"
      if [ -z "$fans" ]; then
        fans="${item}"
      else
        fans="${fans}, ${item}"
      fi
    fi
  done

  # Create log entry with format: [timestamp] Temps: ... | Fans: ...
  local log_entry="[$timestamp] Temps: ${temps} | Fans: ${fans}"

  # Append to log file
  echo "$log_entry" >>"$LOG_FILE"

  # Keep only last 20 lines
  local temp_file="${LOG_FILE}.tmp"
  tail -n "$MAX_LOG_ENTRIES" "$LOG_FILE" >"$temp_file"
  mv "$temp_file" "$LOG_FILE"
}

# Function to colorize temperature values
colorize_temp() {
  local temp=$1
  if (($(echo "$temp >= 80" | bc -l))); then
    echo -e "${RED}${temp}°C${NC}"
  elif (($(echo "$temp >= 60" | bc -l))); then
    echo -e "${YELLOW}${temp}°C${NC}"
  else
    echo -e "${GREEN}${temp}°C${NC}"
  fi
}

# Function to display sensor data
display_sensors() {
  local timestamp
  timestamp=$(date '+%Y-%m-%d %H:%M:%S')
  echo -e "${BOLD}Timestamp:${NC} $timestamp"
  echo ""

  # Get sensor output
  local sensor_output
  sensor_output=$(sensors 2>/dev/null)

  # Arrays to collect data for logging
  local temp_data=()
  local fan_data=()

  # Extract and display CPU temperatures
  echo -e "${BOLD}${BLUE}CPU Temperatures:${NC}"
  while IFS= read -r line; do
    # Extract temperature value
    temp_value=$(echo "$line" | grep -oP '\+\K[0-9]+\.[0-9]+' | head -1)
    if [ -n "$temp_value" ]; then
      colored_temp=$(colorize_temp "$temp_value")
      label=$(echo "$line" | cut -d':' -f1 | sed 's/^[ \t]*//')
      echo -e "  ${label}: ${colored_temp}"
      # Collect for logging
      temp_data+=("${label}:${temp_value}°C")
    fi
  done < <(echo "$sensor_output" | grep -E "(Core|Tctl|Tdie|CPU Temperature)")

  # Extract and display Package/CPU temperature if available
  while IFS= read -r line; do
    temp_value=$(echo "$line" | grep -oP '\+\K[0-9]+\.[0-9]+' | head -1)
    if [ -n "$temp_value" ]; then
      colored_temp=$(colorize_temp "$temp_value")
      echo -e "  ${BOLD}Package Temperature:${NC} ${colored_temp}"
      # Collect for logging
      temp_data+=("Package:${temp_value}°C")
    fi
  done < <(echo "$sensor_output" | grep -i "Package id")

  echo ""
  echo -e "${BOLD}${BLUE}Fan Speeds:${NC}"

  # Extract and display fan speeds
  local fan_found=false
  while IFS= read -r line; do
    fan_found=true
    fan_label=$(echo "$line" | cut -d':' -f1 | sed 's/^[ \t]*//')
    fan_speed=$(echo "$line" | grep -oP '[0-9]+(?= RPM)')
    if [ -n "$fan_speed" ]; then
      echo -e "  ${fan_label}: ${GREEN}${fan_speed} RPM${NC}"
      # Collect for logging
      fan_data+=("${fan_label}:${fan_speed}RPM")
    else
      echo -e "  ${fan_label}: ${YELLOW}N/A${NC}"
      fan_data+=("${fan_label}:N/A")
    fi
  done < <(echo "$sensor_output" | grep -i "fan")

  # Check if any fans were found
  if [ "$fan_found" = false ]; then
    echo -e "  ${YELLOW}No fan sensors detected${NC}"
    fan_data+=("No fans detected")
  fi

  echo ""
  echo -e "${BLUE}════════════════════════════════════════════════════════════${NC}"

  # Log the measurement
  log_measurement "$timestamp" "${temp_data[@]}" "FANS_START" "${fan_data[@]}"
}

# Main loop
while true; do
  print_header
  display_sensors
  sleep 2
done
