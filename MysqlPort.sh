#!/usr/bin/sh

#This command will open up port 3306 to tcp connections which is what we want as MySql is going to be used for it and accept them, which we can check using wireshark
sudo iptables -A INPUT -p tcp --dport 3306 -j ACCEPT

#This command will save the changes to our fitler table and if we need to open up this port again all we have to do is run this script
sudo /sbin/iptables-save
