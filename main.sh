#!/bin/bash
while getopts s:k:i:t:c:p:v: option
do	case "$option"  in
        s) storage_acct=$OPTARG;;
        k) storage_key=$OPTARG;;
        i) subscription_id=$OPTARG;;
        t) tenant_id=$OPTARG;;
        c) client_id=$OPTARG;;
        p) sp_secret=$OPTARG;;
        v) vmss_name=$OPTARG;;
    esac 
done

mkdir -m 777 /var/tmp/azure_dict
touch /var/tmp/azure_dict/az.json

json="{"\"storageAccount\"":"\"$storage_acct\"","\"storageKey\"":"\"$storage_key\"","\"subscriptionId\"":"\"$subscription_id\"","\"tenantId\"":"\"$tenant_id\"","\"clientId\"":"\"$client_id\"","\"secret\"":"\"$sp_secret\"","\"vmss\"":"\"$vmss_name\""}"
echo $json >> /var/tmp/azure_dict/az.json
exit
