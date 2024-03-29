#!/bin/bash
sudo ifdown --force wlan0
sudo pkill wpa_supplicant
# set up dhcp server
sudo cp /home/pi/Pi_Setup/AP_Setup/dhcpd.conf /etc/dhcp/dhcpd.conf
sudo cp /home/pi/Pi_Setup/AP_Setup/isc-dhcp-server /etc/default/isc-dhcp-server
sudo ifconfig wlan0 down
# set up wlan0 for static IP
sudo cp /home/pi/Pi_Setup/AP_Setup/interfaces /etc/network/interfaces
sudo ifconfig wlan0 192.168.42.1
# configure access point
sudo cp /home/pi/Pi_Setup/AP_Setup/hostapd.conf /etc/hostapd/hostapd.conf
sudo cp /home/pi/Pi_Setup/AP_Setup/hostetc /etc/default/hostapd
# configure network address translation
sudo cp /home/pi/Pi_Setup/AP_Setup/sysctl.conf /etc/sysctl.conf
sudo sh -c "echo 1 > /proc/sys/net/ipv4/ip_forward"
sudo sh -c "iptables-save > /etc/iptables.ipv4.nat"
# sudo cp ./interfaces /etc/network/interfaces	### already done ###
# update hostapd
sudo mv /usr/sbin/hostapd /usr/sbin/hostapd.ORIG
sudo cp /home/pi/Pi_Setup/AP_Setup/hostapd /usr/sbin/
sudo chmod 755 /usr/sbin/hostapd
# set program as 'daemon'
sudo service hostapd start
sudo service isc-dhcp-server start
sudo update-rc.d hostapd enable
sudo update-rc.d isc-dhcp-server enable
sudo systemctl restart isc-dhcp-server
sudo systemctl restart hostapd
sleep 5
CONFIRM_IWCONFIG=`iwconfig wlan0 | grep Pi_AP | wc -l`
CONFIRM_IFCONFIG=`ifconfig wlan0 | grep 192.168.42.1 | wc -l`
while [ $CONFIRM_IWCONFIG -ne 1 -a $CONFIRM_IFCONFIG -ne 1 ]; do
	echo "running toRouter.sh again"
	sudo /home/pi/Pi_Setup/AP_Setup/toRouter.sh
	CONFIRM_IWCONFIG=`iwconfig wlan0 | grep Pi_AP | wc -l`
	CONFIRM_IFCONFIG=`ifconfig wlan0 | grep 192.168.42.1 | wc -l`
done
