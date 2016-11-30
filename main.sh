#!/bin/bash
while getopts s:k:i:t:c:p:r:v:u:x: option
do      case "$option"  in
        s) storage_acct=$OPTARG;;
        k) storage_key=$OPTARG;;
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

if [[ $? == 0 ]]; then
     if [[ $instance == 0 ]]; then
          exec f5-rest-node /var/lib/waagent/custom-script/download/0/runScripts.js --log-level debug --tag v1.2.0 --onboard "--output /var/log/onboard.log --log-level debug --host $selfip -u admin -p $passwd --hostname $vmss_name$instance.azuresecurity.com --set-password admin:$passwd --db provision.1nicautoconfig:disable --db tmm.maxremoteloglength:2048 --module ltm:nominal --module asm:nominal --module afm:none --update-sigs --signal ONBOARD_DONE" --cluster "--wait-for ONBOARD_DONE --output /var/log/cluster.log --log-level debug --host $selfip -u admin -p $passwd --config-sync-ip $selfip --create-group --device-group Sync --sync-type sync-failover --device $vmss_name$instance.azuresecurity.com --auto-sync --save-on-auto-sync --asm-sync"
     else
          exec f5-rest-node /var/lib/waagent/custom-script/download/0/runScripts.js --log-level debug --tag v1.2.0 --onboard "--output /var/log/onboard.log --log-level debug --host $selfip -u admin -p $passwd --hostname $vmss_name$instance.azuresecurity.com --set-password admin:$passwd --db provision.1nicautoconfig:disable --db tmm.maxremoteloglength:2048 --module ltm:nominal --module asm:nominal --module afm:none --signal ONBOARD_DONE" --cluster "--wait-for ONBOARD_DONE --output /var/log/cluster.log --log-level debug --host $selfip -u admin -p $passwd --config-sync-ip $selfip --join-group --device-group Sync --sync --remote-host 10.0.0.4 --remote-user admin --remote-password $passwd"
     fi
else 
     echo "FAIL"
exit
