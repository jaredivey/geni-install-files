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
for listener in {0..127}
do
        let port=45000+$listener
        sudo echo "sudo iperf -s -p$port -B10.10.$1.$2 > /local/iperfs-$listener.log" > /local/geni-install-files/start-iperf-$listener.sh
        sudo chmod +x /local/geni-install-files/start-iperf-$listener.sh
        sudo at now -f /local/geni-install-files/start-iperf-$listener.sh
done
