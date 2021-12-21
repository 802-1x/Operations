from netmiko import ConnectHandler
import time

username = "snmpv2_username" # RO Operator account on switches
password = "snmpv2_password"
ip = 'L3_VRRP_IP'

# Create initial device dictionary
switch = {
    'device_type': 'hp_procurve',
    'ip': ip,
    'username': username,
    'password': password,
}

# Define switch commands in variables
ping = 'ping '
ShowMAC = 'sh mac-a '
ShowARP = 'sh arp '
ShowLLDP = 'sh lldp in r'

TargetDevice = input('Specify your target hostname, IP or MAC address (MAC is in format: xx-xx-xx-xx-xx-xx): ')

#def SwitchConnect(TargetDevice):
print("Connecting to device %s " % (switch['ip']))

net_connect = ConnectHandler(**switch)
net_connect.send_command_timing('conf t')
output = net_connect.send_command_timing(cmd1)
print(output)
time.sleep(1)
output = net_connect.send_command_timing(pwd)
print(output)
time.sleep(1)
output = net_connect.send_command_timing(pwd)
print(output)
time.sleep(1)
net_connect.send_command_timing('exit')
output = net_connect.send_command('show run | i manager')
print(output)
# Disconnect ssh session
net_connect.disconnect()




SwitchConnect
RetrieveDevice
