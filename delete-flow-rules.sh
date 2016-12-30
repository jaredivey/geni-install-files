#! /bin/bash  
ssh -X -p33089 jivey@pc5.instageni.rnoc.gatech.edu "sudo ovs-ofctl del-flows br0"
ssh -X -p33090 jivey@pc5.instageni.rnoc.gatech.edu "sudo ovs-ofctl del-flows br0"
ssh -X -p33091 jivey@pc5.instageni.rnoc.gatech.edu "sudo ovs-ofctl del-flows br0"
