## HFE Options ##

For each template, you have different options for licensing your Ribbon SBC. Note that not all options are available for all templates.

  - [**HFEmanualSubnet**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/highavailabilityhfe/existing-stack/byol/HFEmanualSubnet.md)   
   Creation of the private subnet between the HFE and SBC VEs must be created manually prior to running the template.  
   
   - [**HFEautoSubnet**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/highavailabilityhfe/existing-stack/byol/HFEautoSubnet.md)   
    The private subnet created between the HFE and SBC VEs is automatically created by the template - **This is presently not supported through marketplace templates. Contact Ribbon for more information and to get the autoSubnet template.**



## Files in this repo ##

- **HFEautoSubnet.md**	- README for deploying SBC Solution with HFE - (automatically created HFE Private Subnet-not supported).

- **HFEmanualSubnet.md**	- README for deploying SBC Solution with HFE - (manual HFE Private Subnet creation pre-requisite).

- [**HAHFE.template**](https://s3.amazonaws.com/rbbn-sbc-cft/templates/HAHFE.template) - click to download HFE manual subnet template from S3.

- - [**HFE.sh**](https://s3.amazonaws.com/aws-quickstart/quickstart-ribbon-sbc/scripts/HFE.sh) - click to download HFE.sh script used to configure the HFE.

- **README.md** - this README file
