from netmiko import Netmiko
import logging

# Temporary variables for testing - intended to be passed into file as parameters
vlan = "x"

# Log all reads and writes on the SSH channel
logging.basicConfig(filename="test.log", level=logging.DEBUG)
logger = logging.getLogger("netmiko")

# Temporary dictionaries - intended to be passed through from configuration file

host1 = {                                                       # Enter Device information

    "host": "switchDNSname",

    "username": "username",

    "password": "password",

    "device_type": "aruba_os",

    "global_delay_factor": 0.1,                                   # Increase all sleeps by a factor of 1
}

net_connect = Netmiko(**host1)
net_connect.enable()
#command1 = [f"sh vlan {vlan} ", "logout"]  # Enter set of commands
command1 = ["con","sh vlan"]
print("Connected to:", net_connect.find_prompt())               # Display hostname
output = net_connect.send_config_set(command1, delay_factor=.5) # Run set of commands in order

                                                                # Increase the sleeps for just send_command by a factor of 2
print(output)
net_connect.disconnect()                                        # Disconnect from Session
print(output)
