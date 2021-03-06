# Amazon Web Services: Ribbon SBC Solutions 101

You can create Ribbon SBC configurations quickly, reliably, and without being an expert in cloud or Ribbon SBC by using the AWS CloudFormation templates (CFTs) available through links in this repository.

Each CFT creates a pre-configured set of AWS EC2 resources for a Ribbon SBC solution, saving you the time and effort involved in a manual configuration.
CFTs can create configurations for:
- A standalone SBC instance
- Two SBC instances for failover/high availability
- An SBC "triplet" consisting of two SBC instances with High Availability Front End to dramatically reduce the time for EIP-based failover


At this time the CFT will only introduce a Ribbon SBC Solution into an existing VPC (useful when you already have apps in the cloud and want to add SBC).

**Note**: AWS CFTs that create new resources are in an experimental folder in github and Ribbon does not support them. However, you’re welcome to play with them to see how things work.

## Working in github

Github is a source control system where CFTs and related resources live.

To get started with AWS SBC CFTs, visit [https://github.com/RibbonCommunications/sbc_aws_cloudformation](https://github.com/RibbonCommunications/sbc_aws_cloudformation). This is a landing page with links to the latest release of AWS SBC CFTs created by Ribbon.

The CFT links themselves that Ribbon supports are in a folder called **supported**.

The **experimental** folder contains CFTs that have not been as rigorously tested as the supported CFTs, however you could still use them in test environments. Ribbon will not provide support for this CFTs.

The quickest, easiest way to deploy a CFT is to open the folder called **supported** and navigate until you find the CFT you want.
Then view the associated README, scroll down, and click ![](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg) . 

The CFT opens in the AWS console.
![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/images/RBBN-sbc_aws_cloudformation.png) 

To deploy the solution, follow the steps in the wizard.

**Important:** If you have never deployed an instance in AWS before, you must go to the AWS Marketplace and accept the software licensing terms, or the deployment will fail. You will see a button that looks like this: ![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/images/acceptSoftwareTerms.png)

**How to copy a CFT**

If you want your own copy of the CFTs, you can navigate to the appropriate CFT directory and click on the download links.

## How to deploy a CFT
You can deploy a template a few different ways.

**AWS Management Console**

To deploy the CFT, you can log in to the AWS console and go to CloudFormation. Ensure you are in the correct region, and then deploy your CFT.

For more information about how to use CFTs in AWS, see [this AWS walkthrough](http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/GettingStarted.Walkthrough.html).

## View release details
By default, the main github page shows the latest release of the CFTs. Ribbon SBC releases new CFT versions periodically.
Ribbon recommends you use the latest release whenever possible.

The file called aws-sbc-version-matrix.md shows a list of releases, for example:
 ![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/images/RBBN-version-matrix.png)

The most recent release is the default when you go to https://github.com/RibbonCommunications/sbc_aws_cloudformation.

To choose an older release, select a branch tag. For example:
![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/images/releaseTags.png)

## What is an AMI ID?

When you’re working with CFTs, it’s good to know about AMI IDs. An AMI is an *Amazon Machine Image*.

Every Ribbon SBC image in the AWS Marketplace has an image identifier, or *AMI ID*.

When you view any Ribbon offering in the Marketplace, you can continue past the first page, and view AMI IDs on the **Manual Launch** tab:
 
![](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/images/AMIs.png)

The CFTs include lists of AMI IDs. These IDs determine which image AWS uses when it creates the Ribbon SBC instance.





