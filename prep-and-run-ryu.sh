#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-ctrl-deps.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-ctrl-deps.txt"`
        sudo apt-get update
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y -q install at mercurial libreadline-dev texinfo libbz2-dev openjdk-7-jdk ant maven
        sudo hg clone https://hg.python.org/cpython -u v2.7.13
        cd /local/cpython
        sudo patch -p1 -i /local/geni-install-files/python.patch
        sudo ./configure
        sudo make
        sudo make install
        # Python install may not fully complete
        sudo ln -sf /usr/local/bin/python2.7 /usr/local/bin/python
        sudo mkdir -p /usr/local/lib/python2.7/lib-dynload
        sudo cp /local/cpython/build/lib.linux-x86_64-2.7/* /usr/local/lib/python2.7/lib-dynload/
        sudo cp /local/cpython/Include/* /usr/local/include/python2.7/
        sudo cp /local/cpython/pyconfig.h /usr/local/include/python2.7/
        cd /local
        sudo wget https://bootstrap.pypa.io/get-pip.py
        sudo python get-pip.py
        sudo pip -q install eventlet routes webob paramiko babel debtcollector pytz pbr wrapt oslo.config oslo.i18n netaddr rfc3986 repoze.lru tinyrpc
        sudo git clone https://github.com/osrg/ryu.git /local/geni-install-files/ryu
        cd /local/geni-install-files/ryu
        patch -p1 -i ../ryu.patch
        sudo python ./setup.py install
        cd /local/geni-install-files
        sudo git clone https://github.com/jaredivey/dce-python-sdn /local/geni-install-files/dce-python-sdn
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_simple_bfs.py /local/geni-install-files/ryu/ryu/app/nix_simple_bfs.py
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_simple_ucs.py /local/geni-install-files/ryu/ryu/app/nix_simple_ucs.py
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_mpls_bfs.py /local/geni-install-files/ryu/ryu/app/nix_mpls_bfs.py
        sudo ln -s /local/geni-install-files/dce-python-sdn/nix_mpls_ucs.py /local/geni-install-files/ryu/ryu/app/nix_mpls_ucs.py
        #sudo chmod +x /local/geni-install-files/run-ryu.sh
        #sudo at now +1 minute -f /local/geni-install-files/run-ryu.sh

        sudo git clone https://github.com/floodlight/floodlight /local/geni-install-files/floodlight -bv1.2
        cd /local/geni-install-files/floodlight
        sudo git submodule init
        sudo git submodule update
        sudo ant
fi
