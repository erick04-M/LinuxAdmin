#!/usr/bin/sh
#Erick Merino
#10/22/2025
#One important thing is before any commands wae are going to inlcude sudo as inorder to mess around with the firewalls


#we are goiong to start this  command by making it so all connections to port 80 are going to be acctepted, we have the -A to add this rule followed by -i eth0 which is going to set it to interface0  then -p tcp -dport 80 to set the protcol as tcp with the destination being 80 and then we have -j ACCEPT so when iptables looks at a new connection  that matches this rule or link its goint to accept it that what the -j means in laymans terms
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT

# we are also doing the same thing to port 430 since we need both port 80 and 430 open for a webserver
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT

#This command is very simialr to the port 80 one as we are simply doing the same thing but instead we are going to make all connection s to port 8080 accepted, with the same regex as the other one
sudo iptables -A INPUT -p tcp --dport 8080 -j ACCEPT

#this command is using the PREROUTING as since the packets arent going out of the server but instead to another destionation in side the local server we use this, then we have the interface followed
#port 80 then we have -j so when seeing connections to port 80 it is going to jump to port 8080 because we have the REDIRECT directly after
sudo iptables -t nat -A PREROUTING -p tcp --dport 80 -j REDIRECT --to-ports 8080
#now this is going to make it so that any tcp packets are going to be redirected from port 80 to 8080 as well
sudo iptables -t nat -A OUTPUT -p tcp --dport 80 -j REDIRECT --to-ports 8080
#now that we made our changes we are going to save them so that we wont lose them

sudo /sbin/iptables-save
