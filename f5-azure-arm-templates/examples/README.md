
## Example Templates

The examples here leverage the modular [linked templates](https://docs.microsoft.com/en-us/azure/azure-resource-manager/templates/linked-templates) design to provide maximum flexibility when authoring solutions using F5 BIG-IP.  

Example deployments use parent templates to deploy child templates (or modules) to facilitate quickly standing up entire stacks (complete with **example** network, application, and of course BIG-IP tiers). 

As a basic framework, an example full stack deployment will consist of: 

Parent Template:
 -  (Child) Network Template
 -  (Child) Application Template
 -  (Child) Requirements Template(s) 
 -  (Child) BIG-IP Template (existing stack)

***Disclaimer:** F5 does not require or have any recommendations on leveraging linked stacks in production. They are used here simply as useful tested/validated examples to illustrate various resource dependencies, configurations, etc. (that you may need or want to customize), no matter what the deployment method used.* 

## Template Types
Templates are grouped into the following categories.

  - **Quickstart** <br>This template deploys an individual BIG-IP VE with a limited set of input parameters for quick creation, as well as the full stack of resources required by the solution. Standalone BIG-IP VEs are primarily used for Dev/Test/Staging, replacing/Upgrading individual instances in traditional failover clusters (see Failover), and/or scaling out (for deployments where the configuration is managed remotely as opposed to relying on the synchronization functionality (config-sync) of the cluster). <br>

  - **Autoscale** <br> This parent template deploys a group of BIG-IP VEs that scale in and out based on thresholds you configure in the template, as well as the full stack of resources required by the solution. The BIG-IP VEs are all active and are primarily used to scale out an individual L7 service on a single wildcard virtual (although you can add additional services using ports).<br>
  This type of deployment is immutable and does not rely on the native F5 Device Service Clustering (DSC) for configuration sync. Instead, the F5 Automation Toolchain is used for configuration.<br> 
  You must provide valid F5 Declarative Onboarding, Application Services, and Telemetry Streaming component declarations to be deployed via autoscale settings each time an instance is added to the scale set; example declarations are available in the BIG-IP module folder.

  - **Failover** <br> This parent template deploys more than one BIG-IP VE in a <a href="http://www.f5.com/pdf/white-papers/scalen-elastic-infrastructure-white-paper.pdf">ScaleN cluster</a> (a traditional High Availability Pair in most cases), as well as the full stack of resources required by the solution. Failover clusters are primarily used to replicate traditional Active/Standby BIG-IP deployments. <br>
  In these deployments, an individual BIG-IP VE in the cluster owns (or is Active for) a particular IP address. For example, the BIG-IP VEs will fail over services from one instance to another by remapping IP addresses, routes, etc. based on Active/Standby status. Failover is implemented either via API (API calls to the cloud platform vs. network protocols like Gratuitous ARP, route updates, and so on), or via an upstream service (like a native load balancer) which will only send traffic to the active instance for that service based on a health monitor. For more information, see the failover README files. In all cases, a single BIG-IP VE will be active for a single IP address. Valid F5 Declarative Onboarding and Cloud Failover component declarations are required for a successful deployment; example declarations are available in the BIG-IP module folder.

  - **Modules** <br> These templates create the resources that compose a full stack deployment. They are referenced as linked templates from the parent template (Autoscale, Failover, and Quickstart).<br>
  This type of template relies on a parent template (for example, as Autoscale or Failover azuredeploy.json) to pass required input parameters, such as virtual network name and load balancer ID, and their outputs to other child templates.<br>

    #### Module Types:
      - Network: This template creates Azure Virtual Networks, subnets, and the management Network Security Group.
      - Application: This template creates a generic application for use when demonstrating live traffic through the BIG-IP.
      - Disaggregation (DAG): This template creates resources required to get traffic to the BIG-IP.  ex. Azure Public IP Addresses, internal/external Load Balancers, and accompanying resources such as load balancing rules, NAT rules, and probes.
      - Access: This template creates an Azure Managed User Identity, KeyVault, and secret for accessing the service principal key required by F5 service discovery.
      - BIG-IP: This template creates the BIG-IP Virtual Machine instance(s), either a standalone VM, a cluster of two VMs, or a Virtual Machine Scale Set. In the case of autoscale, the required Autoscale Settings and Application Insights resources are also created. The BIG-IP module supports deployment of a standalone instance, two clustered instances, or a Virtual Machine Scale Set, based on the parent deployment type. It can be used separately from the example templates provided here.<br> The BIG-IP template requires a valid f5-bigip-runtime-init configuration file and execution command to be specified in the properties of the Azure Virtual Machine or Scale Set resource. See <a href="https://github.com/f5devcentral/f5-bigip-runtime-init">F5 BIG-IP Runtime Init</a> for more information.<br>
          
          Lifecycle:  The BIG-IP module facilitates initial deployments only. Changing the version of BIG-IP in the template will cause a new BIG-IP image to be deployed and its configuration will have to be restored via traditional means. For example, if the instance has:   
          * Single slot or BIG-IP was replaced/upgraded
            * Restore the BIG-IP VE backup [UCS](https://support.f5.com/csp/article/K13132) file.
            * Use external automation to completely re-configure and re-cluster
          * Multiple slots
            * In place via live installs from an available slot.<br>
 
## Deployment Flow Example
Autoscale example template shown

![Deployment](./images/azure-autoscale-example-diagram.png)