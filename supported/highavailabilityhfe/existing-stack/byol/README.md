## HFE Options ##

For each template, you have different options for licensing your Ribbon SBC. Note that not all options are available for all templates.

  - [**HFEautoSubnet**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/highavailabilityhfe/existing-stack/byol/HFEautoSubnet.md)   
    The private subnet created between the HFE and SBC VEs is automatically created by the template.

  - [**HFEmanualSubnet**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/blob/master/supported/highavailabilityhfe/existing-stack/byol/HFEmanualSubnet.md)   
   Creation of the private subnet between the HFE and SBC VEs is to be created manually prior to running the template.

## Files in this repo ##

- **AWS_HA_HFE_template.json**	- CFT template to use to launch SBC Solution with HFE (manual HFE Private Subnet creation pre-requisite).

- **AWS_HA_HFE_template_auto_subnet.json**	- CFT template to use to launch SBC Solution with HFE (automated HFE Private Subnet creation).

- **HFE.sh**	- Script that is used by the AWS_HA_HFE CFNs to configure the HFE instance once deployed.

- **HFEautoSubnet.md**	- README for deploying SBC Solution with HFE - (automatically created HFE Private Subnet).

- **HFEmanualSubnet.md**	- README for deploying SBC Solution with HFE - (manual HFE Private Subnet creation pre-requisite).

- **README.md** - this README file
