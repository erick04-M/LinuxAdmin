#!/usr/bin/sh
#This command is going to block icmp requestions which stands for ping
sudo iptables -A INPUT -p icmp --icmp-type echo-request -j DROP
#This command is going to block telnet which runs of off port 23 and we are going to disblae all incomfing connections
sudo iptables -A INPUT -p tcp --dport 23 -j DROP
sudo iptables -A OUTPUTE -p tcp --dport 23 -j DROP

#this command will save our changes
sudo /sbin/iptables-save
