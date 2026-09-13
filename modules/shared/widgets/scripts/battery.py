import subprocess

cap = int(subprocess.run(
        ['cat', '/sys/class/power_supply/BAT1/capacity'], 
        stdout=subprocess.PIPE
).stdout.decode("utf-8").rstrip())

status = subprocess.run(
        ['cat', '/sys/class/power_supply/BAT1/status'], 
        stdout=subprocess.PIPE
).stdout.decode("utf-8").rstrip()

charging_icons = ["󰢜", "󰂆", "󰂇", "󰂈", "󰢝", "󰂉", "󰢞", "󰂊", "󰂋", "󰂅"]
discharging_icons = ["󰁺", "󰁻", "󰁼", "󰁽", "󰁾", "󰁿", "󰂀", "󰂁", "󰂂", "󰁹"]

icon = ""

index = int(cap / 10) - 1

if status == "Charging":
    icon = charging_icons[index]
else:
    icon = discharging_icons[index] 

print(f"{icon}  {cap}%")
