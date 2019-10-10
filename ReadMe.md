# Bash Scripting for Security Administration

Explores Bash scripting in order to automate some security administrative tasks in Linux environments.

Implemented in Kali Linux VM and tested with Windows VM in VMWare Fusion 

## Key Commands


### Ping 
Shows whether machine is available on a network or not. Can also show timing delays and whether packets are being lost on the network

### Arp
Looks up the MAC (media access card) hardware address of a machine. This can be used to verify that the IP address being pinged is actually the correct hardware device to be checked and not some other device that has been misconfigured with the same IP address.

### Nmap
Scans a range of ports on a specified machine and reports the response from each. For many ports, this will even report the software and version number running on the port.


## Important Methods

### pingtest
Utilizes ping in order to get packet loss as well as delay and from this determines if Windows machine: not responding, responding with packet loss, responding normally or responding slow.

### arpcheck
By utilizing arp, ensures that server has the right MAC address, makes sure that no arp spoofing has happened in the network.

### servicecheck
Calls nmap on IP and searches for port number. Reports if it is an open port.

### check_from_file
Takes input file containing **IP address, MAC address and ports**. The IP is first pinged, then the MAC address is checked to see if it is valid, then ports provided are checked if they are open, any other open ports reported in the log file. Nmap results can be saved to xml or .log file, or can just be ran in command line to report results to compare against ports provided in file.

## Log File:

### report.log
Reports how the IP on Windows machine is responding, if machine on IP is responding with correct hardware address and which ports from provided ports are open.

## Test Input File:

### test.txt
Each line in file in **IP address, MAC address and ports** form. Tested against program to use with check_from_file method.
