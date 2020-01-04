#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root"
   exit 1
fi
if java -version | grep -q "java version" ; then
  echo "Java is installed."
else
  echo "Java is NOT installed! Installing it for you..."
sleep 3
package=default-jdk
apt=`command -v apt-get`
yum=`command -v yum`

if [ -n "$apt" ]; then
    apt update
    apt -y install $package
elif [ -n "$yum" ]; then
    yum -y install $package
else
    echo "Erro: Yum e APT não disponíveis" >&2;
    exit 1;
fi
echo "Installing EasyIoT..."
systemctl stop easyiot-controller.service
rm -Rf /opt/easyiot-controller
rm -f /etc/systemd/system/easyiot-controller.service
systemctl daemon-reload
mkdir /opt/easyiot-controller
wget  https://easyiot.bhonofre.pt/controller/latest-jar -O /opt/easyiot-controller/easyiot-controller.jar
wget  https://raw.githubusercontent.com/brunohorta82/easyiot-controller-linux-installer/master/easyiot-controller.sh -O /usr/local/bin/easyiot-controller.sh
chmod +x /usr/local/bin/easyiot-controller.sh
wget  https://raw.githubusercontent.com/brunohorta82/easyiot-controller-linux-installer/master/easyiot-controller.service -O /etc/systemd/system/easyiot-controller.service
systemctl daemon-reload
systemctl enable easyiot-controller.service
systemctl start easyiot-controller.service
echo "EasyIoT has been installed, you can access it at the following URL(s):"
ip -o addr show scope global | awk '{gsub(/\/.*/, " "$4); print "http://"$4":8092"}'
echo "Enjoy!"
