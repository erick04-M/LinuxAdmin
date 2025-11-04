#!/usr/bin/sh

#this is going to ask the user whether or not they want to accept or deny SSH connections
echo "hello do you want to allow connections with SSH or Deny them"
read answer
if [ "$answer" = "Allow" ] || [ "$answer" = "allow" ]
then
# This is going to allow incoming SSH connections to port 22
	sudo iptables -A INPUT -p tcp --dport 22 -j ACCEPT

#this command is going to allow us to accept outgoing SSH conecctions
	sudo iptables -A OUTPUT -p tcp --dport 22 -j ACCEPT

#this command right here is going to save our new rules for the fitler table
	sudo /sbin/iptables-save
elif [ "$answer" = "Deny" ] || [ "$answer" = "deny" ]
then
#this command is going to deny all incoming connections for SSH
	sudo iptables -A INPUT -p tcp --dport 22 -j DROP
#This command is going to deny all outgoing connections for SSH
	sudo iptables -A OUTPUT -p tcp --dport 22 -j DROP
#This is going to save them
	sudo /sbin/iptables-save
fi
