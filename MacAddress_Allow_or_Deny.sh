#!/usr/bin/sh

#we are going to ask if they want to block or allow From a certain Mac Address
echo "hello Do you want to Allow or Deny any MAC address so they cant connect to our server?"
read answer
if [ "$answer" = "Allow" ] || [ "$answer" = "allow" ]
then
# This is going to allow the firewall to accept any communication or connections from this MacAddress
	sudo iptables -A INPUT -m mac --mac-source 08:00:27:aa:44:3a -j ACCEPT
	sudo /sbin/iptables-save
elif [ "$answer" = "Deny" ] || [ "$answer" = "deny" ]
then
	sudo iptables -A INPUT -m mac --mac-source 08:00:27:aa:44:3a -j DROP
	sudo /sbin/iptables-save
fi

