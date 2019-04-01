## List of Supported SBC CloudFormation templates for AWS deployments

The following is a list of the current supported SBC CloudFormation templates. See the [experimental](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/experimental) directory for experimental templates. 

Click the links to view the README files which include the Launch buttons and additional information, or click the Launch Stack buttons to immediately launch the template. Because individual templates may have specific prerequisites, we strongly recommend you view the README file before attempting to launch a template.

**Important:** You may have to select the AWS region in which you want to deploy after clicking the Launch Stack button 

[**Standalone SBC**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/standalone/existing-stack/byol)
- Existing Stack which includes single SBC instance but provides no application redundancy (typical)
   o	BYOL (bring your own license)
     
     [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/standalone/existing-stack/byol/AWS_Stand_Alone_template.json)
 
[**High-Availability SBC**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability/existing-stack)
- Existing Stack which includes active and standby instances with application redundancy (typical)
   o	BYOL (bring your own license)
   
   [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/AWS_HA_template.json)

[**High-Availability SBC with Front End (HFE subnet auto-allocated)**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailabilityhfe/existing-stack)
- Existing Stack for HA-SBC with HFE frontend to minimize failover times - HFE private subnet is automatically created, however all other subnets must be pre-allocated (typical)
   o	BYOL (bring your own license)
   
   [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/AWS_HFE_HA_template_auto_subnet.json)
 
[**High-Availability SBC with Front END **](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailabilityhfe/existing-stack)
- Existing Stack for HA-SBC with HFE frontend to minimize failover times - all subnets must be pre-allocated.
   o	BYOL (bring your own license)
   
   [![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://s3.amazonaws.com/rbbn-sbc-cft/AWS_HFE_HA_template.json)
   
 


