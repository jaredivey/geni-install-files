#! /bin/bash
cd /local/geni-install-files
case $1 in
# Run client command
1)
    sudo iperf -c 10.10.1.1 -p45000 -n100M
    sudo iperf -c 10.10.2.1 -p45000 -n100M
    sudo iperf -c 10.10.3.1 -p45000 -n100M
    sudo iperf -c 10.10.4.1 -p45000 -n100M
;;
# Run server command
*)
    sudo at now +1minute -f /local/geni-install-files/start-iperf-server.sh
    sleep 10m
    ./run-iperf.sh 1
;;
esac
