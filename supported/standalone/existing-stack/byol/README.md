# Deploying Ribbon SBC Standalone on AWS with BYOL Licensing

**Contents**
- [Introduction](#Introduction)
- [Files](#Files-in-this-repo)
- [Pre-requisites for AWS CFN Install of SBC Standalone Instance](#pre-requisites-for-aws-cfn-install-of-sbc-standalone-instance )
- [Supported Instance types](#supported-instance-types )
- [Instantiating a standalone SBC Instance](#instantiating-a-standalone-sbc-instance)
- [Template parameters](#template-parameters)
- [Configuration Example](#configuration-example)
- [More documentation](#more-documentation)
- [Getting Help](#support-information)

## Introduction ##

This solution uses a CloudFormation template to launch a single Ribbon SBC instance in an Amazon Virtual Private Cloud, using BYOL (bring your own license) licensing.

This is an existing stack template, meaning the networking infrastructure MUST be available prior to deploying. See the Template Parameters Section for required networking objects. See the production stack directory for additional deployment options.

For information on getting started using Ribbon SBC CFT templates on GitHub, see [**Amazon Web Services: Solutions 101**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/AmazonWebServices-Solutions_101.md).

## Files in this repo ##

- **AWS_Stand_Alone_template.json**	- CFT template to use to launch this SBC Solution.

- **README.md** - this README file

## Pre-requisites for AWS CFN Install of SBC Standalone Instance  

Prior to initiating a CFN-based install of a standalone SBC instance perform the following:

1.  Create a VPC for use in the deployment - see [Creating VPC for SBC](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-vpc-for-sbc )

2.  Create  Internet  Gateway for use in the deployment - see[Creating Internet Gateway for SBC](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-internet-gateway-for-sbc )

3.  Create Key Pairs for Linux shell access and Administrator access - see [Creating Key Pairs for SBC](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-key-pairs-for-sbc )

4.  Create Subnets for use in the deployment - see [Creating Subnets for SBC]( https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-subnets-for-sbc)

5.  Create Security Groups for use in the deployment - see [Creating Security Groups for SBC]( https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-security-groups-for-sbc)

6.  Update or create Route tables for the newly created subnets - see [Creating Route Tables for SBC]( https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-route-tables-for-sbc)

7.  Create a placement group for the SBC deployment - see [Creating Placement Groups](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-placement-groups )

8.  Create a Policy and Role for the SBC instance - see [Creating Identity and Access Management -IAM- Role for SBC](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#creating-identity-and-access-management--iam--role-for-SBC )

>  **NOTE** 
>
>  See [Ribbon SBC AWS SBC Instantiate Pre-Requisites](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/pre_requisites/README.md#ribbon-sbc-aws-sbc-instantiate-pre-requisites) for more details about all pre-requisites.

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
  
## Instantiating a standalone SBC Instance

The easiest way to deploy this CloudFormation template is to use the Launch Stack button.

[![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/AWS_Stand_Alone_template.json)

To manually instantiate  a standalone instance:

1.  Log onto AWS.

2.  Click the  **Services**  drop-down list.  
    The  **Services**  list is displayed.

3.  Click  **CloudFormation**  from Management Tools section.  
    The stacks page displays.

4.  Click  **Create Stack**.
    The  **Select Template**  page displays.

5.  In the  **Choose a template**  section, select  **Upload a template to Amazon S3**.

6.  Click  **Choose File** to  navigate through the folders and select the template.  
    The selected template displays.

7.  Click  **Next**.  
    The  **Create A New Stack**  page displays.

> Note
> 
> If wishing to use pre-allocated EIPs for management, please be sure to set EIPAssociationForMgt to No at that field prompt.
> 
> After the deployment has completed you will need to manually associate the pre-allocated EIP to Mgmt (Eth0) Primary and secondary IPs .

8.  In the **Stack name** field enter a  unique name  for this SBC stack.
    A stack is a collection of AWS resources you create and delete as a single unit.

9.  Enter the required values for the Parameter fields. The following [table](#template-parameters) describes the create stack parameters

10. Click **Next**.  
    The  **Options**  page displays.

11. Optionally you can choose to Tag your deployment with a Key-value
    pair, IAM Role Permissions, Rollback Triggers or other advanced
    Options.

12. Click **Next**.  
    The **Review** page displays.  
      

13. Review the stack details and click **Create**  
    The **CloudFormation Stacks** page is displayed.

> On successful stack creation the stack will be listed.

>  - Do not update or modify the stack after creation.

>  - Do not change or remove resources after instance creation. For example, removing or attaching EIP, or changing the user data and so on.
  
## Verify the Instance Creation

Perform the following steps to view the SBC SWe instances created:

1.  Click the  **Services**  drop-down list.  
    The  **Services**  list is displayed.

2.  From the left pane click  **EC2**.

> The  **EC2 Dashboard**  page is displayed.  
>   

3.  From the left pane under  **Instances**  click  **Instances**.  
    The instances table lists the  new instance.

> If you delete an instance from CFN, be aware that AWS does not delete volume(s) automatically. You must also delete them from the AWS UI if you do not want volumes of deleted instances (standalone, HA or HFN-based SBC installation).  
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
<tr class="odd">
<td>System configuration</td>
<td><strong>AMIID</strong></td>
<td>Amazon Machine Image (AMI) is an encrypted machine image which is like a template of a computer's root drive. For example,  ami-xxxxxxxx.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>CERole</strong></td>
<td>The Role of the SBC. In the case of Standalone SBC, the value of CERole is not used, so any value can be selected.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Elastic IP configuration</td>
<td><strong>EipAssociationOnMgt</strong></td>
<td>Select <strong>Yes  </strong>from the drop-down  to associate EIP for MGT0 interface to login and access SBC application from public networks. Select <strong>No</strong> if not requiring EIP or if wishing to use a pre-allocated EIP for management.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>InstanceName</strong></td>
<td><p>Specifies the actual CE name of the SBC instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC72/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
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
<td>System configuration</td>
<td><strong>InstanceType</strong></td>
<td><p>Type of instance that is created from stack.</p>
<p>Note: Sonus recommends m5.xlarge or higher instance type if this instance type is available in your zone. Use c5.2xlarge instance type or higher to handle more calls with transcoding.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>IOPS</strong></td>
<td>Enter IOPS reservation for io 1 type EBS volume</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Security configuration</td>
<td><strong>LinuxAdmin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to linux shell on SBC instance.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Security configuration</td>
<td><strong>Admin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to admin CLI on SBC instance.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Secondary IP configuration for PKT0 and PKT1</td>
<td><strong>Number of Alternate IP on PKT0</strong></td>
<td><p>Alternate IP address for packet port 0.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Secondary IP configuration for PKT0 and PKT1</td>
<td><strong>Number of Alternate IP on PKT1</strong></td>
<td><p>Alternate IP address for packet port 1.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Elastic IP configuration</td>
<td><strong>Number of EIP on PKT 0</strong></td>
<td><p>The number of Elastic IPs to be associated with PKT 0 interface.</p>
<p><strong>Note</strong>: Default is 0</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Elastic IP configuration</td>
<td><strong>Number of EIP on PKT 1</strong></td>
<td><p>The number of Elastic IPs to be associated with PKT 1 interface.</p>
<p><strong>Note</strong>: Default is 0</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Placement of Instance</td>
<td><strong>PlacementId</strong></td>
<td>A placement group ID of logical group of instances within a single Availability Zone. This is an optional field and can be blank.</td>
<td>  </td>
<td><strong>  X  </strong></td>
<td>  </td>
</tr>
<tr class="even">
<td>Reverse NAT configuration</td>
<td><strong>ReveseNatEnablePkt0</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT0 interface. Set this field to true, to attach the assigned EIP on PKT0 and use it without SMM rule. See  EipAssociationXface  for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Reverse NAT configuration</td>
<td><strong>ReveseNatEnablePkt1</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT1 interface. Set this field to true, to attach the assigned EIP on PKT1 and use it without SMM rule.  See  EipAssociationXface      for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>SBCPersonality</strong></td>
<td>The type of SBC for this deployment. In this release the personality should always be set to <strong>isbc</strong>.</td>
<td><strong>  X  </strong></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SecurityGrpHa0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for HA0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SecurityGrpMgt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for MGT0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SecurityGrpPkt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SecurityGrpPkt1</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT1.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SubnetIdHA0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for HA0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SubnetIdMgt0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for Mgt0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SubnetIdPkt0</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt0.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SubnetIdPkt1</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt1.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>System configuration</td>
<td><strong>SystemName</strong></td>
<td><p>Specifies the actual system name of the SBC instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC62/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
<p><strong>System Requirements:</strong></p>
<ul>
<li><blockquote>
<p>Must start with an alphabetic character.</p>
</blockquote></li>
<li><blockquote>
<p>Only contain alphabetic characters and/or numbers. No special characters.</p>
</blockquote></li>
<li><blockquote>
<p>Cannot exceed 26 characters in length.</p>
</blockquote></li>
</ul></td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>Volume Size</strong></td>
<td>Enter size of disk required in GB. The minimum size is 65 GIB, however more can be chosen.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
<tr class="odd">
<td>Placement of Instance</td>
<td><strong>Tenancy</strong></td>
<td>The Tenancy Attribute for this instance.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>Volume Type</strong></td>
<td>Select the type of volume for SBC. It is recommended that SBC use io1 type.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>VpcId</strong></td>
<td>Select a VPC with Subnet, Security Group, etc., selected earlier.</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Third Party Applications Provisioning</td>
<td><strong>Third Party CPUs</strong></td>
<td>Enter number of CPUs to be reserved for use with third party apps. <strong>Note</strong>: Default is 0</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
<tr class="odd">
<td>Third Party Applications Provisioning</td>
<td><strong>Third Party Memory</strong></td>
<td>Enter number of MB of memory to be reserved for use with third party apps.   <strong>Note</strong>: Default is 0</td>
<td><strong>  X  </strong></td>
<td>  </td>
<td><strong>  X  </strong>  </td>
</tr>
</tbody>
</table>


## Configuration Example

The following is a simple configuration diagram for this Ribbon SBC standalone deployment.
![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/images/RBBN-SBC-SA.png)

## More documentation

For more information on Ribbon SBC solutions, including manual configuration instructions for SBC features, see the Ribbon SBC documentation suite here: https://support.sonus.net/display/SBXDOC72 .

## Support Information

Support for BYOL products with valid licenses is provided through the Ribbon Support Portal ( https://ribboncommunications.com/services/ribbon-support-portal-login )

## Copyright

Copyright 2019 Ribbon Communications LLC
