#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-ctrl-deps.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-ctrl-deps.txt"`
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at python-dev build-essential python-pip python-greenlet python-greenlet-dev
        sudo pip -q install eventlet routes webob paramiko babel debtcollector oslo.config oslo.i18n netaddr rfc3986 repoze.lru tinyrpc
        sudo git clone git://github.com/osrg/ryu.git /local/geni-install-files/ryu
        cd /local/geni-install-files/ryu
        sudo python ./setup.py install
        cd /local/geni-install-files
        sudo chmod +x /local/geni-install-files/run-ryu.sh
        sudo at now +1 minute -f /local/geni-install-files/run-ryu.sh
fi
