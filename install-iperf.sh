#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-iperf.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-iperf.txt"`

       #### Run  one-time commands ####
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at iperf
fi
# Set iperf servers to listen on distinct ports for each host so the bind on the client side
# will not interfere with already bound address/port combination
sudo echo "sudo iperf -s -p4500$1 -B10.10.$1.$2 > /local/iperfs-$1-$2.log" > /local/geni-install-files/start-iperf-$1-$2.sh
sudo chmod +x /local/geni-install-files/start-iperf-$1-$2.sh
sudo at now -f /local/geni-install-files/start-iperf-$1-$2.sh
