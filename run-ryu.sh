#! /bin/bash
cd /local/geni-install-files/ryu
sudo PYTHONPATH=. ./bin/ryu-manager --verbose --ofp-listen-host=0.0.0.0 --ofp-tcp-listen-port=6653 ryu/app/simple_switch_13.py &> /local/geni-install-files/ryu.log
