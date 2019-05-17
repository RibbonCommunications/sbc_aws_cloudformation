**Stack Type**

For each of the standalone templates, you must choose the type of stack
into which you want to deploy the SBC. See the individual README files
for exact requirements. Note that not all options are available for all
templates.

  - [**Existing VPC Stack**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability/existing-stack)
  
    These templates deploy into a pre-existing VPC. This means that all of the
    cloud networking and other infrastructure pre-requisites (VPC, Subnets, Route Tables, 
    Internet gateways, security groups, instance rules/policies, etc) must be available
    prior to launching the template.

  - [**New VPC Stack**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability/new-stack)    
  
    These templates will deploy the solution into a new VPC and create the required 
    infrastructure elements with default values (VPC, Subnets, Route Tables, 
    Internet gateways, security groups, instance rules/policies, etc). These default values 
    may need to be changed later to comply with deployment needs.
