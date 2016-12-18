#! /bin/bash
cd /local/geni-install-files/ryu
sudo PYTHONPATH=. ./bin/ryu-manager --verbose --ofp-listen-host=11.1.1.1 --ofp-tcp-listen-port=6653 ryu/app/simple_switch.py &> /local/geni-install-files/ryu.log
