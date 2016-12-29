#! /bin/bash
# downloading software in ProtoGENI hosts is `/local`
cd /local

##### Check if file is there #####
if [ ! -f "./installed-ovs-deps.txt" ]
then
       #### Create the file ####
        sh -i -c `sudo touch "./installed-ovs-deps.txt"`

       #### Run  one-time commands ####
        sudo git clone https://github.com/openvswitch/ovs /local/ovs
        cd /local/ovs
        sudo patch -p1 -i /local/geni-install-files/ovs.patch
        sudo ./boot.sh
        sudo ./configure
        sudo make
        sudo make install
        sudo /sbin/modprobe openvswitch

        sudo mkdir -p /usr/local/etc/openvswitch
        sudo ovsdb-tool create /usr/local/etc/openvswitch/conf.db vswitchd/vswitch.ovsschema
        sudo mkdir -p /usr/local/var/run/openvswitch
        sudo ovsdb-server --remote=punix:/usr/local/var/run/openvswitch/db.sock \
            --remote=db:Open_vSwitch,Open_vSwitch,manager_options \
            --pidfile --detach --log-file
        sudo ovs-vsctl --no-wait init
        sudo ovs-vswitchd --pidfile --detach --log-file

        sudo chmod +x /local/geni-install-files/create-ovs-br0.sh
        sudo bash /local/geni-install-files/create-ovs-br0.sh $1
fi
