#!/usr/bin/sh
# simple ddos mitigation script
# run as root or with sudo

echo "applying basic ddos mitigation rules"

# drop invalid packets so broken or out of state traffic is ignored
# this reduces cpu work and blocks packets that don't belong to a valid connection
sudo iptables -A INPUT -m conntrack --ctstate INVALID -j DROP

# drop new tcp connections that use an unusual TCP MSS value
# many SYN flood tools use odd MSS values. this blocks NEW packets with mss outside common range
sudo iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss \! --mss 536:65535 -j DROP

# limit how many concurrent connections a single ip can have to web port 80
# this prevents one host from hogging all the connections
sudo iptables -A INPUT -p tcp --dport 80 -m connlimit --connlimit-above 20 --connlimit-mask 32 -j DROP


sudo /sbin/iptables-save 

echo "rules applied. check sudo iptables -L -v and sudo iptables -t mangle -L -v -n for counters"
