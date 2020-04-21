# Deploying Application template


## Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Important Configuration Notes](#important-configuration-notes)
- [Installation](#installation)

## Introduction

This solution uses an ARM template to launch a stack for hosting an application. The template uses Linux operation system for hosting application
and it allows to extend Virtual Machine capabilities via providing custom configurations: 
 
  1) [Cloud-init](https://cloudinit.readthedocs.io/en/latest/)
  2) Bash script


## Prerequisites

 - Requires existing network infrastructure with private subnet
 

## Important configuration notes

 - Template downloads and renders custom configs (i.e. cloud-init and bash script) as external files and therefore, the custom configs must be accessible from Virtual Machine
 - Examples of custom configs are provided under scripts directory
 - Public ip won't be provisioned for this template
 - Template uses the Linux Ubuntu Server 16.04.0-LTS as Virtual Machine operational system


### Template parameters

| Parameter | Required | Description |
| --- | --- | --- |
| vnetName | Yes | Virtual Network name |
| vnetResourceGroupName | Yes | Azure Resource Group used for scoping resources |
| subnetName | Yes | Private subnet name for Virtual Machine |
| appPrivateAddress | Yes | Desire private ip; must be within private subnet |
| adminUsername | Yes | User name for the Virtual Machine |
| adminPassword | Yes | Password for the Virtual Machine |
| dnsLabel | Yes | Unique DNS Name for the Public IP address used to access the Virtual Machine. |
| instanceName | Yes | Name of the Virtual Machine. |
| instanceType | Yes | Instance size of the Virtual Machine. |
| initScriptDeliveryLocation | No | URI to bash init script |
| initScriptParameters | No | Parameters used for init script; mutliple parameters must be provided as space separated string |
| cloudInitDeliveryLocation | No | URI to cloud-init config |

## Copyright

Copyright 2014-2020 F5 Networks Inc.

## License

### Apache V2.0

Licensed under the Apache License, Version 2.0 (the "License"); you may not use
this file except in compliance with the License. You may obtain a copy of the
License [here](http://www.apache.org/licenses/LICENSE-2.0).

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and limitations
under the License.

### Contributor License Agreement

Individuals or business entities who contribute to this project must have
completed and submitted the F5 Contributor License Agreement.