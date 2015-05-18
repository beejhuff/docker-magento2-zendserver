#!/bin/bash
echo 'Downloading magento2...' 
echo $BASE_URL

export PATH=/usr/local/zend/bin:$PATH
source /etc/zce.rc

if [ 'find /var/www/magento2 -prune -empty' ]
then
	cd /var/www/ && git clone https://github.com/magento/magento2.git 	
	mv -f /usr/local/bin/composer.json /var/www/magento2/composer.json
	cd /var/www/magento2 && composer config -g github-oauth.github.com $TOKEN_GITHUB

	cd /var/www/magento2 && composer install --no-interaction	
	cd /var/www/magento2 && composer update
else
	echo 'Directory magento2 not empty, skiping installation'
fi
echo 'changing ACL for magento2 files...' 
chmod 777 -R /var/www/magento2/var 
chmod 777 -R /var/www/magento2/pub
chmod 777 -R /var/www/magento2/app/etc

echo 'starting mysql service...'
/usr/sbin/service mysql start

echo 'user configuration in the database...' 
MYSQL_ROOT_PASSWORD=""
SECURE_MYSQL=$(expect -c "
set timeout 10
spawn mysql_secure_installation
expect \"Enter current password for root (enter for none):\"
send \"$MYSQL\r\"
expect \"Change the root password?\"
send \"n\r\"
expect \"Remove anonymous users?\"
send \"n\r\"
expect \"Disallow root login remotely?\"
send \"n\r\"
expect \"Remove test database and access to it?\"
send \"n\r\"
expect \"Reload privilege tables now?\"
send \"y\r\"
expect eof
")

echo "$SECURE_MYSQL" 

echo 'reboot apache service...' 
/usr/sbin/service zend-server restart 

echo '--creating database...' 
echo "CREATE DATABASE IF NOT EXISTS magento2" > /createdb.sql
mysql < /createdb.sql
export hostIP=$(host HOST_HOSTNAME | awk '/has address/ { print $4 }')

echo '--Installation...' 
php -f bin/magento setup:install \
    --base_url="http://$BASE_URL/"  \
    --backend_frontname=admin \
    --db_host=localhost \
    --db_name=magento2 \
    --db_user=root \
    --admin_firstname=Mage  \
    --admin_lastname=Bento \
    --admin_email=admin@example.com  \
    --admin_user=admin  \
    --admin_password=admin123 \
    --language=fr_FR \
    --currency=EUR \
    --timezone=Europe/Paris
    --use_sample_data

echo '--Installation des samples data--' 
cd /var/www/magento2 && composer update
cd /var/www/magento2 && php dev/tools/Magento/Tools/SampleData/install.php --admin_username=admin
cd /var/www/magento2 && php dev/tools/Magento/Tools/View/deploy.php
cd /var/www/magento2 && php dev/shell/cache.php --flush

service zend-server restart
echo '...end of the startup !' 

tail -f /var/log/apache2/*.log > /var/www/html/logs-server.log
