#!/bin/sh 

#Copyright (C) 2015  Eduardo Granados
#
#This program is free software: you can redistribute it and/or modify
#it under the terms of the GNU General Public License as published by
#the Free Software Foundation, either version 3 of the License, or
# any later version.
#
#This program is distributed in the hope that it will be useful,
#but WITHOUT ANY WARRANTY; without even the implied warranty of
#MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#GNU General Public License for more details.
#
#You should have received a copy of the GNU General Public License
#along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

#Configuration file
NAME=wakewom
CONF_FILE="/etc/config/${NAME}"
PID_FILE="/var/run/${NAME}.pid"

load_configuration () {
	
	if [ ! -e "${CONF_FILE}" ]
	then 
		echo "Configuration file: '${CONF_FILE}' doesnt exist"
		exit 1
	fi
	source "${CONF_FILE}" 
	echo "Configuration loaded from '${CONF_FILE}'"
}

check_mode_monitor () {
		iw ${PHY_W} info | grep monitor > /dev/null 2>&1
		if [ $? -ne 0 ]
		then
				echo "Error: interface '${PHY_W}' does not support mode monitor. Exiting"
				exit 1
		fi
		echo "Interface '${PHY_W}' supports mode monitor"
}

check_config () {

		echo "${SECONDS_BETWEEN_CHECK}" | grep -e "^[0-9]\+$" > /dev/null 2>&1
		if [ $? -ne 0  ] 
		then 
				echo "Error SECONDS_BETWEEN_CHECK : '${SECONDS_BETWEEN_CHECK}' is not a number"
				exit 1
		fi
		[ ${SECONDS_BETWEEN_CHECK} -gt 0 ] || echo "SECONDS_BETWEEN_CHECK must be > 0  and is '${SECONDS_BETWEEN_CHECK}'" || exit 1

		echo "${TIMES_TO_BE_CHECKED_TO_0}" | grep -e "^[0-9]\+$" > /dev/null 2>&1
		if [ $? -ne 0  ] 
		then 
				echo "Error TIMES_TO_BE_CHECKED_TO_0 : '${TIMES_TO_BE_CHECKED_TO_0}' is not a number"
				exit 1
		fi
		[ ${TIMES_TO_BE_CHECKED_TO_0} -gt 0 ] || echo "TIMES_TO_BE_CHECKED_TO_0 must be > 0  and is '${TIMES_TO_BE_CHECKED_TO_0}'" || exit 1

		#Check mac syntax
		REGEX_MAC="\([0-9a-fA-F][0-9a-fA-F]:\)\{5\}[0-9a-fA-F][0-9a-fA-F]"
		echo "${MAC_ADDRESS}"| grep -e "^${REGEX_MAC}\(||${REGEX_MAC}\)*$" > /dev/null 2>&1
		if [ $? -ne 0  ] 
		then 
				echo "Error: MAC_ADDRESS: '${MAC_ADDRESS}' is not a valid mac or macs separated by ||"
				exit 1
		fi
		echo "Configuration is ok. SECONDS_BETWEEN_CHECK: '${SECONDS_BETWEEN_CHECK}'; TIMES_TO_BE_CHECKED_TO_0: '${TIMES_TO_BE_CHECKED_TO_0}'; MAC_ADDRESS: '${MAC_ADDRESS}'"
}



clean_up_interfaces () {
	iw dev wwmon0 info > /dev/null 2>&1
	if [ $? -eq 0 ]
	then
		ifconfig wwmon0 down
		iw dev wwmon0 del
	fi

	iw dev ${WLAN} info > /dev/null 2>&1
	if [ $? -ne 0 ]
	then
		ifconfig ${WLAN} up
		wifi
		sleep 1
	fi
}

clean_up () {
	clean_up_interfaces
	rm -f "${PID_FILE}"
	echo "Cleaning up ${NAME}"
	exit
}


daemon_wifi_power () {
	echo "Starting ${NAME}"
	load_configuration
	check_mode_monitor	
	check_config
	clean_up_interfaces
	
#	trap load_configuration SIGHUP 
	trap clean_up SIGINT SIGTERM

	COUNT=0

	while [ 1 ]
	do
		sleep ${SECONDS_BETWEEN_CHECK} & wait $!

		NUMBER_CONNECTEDS=$(iw dev ${WLAN} station dump | grep -c Station)

		if [ "${NUMBER_CONNECTEDS}" == "0" ]
		then
			COUNT=$((COUNT+1))
			if [ ${TIMES_TO_BE_CHECKED_TO_0} -gt ${COUNT} ]
			then
				echo "No clients connected. Times to be checked; ${TIMES_TO_BE_CHECKED_TO_0} each ${SECONDS_BETWEEN_CHECK} secs. Now count is ${COUNT}"
				#Check again 
				continue
			fi
		else
			COUNT=0
			#Check again 
			continue
		fi
		
		echo "No clients connected. Setting up mode monitor"
		#If a reach here I create the monitor
		iw phy ${PHY_W} interface add wwmon0 type monitor
		ifconfig ${WLAN} down
		ifconfig wwmon0 up

		#Wait for a Mac
		echo "No clients connected. Wait for configured devices: '${MAC_ADDRESS}'"
		tcpdump -qNKni wwmon0 ether  src ${MAC_ADDRESS} -c 2 -s 6 -w /dev/null > /dev/null 2>&1  &
		PID_TCPDUMP=$!
		echo "${PID_TCPDUMP}" >> "${PID_FILE}"
		wait ${PID_TCPDUMP}
		echo "Clients detected. Setting up wifi ap on ${WLAN}"
		sed -i "/${PID_TCPDUMP}/d" "${PID_FILE}"
		#Destroy monitor and start again
		ifconfig wwmon0 down
		iw dev wwmon0 del
		ifconfig ${WLAN} up
		wifi
		echo "Wifi ap on ${WLAN} is up"
		COUNT=0
	done
}

daemon_wifi_power 

