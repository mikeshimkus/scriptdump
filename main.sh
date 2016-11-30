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
echo "Self IP is: $selfip"
lastoctet=`echo $selfip | cut -d . -f 4`
echo "Last octet: $lastoctet"
instance=`expr $lastoctet - 4`
echo "Instance: $instance"

exec f5-rest-node /var/lib/waagent/custom-script/download/0/runScripts.js --log-level debug --tag v1.2.0 --onboard "--output /var/log/onboard.log --log-level debug --host $selfip -u admin -p $passwd --hostname $vmss_name$instance.azuresecurity.com --set-password admin:$passwd --db provision.1nicautoconfig:disable --db tmm.maxremoteloglength:2048 --module ltm:nominal --module asm:nominal --module afm:none --update-sigs"

exit
