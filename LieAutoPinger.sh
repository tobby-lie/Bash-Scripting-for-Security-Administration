#------------------------------------------------------------------
# Auto pinger lab 5 for Cyber Security Programming
# Bash Scripting for Security Administration
# Implemented in Kali Linux VM and tested with Windows VM
#------------------------------------------------------------------
#!/bin/bash
logfile="/root/Documents/report.log"
#------------------------------------------------------------------
# Function: pingtest
#	From ping, gets packet loss as well as delay and from this
#	determines if Windows machine not responding, responding
#	with packet loss, responding normally or responding slow
#
#	parameters: 
#		winIP - IP address of Windows machine we are trying
#			to ping
#	returns:
#		nothing
#------------------------------------------------------------------
function pingtest()
{
	# captures ping result from $1 which is ip address and stores
	# it in variable named ping
	ping=`ping -c3 $1 | tail -2`
	
	# gets percent packet-loss from ping and stores it in variable
	# loss
	loss=`echo $ping | cut -d"," -f3 | cut -d" " -f2`
	
	# gets best delay from ping time from the ping results and stores
	# it in variable delay
	delay=`echo $ping | cut -d"=" -f2 | cut -d"." -f1`
	
	# if loss eq 100% then machine not responding
	if [ "$loss" = "100%" ]; then
		echo `date` Windows machine on IP $1 is not responding at all >> $logfile
	# if loss ne 0% then machine responding with packet loss
	elif [ "$loss" != "0%" ]; then
		echo `date` Windows machine on IP $1 is responding with packet loss >> $logfile
	else
		# machine responding normally
		if [ "$delay" -lt 100 ]; then
			echo `date` Windows machine on IP $1 is responding normally >> $logfile	
		# machine responding slow
		else
			echo `date` Windows machine on IP $1 is responding slow >> $logfile
		fi
	fi
}
#------------------------------------------------------------------
# Function: arpcheck
#	Makes sure that the server has the right MAC address
#	ensures that no arp spoofing has happened in network
#
#	parameters:
#		winIP - IP address of Windows machine we are trying
#			to ping
#		MAC address - MAC address to compare against arp
#
#	returns:
#		nothing
#------------------------------------------------------------------
function arpcheck()
{
	# Use arp command to get MAC address of server
	arp=`arp $1 | tail -1 | cut -c34-50`
	echo $arp
	echo $2
	# if arp is ne to passed in MAC then issue warning
	if [ "$arp" != "$2" ]; then
		echo `date` Windows machine on IP $1 is not responding with a wrong hardware address $arp and is different from $2 >> $logfile
	fi
}
#------------------------------------------------------------------
# Function: servicecheck
#	Calls nmap on IP and searches for port number
#
#	parameters:
#		winIP - IP address of Windows machine we are trying
#			to ping
#		port number - port number to be searched in winIP
#
#	returns:
#		nothing
#------------------------------------------------------------------
function servicecheck()
{
	#echo $2
	# uses nmap to search for open ports in IP
	nmaplog=`nmap $1 | grep $2`
	# if nmaplog not empty then the given port is open
	if [ "$nmaplog" != "" ]; then
		echo `date` port $2 is open on Windows machine on IP $1 >> $logfile
	fi
}
: ' pingtest 192.168.10.196
arpcheck $1 $2
servicecheck $1 $3'
#------------------------------------------------------------------
# Function: check_from_file
#	takes input file containing IP address, MAC address and ports
#	The IP ios first pings, then the MAC address is checked to
#	see if it is valid, then ports provided are checked if they
#	are open, any other open ports will be reported in the log
#	file
#
#	parameters:
#		nothing
#
#	returns:
#		nothing
#------------------------------------------------------------------
function check_from_file()
{
	# location of input file
	input="/root/Documents/test.txt"
	nmapLog_file="/root/Documents/nmap_log.log"
	nmapLog_xml="/root/Documents/nmap_log.xml"
	# command/process to read file line by line
	while IFS= read -r line
	do
		# , is the delimiter and each field in each
		#line of file is stored in an array
		IFS=', ' read -r -a array <<< "$line"

			# ping test with ip
			pingtest ${array[0]}
			
			# arp check with ip and MAC
			arpcheck ${array[0]} ${array[1]}

			# split up array of ports delimited by ;'
			IFS='; ' read -r -a port_array <<< "${array[2]}"
			
			# for each element in port array
			for element in "${port_array[@]}"
			do	
				# port is each element in port array
				port="$element"
				#echo "$port"
				# call servicecheck with IP and port
				servicecheck ${array[0]} $port

			done
			
			# save nmap results to xml
			#nmap -T4 -oX $nmapLog_xml ${array[0]}
			# save nmap results to .log file
			#nmap -T4 -oG $nmapLog_file ${array[0]}
		
	done <"$input"
}

check_from_file



