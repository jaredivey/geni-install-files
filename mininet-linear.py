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
from mininet.node import OVSSwitch, RemoteController
from mininet.link import TCLink
from mininet.cli import CLI
from mininet.log import setLogLevel, info, debug, output

def linearNet():
    start_time = time.time()

    numHosts = 2
    numSwitches = 3

    "Create an empty network and add nodes to it."
    net = Mininet(link=TCLink)

    info('*** Adding controllers\n')
    controllers = []
    switches = []
    hosts = []
    controllerPort = 6653
    controllers.append(net.addController('c0', controller=RemoteController, ip='127.0.0.1', port=controllerPort))

    switchCounter = 0
    for i in range (0, numSwitches):
        switches.append(net.addSwitch('s' + str(switchCounter), datapath='user'))
        info( 'Switch: ' + switches[i].name + '\n' )
        if i > 0:
            net.addLink(switches[i-1], switches[i], bw=1000, delay='1ms')

        hostSet = []
        hostCounter = 0
        for j in range (0, numHosts):
            hostName = 'h' + str(switchCounter) + str(hostCounter)
            hostIP = '10.10.' + str(switchCounter) + '.' + str(hostCounter+1)
            hostSet.append(net.addHost(hostName, ip=hostIP))
            net.addLink(switches[i], hostSet[j], bw=1000, delay='1ms')
            hostCounter += 1
        hosts.append(hostSet)
        switchCounter += 1

    info( '*** Starting network\n')
    net.start()
    CLI(net)
    net.stop()
if __name__ == '__main__':
    setLogLevel ('info')
    linearNet()
