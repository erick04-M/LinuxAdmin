#!/usr/bin/sh
{ echo " This is a networks Information dump about our server" | lolcat #for all of the lol cats following an echo we are doing it for readability so that we   can see it more clearly

#we are going to ping google just to see if we are connected to the internet
echo " we are connected to the internet and are able to communicate with google" | lolcat
ping -c 4 google.com

#we are going to do ip -s link show our status for our interfaces as well as showing their stats like packets, errors, and etc.
echo " we are showing our interface statistics as well as their status" | lolcat
ip -s link show

echo " This is an active summary for our netowork socket related information" | lolcat
#this command will show us all of our tcp connections together with their timers, however it is only the active ones that are shown, if you want to list all
#all of the listening TCP connections you can run ss -lt, or for all active tcp do ss -to and UDP is -ua 
ss -s

echo " This is our route to our default gateway" | lolcat
traceroute 10.0.0.1

echo "this is our host name for the server followed by the ip address" | lolcat
hostname
hostname -i

echo "this is nmap and it will show us our entire network and present to us information about it" | lolcat
#this command will show us network status, and the connections, as well as information about the ports. It is a very powerful command as it can be used for 
#security scans, network audits and so much more. 				
nmap 10.0.0.50


echo "saving results from script into Log File"
} | tee Erick_Merino_Data_Dump_log$(date +"%m-%d-%Y").txt

