#!/bin/sh
if [ "$#" -ne 2 ]; then
    echo "Illegal number of parameters use run-server.sh <instance_name> <tokengithub>"
    return;
fi

rm -rf /data/$1

docker stop $1
docker rm $1
docker run --name $1 --env BASE_URL="www.$1.lan" --env TOKEN_GITHUB="$2" -v /data/$1/mysql/:/var/lib/mysql -v /data/$1/html/:/var/www/magento2 pierrefay/magento2-zendserver

MYHOST="www.$1.lan"

cp /etc/hosts /etc/hosts_sav

sed -i -e "/$1/d" /etc/hosts
CONTAINER_ID=$(docker ps | grep "$1 "| awk '{print $1}')
IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_ID)

echo "$IP www.$1.lan"
echo "$IP www.$1.lan" >> /etc/hosts

echo "Deploying Docker container $1 (http://www.$1.lan/) ! Please wait..."

sleep 350

echo "Container $1 (http://www.$1.lan/) started !!"

echo "Server logs - [ctrl + d] to stop :"
tail -f /data/$1/html/logs-server.log

