# Allows you to configure several switches in the same way. For example (RADIUS configuration, Kron, ...)

import paramiko
import time

# List of IP / DNS addresses of the switches
switch_ips = ['SWITCH1', '192.168.1.15']

# Configuration you want to apply
config_commands = [
    'en',
    'conf t',
    'interface GigabitEthernet0/1',
    'description toto',
    'exit',
    'interface GigabitEthernet0/2',
    'description toto',
    'exit',
    # Add other configuration commands here if necessary
]

# Function to execute commands on the switch
def configure_switch(switch_ip, username, password):
    ssh_client = paramiko.SSHClient()
    ssh_client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    ssh_client.connect(switch_ip, username=username, password=password, timeout=5)

    with ssh_client.invoke_shell() as ssh_shell:
        for command in config_commands:
            ssh_shell.send(command + '\n')
            # Wait a short time for the switch to process the command (adjust according to network speed)
            time.sleep(.5)

    ssh_client.close()

# Authentication information for connecting to switches
username = 'toto'
password = 'P@sswordOfT0t0'

# Apply the configuration to each switch
for ip in switch_ips:
    try:
        configure_switch(ip, username, password)
        print(f"Configuration réussie pour le switch {ip}")
    except Exception as e:
        print(f"Échec de la configuration pour le switch {ip} : {e}")