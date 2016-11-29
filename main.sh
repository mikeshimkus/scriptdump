#!/bin/bash
while getopts s:k:i:t:c:p: option
do	case "$option"  in
        s) storage_acct=$OPTARG;;
        k) storage_key=$OPTARG;;
        i) subscription_id=$OPTARG;;
        t) tenant_id=$OPTARG;;
        c) client_id=$OPTARG;;
        p) sp_secret=$OPTARG;;
    esac 
done

mkdir -m 777 /var/tmp/mystuff
touch /var/tmp/mystuff/mystuff.txt

echo $storage_acct >> /var/tmp/mystuff/mystuff.txt
echo $storage_key >> /var/tmp/mystuff/mystuff.txt
echo $subscription_id >> /var/tmp/mystuff/mystuff.txt
echo $tenant_id >> /var/tmp/mystuff/mystuff.txt
echo $client_id >> /var/tmp/mystuff/mystuff.txt
echo $sp_secret >> /var/tmp/mystuff/mystuff.txt
exit
