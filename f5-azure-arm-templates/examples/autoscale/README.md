
# Deploying the BIG-IP VE in Azure - Example Auto Scale BIG-IP WAF (LTM + ASM) - VM Scale Set (Frontend via ALB)

[![Slack Status](https://f5cloudsolutions.herokuapp.com/badge.svg)](https://f5cloudsolutions.herokuapp.com)
[![Releases](https://img.shields.io/github/release/f5networks/f5-azure-arm-templates.svg)](https://github.com/f5networks/f5-azure-arm-templates/releases)
[![Issues](https://img.shields.io/github/issues/f5networks/f5-azure-arm-templates.svg)](https://github.com/f5networks/f5-azure-arm-templates/issues)

## Contents

- [Introduction](#introduction)
- [Prerequisites](#prerequisites)
- [Important Configuration Notes](#important-configuration-notes)
- [Security](#security)
- [Getting Help](#community-help)
- [Installation](#installation)
- [Configuration Example](#configuration-example)
- [Service Discovery](#service-discovery)

## Introduction

This solution uses a parent template to launch several linked child templates (modules) to create a full example stack for the BIG-IP autoscale solution.  The children templates are located in the examples/modules directories in this repository. **F5 encourages you to clone this repository and modify these templates to fit your use case.** 

The modules below create the following resources:

- **Network**: This template creates Azure Virtual Networks, subnets, and the management Network Security Group.
- **Application**: This template creates a generic application for use when demonstrating live traffic through the BIG-IP.
- **Disaggregation** *(DAG)*: This template creates resources required to get traffic to the BIG-IP.  ex. Azure Public IP Addresses, internal/external Load Balancers, and accompanying resources such as load balancing rules, NAT rules, and probes.
- **Access**: This template creates an Azure Managed User Identity, KeyVault, and secret for accessing the service principal key required by F5 service discovery.
- **BIG-IP**: This template creates the Microsoft Azure VM Scale Set with F5 BIG-IP Virtual Editions (provisioned with Local Traffic Manager (LTM) and Application Security Manager (ASM)). Traffic flows from the Azure load balancer to the BIG-IP VE instances and then to the application servers. The BIG-IP VE(s) are configured in single-NIC mode. Auto scaling means that as certain thresholds are reached, the number of BIG-IP VE instances automatically increases or decreases accordingly. The BIG-IP module template can be deployed separately from the example template provided here into an "existing" stack.

In contrast with the first-generation autoscale solution, this solution uses an immutable deployment model. The BIG-IP instances in the VM Scale Set no longer require configuration via the live BIG-IP instances or Device Service Cluster itself. Each instance is created with an identical configuration based on the optional input parameter values for dodeclarationurl, as3declarationurl, and tsdeclarationurl, eliminating the requirement for device synchronization. 

For instance, if you need to change the configuration on the BIG-IP, you update the model by simply modifying the input declarationUrl parameters to reference the new declarations. New instances will be deployed with the new configurations.  In most cases, it is expected that at least the AS3 declaration will be custom but if you leave the default (OPTIONAL) for any of these parameters, the example declaration from the BIG-IP module folder will be used.

F5 has provided the following example declarations for the supported Automation Toolchain components in the BIG-IP module folder:

- autoscale_do.json: The Declarative Onboarding declaration configures L2/L3 networking and system settings on BIG-IP. See the [DO documentation](https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/) for details on how to use DO.
- autoscale_as3.json: The Application Services declaration configures L4-L7 application services on BIG-IP, including service discovery. See the [AS3 documentation](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/) for details on how to use AS3.
- autoscale_ts.json: The Telemetry Streaming declaration configures BIG-IP to declaratively aggregate, normalize, and forward statistics and events to a consumer application. See the [TS documentation](https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/) for details on how to use TS.

For information on getting started using F5's ARM templates on GitHub, see [Microsoft Azure: Solutions 101](http://clouddocs.f5.com/cloud/public/v1/azure/Azure_solutions101.html).

## Prerequisites

 - This solution requires outbound Internet access for downloading the F5 BIG-IP Runtime Init and Automation Toolchain installation packages.
 - This solution uses calls to the Azure REST API to read and update Azure resources such as KeyVault secrets. For the solution to function correctly, you must ensure that the BIG-IP(s) can connect to the Azure REST API on port 443.
 - This solution uses calls to the Azure REST API to read and update Azure resources, this has specifically been tested in Azure Commercial Cloud. Additional cloud environments such as Azure Government, Azure Germany and Azure China cloud have not yet been tested.
 - If you are deploying an AS3 declaration that uses service discovery, you must provide an Azure Service Principal access key with the correct permissions for discovering application instances or network interfaces.
 - This template requires an SSH public key for access to the BIG-IP instances. 
   - Password authentication is not supported on initial deployment.  If you want access to the BIG-IP web-based Configuration utility, you must first SSH into the BIG-IP VE using the SSH key you provided in the template. You can then create a user account with admin-level permissions on the BIG-IP VE to allow access if necessary.
   -   **Disclaimer:** ***Accessing or logging into the instances themselves is for debugging purposes only. All configuration changes should be applied by updating the model via the template instead.***   

## Important configuration notes

- If you have cloned this repository to an internally hosted location in order to modify the templates, you can use the templateBaseUrl and artifactLocation input parameters to specify the location of the modules.

- To facilitate this immutable deployment model, the BIG-IP leverages the F5 BIG-IP Runtime Init package.  The BIG-IP template requires a valid f5-bigip-runtime-init configuration file and execution command to be specified in the properties of the Azure Virtual Machine Scale Set resource. See <a href="https://github.com/f5devcentral/f5-bigip-runtime-init">F5 BIG-IP Runtime Init</a> for more information.<br>

- In this solution, the BIG-IP VEs must have the [LTM](https://f5.com/products/big-ip/local-traffic-manager-ltm) and [ASM](https://f5.com/products/big-ip/application-security-manager-asm) modules enabled to provide advanced traffic management and web application security functionality. The provided Declarative Onboarding declaration describes how to provision these modules. This template uses BIG-IP **private** management address when license is requested via BIG-IQ.

- This template supports service discovery. See the [Service Discovery section](#service-discovery) for details.

- This template can send non-identifiable statistical information to F5 Networks to help us improve our templates. See [Sending statistical information to F5](#sending-statistical-information-to-f5).

- This template can be used to create the BIG-IP(s) using a local VHD or Microsoft.Compute image, please see the **customImage** parameter description for more details.

- F5 has created a matrix that contains all of the tagged releases of the F5 ARM templates for Microsoft Azure and the corresponding BIG-IP versions, license types, and throughput levels available for a specific tagged release. See [azure-bigip-version-matrix](https://github.com/F5Networks/f5-azure-arm-templates/blob/master/azure-bigip-version-matrix.md).

- F5 ARM templates now capture all deployment logs to the BIG-IP VE in **/var/log/cloud/azure**. Depending on which template you are using, this includes deployment logs (stdout/stderr) and more. Logs from Automation Toolchain components are located at **/var/log/restnoded/restnoded.log** on each BIG-IP instance.

- F5 ARM templates do not reconfigure existing Azure resources, such as network security groups. Depending on your configuration, you may need to configure these resources to allow the BIG-IP VE(s) to receive traffic for your application. Similarly, the DAG example template that deploys Azure Load Balancer(s) configures load balancing rules and probes on those resources to forward external traffic to the BIG-IP(s) on standard ports 443 and 80. F5 recommends cloning this repository and modifying the module templates to fit your use case.

- See the **[Configuration Example](#configuration-example)** section for a configuration diagram and description for this solution.

## Security

This ARM template downloads helper code to configure the BIG-IP system:

- installer.sh: The bootstrapping script for installing F5 BIG-IP Runtime Init, it is verified against a SHA256 checksum provided in the variables section of the ARM template.
- F5 BIG-IP Runtime Init: The installer.sh script downloads, verifies, and installs the F5 BIG-IP Runtime Init package. Package files are automatically verified based on SHA256 checksums published at the public F5 BIG-IP Runtime Init repository.
- F5 Automation Toolchain components: F5 BIG-IP Runtime Init downloads, installs, and configures the F5 Automation Toolchain components. Although it is optional, F5 recommends adding the extensionHash field to each extension install operation in the YAML configuration file. The presence of this field triggers verification of the downloaded component package checksum against the provided value. The checksum values are published as release assets on each extension's public Github repository, for example: https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.18.0/f5-appsvcs-3.18.0-4.noarch.rpm.sha256

The following example configuration file will verify the Declarative Onboarding and Application Services extensions before installation:

```yaml
runtime_parameters: []
extension_packages:
    install_operations:
        - extensionType: do
          extensionVersion: 1.10.0
          extensionHash: 190b9bb7e0f6e20aa344a36bcabeeb76c2af26e8b9c9a93d62bd6d4a26337cae
        - extensionType: as3
          extensionVersion: 3.17.0
          extensionHash: 41151962912408d9fc6fc6bde04c006b6e4e155fc8cc139d1797411983b7afa6
extension_services:
    service_operations:
      - extensionType: as3
        type: file
        value: ./examples/declarations/as3.json
```

If you want to verify the integrity of the template itself, F5 provides checksums for all of our templates. For instructions and the checksums to compare against, see [checksums-for-f5-supported-cft-and-arm-templates-on-github](https://devcentral.f5.com/codeshare/checksums-for-f5-supported-cft-and-arm-templates-on-github-1014).

## Supported BIG-IP versions

The following is a map that shows the available options for the template parameter **bigIpVersion** as it corresponds to the BIG-IP version itself. Only the latest version of BIG-IP VE is posted in the Azure Marketplace. For older versions, see downloads.f5.com.

| Azure BIG-IP Image Version | BIG-IP Version |
| --- | --- |
| 15.0.100000 | 15.0.1 Build 0.0.1 |
| 14.1.200000 | 14.1.2 Build 0.0.1 |
| latest | This will select the latest BIG-IP version available |

## Supported instance types and hypervisors

- For a list of supported Azure instance types for this solution, see the [Azure instances for BIG-IP VE](http://clouddocs.f5.com/cloud/public/v1/azure/Azure_singleNIC.html#azure-instances-for-big-ip-ve).

- For a list of versions of the BIG-IP Virtual Edition (VE) and F5 licenses that are supported on specific hypervisors and Microsoft Azure, see [supported-hypervisor-matrix](https://support.f5.com/kb/en-us/products/big-ip_ltm/manuals/product/ve-supported-hypervisor-matrix.html).

### Community Help

We encourage you to use our [Slack channel](https://f5cloudsolutions.herokuapp.com) for discussion and assistance on F5 ARM templates. There are F5 employees who are members of this community who typically monitor the channel Monday-Friday 9-5 PST and will offer best-effort assistance. This slack channel community support should **not** be considered a substitute for F5 Technical Support for supported templates. See the [Slack Channel Statement](https://github.com/F5Networks/f5-azure-arm-templates/blob/master/slack-channel-statement.md) for guidelines on using this channel.

## Installation

You have three options for deploying this solution:

- Using the Azure deploy buttons
- Using [PowerShell](#powershell-script-example)
- Using [CLI Tools](#azure-cli-10-script-example)

### Azure deploy buttons

Use the appropriate button below to deploy:

- **PAYG**: This allows you to use pay-as-you-go hourly billing.

  [![Deploy to Azure](http://azuredeploy.net/deploybutton.png)](https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2FF5Networks%2Ff5-azure-arm-templates%2Fv7.3.0.0%2Fexamples%2Fautoscale%2Fazuredeploy.json)

### Template parameters

| Parameter | Required | Description |
| --- | --- | --- |
| templateBaseUrl | Yes | URL where templates are stored. |
| artifactLocation | Yes | Location where modules folder is stored. |
| doDeclarationUrl | Yes | URL for the DO (https://clouddocs.f5.com/products/extensions/f5-declarative-onboarding/) declaration JSON file to be deployed. Leave as **OPTIONAL** to deploy with a default service configuration. |
| as3DeclarationUrl | Yes | URL for the AS3 (https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/) declaration JSON file to be deployed. Leave as **OPTIONAL** to deploy with a default service configuration. |
| tsDeclarationUrl | Yes | URL for the TS (https://clouddocs.f5.com/products/extensions/f5-telemetry-streaming/) declaration JSON file to be deployed. Leave as **OPTIONAL** to deploy with a default service configuration. |
| adminUsername | Yes | User name for the Virtual Machine. |
| sshKey | Yes | SSH public key to login to the Virtual Machine. Note: This should be the public key as a string, typically starting with **---- BEGIN SSH2 PUBLIC KEY ----** and ending with **---- END SSH2 PUBLIC KEY ----**. |
| dnsLabel | Yes | Unique DNS Name for the Public IP address used to access the Virtual Machine. |
| instanceType | Yes | Instance size of the Virtual Machine. |
| imageName | Yes | F5 SKU (image) you want to deploy. Note: The disk size of the VM is determined based on the option you select. **Important**: 10Gbps SKUs are supported only with BIG-IP VE v15 or later. If you intend to provision multiple modules, ensure the appropriate value is selected, such as **Best** instead of **Good**. |
| customImage | Yes | If you would like to deploy using a local BIG-IP image, provide either the full URL to the VHD in Azure storage **or** the full resource ID to an existing Microsoft.Compute image resource. **Note**: Unless specifically required, leave the default of **OPTIONAL**. |
| bigIpVersion | Yes | F5 BIG-IP version you want to use. |
| provisionPublicIP | Yes | Enabling management public IP(s) allows for direct public access to each BIG-IP VE that is created. |
| vnetAddressPrefix | Yes | The start of the CIDR block the BIG-IP VEs use when creating the Vnet and subnets. You MUST type just the first two octets of the /16 virtual network that will be created, for example '10.0', '10.100', 192.168'. |
| mgmtNsgName | Yes | If you would like to deploy using an existing Azure Network Security Group, provide the NSG name here.  **Note**: Unless specifically required, leave the default of **OPTIONAL**. |
| restrictedSrcAddress | Yes | This field restricts management access to a specific network or address. Enter an IP address or address range in CIDR notation, or asterisk for all sources. |
| vmScaleSetMinCount | Yes | The minimum (and default) number of BIG-IP VEs that will be deployed into the VM Scale Set. |
| vmScaleSetMaxCount | Yes | The maximum number of BIG-IP VEs that can be deployed into the VM Scale Set. |
| appInsights | Yes | Enter the name of your existing Application Insights environment that will be used to receive custom BIG-IP metrics you can use for Scale Set rules and device visibility. If the Application Insights environment is in a different Resource Group than this deployment, specify it as **app_insights_name;app_insights_rg**). If you do not have an Application Insights environment, leave the default (CREATE_NEW) and the template will create one. Note: By default, the new Application Insights environment will be created in **East US**, if necessary you can specify a different region as **CREATE_NEW:app_insights_region**). |
| scaleOutCpuThreshold | Yes | The percentage of CPU utilization that should trigger a scale out event. |
| scaleInCpuThreshold | Yes | The percentage of CPU utilization that should trigger a scale in event. |
| scaleOutThroughputThreshold | Yes | The amount of throughput (**bytes**) that should trigger a scale out event. Note: The default value is equal to 20 MB. |
| scaleInThroughputThreshold | Yes | The amount of throughput (**bytes**) that should trigger a scale in event. Note: The default value is equal to 10 MB. |
| scaleOutTimeWindow | Yes | The time window required to trigger a scale out event. This is used to determine the amount of time needed for a threshold to be breached, as well as to prevent excessive scaling events (flapping). **Note:** Allowed values are 1-60 (minutes). |
| scaleInTimeWindow | Yes | The time window required to trigger a scale in event. This is used to determine the amount of time needed for a threshold to be breached, as well as to prevent excessive scaling events (flapping). **Note:** Allowed values are 1-60 (minutes). |
| notificationEmail | Yes | If you want email notifications on scale events, specify an email address, otherwise leave the parameter as **OPTIONAL**. Note: You can specify multiple emails by separating them with a semi-colon, such as *email@domain.com;email2@domain.com*. |
| externalLoadBalancerName | Yes | If you would like to deploy using an existing Azure Load Balancer (Standard SKU) with a backend pool called loadBalancerBackEnd, provide the ALB name here. **Note**: Unless specifically required, leave the default of **OPTIONAL**. |
| internalLoadBalancerName | Yes | If you would like to add instances to an existing internal Azure Load Balancer (Standard SKU) with a backend pool called loadBalancerBackEnd, provide the internal ALB name here.  **Note**: Unless specifically required, leave the default of **OPTIONAL**. |
| useAvailabilityZones | Yes | This deployment can deploy resources into Azure Availability Zones (if the region supports it). If that is not desired, the input should be set 'No'. |
| provisionApp | Yes | Choose yes to deploy the application template. A full-stack deployment of application resources will be created. |
| application1ContainerName | Yes | Container Name for application 1 stack. |
| serviceDiscoveryApiKey | Yes | If you would like to automatically discover service nodes, specify the Azure service principal access key with appropriate permissions here. A separate template for Azure User Managed Identity and KeyVault resources will be deployed. Otherwise, leave the default of **OPTIONAL**.|
| tagValues | Yes | Default key/value resource tags will be added to the resources in this deployment, if you would like the values to be unique, adjust them as needed for each key. |

### Programmatic deployments

As an alternative to deploying through the Azure Portal (GUI) each solution provides example scripts to deploy the ARM template. The example commands can be found below along with the name of the script file, which exists in the current directory.

#### PowerShell Script Example

```powershell
## Example Command: .\Deploy_via_PS.ps1 -templateBaseUrl https://cdn.f5.com/product/cloudsolutions/ -artifactLocation f5-azure-arm-templates/examples/ -doDeclarationUrl <value> -as3DeclarationUrl <value> -tsDeclarationUrl <value> -adminUsername azureuser -sshKey <value> -dnsLabel <value> -instanceType Standard_DS2_v2 -imageName Best1Gbps -customImage OPTIONAL -bigIpVersion 15.0.100000 -provisionPublicIP Yes -vnetAddressPrefix 10.0 -mgmtNsgName OPTIONAL -restrictedSrcAddress * -vmScaleSetMinCount 2 -vmScaleSetMaxCount 4 -appInsights CREATE_NEW -scaleOutCpuThreshold 80 -scaleInCpuThreshold 20 -scaleOutThroughputThreshold 20000000 -scaleInThroughputThreshold 10000000 -scaleOutTimeWindow 10 -scaleInTimeWindow 10 -notificationEmail OPTIONAL -externalLoadBalancerName OPTIONAL -internalLoadBalancerName OPTIONAL -useAvailabilityZones Yes -provisionApp Yes -application1ContainerName f5devcentral/f5-demo-app:1.0.1 -serviceDiscoveryApiKey OPTIONAL -resourceGroupName <value>
```

=======

#### Azure CLI (1.0) Script Example

```bash
## Example Command: ./deploy_via_bash.sh 
--templateBaseUrl https://cdn.f5.com/product/cloudsolutions/ --artifactLocation f5-azure-arm-templates/examples/ --doDeclarationUrl <value> --as3DeclarationUrl <value> --tsDeclarationUrl <value> --adminUsername azureuser --sshKey <value> --dnsLabel <value> --instanceType Standard_DS2_v2 --imageName Best1Gbps --customImage OPTIONAL --bigIpVersion 15.0.100000 --provisionPublicIP Yes --vnetAddressPrefix 10.0 --mgmtNsgName OPTIONAL --restrictedSrcAddress * --vmScaleSetMinCount 2 --vmScaleSetMaxCount 4 --appInsights CREATE_NEW --scaleOutCpuThreshold 80 --scaleInCpuThreshold 20 --scaleOutThroughputThreshold 20000000 --scaleInThroughputThreshold 10000000 --scaleOutTimeWindow 10 --scaleInTimeWindow 10 --notificationEmail OPTIONAL --externalLoadBalancerName OPTIONAL --internalLoadBalancerName OPTIONAL --useAvailabilityZones Yes --provisionApp Yes --application1ContainerName f5devcentral/f5-demo-app:1.0.1 --serviceDiscoveryApiKey OPTIONAL --resourceGroupName <value> --azureLoginUser <value> --azureLoginPassword <value>
```


## Configuration Example

The following is an example configuration diagram for this solution deployment. In this scenario, all access to the BIG-IP VE appliance is through an Azure Load Balancer. The Azure Load Balancer processes both management and data plane traffic into the BIG-IP VEs, which then distribute the traffic to web/application servers according to normal F5 patterns.

![Configuration Example](../images/azure-autoscale-example-diagram.png)

#### BIG-IP Lifecycle Management

As new BIG-IP versions are released, existing VM scale sets can be upgraded to use those new images. This section describes the process of upgrading and retaining the configuration.

#### To upgrade the BIG-IP VE Image

1. Update the VM Scale Set Model to the new BIG-IP version
    - From PowerShell: Use the PowerShell script in the **scripts** folder in this directory.
    - Using the Azure redeploy functionality: From the Resource Group where the ARM template was initially deployed, click the successful deployment and then select to redeploy the template. If necessary, re-select all the same variables, and **only change** the BIG-IP version to the latest.
2. Upgrade the Instances
    1. In Azure, navigate to the VM Scale Set instances pane and verify the *Latest model* does not say **Yes** (it should have a caution sign instead of the word Yes).
    2. Select either all instances at once or each instance one at a time (starting with instance ID 0 and working up).
    3. Click the **Upgrade** action button.

#### Configure Scale Event Notifications

**Note:** You can specify email addresses for notifications within the solution and they will be applied automatically. You can also manually configure them via the VM Scale Set configuration options available within the Azure Portal.

You can add notifications when scale up/down events happen, either in the form of email or webhooks. The following shows an example of adding an email address via the Azure Resources Explorer that receives an email from Azure whenever a scale up/down event occurs.

Log in to the [Azure Resource Explorer](https://resources.azure.com) and then navigate to the Auto Scale settings (**Subscriptions > Resource Groups >** *resource group where deployed* **> Providers > Microsoft.Insights > Autoscalesettings > autoscaleconfig**). At the top of the screen click Read/Write, and then from the Auto Scale settings, click **Edit**.  Replace the current **notifications** json key with the example below, making sure to update the email address(es). Select PUT and notifications will be sent to the email addresses listed.

```json
    "notifications": [
      {
        "operation": "Scale",
        "email": {
          "sendToSubscriptionAdministrator": false,
          "sendToSubscriptionCoAdministrators": false,
          "customEmails": [
            "email@f5.com"
          ]
        },
        "webhooks": null
      }
    ]
```


## Documentation

For more information on F5 solutions for Azure, including manual configuration procedures for some deployment scenarios, see the Azure section of [Public Cloud Docs](http://clouddocs.f5.com/cloud/public/v1/).

### Service Discovery

The example autoscale template supports F5 service discovery configured via the Application Services (AS3) extension. If you are using service discovery in your custom AS3 declaration, you must specify an Azure Service Principal access key in the **serviceDiscoveryApiKey** input parameter. You must also reference this input parameter in your AS3 declaration and the customData property of the Azure VM Scale Set. See [Service discovery documentation](https://clouddocs.f5.com/products/extensions/f5-appsvcs-extension/latest/declarations/discovery.html) for specific guidance.

AS3 Declaration (snippet):

```json
"members": [
    {
        "servicePort": 80,
        "addressDiscovery": "azure",
        "updateInterval": 10,
        "tagKey": "foo",
        "tagValue": "bar",
        "addressRealm": "private",
        "resourceGroup": "myResourceGroup",
        "subscriptionId": "7fb1006f943a",
        "directoryId": "f98586303b68",
        "applicationId": "c9c4d0f9aa7",
        "apiAccessKey": "{{AZURE_SERVICE_PRINCIPAL}}",
        "credentialUpdate": true
    }
]
```

VM Scale Set customData (snippet):

```yaml
runtime_parameters:
  - name: AZURE_SERVICE_PRINCIPAL
    type: secret
    secretProvider: 
      type: KeyVault
      environment: azure
      vault: my-keyvault.vault.azure.net
    secretName: my_azure_secret
extension_packages:
    install_operations: []
extension_services:
    service_operations: []
```


#### Tagging

In Microsoft Azure, you have three options for tagging objects that service discovery uses. Note that you select public or private IP addresses within the declaration using the **addressRealm** field value.

- *Tag a VM resource*<br> The BIG-IP VE will discover the primary public or private IP addresses for the primary NIC configured for the tagged VM.

- *Tag a NIC resource*<br> The BIG-IP VE will discover the primary public or private IP addresses for the tagged NIC. Use this option if you want to use the secondary NIC of a VM in the pool.

- *Tag a Virtual Machine Scale Set resource*<br> The BIG-IP VE will discover the primary private IP address for the primary NIC configured for each Scale Set instance. Note you must specify private for the addressRealm property in the AS3 declaration if you are tagging a Scale Set.

Service discovery first looks for NIC resources with the tags you specify in the **tagKey** and **tagValue** field values. If it finds NICs with the proper tags, it does not look for VM resources. If it does not find NIC resources, it looks for VM resources with the proper tags. In either case, it then looks for Scale Set resources with the proper tags.

### Sending statistical information to F5

All of the F5 templates now have an option to send anonymous statistical data to F5 Networks to help us improve future templates.
None of the information we collect is personally identifiable, and only includes:

- Customer ID: this is a hash of the customer ID, not the actual ID
- Deployment ID: hash of stack ID
- F5 template name
- F5 template version
- Cloud Name
- Azure region
- BIG-IP version
- F5 license type
- F5 Cloud libs version
- F5 script name

This information is critical to the future improvements of templates, but if you select **No**, information will not be sent to F5.

## Filing Issues

If you find an issue, we would love to hear about it.
You have a choice when it comes to filing issues:

- Use the **Issues** link on the GitHub menu bar in this repository for items such as enhancement or feature requests and non-urgent bug fixes. Tell us as much as you can about what you found and how you found it.
- Contact us at [solutionsfeedback@f5.com](mailto:solutionsfeedback@f5.com?subject=GitHub%20Feedback) for general feedback or enhancement requests.
- Use our [Slack channel](https://f5cloudsolutions.herokuapp.com) for discussion and assistance on F5 cloud templates. There are F5 employees who are members of this community who typically monitor the channel Monday-Friday 9-5 PST and will offer best-effort assistance.
- For templates in the **supported** directory, contact F5 Technical support via your typical method for more time sensitive changes and other issues requiring immediate support.

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