#! /bin/bash
sudo ovs-vsctl add-br br0
let 'eths=0'
for intf in $(ifconfig -s)
do
    # Last interface should be controller so don't add to bridge
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
    12.10.1.*)
        sudo ifconfig $ethX 0.0.0.0
        sudo ovs-vsctl add-port br0 $ethX
    ;;
    *)
    ;;
    esac
done
sudo ovs-vsctl set-controller br0 tcp:11.1.1.1:6653
sudo ovs-vsctl set-fail-mode br0 secure
#ovs-vsctl list-ports br0
