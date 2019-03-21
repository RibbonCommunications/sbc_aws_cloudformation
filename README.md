# Ribbon SBC Cloudformation Templates
CloudFormation Templates for quickly deploying SBC in Amazon Web Services EC2

**Introduction**

Welcome to the GitHub repository for Ribbon SBC's Cloud Formation templates for deploying Ribbon SBC in Amazon Web Services. All of the templates in this repository have been developed by Ribbon SBC engineers.

For information on getting started using Ribbon SBC's CFT templates on GitHub, see the README files in each directory.

Across all branches in this repository, there are two directories: *supported* and *experimental*.

  - **supported**  
    The *supported* directory contains CloudFormation templates that
    have been created and fully tested by Ribbon. These templates are
    fully supported by Ribbon (provided you have an existing support
    agreement), meaning you can get assistance if necessary from Ribbon
    Technical Support via your typical methods.

  - **experimental**  
    The *experimental* directory also contains CloudFormation templates
    that have been created by Ribbon, however these templates have not
    completed full testing and are subject to change. Ribbon does not
    offer technical support for templates in the experimental directory,
    so use these templates with caution.

**Template information**

Descriptions for each template are contained at the top of each template in the *Description* key. For additional information, including how the templates are generated, and assistance in deploying a template, see the README file on the individual template pages.

**Matrix for tagged releases**

Ribbon has created a matrix that contains all of the tagged releases of the Ribbon SBC Cloud Formation Templates (CFTs) for Amazon AWS. See the [AWS SBC Matrix](https://github.com/RibbonCommunications/sbc-aws-cloudformation/blob/master/aws-sbc-matrix.md).

**Quick Start**

The quickstart template allows you to quickly launch a High Availability SBC Cluster into AWS to demonstrate a typical High Availability
deployment model.

For detailed information, we recommend you first see the <span class="underline">Quick Start README file</span>

Or you can use the Launch Stack button to get started:  
[![Launch Stack](https://cdn.rawgit.com/buildkite/cloudformation-launch-stack-button-svg/master/launch-stack.svg)](https://console.aws.amazon.com/cloudformation/home#/stacks/new?stackName=buildkite&templateURL=https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/standalone/existing-stack/byol/AWS_Stand_Alone_template.json)

**All Ribbon SBC Supported templates for AWS**

To see a list of all of our supported AWS CloudFormation templates, see the [**AWS SBC Supported Template index**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/template-index.md).

**Copyright**

Copyright 2019 Ribbon Communications LLC
