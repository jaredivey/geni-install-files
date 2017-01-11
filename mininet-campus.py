#!/usr/bin/python

"""
This example shows how to create an empty Mininet object
(without a topology object) and add nodes to it manually.
"""
import sys
import random
import time
from signal import SIGINT
import string

from mininet.net import Mininet
from mininet.node import OVSSwitch, UserSwitch, RemoteController
from mininet.link import TCLink
from mininet.cli import CLI
from mininet.log import setLogLevel, info, debug, output
from mininet.util import custom

def campusNet():
    start_time = time.time()

    numHosts = 2
    numSwitches = 3

    "Create an empty network and add nodes to it."
    net = Mininet(switch=OVSSwitch, waitConnected=True)

    info('*** Adding controllers\n')
    controllers = []
    switches = []
    hosts = []
    controllerPort = 6653
    controllers.append(net.addController('c0', controller=RemoteController, port=controllerPort))

    switchCounter = 0
    # Create subnet 0
    print "Creating subnet 0"
    subnet = 0
    ovs0 = []
    sn0_switches = 3
    for i in xrange(0,sn0_switches):
        ovs0.append(net.addSwitch("ovs%d-%d" % (subnet, i), datapath='user'))
        switchCounter += 1

        # Connect subnet 0 switches together
        if len(ovs0) > 1:
            # net.addLink(ovs0[i-1], ovs0[i], bw=1000, delay='1ms')
            net.addLink(ovs0[i-1], ovs0[i])
        # Connect last switch to first switch
        if len(ovs0) == sn0_switches:
            # net.addLink(ovs0[i], ovs0[0], bw=1000, delay='1ms')
            net.addLink(ovs0[i], ovs0[0])

    # Create subnet 1
    print "Creating subnet 1"
    subnet = 1
    ovs1 = []
    sn1_switches = 2
    sn1_links = 2
    for i in xrange(0,sn1_switches):
        ovs1.append(net.addSwitch("ovs%d-%d" % (subnet, i), datapath='user'))
        switchCounter += 1

        if len(ovs1) > 1:
            # net.addLink(ovs1[i-1], ovs1[i], bw=1000, delay='1ms')
            net.addLink(ovs1[i-1], ovs1[i])

        # Create 2 hosts with 1 link per switch in subnet 1
        hostSet = []
        for j in xrange(0, sn1_links):
            hostName = 'h' + str(switchCounter) + str(j)
            hostIP = '10.10.' + str(switchCounter) + '.' + str(j+1)
            hostSet.append(net.addHost(hostName, ip=hostIP))
            # net.addLink(ovs1[i], hostSet[j], bw=1000, delay='1ms')
            net.addLink(ovs1[i], hostSet[j])

    # Create a link between subnets 0 and 1
    # net.addLink(ovs0[2], ovs1[0], bw=1000, delay='1ms')
    net.addLink(ovs0[2], ovs1[0])

    # Create subnet 2
    print "Creating subnet 2"
    subnet = 2
    ovs2 = []
    sn2_switches = 7
    sn2_links = 1
    for i in xrange(0,sn2_switches):
        ovs2.append(net.addSwitch("ovs%d-%d" % (subnet, i), datapath='user'))
        switchCounter += 1

        hostSet = []
        if i > 1:
            for j in xrange(0, sn2_links):
                hostName = 'h' + str(switchCounter) + str(j)
                hostIP = '10.10.' + str(switchCounter) + '.' + str(j+1)
                hostSet.append(net.addHost(hostName, ip=hostIP))
                # net.addLink(ovs2[i], hostSet[j], bw=1000, delay='1ms')
                net.addLink(ovs2[i], hostSet[j])

        # Add 2 more host sets for switch 6
        if i == 6:
            hostSet = []
            for b in xrange(0,2*sn2_links):
                hostName = 'h' + str(switchCounter) + str(sn2_links+b)
                hostIP = '10.10.' + str(switchCounter) + '.' + str(sn2_links+b+1)
                hostSet.append(net.addHost(hostName, ip=hostIP))
                # net.addLink(ovs2[i], hostSet[b], bw=1000, delay='1ms')
                net.addLink(ovs2[i], hostSet[b])

    # net.addLink(ovs2[0], ovs2[1], bw=1000, delay='1ms')
    net.addLink(ovs2[0], ovs2[1])
    # net.addLink(ovs2[0], ovs2[2], bw=1000, delay='1ms')
    net.addLink(ovs2[0], ovs2[2])
    # net.addLink(ovs2[1], ovs2[3], bw=1000, delay='1ms')
    net.addLink(ovs2[1], ovs2[3])
    # net.addLink(ovs2[2], ovs2[3], bw=1000, delay='1ms')
    net.addLink(ovs2[2], ovs2[3])
    # net.addLink(ovs2[2], ovs2[4], bw=1000, delay='1ms')
    net.addLink(ovs2[2], ovs2[4])
    # net.addLink(ovs2[3], ovs2[5], bw=1000, delay='1ms')
    net.addLink(ovs2[3], ovs2[5])
    # net.addLink(ovs2[5], ovs2[6], bw=1000, delay='1ms')
    net.addLink(ovs2[5], ovs2[6])

    # Create subnet 3
    print "Creating subnet 3"
    subnet = 3
    ovs3 = []
    sn3_switches = 4
    sn3_links = 1
    saveSwitchCounter = 100 # Setting it ridiculously out of the way of other switches until we get the correct one
    for i in xrange(0,sn3_switches):
        ovs3.append(net.addSwitch("ovs%d-%d" % (subnet, i), datapath='user'))
        switchCounter += 1

        hostSet = []
        if i != 1:
            for j in xrange(0, sn3_links):
                hostName = 'h' + str(switchCounter) + str(j)
                hostIP = '10.10.' + str(switchCounter) + '.' + str(j+1)
                hostSet.append(net.addHost(hostName, ip=hostIP))
                # net.addLink(ovs3[i], hostSet[j], bw=1000, delay='1ms')
                net.addLink(ovs3[i], hostSet[j])
        else:
            saveSwitchCounter = switchCounter

    # Add a second host set to switch 0 using the address space that 1 would have used
    hostSet = []
    for j in xrange(0, sn3_links):
        hostName = 'h' + str(saveSwitchCounter) + str(j)
        hostIP = '10.10.' + str(saveSwitchCounter) + '.' + str(j+1)
        hostSet.append(net.addHost(hostName, ip=hostIP))
        # net.addLink(ovs3[0], hostSet[j], bw=1000, delay='1ms')
        net.addLink(ovs3[0], hostSet[j])

    # Add a second host set to switch 3
    hostSet = []
    for j in xrange(0, sn3_links):
        hostName = 'h' + str(switchCounter) + str(j+sn3_links)
        hostIP = '10.10.' + str(switchCounter) + '.' + str(j+sn3_links+1)
        hostSet.append(net.addHost(hostName, ip=hostIP))
        # net.addLink(ovs3[3], hostSet[j], bw=1000, delay='1ms')
        net.addLink(ovs3[3], hostSet[j])

    # net.addLink(ovs3[0], ovs3[1], bw=1000, delay='1ms')
    net.addLink(ovs3[0], ovs3[1])
    # net.addLink(ovs3[1], ovs3[2], bw=1000, delay='1ms')
    net.addLink(ovs3[1], ovs3[2])
    # net.addLink(ovs3[1], ovs3[3], bw=1000, delay='1ms')
    net.addLink(ovs3[1], ovs3[3])
    # net.addLink(ovs3[2], ovs3[3], bw=1000, delay='1ms')
    net.addLink(ovs3[2], ovs3[3])

    # Create subnet "4" (really just one switch connecting subnets 0 and 2
    print "Creating switch 4"
    subnet = 4
    ovs4 = net.addSwitch("ovs%d" % (subnet), datapath='user')
    switchCounter += 1

    # net.addLink(ovs4, ovs0[0], bw=1000, delay='1ms')
    net.addLink(ovs4, ovs0[0])
    # net.addLink(ovs4, ovs2[0], bw=1000, delay='1ms')
    net.addLink(ovs4, ovs2[0])
    # net.addLink(ovs4, ovs2[1], bw=1000, delay='1ms')
    net.addLink(ovs4, ovs2[1])

    # Create subnet "5" (really just one switch connecting subnets 0 and 3 and switch 4
    print "Creating switch 5"
    subnet = 5
    ovs5 = net.addSwitch("ovs%d" % (subnet), datapath='user')
    switchCounter += 1

    # net.addLink(ovs5, ovs0[1], bw=1000, delay='1ms')
    net.addLink(ovs5, ovs0[1])
    # net.addLink(ovs5, ovs3[0], bw=1000, delay='1ms')
    net.addLink(ovs5, ovs3[0])
    # net.addLink(ovs5, ovs3[1], bw=1000, delay='1ms')
    net.addLink(ovs5, ovs3[1])
    # net.addLink(ovs5, ovs4, bw=1000, delay='1ms')
    net.addLink(ovs5, ovs4)

    info( '*** Starting network\n')
    net.start()
    CLI(net)
    net.stop()
if __name__ == '__main__':
    setLogLevel ('info')
    campusNet()
