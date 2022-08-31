#!/usr/bin/python3
BATTERY = "BAT0"
battery_directory = f"/sys/class/power_supply/{BATTERY}/"
with open(battery_directory + "status", "r") as f:
    state = f.read().strip()
with open(battery_directory + "current_now", "r") as f:
    current = int(f.read().strip())
with open(battery_directory + "voltage_now", "r") as f:
    voltage = int(f.read().strip())
wattage = (voltage / 10**6) * (current / 10**6)
wattage_formatted = f"{'-' if state == 'Discharging' else ''}{wattage:.2f}W"
if state in ["Charging", "Discharging", "Not charging"]:
    print(f"{wattage_formatted}")
