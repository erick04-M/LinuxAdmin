#!/usr/bin/sh
# Author: Erick Merino
# Date: 10-13-2025
#This script will begin a command of echo, saying that this script will print out networking information on this server
#To run use ' ./*scriptname*.sh 
#sudo dnf install mtr, nmap
{
echo "Hello User! This script will print out various pieces of information on
this server!"
#This echo command echo -e '\t' will print a tab space so it will break up the 
#information making it easier to see and read
echo -e '\t'
#This is going to explain what our ping command is and then right below it we will run the command
echo "This is our ping command, with it we will ping google in order to see if
our internet connectivity is good and that we can still communicate with other
machines"
ping -c 2 google.com

echo -e '\t'
echo " This command will show us how our interface is currently configured and
its statistics"
#this command will show us IP,DNS,MAC and connections information
nmcli device show eth0 | head -n 15

echo -e '\t'
echo "This command will show us all of our TCP, RAW,UDP,INET,FRAG statistics on all of our sockets"
ss -s

echo -e '\t'
echo "This is our hostname and our IP for our host, with us tracing the route we take to google.com"
#hostname will print our the name of our host and with the -I, it will print the IP address instead
hostname
hostname -I
#Before we can use this done forget to intall traceroute and we can do this by
#doing sudo dnf install traceroute
echo -e '\t'
traceroute google.com

echo -e '\t'
echo "this command will map our network and present to us information about the ports, network statuses, and more"
#in order to use nmap dont forget to install it with this command sudo dnf install nmap
nmap 10.0.0.60

echo -e '\t'
echo "this command is mtr and this will combine the funcionality of ping,
traceroute and more and the inforamtion below is the results of this command
with google"
#this command is very useful as it combines the functions of traceroute and pingwhile allowing us to apply filters and see more stats, one important thing you 
#need to remeber is to install it, if not already installed you can run this command sudo dnf install mtr
mtr -c 3 google.com

echo -e '\t'
echo "Now saving the results into a log file"
} | tee ./Logs/Erick_merino_Networking_dump_log$(date +"%m_%d-%Y").txt
