#!/bin/bash

#############################################################
#
# Copyright (c) 2018 Sonus Networks, Inc.
#
# All Rights Reserved.
# Confidential and Proprietary.
#
# HFE.sh
#
# Lokesh Ranadive
# 4/1/2018
#
# Module Description:
# Script to enable HFE(High-Availability Front End) instance as frontend for public facing 
# PKT port of SBC.
# The script will perform the following steps when called from cloud-init (setup function):
# 1) Save old iptables rules : preConfigure
# 2) Enalbe IP Forwarding :configureNATRules
# 3) Read Secondary IPs of SBC, IP of machine for which we need route table
# entry(for ssh connection). Route for REMOTE_SSH_MACHINE_IP is set so that user
# can connect HFE instance over eth1 : readConfig.
# Route entry for all SIPs of SBC(pkt0) are set to route packets towards SBC via
# eth2
# 4) Setup DNAT for incoming traffic over eth0 (public facing EIPs for SBC's pkt
# port) and forward it to SBC's secondary IPs over eth2 : configureNATRules
# 5) Setup SNAT for traffic coming from SBC and forward it to public
# end-points over eth0 (EIPs) : configureNATRules
# 6) Configure route for IP of machine read in step #3(REMOTE_SSH_MACHINE_IP) : configureMgmtNAT
# 7) Log applied iptables configuration and route: showCurrentConfig 
#
#
# For debugging-
# Call HFE.sh with cleanup switch. e.g sh HFE.sh cleanup:
# 1) Remove all routes set to forward SBC SIPs(pkt0)
# 2) Save iptable entries 
# 3) Flush iptables
# This option is useful to debug connectivity of end-point with HFE, after
# calling this no packet is forwarded to SBC, user can ping all EIPs on eth0 to
# make sure connectivity between end-point and HFE is working fine.
# Once this is done user MUST reboot HFE node to restore all forwarding rules
# and routes.
# 
#
# NOTE: This script is run by cloud-init in HFE instance.
#
# This script should be uploaded to S3 bucket and
# AWS_HFE_HA_template_auto_subnet.json configures HFE instance to
# get this script from S3 bucket and run with cloud-init.
#
#
#############################################################


## This version is changed to current release build by build process.
TemplateVersion="V07.02.00S400"
HFERoot="/home/ec2-user/HFE"
varFile="$HFERoot/natVars.input"
logFile="$HFERoot/HFE.log"
cloudWatchFile="$HFERoot/cloudWatch.sh"
oldRules="$HFERoot/iptables.rules.prev"

PROG=${0##*/}

usage()
{
    echo $1
    echo "usage: $PROG <setup|cleanup>"
    echo "Example:"
    echo "$PROG setup"
    exit
}

timestamp()
{
 date +"%Y-%m-%d %T"
}

doneMessage()
{
    echo $(timestamp) " =========================    DONE HFE.sh     =========================================="
    echo $(timestamp) ""
    echo $(timestamp) ""
    exit 
}

errorAndExit()
{
    echo $(timestamp) " Error: $1"
    doneMessage
}


saveAndClearOldRules()
{
    sudo iptables-save > $oldRules
    if [ "$?" = "0" ]; then
        echo $(timestamp) " Clean all old firewall rules"
        iptables -X
        iptables -t nat -F
        iptables -t nat -X
        iptables -t mangle -F
        iptables -t mangle -X
        iptables -P INPUT ACCEPT
        iptables -P FORWARD ACCEPT
        iptables -P OUTPUT ACCEPT
    else
        errorAndExit "Cound not save old iptables rules. Exiting"
    fi
}


getRegion()
{
    # Get region.
    availZone=`curl -s "http://169.254.169.254/latest/meta-data/placement/availability-zone"`
    if [[ -z "$availZone" ]];then
        errorAndExit "Failed to get availability-zone."
    fi
    
    region="${availZone::-1}"
    echo "$region"
}

getSWePkt0CIDR()
{
    local region=""
    
    # Get region.
    region=$(getRegion)
    if [[ -z "$region" ]];then
        errorAndExit "Failed to get region."
    fi
   
    # Get subnet-id for SECONDARY_IP_OF_SBC.
    sbcPkt0SubnetId=`aws ec2 describe-network-interfaces --filters "Name=addresses.private-ip-address,Values=$SBC_SECONDARY_IP" --region $region --query 'NetworkInterfaces[0].SubnetId' --output text`
    if [[ -z "$sbcPkt0SubnetId" ]];then
        errorAndExit "Failed to get SBC Pkt0 subnet Id."
    fi

    # Get CIDR for SECONDARY_IP_OF_SBC.
    sbcPkt0CIDR=`aws ec2 describe-subnets --subnet-ids $sbcPkt0SubnetId --region $region --query 'Subnets[0].CidrBlock' --output text`
    if [[ -z "$sbcPkt0CIDR" ]];then
        errorAndExit "Failed to get SBC Pkt0 CIDR."
    fi

    echo "$sbcPkt0CIDR"
}


routeCleanUp()
{
    echo $(timestamp) " Route clean up for SWe Pkt0 secondary IPs and remote machine's public IP."

    local sbcPkt0CIDR=""
    sbcPkt0CIDR=$(getSWePkt0CIDR)
    if [[ -z "$sbcPkt0CIDR" ]];then
        errorAndExit " Failed to get SWe Pkt0 CIDR."
    fi
  
    ip route | grep -E "$sbcPkt0CIDR.*$ETH2_GW.*eth2"
    if [ "$?" = "0" ]; then
        #route del -net <CIDR> gw <GW_OF_ETH2> dev eth2
        route del -net $sbcPkt0CIDR gw $ETH2_GW dev eth2
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Route deleted to reach SBC Pkt0 CIDR $sbcPkt0CIDR from eth2"
        else
            errorAndExit " Failed to delete route to reach SBC CIDR $sbcPkt0CIDR from eth2"
        fi
    else
        echo $(timestamp) " Route not available to reach SBC Pkt0 CIDR $sbcPkt0CIDR from eth2"
    fi

    ip route | grep -E "$REMOTE_SSH_MACHINE_IP.*$ETH1_GW.*eth1"
    if [ "$?" = "0" ]; then
        #route del <PUBLIC_IP_OF_MACHINE_USED_TO_MANAGE_HFE> gw <GW_OF_ETH0> dev eth1
        route del $REMOTE_SSH_MACHINE_IP gw $ETH1_GW dev eth1
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Route deleted for remote machine's public IP($REMOTE_SSH_MACHINE_IP) to reach from eth1"
        else
            errorAndExit " Failed to delete route for remote machine's public IP($REMOTE_SSH_MACHINE_IP) to reach from eth1"
        fi
    else
        echo $(timestamp) " Route not available for remote machine's public IP($REMOTE_SSH_MACHINE_IP) to reach from eth1"
    fi
}

prepareHFEInstance()
{
    ### Configure ip_forward and dump code for HFE healthcheck using CloudWatch
    ### This should be called before echo is redirected to log file.

    echo > $cloudWatchFile

    echo "#!/bin/bash" >> $cloudWatchFile
    echo "counter=0 ">> $cloudWatchFile
    echo "instanceId=\`wget -q -O - http://169.254.169.254/latest/meta-data/instance-id\` ">> $cloudWatchFile
    echo "availZone=\`curl -s http://169.254.169.254/latest/meta-data/placement/availability-zone\` " >> $cloudWatchFile

    echo " " >> $cloudWatchFile
    echo " " >> $cloudWatchFile

    echo "if [[ -z \"\$availZone\" ]];then" >> $cloudWatchFile
    echo "logger  \"prepareHFEInstance: Error: Failed to get Availability Zone.  This instance can not send CloudWatch events.\"">> $cloudWatchFile
    echo "fi" >> $cloudWatchFile
    
    echo " " >> $cloudWatchFile
    echo " " >> $cloudWatchFile

    echo "region=\"\${availZone::-1}\" " >> $cloudWatchFile

    echo " " >> $cloudWatchFile
    echo "logger  \"prepareHFEInstance: Sending HFE state up notification.  $instanceId\" ">> $cloudWatchFile
    echo "while true ">> $cloudWatchFile
    echo "do ">> $cloudWatchFile

    echo " " >> $cloudWatchFile
    echo "    ### Update timestamp every 10 seconds" >> $cloudWatchFile
    echo "    remainder=\$(( counter % 5 ))" >>$cloudWatchFile
    echo "    if [ \$remainder -eq 0 ]" >> $cloudWatchFile
    echo "        then">> $cloudWatchFile
    echo "        echo "\$\(date +\'%d/%m/%Y %H:%M:%S:%3N\'\)" >.cloudWatch " >> $cloudWatchFile
    echo "    fi" >> $cloudWatchFile

    echo " " >> $cloudWatchFile
    echo "    counter=\$((counter+1)) ">> $cloudWatchFile

    echo " " >> $cloudWatchFile
    echo "    if [ \$counter -eq 100000 ]" >> $cloudWatchFile
    echo "        then">> $cloudWatchFile
    echo "        logger \"prepareHFEInstance: reset counter\" ">> $cloudWatchFile
    echo "        counter=0" >> $cloudWatchFile
    echo "    fi" >> $cloudWatchFile

    echo "    ### Send keep alive signal" >> $cloudWatchFile

    echo "    aws cloudwatch put-metric-data --region \$region  --metric-name HFEState --dimensions InstanceID=\$instanceId --namespace HFE --value 1 --storage-resolution 1 " >> $cloudWatchFile
    echo "    sleep 2 " >> $cloudWatchFile
    echo "done" >> $cloudWatchFile

    ### Enable ip forwarding
    echo 1 >  /proc/sys/net/ipv4/ip_forward

}

preConfigure()
{
    ### Redirect all echo $(timestamp) to file after writing ip_forward
    exec >> $logFile 2>&1
    echo $(timestamp) " ==========================   Starting HFE.sh  ============================"
    echo $(timestamp) " Enabled IP forwarding"
    echo $(timestamp) " This script will setup DNAT, SNAT and IP forwarding."
    echo $(timestamp) " Save old rules in $HFERoot/firewall.rules"
    saveAndClearOldRules
}



readConfig()
{
    echo $(timestamp) " Read variables from file $varFile"

    source $varFile
    echo $(timestamp) " Data from $varFile:"
    echo $(timestamp) " SBC_SECONDARY_IP $SBC_SECONDARY_IP"
    echo $(timestamp) " REMOTE_SSH_MACHINE_IP       $REMOTE_SSH_MACHINE_IP"
    echo $(timestamp) ""

    ETH1_GW=`/sbin/ip route | grep eth1|  awk '/default/ { print $3 }'`
    ETH2_GW=`/sbin/ip route | grep eth2|  awk '/default/ { print $3 }'`

    echo $(timestamp) ""
    echo $(timestamp) " Default GWs:"
    echo $(timestamp) " ETH2_GW          $ETH2_GW"
    echo $(timestamp) " ETH1_GW          $ETH1_GW"
}

installConntrack()
{
    echo $(timestamp) " Check and install conntrack "
    rpm -q conntrack-tools
    installed=$?

    if [ $installed -eq 0 ];then
        echo $(timestamp) " conntrack already installed."
    else
        echo $(timestamp) " conntrack is not installed. Installing it."
        yum -y install conntrack
    fi

    rpm -q conntrack-tools
    installed=$?

    if [ $installed -eq 0 ];then
        echo $(timestamp) " conntrack installed."
    else
        errorAndExit "Could not install conntrack. Exit."
    fi
}

configureNATRules()
{
    echo $(timestamp) " ==========================   Section 1 ============================"
    echo $(timestamp) " Endpoint -> EIP of HFE instance (eth0) -> eth2 -> VPC router -> SBC"
    echo $(timestamp) " This setting enables HFE instance to forward all packets received on eth0[EIP] to SBC's(current active) secondary IP."
    echo $(timestamp) " These packets are sent out on eth2 interface and routed via private VPC's default routing table rule"
    echo $(timestamp) " ==================================================================="
    echo $(timestamp) ""
    echo $(timestamp) ""
    
    local sbcPkt0CIDR=""

    iptables -A FORWARD -i eth0 -o eth2 -j ACCEPT
    if [ "$?" = "0" ]; then
        echo $(timestamp) " Set Forward ACCEPT rule all packets coming from outside eth0 to eth2 towards SBC"
    else
        errorAndExit "Failed to set forward ACCEPT rule for all packets coming on EIP(eth0)"
    fi
    
    # Get number of secondary IP assigned on HFE eth0 interface.
    secIpOnHfeEth0Count="${#secIpOnHfeEth0SortArr[@]}"

    # Get number of secondary IP assigned on SBC Pkt0 interface.
    secIpOnSWePkt0Count="${#secIpOnSWePkt0SortArr[@]}"

    addNumRoute=$(( secIpOnHfeEth0Count < secIpOnSWePkt0Count ? secIpOnHfeEth0Count : secIpOnSWePkt0Count ))
    # Get SBC Pkt0 CIDR.
    sbcPkt0CIDR=$(getSWePkt0CIDR)
    if [[ -z "$sbcPkt0CIDR" ]];then
        errorAndExit "Failed to get SWe Pkt0 CIDR."
    fi
   
    ip route | grep -E "$sbcPkt0CIDR.*$ETH2_GW.*eth2"
    if [ "$?" = "0" ]; then
        echo $(timestamp) " Route is already available to reach SBC Pkt0 CIDR  $sbcPkt0CIDR from eth2"
    else
        #route add -net <CIDR> gw <GW_OF_ETH2> dev eth2
        route add -net $sbcPkt0CIDR gw $ETH2_GW dev eth2
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Set route to reach SBC Pkt0 CIDR  $sbcPkt0CIDR from eth2"
        else
            errorAndExit "Failed to set route to reach SBC CIDR  $sbcPkt0CIDR from eth2"
        fi
    fi
        
    for (( idx=0; idx<$addNumRoute; idx++ ))
    do
        #iptables -t nat -A PREROUTING  -i eth0 -d <DESTINATION_IP> -j DNAT --to <SECONDARY_IP_OF_SBC>
        iptables -t nat -A PREROUTING  -i eth0 -d ${secIpOnHfeEth0SortArr[$idx]} -j DNAT --to ${secIpOnSWePkt0SortArr[$idx]}
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Set up proper DNAT for destination IP ${secIpOnHfeEth0SortArr[$idx]} to offset ${secIpOnSWePkt0SortArr[$idx]} "
        else
            errorAndExit "Failed to set DNAT rule for destination IP ${secIpOnHfeEth0SortArr[$idx]} to offset ${secIpOnSWePkt0SortArr[$idx]}."
        fi
    done

    ## Reset connection tracking
    ## Any packet received on eth0 before NAT rules are set are not forwarded
    ## to sbc via eth2, connection tracking will not forward those packets even
    ## if NAT rules are set after receiving first packet from that source
    ## IP/Port as it has cache entry for source IP and Port.
    ## Reset connection tracking will treat them as new stream and those packets
    ## will be forwarded to SBC via eth2 once SNAT and DNAT rules are setup
    ## properly.

    installConntrack

    conntrack -F conntrack
    if [ "$?" = "0" ]; then
        echo $(timestamp) " Flushing connection tracking rules."
    else
        echo $(timestamp) " (WARNING):Flushing connection tracking rules failed."
    fi


    echo $(timestamp) " ==========================   Section 2 ============================"
    echo $(timestamp) " This configuration is needed for calls originated by SBC on public IP (using EIP of HFE)"
    echo $(timestamp) " SBC -> routing table -> eth1 (HFE instance) -> DNAT -> eth0 -> EIP "
    echo $(timestamp) " This setting enables HFE instance to forward all packets received on eth2 from SBC's(current active) secondary IP."
    echo $(timestamp) " These packets are sent out on eth0 interface as default route is set for this interface and routed via default rule of routing table"
    echo $(timestamp) " Private subnet should use rules like following to route all packets to HFE instance-"
    echo $(timestamp) "


    #### Use routing table to route packets from pkt0 to reach eth2 of HFE instance

    Route Table:
    rtb-XXXXXXXXXXXXXXXX | PRIVATE_SUBNET_NAT_ROUTING_TABLE
    Destination      Target
    10.54.0.0/16     local
    0.0.0.0/0        eni-014b69a1554d886c0 / i-0e9006e91b9fbc3fa

    "

    iptables -A FORWARD -i eth2 -o eth0 -j ACCEPT
    if [ "$?" = "0" ]; then
        echo $(timestamp) " Set Forward ACCEPT rule all packets coming from SBC (eth2) to eth0"
    else
        errorAndExit "Failed to set ACCEPT rule all packets coming from SBC (eth2) to eth0"
    fi


    for (( idx=0; idx<$addNumRoute; idx++ ))
    do
        iptables -t nat -I POSTROUTING -o eth0 -s ${secIpOnSWePkt0SortArr[$idx]} -j SNAT --to ${secIpOnHfeEth0SortArr[$idx]}  
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Set up POSTROUTING rule (source IP ${secIpOnSWePkt0SortArr[$idx]}, to offset ${secIpOnHfeEth0SortArr[$idx]}) for packet sent on eth0 "
        else
            errorAndExit "Failed to set POSTROUTING rule (source IP ${secIpOnSWePkt0SortArr[$idx]}, to offset ${secIpOnHfeEth0SortArr[$idx]}) for packet sent on eth0"
        fi
    done

    echo $(timestamp) " ==================================================================="
    echo $(timestamp) ""
    echo $(timestamp) ""

}

configureMgmtNAT()
{
    echo $(timestamp) " ==========================   Section 3 ============================"
    echo $(timestamp) " Optional configuration to reach eth1 using EIP. "


    if [ -z "${REMOTE_SSH_MACHINE_IP}" ]; then
        echo $(timestamp) " No IP is given for REMOTE_SSH_MACHINE_IP field, no route is set for managing this instance over eth1."
    else
        echo $(timestamp) " eth1 is used to manage this HFE instance, we can login using private IP to manage HFE machine without setting default route"
        echo $(timestamp) " default route points to eth0 which will be used to interface all traffic for SBC"

        ip route | grep -E "$REMOTE_SSH_MACHINE_IP.*$ETH1_GW.*eth1"
        if [ "$?" = "0" ]; then
            echo $(timestamp) " Route is already available for remote machine's public IP($REMOTE_SSH_MACHINE_IP), from this IP you can SSH to HFE over EIP(eth1)"
        else
            #route add <PUBLIC_IP_OF_MACHINE_USED_TO_MANAGE_HFE> gw <GW_OF_ETH0> dev eth1
            route add $REMOTE_SSH_MACHINE_IP gw $ETH1_GW dev eth1
            if [ "$?" = "0" ]; then
                echo $(timestamp) " Route added for remote machine's public IP($REMOTE_SSH_MACHINE_IP), from this IP you can SSH to HFE over EIP(eth1)"
            else
                errorAndExit "Failed to add route for ($REMOTE_SSH_MACHINE_IP)"
            fi
        fi
    fi
    echo $(timestamp) " ==================================================================="
    echo $(timestamp) ""
    echo $(timestamp) ""
}

showCurrentConfig()
{
    echo $(timestamp) " ==========================   Section 3 ============================"
    echo $(timestamp) " Applied iptable rules and kernel routing table. "
    natTable=`iptables -t nat -vnL`
    echo " "
    echo $(timestamp) " NAT tables:"
    echo $(timestamp) " $natTable "

    filterTable=`iptables -t filter -vnL`
    echo " "
    echo $(timestamp) " Filter tables:"
    echo $(timestamp) " $filterTable "

    echo " "
    routeOutput=`route -n`
    echo $(timestamp) " Route:"
    echo $(timestamp) " $routeOutput "
    echo " "

    echo $(timestamp) " ==================================================================="
    echo $(timestamp) ""
    echo $(timestamp) ""


}

installWireshark()
{
    echo $(timestamp) " ==========================   Section 4 ============================"
    echo $(timestamp) " Check and install wireshark. "
    rpm -q wireshark
    installed=$?

    if [ $installed -eq 0 ];then
        echo $(timestamp) " Wireshark already installed."
    else
        echo $(timestamp) " Wireshark is not installed. Installing it."
        yum -y install wireshark
    fi

}

stopHealthCheck()
{
    echo $(timestamp) " ==========================   Cleanup: kill health check ============================"
    echo $(timestamp) " Stop health check. "
    sudo pkill -f $cloudWatchFile
}

startHealthCheck()
{
    echo $(timestamp) " ==========================   Section 5 ============================"
    echo $(timestamp) " Start health check. Logs are appended in syslog. Check .cloudWatch file for last health check message sent out from this machine. "
    ### First kill other instance of cloudWatch health check script.
    stopHealthCheck
    nohup sh $cloudWatchFile &  2>&1
    doneMessage
}


getHfeEth0AndSWePkt0SipArray()
{
    # Get region.
    local region=""
    
    # Get region.
    region=$(getRegion)
    if [[ -z "$region" ]];then
        errorAndExit "Failed to get region."
    fi
   
    # Get primary ip assigned on SWE PKT0 interface.
    priIpOnSWePkt0=`aws ec2 describe-network-interfaces --filters "Name=addresses.private-ip-address,Values=$SBC_SECONDARY_IP" --region $region --query "NetworkInterfaces[].PrivateIpAddresses[?Primary].PrivateIpAddress" --output text`
    if [[ -z "$priIpOnSWePkt0" ]];then
        errorAndExit "Failed to get primary Ip assigned on SBC Pkt0."
    fi

    # Get list of secondary ip assigned on SWe PKT0 interface.
    secIpOnSWePkt0List=`aws ec2 describe-network-interfaces --filters "Name=addresses.private-ip-address,Values=$SBC_SECONDARY_IP" --region $region --query 'NetworkInterfaces[].PrivateIpAddresses[] | [?Primary==\`false\`].PrivateIpAddress'  --output text`
    if [[ -z "$secIpOnSWePkt0List" ]];then
        errorAndExit "Failed to get list of secondary ip assigned on SBC PKT0 interface."
    fi

    # Sort list of secondary ip assigned on SWe PKT0 interface.
    tmpSipSWePkt0File="/tmp/sipSWePkt0.txt"
    echo " " > $tmpSipSWePkt0File

    for ip in $secIpOnSWePkt0List;
    do
        echo $ip >> $tmpSipSWePkt0File     
    done
    secIpOnSWePkt0SortList=`sort -n -t . -k1,1 -k2,2 -k 3,3 -k4,4 $tmpSipSWePkt0File`
    echo $(timestamp) "List of secondary IP assigned on SWe Pkt0 in sorted order: $secIpOnSWePkt0SortList"

    secIpOnSWePkt0SortArr=( $secIpOnSWePkt0SortList )
    if [[ -z "$secIpOnSWePkt0SortArr" ]];then
        errorAndExit "Array of Secondary IP on SWe Pkt0 is empty."
    fi

    # Get primary ip assigned on HFE public interface(eth0).
    priIpOnHfeEth0=`ip addr show dev eth0 | grep -v secondary | grep inet | grep -v inet6 | awk '{print $2}' | awk -F"/" '{print $1}'`
    if [[ -z "$priIpOnHfeEth0" ]];then
        errorAndExit "Failed to get primary Ip assigned on HFE eth0 interface."
    fi

    # Get list of secondary ip assigned on HFE public interface(eth0).
    secIpOnHfeEth0List=`aws ec2 describe-network-interfaces --filters "Name=addresses.private-ip-address,Values=$priIpOnHfeEth0" --region $region --query 'NetworkInterfaces[].PrivateIpAddresses[] | [?Primary==\`false\`].PrivateIpAddress' --output text`
    if [[ -z "$secIpOnHfeEth0List" ]];then
        errorAndExit "Failed to get list of secondary ip assigned on HFE eth0 interface."
    fi

    # Get EIP associated on secondary ip of HFE public interface(eth0).
    for ip in $secIpOnHfeEth0List;
    do
        eip=`aws ec2 describe-addresses --filters "Name=private-ip-address,Values=$ip" --region $region --query 'Addresses[0].PublicIp' --output text`
        if [[ -z "$eip" ]];then
            errorAndExit "Failed to get EIP on secondary IP $ip"
        else
            echo $(timestamp) "EIP $eip is associated on secondary IP $ip"
            hfeEipEth0List+=" $eip"
        fi
    done


    if [ "$SORT_HFE_EIP" = "True" ]; then
        # Sort list of EIP assigned on HFE Eth0 interface.
        tmpEipHfeEth0File="/tmp/eipHfeEth0.txt"
        echo " " > $tmpEipHfeEth0File     

        for eip in $hfeEipEth0List;
        do
            echo $eip >> $tmpEipHfeEth0File     
        done
        eipOnHfeEth0SortList=`sort -n -t . -k1,1 -k2,2 -k 3,3 -k4,4 $tmpEipHfeEth0File`
        echo $(timestamp) "List of EIP assigned on HFE eth0 in sorted order: $eipOnHfeEth0SortList"

        # Create secondary IP list mapped with EIP on HFE eth0 interface.
        for eip in $eipOnHfeEth0SortList;
        do
            sip=`aws ec2 describe-addresses --filters "Name=public-ip,Values=$eip" --region $region --query 'Addresses[0].PrivateIpAddress' --output text`
            if [[ -z "$sip" ]];then
                errorAndExit "Failed to get secondary IP associated with EIP $eip"
            fi
            secIpOnHfeEth0SortList+=" $sip"
        done
    else
        # Sort list of secondary ip assigned on HFE Eth0 interface.
        tmpSipHfeEth0File="/tmp/sipHfeEth0.txt"
        echo " " > $tmpSipHfeEth0File     

        for ip in $secIpOnHfeEth0List;
        do
            echo $ip >> $tmpSipHfeEth0File     
        done
        secIpOnHfeEth0SortList=`sort -n -t . -k1,1 -k2,2 -k 3,3 -k4,4 $tmpSipHfeEth0File`
        echo $(timestamp) "List of secondary IP assigned on HFE eth0 in sorted order: $secIpOnHfeEth0SortList"
    fi

    secIpOnHfeEth0SortArr=( $secIpOnHfeEth0SortList )
    if [[ -z "$secIpOnHfeEth0SortArr" ]];then
        errorAndExit "Array of Secondary IP on HFE eth0 is empty."
    fi
}

main()
{

    
    case $1 in
        "setup") 
            prepareHFEInstance
            preConfigure
            readConfig
            getHfeEth0AndSWePkt0SipArray
            configureNATRules
            configureMgmtNAT
            showCurrentConfig
            installWireshark
            startHealthCheck
            ;;
        "cleanup")
            stopHealthCheck
            preConfigure
            readConfig
            routeCleanUp
            doneMessage
            ;;
        *) 
            usage "Unrecognized switch"
            ;;
    esac
}

[[ $# -ne 1 ]] && usage

main $1
