# Master AWS Marketplace template for deploying Ribbon SBC with BYOL Licensing

**Contents**
- [Introduction](#Introduction)
- [Files](#Files-in-this-repo)
- [Supported Instance types](#supported-instance-types )
- [Template parameters](#template-parameters)
- [More documentation](#more-documentation)
- [Getting Help](#support-information)

## Introduction ##

This is the master CloudFormation template available from AWS Marketplace.

This is an existing stack template, meaning the networking infrastructure MUST be available prior to deploying. 
    
For information on getting started using Ribbon SBC CFT templates on GitHub, see [**Amazon Web Services: Solutions 101**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/AmazonWebServices-Solutions_101.md).

This CloudFormation template prompts the user to select the SBC mode to launch (SA, HA or HAHFE) and then collects information to launch one of the SBC deployment solutions below. 

Click on the title links below to find more information about the different SBC deployment solutions and their pre-requisites:

[**Standalone SBC (SA)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/standalone/existing-stack/byol)
- requires existing stack
- includes single SBC instance but provides no application redundancy 
- BYOL (bring your own license)
 
[**High Availability SBC (HA)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability/existing-stack/byol)
- requires existing stack  
- instantiates includes active and standby instances with application redundancy 
- BYOL (bring your own license)
 
[**High Availability SBC with Front End (HAHFE)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailabilityhfe/existing-stack/byol/HFEmanualSubnet.md)
- requires existing stack.
- instantiates HA-SBC with HFE to minimize failover times - all subnets must be pre-allocated.
- BYOL (bring your own license)

**Launch the Ribbon SBC Marketplace CFT**

[![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/templates/marketplace_cft_1.1)

## Files in this repo ##

- **marketplace_cft_1.1**	- CFT master template as posted in marketplace - allows selection of which SBC mode to deploy .

- **README.md** - this README file

## Supported Instance Types

As of release 7.2S405, only following Instance types are supported for deployment in AWS:
  - m5.xlarge
  - m5.2xlarge
  - c5.2xlarge
  - c5.4xlarge
  - c5.9xlarge
  - c5n.2xlarge
  - c5n.4xlarge
  - c5n.9xlarge
  - g3.4xlarge
  - p3.2xlarge
  
## Template Parameters  
  
  **Table**  :  Create Stack Parameters
  
> Note
> 
> Third party CPU setting of more than 2 vCPU is not supported with
> p3.2xlarge instances due to the vCPU requirement of the
> Standard\_GPU\_Profile.

<table>
<thead>
<tr class="header">
<th><strong>Parameter Section</strong></th>
<th><strong>Field</strong></th>
<th><strong>Description</strong></th>
<th><strong>Mandatory</strong></th>
<th><strong>Can be Left Blank</strong></th>
<th><strong>Customizable by User</strong></th>
</tr>
</thead>
<tbody>
<tr class="even">
<td>SBC Mode</td>
<td><strong>SBCMODE</strong></td>
<td>SBC Deployment Topology. Specify whether Standalone(SA), High-Availability(HA), or High-Availability with HFE(HAHFE)</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC and HFE Common Data</td>
<td><strong>LinuxAdmin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to linux shell on SBC instance.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC and HFE Common Data</td>
<td><strong>Admin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to admin CLI on SBC instance.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC and HFE Common Data</td>
<td><strong>VpcId</strong></td>
<td>Select a VPC with Subnet, Security Group, etc., selected earlier.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC and HFE Common Data</td>
<td><strong>InstanceType</strong></td>
<td><p>Type of instance that is created from stack.</p>
<p>Note: Sonus recommends m5.xlarge or higher instance type if this instance type is available in your zone. Use c5.2xlarge instance type or higher to handle more calls with transcoding.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC and HFE Common Data</td>
<td><strong>EipAssociationForMgt</strong></td>
<td>Select <strong>Yes  </strong>from the drop-down  to associate EIP for MGT0 interface to login and access SBC application from public networks. Select <strong>No</strong> if not requiring EIP or if wishing to use a pre-allocated EIP for management.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC and HFE Common Configuration</td>
<td><strong>SortHfeEip</strong></td>
<td>Select <strong>Yes  </strong>from the drop-down  to  enable sorting based on HFE EIP.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC and HFE Common Data</td>
<td><strong>remoteSSHMachinePublicIP</strong></td>
<td>Optionally the HFE management interface can be accessed from a public server. Enter IP(public IP) of machine that will connect(SSH) to HFE using public IP.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC and HFE Common Data</td>
<td><strong>SBCAvailabilityZone</strong></td>
<td>Enter Availability Zone for SBC, New subnets for SBC must exist here.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC Configuration</td>
<td><strong>SecurityGrpMgt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for MGT0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC Configuration</td>
<td><strong>SecurityGrpHa0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for HA0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC Configuration</td>
<td><strong>SecurityGrpPkt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC Configuration</td>
<td><strong>SecurityGrpPkt1</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT1.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC configuration</td>
<td><strong>SubnetIdMgt0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for Mgt0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>SubnetIdHA0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for HA0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>SubnetIdPkt0</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC configuration</td>
<td><strong>SubnetIdPkt1</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt1.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC configuration</td>
<td><strong>IAMRole</strong></td>
<td>The name of the IAM role for SBC SWe instance. For more information on IAM Role, see Creating Identity and Access Management (IAM) Roles.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>Tenancy</strong></td>
<td>Tenancy attribute for SBC instances. Options are default and dedicated.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC Configuration</td>
<td><strong>PlacementId</strong></td>
<td>A placement group ID of logical group of instances within a single Availability Zone. This is an optional field and can be blank.</td>
<td>  </td>
<td><strong>  X  </strong></td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC Configuration</td>
<td><strong>SBCPersonality</strong></td>
<td>The type of SBC for this deployment. In this release the personality should always be set to <strong>isbc</strong>.</td>
<td><strong>  X  </strong></td>
<td></td>
<td></td>
</tr>
<tr class="even">
<td>SBC configuration</td>
<td><strong>ActiveInstanceName</strong></td>
<td><p>Specifies the actual CE name of the SBC active instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC72/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
<p><strong>CEName Requirements:</strong></p>
<ul>
<li>
<p>Must start with an alphabetic character.</p>
</li>
<li>
<p>Only contain alphabetic characters and/or numbers. No special characters.</p>
</li>
<li>
<p>Cannot exceed 64 characters in length</p>
</li>
</ul></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong></td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>Standby InstanceName</strong></td>
<td><p>Specifies the actual CE name of the SBC standby instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC72/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
<p><strong>CEName Requirements:</strong></p>
<ul>
<li>
<p>Must start with an alphabetic character.</p>
</li>
<li>
<p>Only contain alphabetic characters and/or numbers. No special characters.</p>
</li>
<li>
<p>Cannot exceed 64 characters in length</p>
</li>
</ul></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong></td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>SystemName</strong></td>
<td><p>Specifies the actual system name of the SBC instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC62/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
<p><strong>System Requirements:</strong></p>
<ul>
<li>
<p>Must start with an alphabetic character.</p>
</li>
<li>
<p>Only contain alphabetic characters and/or numbers. No special characters.</p>
</li>
<li>
<p>Cannot exceed 26 characters in length.</p>
</li>
</ul></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<td>SBC configuration</td>
<td><strong>Volume Type</strong></td>
<td>Select the type of volume for SBC. It is recommended that SBC use io1 type.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>SBC configuration</td>
<td><strong>IOPS</strong></td>
<td>Enter IOPS reservation for io 1 type EBS volume</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>SBC configuration</td>
<td><strong>Volume Size</strong></td>
<td>Enter size of disk required in GB. The minimum size is 65 GIB, however more can be chosen.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
<tr class="even">
<td>SBC Configuration</td>
<td><strong>Third Party CPUs</strong></td>
<td>Enter number of CPUs to be reserved for use with third party apps. <strong>Note</strong>: Default is 0</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
<tr class="odd">
<td>SBC Configuration</td>
<td><strong>Third Party Memory</strong></td>
<td>Enter number of MB of memory to be reserved for use with third party apps.   <strong>Note</strong>: Default is 0</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
<tr class="odd">
<td>HFE configuration</td>
<td><strong>HFEScriptS3Location</strong></td>
<td>Location of the HFE.sh script on a local S3. Enter the name of the bucket and file preceeded by s3:// , eg. s3://rbbn-sbc-cft/HFE.sh.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>HFE configuration</td>
<td><strong>IAMRoleHfe</strong></td>
<td>The name of the IAM role for HFe instance. For more information on IAM Role, see Creating Identity and Access Management (IAM) Roles.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>HFE configuration</td>
<td><strong>SecurityGrpHFEPublic</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic to HFE.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>HFE configuration</td>
<td><strong>SecurityGrpPktHFETowardsSBC</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic between HFE and SBC.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>HFE configuration</td>
<td><strong>SubnetIdHFePublic</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for the Public Interface of HFE.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>HFE configuration</td>
<td><strong>SubnetIdHFeTowardsSBC</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for the private interface on HFE (towards the SBC).</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>Number of Alternate IP on PKT0</strong></td>
<td><p>Alternate IP address for packet port 0.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>Number of Alternate IP on PKT1</strong></td>
<td><p>Alternate IP address for packet port 1.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>NumberOfEIPonPkt0</strong></td>
<td><p>Enter the number of EIP(s) required on PKT0 interface. </p>
<p><strong>Note</strong>: Default is 1</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>NumberOfEIPonPkt1</strong></td>
<td><p>Enter the number of EIP(s) required on PKT1 interface.</p>
<p><strong>Note</strong>: Default is 1</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>ReveseNatEnablePkt0</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT0 interface. Set this field to true, to attach the assigned EIP on PKT0 and use it without SMM rule. See  EipAssociationXface  for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>ReveseNatEnablePkt1</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT1 interface. Set this field to true, to attach the assigned EIP on PKT1 and use it without SMM rule.  See  EipAssociationXface      for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>

<tr class="odd">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>NumberOfSIPonHFEPublic</strong></td>
<td><p>Enter the number of EIP(s) required to configure the HFE public port. It must be [<= NumberOfAlternateIPOnPkt0] of the SBC. This helps the user to use the maximum [NumberOfAlternateIPOnPkt0] for the public calls. For example, if the NumberOfAlternateIPOnPkt0 = 3 and the NumberOfSIPOnHFEPublic = 5, the HFE configures only 3 IPs for the public calls and the rest 2 IPs are unused.</p>
<p><strong>Note</strong>: Default is 1</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>

<tr class="odd">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>AllocateEIPOnHFEPublicInterface	</strong></td>
<td><p>Set True to allocate EIPs from Amazon's pool of public IPv4 addresses on HFE public interface or set False to use pre-allocated/reserved EIPs.</p>
<p><strong>Note</strong>: Default is True</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>IP configuration for SBC PKT0, PKT1 and HFE Public port</td>
<td><strong>EIPAllocationIdList</strong></td>
<td><p>If [AllocateEIPOnHFEPublicInterface] is set to False then enter comma separated pre-allocated/reserved EIPs allocation IDs and make sure number of EIP allocation IDs are equal to the [NumberOfSIPOnHFEPublic] value.

For example,a list of EIPs allocation IDs could be:

eipalloc-0f2e0f651bbf494fe,eipalloc-0a9ab9d240705c149,eipalloc-04e59f946b14980b8</p></td>
<td> </td>
<td><strong> X  </strong></td>
<td>  </td>
</tr>

<tr class="even">
<td>S3 Details</td>
<td><strong>S3BucketName</strong></td>
<td>This is the name of the bucket containing the SA, HA or HAHFE template files. (Default is rbbn-sbc-cft).</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>S3 Details</td>
<td><strong>S3KeyPrefix</strong></td>
<td>This the directory in the S3 bucket where the template files are located. (Default is template).</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>

</tbody>
</table>
  
## More documentation

For more information on Ribbon SBC solutions, including manual configuration instructions for SBC features, see the Ribbon SBC documentation suite here: https://support.sonus.net/display/SBXDOC72 .

## Support Information

Support for BYOL products with valid licenses is provided through the Ribbon Support Portal ( https://ribboncommunications.com/services/ribbon-support-portal-login )

## Copyright

Copyright 2019 Ribbon Communications LLC
