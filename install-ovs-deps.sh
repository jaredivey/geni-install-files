#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-ovs-deps.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-ovs-deps.txt"`

       #### Run  one-time commands ####
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at
        sudo chmod +x /local/geni-install-files/create-ovs-br0.sh
        sudo at now +5 minutes -f /local/geni-install-files/create-ovs-br0.sh
