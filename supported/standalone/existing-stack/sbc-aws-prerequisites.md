# Ribbon SBC AWS SBC Instantiate Pre-Requisites

Prior to deploying an SBC, the following activities should be completed. See sections below for details.

  - Creating Placement Groups
  - Creating VPC for SBC
  - Creating Internet Gateway for SBC
  - Creating Subnets for SBC
  - Creating Route Tables for SBC
  - Creating Security Groups for SBC
  - Creating Key Pairs for SBC
  - Creating Identity and Access Management -IAM- Role for SBC
  - Creating Identity and Access Management -IAM- Role for HFE
  - Upload HFE.sh script to S3
  - Finding Amazon Linux 2 AMI ID for use in HFE deployments

>**Note
>
>Ribbon recommends m5.xlarge or higher instance type if this instance type is available in your zone. Use c5.2xlarge instance type or higher to handle more calls with transcoding.
>
>As of release 7.2S405, only following Instance types are supported for deployment in AWS:
>
>  - m5.xlarge
>  - m5.2xlarge
>  - c5.2xlarge
>  - c5.4xlarge
>  - c5.9xlarge
>  - c5n.2xlarge
>  - c5n.4xlarge
>  - c5n.9xlarge
>  - p3.2xlarge
>
>Any prior release deployments using C3, C4 or M4 instance types will need to be migrated to the newer instance types.**

# Creating Placement Groups

>**Note**
>
>Use of Placement Groups is optional and not required.

If using a Placement group, it is recommended to use a cluster placement group so all resources are within the same AZ to maximize performance.

You can create a placement group in advance, or create one during Instance instantiation.



To create a placement group, perform the following steps:

1.  Navigate to EC2 Management Console.

2.  Select **NETWORK & SECURITY >  Placement Groups**.  
      
    The **Placement Groups** page displays.

3.  Click **Create Placement Groups**.  
      
    The **Create Placement Groups** window displays.

4.  Enter a name for placement group.

5.  Select a strategy for the placement group -
    
    1.  A cluster placement group clusters instances in a single Availability Zone to provide low latency and higher network        throughput.
    
    2.  A spread placement group spreads instances across distinct hardware to improve redundancy.

6.  Click **Create**.

# Creating VPC for SBC

## VPC Overview

An SBC deployment requires a VPC with at least 4 IPv4 subnets:

  - Management (MGT0)

  - High Availability (HA0)

  - Packet 0 (PKT0)

  - Packet 1 (PKT1)

All 4 subnets must be located in the same availability zone.

The suggested size of the VPC is CIDR x.x.x.x/16, where each subnet has a CIDR of x.x.x.x/24, although smaller CIDR ranges can be used.

## To create a new VPC

1.  Navigate to the [**VPC Dashboard**](https://console.aws.amazon.com/vpc/ ) 

2.  Click on **Your VPCs** on the panel at left  
    The Create VPC window appears.

3.  Click on **Create VPC**.  
    The Create VPC window appears.

4.  Enter a **Name Tag** to uniquely identify this new VPC.

5.  Enter an **IPv4 CIDR block** value which is large enough to support 4 subnets. The suggested size is CIDR x.x.x.x/24

6.  Click on **Create**.  
    On success, the new VPC ID will be shared on a new window.

For further information about creating VPCs see [**here**](https://docs.aws.amazon.com/vpc/latest/userguide/vpc-getting-started.html ) 

# Creating Internet Gateway for SBC

Each SBC deployment requires access to the internet for management and potentially for signaling and media, depending on customer needs.



To create an Internet Gateway perform the following steps:

1.  Navigate to the [**VPC Dashboard**](https://console.aws.amazon.com/vpc/ ) 

2.  Click on **Internet Gateways** on the panel at left.  
    The Create internet gateway window appears.

3.  Click on **Create Internet Gateway**.  
    The Create Internet Gateway window appears.

4.  Enter a **Name Tag** to uniquely identify this new Internet Gateway.

5.  Click on **Create**.  
    On success, the new Internet gateway ID will be shared on a new
    window.

6.  Click on Close to return to the Create internet gateway screen.

7.  Select the created internet gateway and the select Attach to VPC from the Action pulldown menu.  
      
    The attach to VPC screen appears.

8.  Select the desired VPC from the pulldown menu and then click Attach.

9.  The user will be returned to the Create internet gateway screen. The new internet gateway should now have state attached and list the appropriate VPC id next to it.



For more information concerning internet gateways see [**VPC Internet Gateway**](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_Internet_Gateway.html ) 

# Creating Subnets for SBC



An SBC deployment requires a VPC with sufficient IP space to support 4 or 5 IPv4 subnets:

  - Management (MGT0)

  - High Availability (HA0)

  - Packet 0 (PKT0)

  - Packet 1 (PKT1)

  - High-Availability-forwarding Engine Public Subnet (HFE Public-facing) - depending on deployment type


These subnets can be created within an existing VPC or a new VPC can be allocated. All 4 subnets must reside within the same region/VPC and availability zone.

To create a new subnet with CIDR x.x.x.x/20 within an existing VPC:

1.  Navigate to the [**VPC Dashboard**](https://console.aws.amazon.com/vpc/ ) 

2.  Select **Your VPCs** on the taskbar at left to see the list of VPCs available

3.  Select **Subnets** on the taskbar at left.

4.  Click on **Create subnet** to create a subnet for MGT0 using a CIDR block, e.g. x.x.0.0/20

5.  Click on **Create subnet** to create a subnet for HA0 using an IPv4 CIDR block, e.g. x.x.16.0/20

6.  Click on **Create subnet** to create a subnet for PKT0 usingan IPv4 CIDR block, e.g. x.x.32.0/20

7.  Click on **Create subnet** to create a subnet for PKT1 usingan IPv4 CIDR block, e.g. x.x.48.0/20

8.  IF a High-Availability Forwarded Engine instance is to be deployed with the SBC, a public-facting subnet must be used. An existing    public-facing subnet can be re-used. If not available, click on **Create subnet** to create a subnet for HFE Public-facing using an    IPv4 CIDR block, e.g. x.x.64.0/20

For more information on creating subnets in AWS, refer to [**Add a Subnet**](https://docs.aws.amazon.com/vpc/latest/userguide/working-with-vpcs.html#AddaSubnet ) 

# Creating Route Tables for SBC

In order for your new Subnets to have routing outside the VPC, you must ensure the new subnets created have appropriate inbound and outbound routes in a route table. You can choose to update the master route table (which is implicitly assigned to your new subnets - or you can define a new route table and explicitly associate it with your subnets.

In this example we will create an explicit route table and assign the MGT, PKT0, PKT1 and HFE(if required) subnets to it. Note that you could create separate route tables for each of the MGT, PKT0, PKT1 and HFE subnets if desired.

AWS uses the most specific route in your route table that matches the traffic to determine how to route the traffic (longest prefix match). You need to have the rule to route all the non-Virtual Private Clouds (VPC) traffic to internet gateway or ensure that the internet traffic is routed through your own NAT instance or Gateway. If you cannot provide a way to send out the SBC API query to the internet, the HA solution fails (SBC) in AWS.

The routes to the IPv4 and IPv6 addresses or CIDR blocks are independent of each other. AWS uses the most specific route that matches either IPv4 traffic or IPv6 traffic to determine how to route the traffic.

For example, the following route table has a route for IPv4 Internet traffic 0.0.0.0/0 that points to an Internet gateway. Any traffic destined for a target within the VPC (10.0.0.0/16) is covered by the Local route, and therefore, routed within the VPC. All other traffic from the subnet uses the internet gateway.

**Table:** Route Table

| **Destination** | **Target**   |
| --------------- | ------------ |
| 10.0.0.0/16     | Local        |
| 0.0.0.0/0       | igw-11aa22bb |



For detailed information on the Route Table, refer to [**VPC Route Tables**](https://docs.aws.amazon.com/AmazonVPC/latest/UserGuide/VPC_Route_Tables.html ) 

## To create a Route table for MGT0, PKT0, PKT1, HFE

1.  Navigate to the [**VPC Dashboard**](https://console.aws.amazon.com/vpc/ ) 

2.  Select **Route Tables** on the taskbar at left to see the list of route tables available

3.  Click on **Create Route Table** to create a route table for MGT0 .

4.  Enter a name for the route table and select the VPC that contains your subnet.

5.  Click on **Create**.  
    The route Table will be created and the route table id returned.

6.  Click on the **Close** button to close the screen.

7.  The Route Table screen is once again displays. You will be able to see the new route table in the list of route tables.

8.  Select your route table from the list and select **Edit routes** from the **Actions** pulldown to open the Edit Routes screen.  
      
    By default the new subnet masks will be populated to allow inbound traffic to reach the new subnets, and for each subnet to be able to reach the other.

9.  Click on **Add route** and select **Internet Gateway** from the Target pulldown to add a destination for outbound traffic to reach    the internet gateway associated with your VPC

10. Select the internet gateway associated with your VPC.

11. Click on **Save routes** to save the route.

12. Click on the **Close** button to close the screen.

13. The Route Table screen is once again displays.

14. Select your route table from the list and select **Edit subnet associates** from the **Actions** pulldown.  
      
    The Edit subnets association screen appears.

15. Select the subnets that you would want to enable external routing on (e.g. MGT0, PKT0, PKT1, HFE) and click on **Save**

16. You will be returned to the route table screen. The **Explicitly Associate with** field in the table should show that 3 subnets are associated with your route table.

# Creating Security Groups for SBC

Security groups must be created to support Management (MGT0), High Availability (HA0), PKT0 and PKT1 subnets for the SBC.

Before creating the security groups, review the recommended security group rule settings in the following section.

## Security Group Rules Overview

## Inbound Security Group Rules

It is recommended to open the following ports using Inbound/Ingress rules in the security groups associated with management, HA and packet subnets.

#### Management Security Group

**Table:** Configuring Security Group for Management Subnet

| **Type**        | **Protocol** | **Port Range** | **Source** | **Notes/Purpose**                                                 |
| --------------- | ------------ | -------------- | ---------- | ----------------------------------------------------------------- |
| SSH             | TCP          | 22             | 0.0.0.0/0  | SSH to CLI                                                        |
| Custom UDP rule | UDP          | 123            | 0.0.0.0/0  | NTP                                                               |
| Custom UDP rule | UDP          | 161            | 0.0.0.0/0  | SNMP Polling                                                      |
| Custom UDP rule | UDP          | 162            | 0.0.0.0/0  | SNMP traps                                                        |
| Custom TCP rule | TCP          | 2022           | 0.0.0.0/0  | NetConf over ssh                                                  |
| Custom TCP rule | TCP          | 2024           | 0.0.0.0/0  | SSH to Linux                                                      |
| HTTP            | TCP          | 80             | 0.0.0.0/0  | EMA                                                               |
| HTTPS           | TCP          | 443            | 0.0.0.0/0  | REST to ConfD DB                                                  |
| Custom UDP rule | UDP          | 3057           | 0.0.0.0/0  | Used for load balancing service                                   |
| Custom UDP rule | UDP          | 3054           | 0.0.0.0/0  | Call processing requests                                          |
| Custom UDP rule | UDP          | 3055           | 0.0.0.0/0  | Keep Alive and Registration                                       |
| Custom TCP rule | TCP          | 4019           | 0.0.0.0/0  | Applicable to D-SBC only                                          |
| Custom UDP rule | UDP          | 5093           | 0.0.0.0/0  | SLS (license server) traffic                                      |
| Custom TCP rule | TCP          | 444            | 0.0.0.0/0  | Communicating with EMS, AWS EC2-API server, and Platform Manager. |



#### HA Security Group

**Table:** Configuring Security Group for HA Subnet

| **Type**    | **Protocol** | **Port Range** | **Source** | **Notes/Purpose**                |
| ----------- | ------------ | -------------- | ---------- | -------------------------------- |
| All Traffic | All          | All            | x.x.x.x/y  | x.x.x.x/y is the HA subnet CIDR. |



#### Packet Security Group

**Table:** Configuring Security Group for Packet Ports PKT0 and PKT1

| **Type**        | **Protocol** | **Port Range** | **Source** |
| --------------- | ------------ | -------------- | ---------- |
| Custom UDP rule | UDP          | 5060           | x.x.x.x/y  |
| Custom TCP rule | TCP          | 5061           | x.x.x.x/y  |
| Custom UDP rule | UDP          | 1024-65535     | x.x.x.x/y  |

The source ranges for the packet security group may be external IP address ranges or they may be the HFE private subnet CIDR if a High-availability Forwarding Engine is present in the configuration.



### HA Forwarding Node Security Groups

**Table:** Configuring a Security Group for the Public-facing/Management Port (eth1)

| **Type**        | **Protocol** | **Port Range** | **Source** |
| --------------- | ------------ | -------------- | ---------- |
| Custom UDP rule | UDP          | 5060           | x.x.x.x/y  |
| Custom TCP rule | TCP          | 5061           | x.x.x.x/y  |
| Custom UDP rule | UDP          | 1024-65535     | x.x.x.x/y  |

**Table:** Configuring a Security Group for the Private-facing Port (eth2)

| **Type**        | **Protocol** | **Port Range** | **Source**                                                                       |
| --------------- | ------------ | -------------- | -------------------------------------------------------------------------------- |
| Custom UDP rule | UDP          | 5060           | x.x.x.x/y is the PKT0 or PKT1 subnet CIDR which is to have external connectivity |
| Custom TCP rule | TCP          | 5061           | x.x.x.x/y is the PKT0 or PKT1 subnet CIDR which is to have external connectivity |
| Custom UDP rule | UDP          | 1024-65535     | x.x.x.x/y is the PKT0 or PKT1 subnet CIDR which is to have external connectivity |

The source ranges for the HFE Private-facing Port security group may be the private subnet CIDR of the SBC PKT0 or PKT1 subnets.



## Outbound Security Group Rules

It is recommended to open allports using Outbound/Egress rules in the security groups associated withmanagement, HA and packet interfaces.

**Table:** Outbound Security Group Rules

| **Type**   | **Protocol** | **Port Range** | **Destination** |
| ----------- | ------------ | -------------- | --------------- |
| All Traffic | All          | All            | 0.0.0.0/0       |





>**Caution**
>
>If specific ports are opened in outbound security group rules, the remaining ports are blocked.

>**Note**
>
>Refer to the **Management Security Group**,**HA Security Group**, and **Packet Security Group** tables for the minimum required security group rulesfor the SBC to function.

>**Note**
>
>Considering that the SIP signaling port in SBC configuration is set to the default port (5060), the port numbers for UDP/TCP are set to 5060 and 5061.

## Create Security Groups

1.  Navigate to **EC2 Management Console**.

2.  From the left pane, click **Security Groups**.

3.  Click **Create Security Group**. The **Create Security Group** page displays.

4.  Enter a **Security group name** for the MGT0 security group and **Description**

5.  Select an appropriate **VPC** from the list.

6.  Click **Add Rule** to create security group rules as suggested above.

 >**Note**
 >
 >  By default, the **Inbound** rules tab is displayed on the screen.

7.  Click **Create**.

8.  Repeat steps **3** through **7** to create the new security group for HA, PKT0, and PKT1 subnets.

9.  If deploying with a High-availability Forwarding Engine option, repeat steps **3** through **7** to create a new security group for the HFE public- and private-facing subnets.

 >  For more information, refer to [**VPC Security Groups**](https://docs.aws.amazon.com/vpc/latest/userguide/VPC_SecurityGroups.html ) 

# Creating Key Pairs for SBC

The SBC requires 2 key pairs to be supplied at deployment time to service the linux shell and administrative users:

  - linuxadmin user keypair
  - admin user keypair

These should be created in advance of deployment.

To create a key pair, perform the following steps:

1.  Navigate to EC2 Management Console.

2.  Select **NETWORK & SECURITY >  Key Pairs**.  
      
    The **Create Key Pair** page displays.

3.  Click **Create Key Pair**.  
    The **Create Key Pair** window displays.

4.  Enter a **Key pair name** for your linuxadmin key pair.

5.  Click **Create**.
    The new key pair file (e.g. my-linuxadmin-keypair.pem) will be be pushed to the user.

6.  Save the \*.pem file for linuxadmin user to your PC. This keypair will be required later to enable login to the SBC linux shell.

7.  Repeat the steps above for the "admin" user.

For more information about key pairs refer to: [**ec2-keypairs**](https://docs.aws.amazon.com/AWSEC2/latest/WindowsGuide/ec2-key-pairs.html ) 

# Creating Identity and Access Management -IAM- Role for HFE

AWS Identity and Access Management (IAM) is a web service that helps to securely control user access to AWS resources through authentication and authorization. For more information on IAM, refer to [**UsingIAM**](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/UsingIAM.html ) .


Create a policy for the HFE node using the JSON method (refer to [**create access policies**](https://docs.aws.amazon.com/IAM/latest/UserGuide/access_policies_create.html ) ).
The policy details are shown below.

Attach this policy to a new IAM role. You must enter this IAM role in the template (**IAMRoleHFE:IAM role**)for HFE instances.

 >  
 >  
 >  {
 >  "Version": "2012-10-17",
 >  "Statement": \[
 >  {
 >  "Effect": "Allow",
 >  "Action": \[
 >  "ec2:DescribeInstances",
 >  "ec2:DescribeAddresses",
 >  "ec2:DescribeNetworkInterfaces",
 >  "ec2:DescribeInstanceAttribute",
 >  "ec2:DescribeRegions",
 >  "ec2:ModifyInstanceAttribute",
 >  "ec2:DescribeSubnets",
 >  "s3:Get\*",
 >  "s3:List\*",
 >  "events:PutRule",
 >  "cloudwatch:PutMetricData"
 >  \],
 >  "Resource": "\*"
 >  }
 >  \]
 >  }
 >  


To create a Policy and associate it to a Role for SBC follow these
steps:

1.  Navigate to [**IAM** Dashboard]((https://console.aws.amazon.com/iam/home ) 

2.  Select **Policies** from the left panel.  
    The **Policies** page displays.

3.  Click **Create policy**  
    ThePolicies page displays.

4.  Click on the **JSON** tab.  
    The JSON editor panel appears.

5.  Update the policy to include the content below

 >  {
 >  
 >  "Version": "2012-10-17",
 >  
 >  "Statement": \[
 >  
 >  {
 >  
 >  "Effect": "Allow",
 >  
 >  "Action": \[
 >  
 >  "ec2:DescribeInstances",
 >  "ec2:DescribeAddresses",
 >  "ec2:DescribeNetworkInterfaces",
 >  "ec2:DescribeInstanceAttribute",
 >  "ec2:DescribeRegions",
 >  "ec2:ModifyInstanceAttribute",
 >  "ec2:DescribeSubnets",
 >  "s3:Get\*",
 >  "s3:List\*",
 >  "events:PutRule",
 >  "cloudwatch:PutMetricData"
 >  
 >  \],
 >  
 >  "Resource": "\*"
 >  
 >  }
 >  
 >  \]
 >  
 >  }

6.  Click on **Review Policy**.

7.  Enter a name for the policy and a description, then click on **Create policy**.  

8.  The user will get an indication that the policy was created and will be returned to the create policy window  

9.  Click on **Roles**.  
    The Roles window will appear.

10. Click on **Create role**.  
    The Create role window will appear

11. Select **EC2** as the service that will use this role, then click on **Next: Permissions**

12. The **Attach permissions** policies window will appear.

13. In the search window next to **Filter policies**, type the name of the policy you just created, then select it from the list.

14. Click on **Next: tags.**  
    The Add tags window appears.

15. If desired, enter a tag. Click on **Next: Review**  
    The Create Role Review page is displayed.

16. Enter a **Role name** and then click **Create role**.

17. The user will be returned to the **Create role** window.

18. You can verify that your role was created by typing the name of the created role in the search area.



For more information on creating and using IAM roles and policies, refer to AWS online documentation at [IAM Roles](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-roles-for-amazon-ec2.html) and [IAM Policies](http://docs.aws.amazon.com/AWSEC2/latest/UserGuide/iam-policies-for-amazon-ec2.html).

# Upload HFE.sh script to S3

Launching of a High-availabilty Front End instance requires access to the HFE.sh script. This script is to be uploaded to an S3 bucket available to your region in advance of a launch attempt of the HFE. The HFE.sh script and role can be re-used across multiple instances of HFE nodes in your region.

To make HFE.sh script available do the following:

1.  Click the **Services** drop-down list.  
    The **Services** list is displayed.

2.  From the left pane click **S3**

3.  The **S3 buckets** Dashboard page is displayed.

4.  Click Create bucket.  
    The Create bucket page is displayed.

5.  Enter a name for the bucket in the**Bucket name** field.

6.  Select the **Region** from which this bucket is to be accessed.

7.  Click **Next**.  
    The **Configure options**page of **Create bucket** is displayed.

8.  Put a checkmark next to Keep all versions of an object in the same bucket.

9.  Click **Next**.  
    The **Set permissions**page of**Create bucket**is displayed.

10. Accept all defaults (all boxes checked)

11. Select **Do not grant Amazon S3 Log Delivery group write access to this bucket** from the pulldown under **Manage system permissions**.

12. Click **Next**.  
    The **Review** page of **Create bucket** is displayed.

13. Click **Create bucket**.  
    The new bucket is created with the name you chose. The user is returned to the S3 buckets page.

14. Click on the name of the newly created bucket in the list.  
    The S3 bucket contents are listed.

15. Optionally a folder can be created to upload the HFE.sh script into by clicking **Create folder** and providing a folder name.

16. Click on **Upload** and then select the HFE.sh script from your computer for upload, then click on **Upload**.

17. Click on the newly added file name and record the **Object URL** of the script. This will be needed later.

# Finding Amazon Linux 2 AMI ID for use in HFE deployments

The High-Availabiltity Front-End (HFE) is a lightweight instance with minimal processes used to forward packets from Public IP addresses to private IP addresses on the SBC. The HFE runs on a standard Amazon Linux 2 instance.

To find the AMI id of the latest Amazon Linux 2 image in your region do the following:

1.  Navigate to the **EC2 Management Console** for the region in which you plan to launch the HFE and SBC.

2.  Click on **Launch Instance.**  
    The Choose an Amazon Machine Image (AMI) screen appears

3.  Locate the Amazon Linux 2 AMI (HVM), SSD Volume Type image in the list and copy the AMI id next to for 64-bit x86.  
    This AMI ID will be used later when deploying the HFE using CloudFormation.



