**Template Types**

Ribbon has created templates grouped into the following categories. Each of the templates has pre-requisites. For details about pre-requisites see [here](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/pre_requisites).

  - [**Standalone**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/standalone)
  
    These templates deploy an individual SBC instance. Standalone SBC
    instances are primarily used for Dev/Test/Staging.

  - [**HighAvailability**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailability)
  
    These templates deploy an Active and a Standby SBC instance in a
    cluster. High Availability clusters are primarily used to replicate
    traditional Active/Standby SBC deployments. The failover can result
    in a 15-20 second switchover time if using EIP for signaling or
    media.   
      
    In these deployments, an individual SBC instance in the cluster owns
    (or is Active for) a particular set of signaling and media IP
    addresses. For example, the SBC instance will fail over service from
    one instance to another by remapping IP addresses, routes, etc.
    based on Active/Standby status. In some solutions, failover is
    implemented via API (API calls to the cloud platform vs. network
    protocols like Gratuitous ARP, route updates, and so on). For more
    information, see the highavailability README files.  

  - [**HighAvailabilityHFE**](https://github.com/RibbonCommunications/sbc_aws_cloudformation/tree/master/supported/highavailabilityhfe)
  
    These templates deploy an Active and a Standby SBC instance, plus a
    High Availability Front End in a cluster. High Availability clusters
    with Front End are primarily used to replicate traditional
    Active/Standby SBC deployments with fast switchover times.   
      
    In AWS, High Availability is provided through the use of Elastic IP
    (EIP). With EIP, when a switchover is required from an active SBC
    instance to a standby instance, the IP address for the active server
    is moved to the standby instance through a REST API call, which can
    result in a 15 to 20 second switchover time. While this solution may
    be acceptable for the majority of web-based applications it does not
    meet the requirements needed for SBCs for real-time communications.

> To accomplish switchover times closer to 2 seconds Ribbon added an HA
> Front-End (HFE) to our AWS architecture solution to host the Elastic
> IP.
> 
> The High-Availability Front-End (HFE) is a lightweight instance with
> minimal processes used to forward packets from Public IP addresses to
> private IP addresses on the SBC. With the HFE, the public IP and
> secondary IP address of the active and standby SBC instances are
> separated, with the public IP address anchored on the HFE. During a
> switchover from active to standby only the secondary IP address is
> re-anchored from the active to standby node. This reduces the
> switchover time down to approximately 2 seconds.
> 
> For more information, see the highavailabilityHFE README files.
