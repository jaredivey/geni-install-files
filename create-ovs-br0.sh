#! /bin/bash
sudo ovs-vsctl add-br br0
#sudo ovs-vsctl set bridge br0 datapath_type=netdev protocols=OpenFlow10,OpenFlow13
sudo ovs-vsctl set bridge br0 protocols=OpenFlow10,OpenFlow13
#sudo ifconfig br0 192.168.1.$1/24 up promisc multicast
# Determine number of Ethernet interfaces
let 'eths=0'
for intf in $(ifconfig -s)
do
    case $intf in
    eth*)
        let 'eths++'
    ;;
    esac
done
echo $eths
for (( intf=0 ; intf<$eths ; intf++ ))
do
    ethX=eth$intf
    ipaddr=$(ifconfig $ethX | grep "inet addr:" | cut -d: -f2 | awk '{ print $1}')
    case $ipaddr in
    12.10.*)
        sudo ifconfig $ethX 0.0.0.0
        sudo ovs-vsctl add-port br0 $ethX
        #sudo iptables -A INPUT -i $ethX -j DROP
        #sudo iptables -A FORWARD -i $ethX -j DROP
    ;;
    *)
    ;;
    esac
done
sudo ovs-vsctl set-controller br0 tcp:11.1.1.$1:6653
sudo ovs-vsctl set-fail-mode br0 secure
#ovs-vsctl list-ports br0
