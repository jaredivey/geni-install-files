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
        sudo chmod +x /local/geni-install-files/run-iperf.sh
        sudo chmod +x /local/geni-install-files/start-iperf-server.sh
        sudo at now +1 minute -f /local/geni-install-files/run-iperf.sh
fi
