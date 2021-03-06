## List of Supported SBC CloudFormation templates for AWS deployments

The following is a list of the currently supported Ribbon SBC CloudFormation templates. See the [experimental](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/experimental) directory for experimental templates. 

Click the SBC deployment title links below to be redirected to the directory containing the associated CloudFormation templates and deployment information relevant for that deployment type. 

You can click the Launch Stack buttons to immediately launch the template stored on Ribbon's SBC AWS public S3. Because individual templates have specific prerequisites, we strongly recommend you review the deployment information contained in the README file of the deployment directory before attempting to launch a template.

**Important:** You may have to select the AWS region in which you want to deploy after clicking the Launch Stack button 

[**SBC AWS Master Marketplace CFT**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/marketplace/existing-stack/byol)
- requires existing stack.
- Master template available from AWS Marketplace. 
- Prompts user to select the SBC mode to launch (SA, HA or HAHFE) and then collects information to launch one of the CFT templates below. 
- BYOL (bring your own license)

    [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/templates/marketplace_cft_1.1)

[**Standalone SBC (SA)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/standalone/existing-stack/byol)
- launched if select SBC Mode: SA 
- requires existing stack
- includes single SBC instance but provides no application redundancy 
- BYOL (bring your own license)
     
     [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/templates/marketplace_cft_1.1)
 
[**High Availability SBC (HA)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability/existing-stack/byol)
- launched if select SBC Mode: HA 
- requires existing stack  
- instantiates includes active and standby instances with application redundancy 
- BYOL (bring your own license)
   
   [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/templates/marketplace_cft_1.1)
 
[**High Availability SBC with Front End (HAHFE)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailabilityhfe/existing-stack/byol/HFEmanualSubnet.md)
- launched if select SBC Mode: HFHFE 
- requires existing stack.
- instantiates HA-SBC with HFE to minimize failover times - all subnets must be pre-allocated.
- BYOL (bring your own license)
   
   [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/templates/marketplace_cft_1.1)
   
 
 

