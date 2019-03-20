# Ribbon SBC Standalone AWS Instantiation from Cloud Formation Template 

## Pre-requisites for AWS CFN Install of SBC Standalone Instance  

Prior to initiating a CFN-based install of a standalone SBC instance
perform the following:

1.  Create a VPC for use in the deployment - see    Creating VPC for SBC

2.  Create  Internet  Gateway for use in the deployment - see    Creating Internet Gateway for SBC

3.  Create Key Pairs for Linux shell access and Administrator access -
    see Creating Key Pairs for SBC

4.  Create Subnets for use in the deployment - see Creating Subnets for SBC

5.  Create Security Groups for use in the deployment - see    Creating
    Security Groups for SBC

6.  Update or create Route tables for the newly created subnets -
    see  Creating Route Tables for SBC

7.  Create a placement group for the SBC deployment - see  Creating
    Placement Groups

8.  Create a Policy and Role for the SBC instance - see  Creating
    Identity and Access Management -IAM- Role for SBC

  

## Instantiating a standalone SBC Instance

To instantiate  a standalone instance:

1.  Log onto AWS.

2.  Click the  **Services**  drop-down list.  
    The  **Services**  list is displayed.

3.  Click  **CloudFormation**  from Management Tools section.  
      The stacks page displays.

4.  Click  **Create Stack**.

> The  **Select Template**  page displays.

5.  In the  **Choose a template**  section, select  **Upload a template to Amazon S3**.

6.  Click  **Choose File** to  navigate through the folders and select the template.  
    The selected template displays.

7.  Click  **Next**.  
    The  **Create A New Stack**  page displays.

> Note
> 
> If wishing to use pre-allocated EIPs for management, please be sure to set EIPAssociationForMgt to No at that field prompt.
> 
> After the deployment has completed you will need to manually associate the pre-allocated EIP to Mgmt (Eth0) Primary and secondary IPs .

8.  In the **Stack name** field enter a  unique name  for this SBC stack.
    A stack is a collection of AWS resources you create and delete as a single unit.

9.  Enter the required values for the Parameter fields. The following
    table describes the create stack parameters:  
    **Table**  :  Create Stack Parameters

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
<td>Amazon Machine Image (AMI) is an encrypted machine image which is like a template of a computer's root drive. For example,  ami-xxxxxxxx.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>CERole</strong></td>
<td>The Role of the SBC. In the case of Standalone SBC, the value of CERole is not used, so any value can be selected.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Elastic IP configuration</td>
<td><strong>EipAssociationOnMgt</strong></td>
<td>Select <strong>Yes  </strong>from the drop-down  to associate EIP for MGT0 interface to login and access SBC application from public networks. Select <strong>No</strong> if not requiring EIP or if wishing to use a pre-allocated EIP for management.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>InstanceName</strong></td>
<td><p>Specifies the actual CE name of the SBC instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC62/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
<p><strong>CEName Requirements:</strong></p>
<ul>
<li><blockquote>
<p>Must start with an alphabetic character.</p>
</blockquote></li>
<li><blockquote>
<p>Only contain alphabetic characters and/or numbers. No special characters.</p>
</blockquote></li>
<li><blockquote>
<p>Cannot exceed 64 characters in length</p>
</blockquote></li>
</ul></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
</tr>
<tr class="odd">
<td>System configuration</td>
<td><strong>InstanceType</strong></td>
<td><p>Type of instance that is created from stack.</p>
<p>Note: Sonus recommends m5.xlarge or higher instance type if this instance type is available in your zone. Use c5.2xlarge instance type or higher to handle more calls with transcoding.</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>IOPS</strong></td>
<td>Enter IOPS reservation for io 1 type EBS volume</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Security configuration</td>
<td><strong>LinuxAdmin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to linux shell on SBC instance.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Security configuration</td>
<td><strong>Admin SshKey</strong></td>
<td>Existing EC2 KeyPair name to enable SSH access to admin CLI on SBC instance.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Secondary IP configuration for PKT0 and PKT1</td>
<td><strong>Number of Alternate IP on PKT0</strong></td>
<td><p>Alternate IP address for packet port 0.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Secondary IP configuration for PKT0 and PKT1</td>
<td><strong>Number of Alternate IP on PKT1</strong></td>
<td><p>Alternate IP address for packet port 1.</p>
<p><strong>Note</strong>:  Default is 1. If you are using more than one IP for alternate IPs, use comma separated IPs list.</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Elastic IP configuration</td>
<td><strong>Number of EIP on PKT 0</strong></td>
<td><p>The number of Elastic IPs to be associated with PKT 0 interface.</p>
<p><strong>Note</strong>: Default is 0</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Elastic IP configuration</td>
<td><strong>Number of EIP on PKT 1</strong></td>
<td><p>The number of Elastic IPs to be associated with PKT 1 interface.</p>
<p><strong>Note</strong>: Default is 0</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Placement of Instance</td>
<td><strong>PlacementId</strong></td>
<td>A placement group ID of logical group of instances within a single Availability Zone. This is an optional field and can be blank.</td>
<td>  </td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
</tr>
<tr class="even">
<td>Reverse NAT configuration</td>
<td><strong>ReveseNatEnablePkt0</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT0 interface. Set this field to true, to attach the assigned EIP on PKT0 and use it without SMM rule. See  EipAssociationXface  for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Reverse NAT configuration</td>
<td><strong>ReveseNatEnablePkt1</strong></td>
<td><p>Enable or disable reverse Network Address Translation (NAT) functionality for PKT1 interface. Set this field to true, to attach the assigned EIP on PKT1 and use it without SMM rule.  See  EipAssociationXface      for associating EIP for the required interfaces.</p>
<p><strong>Note:</strong>  When set to False, the SBC application cannot use the attached EIP.</p></td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>System configuration</td>
<td><strong>SBCPersonality</strong></td>
<td>The type of SBC for this deployment. In this release the personality should always be set to <strong>isbc</strong>.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td></td>
<td></td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SecurityGrpHa0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for HA0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SecurityGrpMgt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for MGT0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SecurityGrpPkt0</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SecurityGrpPkt1</strong></td>
<td>Acts as a firewall for associated Amazon EC2 instances, controlling both inbound and outbound traffic for PKT1.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SubnetIdHA0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for HA0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SubnetIdMgt0</strong></td>
<td>Subnet ID of an existing subnet in your Virtual Private Cloud (VPC) for Mgt0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>SubnetIdPkt0</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt0.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Network configuration</td>
<td><strong>SubnetIdPkt1</strong></td>
<td>SubnetId of an existing subnet in your Virtual Private Cloud (VPC) for Pkt1.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>System configuration</td>
<td><strong>SystemName</strong></td>
<td><p>Specifies the actual system name of the SBC instance. For more information, see  <a href="https://wiki.sonusnet.com/display/SBXDOC62/System+and+Instance+Naming+Conventions">System and Instance Naming Conventions</a>.</p>
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
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>Volume Size</strong></td>
<td>Enter size of disk required in GB. The minimum size is 65 GIB, however more can be chosen.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" />  </td>
</tr>
<tr class="odd">
<td>Placement of Instance</td>
<td><strong>Tenancy</strong></td>
<td>The Tenancy Attribute for this instance.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Storage configuration</td>
<td><strong>Volume Type</strong></td>
<td>Select the type of volume for SBC. It is recommended that SBC use io1 type.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="odd">
<td>Network configuration</td>
<td><strong>VpcId</strong></td>
<td>Select a VPC with Subnet, Security Group, etc., selected earlier.</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td>  </td>
</tr>
<tr class="even">
<td>Third Party Applications Provisioning</td>
<td><strong>Third Party CPUs</strong></td>
<td>Enter number of CPUs to be reserved for use with third party apps. <strong>Note</strong>: Default is 0</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" />  </td>
</tr>
<tr class="odd">
<td>Third Party Applications Provisioning</td>
<td><strong>Third Party Memory</strong></td>
<td>Enter number of MB of memory to be reserved for use with third party apps.   <strong>Note</strong>: Default is 0</td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" /></td>
<td>  </td>
<td><embed src="media/image1.tmp" style="width:0.16667in;height:0.16667in" />  </td>
</tr>
</tbody>
</table>

10. Click **Next**.  
    The  **Options**  page displays.

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

1.  Click the  **Services**  drop-down list.  
    The  **Services**  list is displayed.

2.  From the left pane click  **EC2**.

> The  **EC2 Dashboard**  page is displayed.  
>   

3.  From the left pane under  **Instances**  click  **Instances**.  
    The instances table lists the  new instance.

> If you delete an instance from CFN, be aware that AWS does not delete volume(s) automatically. You must also delete them from the AWS UI if you do not want volumes of deleted instances (standalone, HA or HFN-based SBC installation).

