#!/bin/bash
if [[ $EUID -ne 0 ]]; then
   echo "Please run this script as root"
   exit 1
fi
echo "Installing EasyIoT..."
systemctl stop easyiot-controller.service
rm -Rf /opt/easyiot-controller
rm -f /etc/systemd/system/easyiot-controller.service
systemctl daemon-reload
mkdir /opt/easyiot-controller
wget  https://easyiot.bhonofre.pt/controller/latest-jar -O /opt/easyiot-controller/easyiot-controller.jar
wget  https://easyiot.bhonofre.pt/controller/script-linux -O /usr/local/bin/easyiot-controller.sh
chmod +x /usr/local/bin/easyiot-controller.sh
wget  https://easyiot.bhonofre.pt/controller/service-linux -O /etc/systemd/system/easyiot-controller.service
systemctl daemon-reload
systemctl enable easyiot-controller.service
systemctl start easyiot-controller.service
echo "EasyIoT has been installed, you can access it at the URL http://yourip:8092/"
