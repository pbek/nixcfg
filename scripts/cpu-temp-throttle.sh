#!/usr/bin/env nix-shell
#!nix-shell -i bash -p lm_sensors bc
# shellcheck shell=bash
set -euo pipefail

# CPU Temperature Throttling Script
# This script monitors CPU temperature and dynamically adjusts the max frequency
# to prevent overheating.

# temperatures are in millidegrees Celsius in /sys
THRESH=80000   # start throttling at 85C
COOLDOWN=75000 # stop throttling when below 80C
LIMIT=3600000  # cap to 3.5 GHz while hot (adjust to taste)

# Colors for output
RED='\033[0;31m'
YELLOW='\033[1;33m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Flag to track throttle state
THROTTLED=false

# Helper: set scaling_max_freq for all policies
set_limit() {
  echo -e "${RED}? Temperature above threshold, throttling CPU to $((LIMIT / 1000)) MHz${NC}"
  for p in /sys/devices/system/cpu/cpufreq/policy*; do
    echo "$LIMIT" >"$p/scaling_max_freq" || true
  done
  THROTTLED=true
}

restore_max() {
  echo -e "${GREEN}? Temperature cooled down, restoring max frequency${NC}"
  for p in /sys/devices/system/cpu/cpufreq/policy*; do
    cat "$p/cpuinfo_max_freq" >"$p/scaling_max_freq" || true
  done
  THROTTLED=false
}

# Display current status
show_status() {
  local temp=$1
  local temp_c
  temp_c=$(echo "scale=1; $temp / 1000" | bc)
  local thresh_c
  thresh_c=$(echo "scale=1; $THRESH / 1000" | bc)
  local cooldown_c
  cooldown_c=$(echo "scale=1; $COOLDOWN / 1000" | bc)

  if [ "$THROTTLED" = true ]; then
    echo -e "${YELLOW}[$(date '+%H:%M:%S')] Current: ${temp_c}C | Threshold: ${thresh_c}C | Status: THROTTLED${NC}"
  else
    echo -e "${BLUE}[$(date '+%H:%M:%S')] Current: ${temp_c}C | Threshold: ${thresh_c}C | Cooldown: ${cooldown_c}C | Status: NORMAL${NC}"
  fi
}

# Check if running as root
if [ "$EUID" -ne 0 ]; then
  echo -e "${RED}ERROR: This script must be run as root (use sudo)${NC}"
  exit 1
fi

echo -e "${GREEN}Starting CPU temperature monitoring...${NC}"
echo -e "Throttle threshold: $(echo "scale=1; $THRESH / 1000" | bc)C"
echo -e "Cooldown threshold: $(echo "scale=1; $COOLDOWN / 1000" | bc)C"
echo -e "Throttle limit: $((LIMIT / 1000)) MHz"
echo ""

while true; do
  # Read CPU temperature from k10temp (AMD) or coretemp (Intel)
  MAX=0

  # Find k10temp or coretemp hwmon device
  for hwmon in /sys/class/hwmon/hwmon*; do
    if [ -f "$hwmon/name" ]; then
      name=$(cat "$hwmon/name" 2>/dev/null)
      if [ "$name" = "k10temp" ] || [ "$name" = "coretemp" ]; then
        # Read all CPU temperature inputs (Tctl, Tccd1, Tccd2, etc.)
        for temp_input in "$hwmon"/temp*_input; do
          if [ -f "$temp_input" ]; then
            val=$(cat "$temp_input" 2>/dev/null || echo 0)
            [ "$val" -gt "$MAX" ] && MAX="$val"
          fi
        done
      fi
    fi
  done

  # Fallback to thermal zones if no CPU sensor found
  if [ "$MAX" -eq 0 ]; then
    for t in /sys/class/thermal/thermal_zone*/temp; do
      if [ -f "$t" ]; then
        val=$(cat "$t" 2>/dev/null || echo 0)
        [ "$val" -gt "$MAX" ] && MAX="$val"
      fi
    done
  fi

  if [ "$MAX" -ge "$THRESH" ]; then
    if [ "$THROTTLED" = false ]; then
      set_limit
    fi
  elif [ "$MAX" -le "$COOLDOWN" ]; then
    if [ "$THROTTLED" = true ]; then
      restore_max
    fi
  fi

  show_status "$MAX"
  sleep 2
done
