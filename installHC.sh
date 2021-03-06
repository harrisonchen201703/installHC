#!/bin/sh
/opt/ds_agent/dsa_control -m policyID:1
/opt/dsm/dsm_c -action changesetting -name settings.configuration.webserviceAPIEnabled -Value true
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivation -Value 1
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivationActiveHost -Value 2
/opt/dsm/dsm_c -action changesetting -name settings.configuration.defaultHeartbeatPeriod -value 1
echo "mode.tester=true" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
echo "mode.tester.key=750fdf0e-2a26-11d1-a3ea-080036587f03" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
/opt/dsm/dsm_s restart
sleep 10
/opt/dsm/dsm_s start

#install nmap for firewall tests
yum install nmap -y

#Enable HC server
cd /opt/

wget https://github.com/harrisonchen201703/installHC/raw/master/qa-hc-server-2.3.14-bin.tar.gz
tar xvof qa-hc-server-2.3.14-bin.tar.gz
mv /opt/qa-hc-server-2.3.14/config/restServer.properties /opt/qa-hc-server-2.3.14/config/restServer.properties.orig
sed s/9998/80/ < /opt/qa-hc-server-2.3.14/config/restServer.properties.orig > /opt/qa-hc-server-2.3.14/config/restServer.properties
cd qa-hc-server-2.3.14
/opt/dsm/jre/bin/java -jar qa-hc-server-2.3.14.jar &
