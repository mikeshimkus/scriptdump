#!/usr/bin/env node
const args = process.argv;
var subscriptionId = args[2];
var clientId = args[3];
var tenantId = args[4];
var secret = args[5];
var resourceGroup = args[6];
var azureSet = args[7];

var msRestAzure = require('ms-rest-azure');
var credentials = new msRestAzure.ApplicationTokenCredentials(clientId, tenantId, secret);

var async = require('async');
var util = require('util');
var iControl = require('icontrol');

var winston = require('winston');
var logger = new (winston.Logger)({
     transports: [
          new (require('winston-daily-rotate-file'))({
               filename: '/var/log/-azurevmss.log',
               datePattern: 'yyyy-MM-dd',
               prepend: true,
               handleExceptions: true,
               json: true,
               maxsize: 2097152,
               maxFiles: 5
          })
     ]
});

var port = '443';

var bigip = new iControl({
  host: 'localhost',
  proto: 'https',
  port: 443,
  strict: false,
  debug: false
});

var networkManagementClient = require('azure-arm-network');
var networkClient = new networkManagementClient(credentials, subscriptionId);

function getScaleSet(operationCallback) {
     async.parallel([
          function (callback) {
               networkClient.networkInterfaces.listVirtualMachineScaleSetNetworkInterfaces(resourceGroup, azureSet, function (err, result) {
                    if (err) return callback(err);
                    callback(null, result);
               });
          },
          function (callback) {
               bigip.list('/net/self', function (err, result) {
                    if (err) return callback(err);
                    callback(null, result);
               });
          }
     ],
     function (err, results) {
          if (err) return console.log('Error getting scale set info: ', err);
          dictionaryCallback(null, results[0], results[1]);
          return;
     });
     return;
}

function dictionaryCallback(err, scaleNet, selfIp) {
     if (err) return console.log('Pool update error: ', err);
     
     // what's my IP address
     for ( var a in selfIp ) {
          var selfName = selfIp[a].name;
          var selfAddr = selfIp[a].address.split('/').shift();
          if ( selfName === "self_1nic" ) {
               console.log("Self IP " + selfName + " found: " + selfAddr);
          }
     }
     
     // what are the hostnames, IP addresses, and instance IDs of the VMs
     var vmssDict = [];
     for ( var i in scaleNet ) {
          var vm = scaleNet[i].virtualMachine.id;
          var vmID = vm.split('/').pop();
          var vmName = azureSet + vmID + ".azuresecurity.com";
          var privateIP = scaleNet[i].ipConfigurations[0].privateIPAddress;       
          console.log("Private IP for VM " + vmName + " with instance ID " + vmID + " is: " + privateIP);
     }    
}

getScaleSet();
