# Amazon Web Services: Solutions 101

You can create Ribbon SBC configurations quickly, reliably, and without being an expert in cloud or Ribbon SBC by using the AWS CloudFormation templates (CFTs) on [https://github.com/RibbonCommunications/sbc_aws_cloudformation](https://github.com/RibbonCommunications/sbc_aws_cloudformation).

Each CFT creates a pre-configured Ribbon SBC solution, saving you the time and effort involved in a manual configuration.
CFTs can create configurations like:
•	Two SBC VE instances with failover/high availability
•	An SBC "triplet" consisting of two SBC VE instances with High Availability Front End to fast EIP-based failover/high availability 
•	A standalone SBC instance
•	And more

Additionally, each CFT can:
•	Introduce a Ribbon SBC into an existing environment (useful when you already have apps in the cloud and want to add SBC)

Note: AWS CFTs that create new resources are in an experimental folder in github and Ribbon does not support them. However, you’re welcome to play with them to see how things work.

**Working in github**

Github is a source control system where CFTs and related resources live.

To get started with AWS SBC CFTs, visit [https://github.com/RibbonCommunications/sbc_aws_cloudformation](https://github.com/RibbonCommunications/sbc_aws_cloudformation). This is a landing page for the latest release of AWS SBC CFTs created by Ribbon.

The CFTs themselves that Ribbon supports are in a folder called supported.

The experimental folder contains CFTs that have not been as rigorously tested as the supported CFTs, but that you can still use them in test environments.

The quickest, easiest way to deploy a CFT is to open the folder called supported and navigate until you find the CFT you want.
Then view the associated README, scroll down, and click [![](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)] . The CFT opens in the AWS console.
