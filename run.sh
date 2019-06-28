sudo systemctl disable systemd-resolved.service
sudo systemctl stop systemd-resolved
sudo systemctl stop NetworkManager

sudo ip link set enp9s0 up
sudo ip addr flush dev enp9s0
sudo ip addr add 10.10.12.111/24 dev enp9s0
sudo ip route add 10.10.12.0/24  dev enp9s0
sudo ip route add default via 10.10.12.1

sudo ifconfig wlp5s0 down
sudo iwconfig wlp5s0 mode monitor
sudo ifconfig wlp5s0 up 192.168.1.1 netmask 255.255.255.0

sudo sh -c 'echo "nameserver 8.8.4.4" >  /etc/resolv.conf'

sudo iptables -F
sudo iptables --append FORWARD --in-interface wlp5s0 -j ACCEPT
sudo iptables --table nat --append POSTROUTING --out-interface enp9s0 -j MASQUERADE
sudo sysctl -w net.ipv4.ip_forward=1


sudo /etc/init.d/dnsmasq stop
sudo /etc/init.d/hostapd stop
sudo hostapd ./hostapd.conf &
sudo dnsmasq -C ./dnsmasq.conf -d

