#!/bin/sh
/opt/dsm/dsm_c -action changesetting -name settings.configuration.webserviceAPIEnabled -Value true
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivation -Value 1
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivationActiveHost -Value 2
/opt/dsm/dsm_c -action changesetting -name settings.configuration.defaultHeartbeatPeriod -value 1
echo "mode.developer=true" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
echo "mode.developer.key=e32e9a2e-4f24-409e-a751-39cf2db03b19" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
/opt/dsm/dsm_s restart
#Enable HC server
cd /opt/
wget --no-cookies --no-check-certificate --header "Cookie: gpw_e24=http%3A%2F%2Fwww.oracle.com%2F; oraclelicense=accept-securebackup-cookie" "http://download.oracle.com/otn-pub/java/jdk/8u152-b16/aa0333dd3019491ca4f6ddbe78cdb6d0/jdk-8u152-linux-x64.rpm"
rpm -ivh jdk-8u152-linux-x64.rpm
wget --no-passive-ftp ftp://52.168.147.42/qa-hc-server-2.1.4-bin.tar.gz
tar xvof qa-hc-server-2.1.4-bin.tar.gz
cd qa-hc-server-2.1.4
java -jar qa-hc-server-2.1.4.jar &
