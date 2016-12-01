#!/bin/bash
while getopts d:s:m:a:o::i:t:c:p:r:v:u:x: option
do case "$option" in
        d) deployment=$OPTARG;;
        s) cloudlibs_tag=$OPTARG;;
        m) mode=$OPTARG;;
        a) addr=$OPTARG;;
        o) port=$OPTARG;;
        i) subscription_id=$OPTARG;;
        t) tenant_id=$OPTARG;;
        c) client_id=$OPTARG;;
        p) sp_secret=$OPTARG;;
        r) resource_group=$OPTARG;;
        v) vmss_name=$OPTARG;;
        u) user=$OPTARG;;
        x) passwd=$OPTARG;;
    esac
done

selfip=$(tmsh list net self self_1nic address | grep -o '[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}\.[0-9]\{1,3\}')
lastoctet=`echo $selfip | cut -d . -f 4`
instance=`expr $lastoctet - 4`

if [[ $instance == 0 ]]; then
     exec f5-rest-node /var/lib/waagent/custom-script/download/0/runScripts.js --log-level debug --tag $cloudlibs_tag --onboard "--output /var/log/onboard.log --log-level debug --host $selfip -u admin -p $passwd --hostname $vmss_name$instance.azuresecurity.com --set-password admin:$passwd --db provision.1nicautoconfig:disable --db tmm.maxremoteloglength:2048 --module ltm:nominal --module asm:none --module afm:none --signal ONBOARD_DONE" --cluster "--wait-for ONBOARD_DONE --output /var/log/clusterGroup.log --log-level debug --host $selfip -u admin -p $passwd --create-group --device-group Sync --sync-type sync-failover --device $vmss_name$instance.azuresecurity.com --auto-sync --save-on-auto-sync --signal CLUSTER_GROUP_DONE" --script "--wait-for CLUSTER_GROUP_DONE --output /var/log/runScript.log --log-level debug --host $selfip -u admin -p $passwd --url http://cdn-prod-ore-f5.s3-website-us-west-2.amazonaws.com/product/blackbox/staging/azure/deploy_ha.sh --cl-args ' -m $mode -d $deployment -n $add -h $port -u $user -p $passwd' --signal SCRIPT_DONE" --cluster "--wait-for SCRIPT_DONE --output /var/log/clusterSync.log --log-level debug --host $selfip -u admin -p $passwd --config-sync-ip $selfip --signal CLUSTER_SYNC_DONE"
else
     exec f5-rest-node /var/lib/waagent/custom-script/download/0/runScripts.js --log-level debug --tag $cloudlibs_tag --onboard "--output /var/log/onboard.log --log-level debug --host $selfip -u admin -p $passwd --hostname $vmss_name$instance.azuresecurity.com --set-password admin:$passwd --db provision.1nicautoconfig:disable --db tmm.maxremoteloglength:2048 --module ltm:nominal --module asm:none --module afm:none --signal ONBOARD_DONE" --cluster "--wait-for ONBOARD_DONE --output /var/log/cluster.log --log-level debug --host $selfip -u admin -p $passwd --config-sync-ip $selfip --join-group --device-group Sync --sync --remote-host 10.0.0.4 --remote-user admin --remote-password $passwd --signal CLUSTER_DONE"
fi
     
if [[ $? == 0 ]]; then
     echo "SUCCESS!"
else 
     echo "FAIL"
     exit
fi

exit
