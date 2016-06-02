#!/bin/bash

tmsh modify sys dns name-servers replace-all-with { 8.8.8.8 }       
sleep 10

tmsh modify sys ntp timezone UTC servers replace-all-with { pool.ntp.org }
sleep 10
