#!/bin/bash
while getopts s:k: option
do	case "$option"  in
        s) storageacct=$OPTARG;;
        k) key=$OPTARG;;
    esac 
done

mkdir -m 777 /var/tmp/mystuff
touch /var/tmp/mystuff/mystuff.txt

echo $storageacct >> /var/tmp/mystuff/mystuff.txt
echo $key >> /var/tmp/mystuff/mystuff.txt
exit
