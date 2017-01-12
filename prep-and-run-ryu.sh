#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-ctrl-deps.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-ctrl-deps.txt"`
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at
        sudo hg clone https://hg.python.org/cpython -u v2.7.13
        cd /local/cpython
        sudo ./configure
        sudo make
        sudo make install
        cd /local
        sudo wget https://bootstrap.pypa.io/get-pip.py
        sudo python get-pip.py
        sudo pip -q install eventlet routes webob paramiko babel debtcollector pytz pbr wrapt oslo.config oslo.i18n netaddr rfc3986 repoze.lru tinyrpc
        sudo git clone git://github.com/osrg/ryu.git /local/geni-install-files/ryu
        cd /local/geni-install-files/ryu
        patch -p1 -i ../ryu.patch
        sudo python ./setup.py install
        cd /local/geni-install-files
        sudo git clone git://github.com/jaredivey/dce-python-sdn /local/geni-install-files/dce-python-sdn
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_simple.py /local/geni-install-files/ryu/ryu/app/nix_simple.py
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_mpls_geni.py /local/geni-install-files/ryu/ryu/app/nix_mpls_geni.py
        sudo chmod +x /local/geni-install-files/run-ryu.sh
        sudo at now +1 minute -f /local/geni-install-files/run-ryu.sh
fi
