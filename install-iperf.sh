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
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at iperf wireshark
fi
# Set iperf servers to listen on distinct ports for each host so the bind on the client side
# will not interfere with already bound address/port combination
sudo mkdir -p /local/iperfs
#for listener in {0..127}
#do
#        let port=45000+$listener
#        sudo echo "iperf -s -i1s -p$port -B10.10.$1.$2 > /users/jivey/iperfs-10.10.$1.$2.$port.log" > /local/iperfs/start-iperf-10.10.$1.$1.$port.sh
#        sudo chmod +x /local/iperfs/start-iperf-10.10.$1.$1.$port.sh
#        sudo at now -f /local/iperfs/start-iperf-10.10.$1.$1.$port.sh
#done
