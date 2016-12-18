#! /bin/bash
sudo ovs-vsctl add-br br0
for intf in $(ifconfig -s)
do
    # Last interface should be controller so don't add to bridge
    case $intf in
    eth*)
        ETHx=$intf
    ;;
    esac
done
for intf in $(ifconfig -s)
do
    case $intf in
    eth0)
        #echo "Skip $intf public interface"
        ;;
    $ETHx)
        #echo "Skip $intf controller interface"
        ;;
    eth*)
        #echo "Configure $intf"
        sudo ifconfig $intf 0.0.0.0
        sudo ovs-vsctl add-port br0 $intf
    ;;
    *)
    ;;
    esac
done
sudo ovs-vsctl set-controller br0 tcp:11.1.1.1:6653
sudo ovs-vsctl set-fail-mode br0 secure
#ovs-vsctl list-ports br0