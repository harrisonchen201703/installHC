#!/bin/sh
/opt/dsm/dsm_c -action changesetting -name settings.configuration.webserviceAPIEnabled -Value true
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivation -Value 1
/opt/dsm/dsm_c -action changesetting -name settings.configuration.agentInitiatedActivationActiveHost -Value 2
/opt/dsm/dsm_c -action changesetting -name settings.configuration.defaultHeartbeatPeriod -value 1
echo "mode.tester=true" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
echo "mode.tester.key=750fdf0e-2a26-11d1-a3ea-080036587f03" >> /opt/dsm/webclient/webapps/ROOT/WEB-INF/dsm.properties
/opt/dsm/dsm_s restart
sleep 10
/opt/dsm/dsm_s start
#Enable HC server
cd /opt/

jdk_version=${1:-8}
ext=${2:-rpm}

readonly url="http://www.oracle.com"
readonly jdk_download_url1="$url/technetwork/java/javase/downloads/index.html"
readonly jdk_download_url2=$(
    curl -s $jdk_download_url1 | \
    egrep -o "\/technetwork\/java/\javase\/downloads\/jdk${jdk_version}-downloads-.+?\.html" | \
    head -1 | \
    cut -d '"' -f 1
)
[[ -z "$jdk_download_url2" ]] && echo "Could not get jdk download url - $jdk_download_url1" >> /dev/stderr

readonly jdk_download_url3="${url}${jdk_download_url2}"
readonly jdk_download_url4=$(
    curl -s $jdk_download_url3 | \
    egrep -o "http\:\/\/download.oracle\.com\/otn-pub\/java\/jdk\/[8-9](u[0-9]+|\+).*\/jdk-${jdk_version}.*(-|_)linux-(x64|x64_bin).$ext"
)

for dl_url in ${jdk_download_url4[@]}; do
    wget --no-cookies \
         --no-check-certificate \
         --header "Cookie: oraclelicense=accept-securebackup-cookie" \
         -N $dl_url
    break;
done

rpm -ivh jdk*
wget --no-passive-ftp ftp://52.168.147.42/qa-hc-server-2.1.4-bin.tar.gz
tar xvof qa-hc-server-2.1.4-bin.tar.gz
cd qa-hc-server-2.1.4
java -jar qa-hc-server-2.1.4.jar &
