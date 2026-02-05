#!/usr/bin/env bash

# Script to get disk temperatures using smartctl
# Requires smartmontools package

set -euo pipefail

# Check if smartctl is available
if ! command -v smartctl &>/dev/null; then
  echo "Error: smartctl not found. Please install smartmontools package."
  exit 1
fi

# Check if running with sufficient privileges
if [[ $EUID -ne 0 ]]; then
  echo "Warning: This script may need root privileges to access all disks."
  echo "Consider running with sudo if you encounter permission errors."
  echo ""
fi

echo "Scanning for disks and reading temperatures..."
echo "=============================================="
echo ""

# Find all disk devices
# This covers /dev/sd*, /dev/nvme*, /dev/hd*, etc.
disks=$(lsblk -d -n -o NAME,TYPE | awk '$2=="disk" {print "/dev/"$1}')

if [[ -z "$disks" ]]; then
  echo "No disks found."
  exit 0
fi

# Process each disk
for disk in $disks; do
  echo "Device: $disk"

  # Get SMART data
  if smart_data=$(smartctl -A "$disk" 2>/dev/null); then
    # Try to find temperature in various formats
    # Different drives report temperature differently:
    # - "Temperature_Celsius" for many SATA drives (column 10 is RAW_VALUE)
    # - "Airflow_Temperature_Cel" for some drives

    # For SATA drives: ID# ATTRIBUTE_NAME FLAG VALUE WORST THRESH TYPE UPDATED WHEN_FAILED RAW_VALUE
    # Temperature is in column 10 (RAW_VALUE)
    temp=$(echo "$smart_data" | grep -iE "Temperature_Celsius|Airflow_Temperature" | head -1 | awk '{
			# Column 10 is RAW_VALUE which contains actual temperature
			# It may have format like "42" or "42 (Min/Max 18/57)"
			raw=$10
			# Extract just the number
			if (match(raw, /^[0-9]+/)) {
				temp=substr(raw, RSTART, RLENGTH)
				if (temp > 0 && temp < 100) {
					print temp "°C"
				}
			}
		}')

    if [[ -n "$temp" ]]; then
      echo "  Temperature: $temp"
    else
      # Try alternative method for NVMe drives
      # NVMe output format: "Temperature:                        42 Celsius"
      if temp_alt=$(smartctl -a "$disk" 2>/dev/null | grep -i "temperature:" | head -1 | grep -oP '\d+\s*Celsius' | grep -oP '\d+'); then
        echo "  Temperature: ${temp_alt}°C"
      else
        echo "  Temperature: Not available"
      fi
    fi
  else
    echo "  Status: Unable to read SMART data (device may not support SMART)"
  fi

  echo ""
done

echo "=============================================="
echo "Scan complete."
