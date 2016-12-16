#!/bin/bash

(
# Set up environment
echo "PATH=$PATH:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:/sbin" >> ~/.bashrc
source ~/.bashrc

# Hostname
echo "Hostname and version:"
hostname
echo
uname -a
echo
cat /etc/os-* 2>/dev/null

echo -e "\n--------------------------------------------------\n"

# IP Addresses
echo "IP Addresses:"
ip -o addr show scope global #| cut -d'/' -f1 | rev | cut -d' ' -f1 | rev

echo -e "\n--------------------------------------------------\n"

# Routes
echo "Routes:"
ip route

echo -e "\n--------------------------------------------------\n"

# Flags
echo "Flag directory:"
ls -lah /usr/share/cctc
echo
cat /usr/share/cctc/*txt 2>/dev/null
echo
for file in /usr/share/cctc/*; do
    echo "Start of $file"
    cat $file | base64
    echo
    echo "End of $file"
done

echo -e "\n--------------------------------------------------\n"

# IPtables
echo "IPTables:"
cat /etc/iptables/rules* 2>/dev/null

echo -e "\n--------------------------------------------------\n"

# ARP Table
echo "ARP Table:"
/usr/sbin/arp

echo -e "\n--------------------------------------------------\n"

# Netstat
echo "Netstat:"
netstat -pant | egrep "LISTEN|EST"

echo -e "\n--------------------------------------------------\n"

# Port Scan
echo "Port Scan:"

# - Fast scan using a ping sweep first
#for net in $(ip route | grep "/" | cut -d"/" -f1 | cut -d "." -f1-3); do for host in $net.{1..254}; do (ping -w1 -c1 $host >/dev/null 2>&1 && (for port in {1..1024}; do (echo >/dev/tcp/$host/$port >/dev/null 2>&1 && (echo -e "$host $port\n $(echo -e 'GET / HTTP/1.0\n' | nc -tnw1 $host $port)\n" ) & ); done) & ); done; done 2>/dev/null

# - Slow scan that scans using port scan only
for net in $(ip route | grep "/" | cut -d"/" -f1 | cut -d "." -f1-3); do for host in $net.{1..254}; do ((for port in {1..1024}; do (echo >/dev/tcp/$host/$port >/dev/null 2>&1 && (echo -e "$host $port\n $(echo -e 'GET / HTTP/1.0\n' | nc -tnw1 $host $port)\n" ) & ); done) & ); done; done 2>/dev/null

wait
) > report.txt
