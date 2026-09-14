import subprocess
import re

devices_ouput = subprocess.run(
        ['bluetoothctl', 'devices', 'Connected'], 
        stdout=subprocess.PIPE
).stdout.decode("utf-8")

devices = devices_ouput.splitlines()
addrs = [''] * len(devices)

for i in range(0, len(devices)):
    addrs[i] = devices[i].split(' ')[1]

if len(devices) >= 1:
    # TODO: Support being connected to multiple devices
    device_info_out = subprocess.run(['bluetoothctl', 'info', addrs[0]], check=True, capture_output=True).stdout
    batteries_output = subprocess.run(['grep', 'Battery'], input=device_info_out, capture_output=True).stdout.decode('utf-8')
    battery_percentage = int(re.search(r'\((.*?)\)', batteries_output).group(1))
    print(f"  {battery_percentage}%")
else:
    print('')
