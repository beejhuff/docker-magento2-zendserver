from ubuntu 

RUN apt-get update 
RUN DEBIAN_FRONTEND=noninteractive apt-get -y dist-upgrade 

RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim php5 php5-cli git curl expect mysql-server-5.6 mysql-client-5.6 

RUN DEBIAN_FRONTEND=noninteractive curl -sS https://getcomposer.org/installer | php
RUN DEBIAN_FRONTEND=noninteractive mv composer.phar /usr/local/bin/composer

RUN apt-key adv --keyserver pgp.mit.edu --recv-key 799058698E65316A2E7A4FF42EAE1437F7D2C623
RUN echo "deb http://repos.zend.com/zend-server/8.0/deb_apache2.4 server non-free" >> /etc/apt/sources.list.d/zend-server.list

RUN DEBIAN_FRONTEND=noninteractive apt-get update
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y libapache2-mod-php-5.6-zend-server zend-server-php-5.6
RUN DEBIAN_FRONTEND=noninteractive /usr/local/zend/bin/zendctl.sh stop

ADD ./000-default.conf /etc/apache2/sites-available/000-default.conf
ADD ./startup.sh /usr/local/bin/startup.sh
RUN chmod +x /usr/local/bin/startup.sh
ADD ./composer.json /usr/local/bin/composer.json

expose 80
expose 3306
EXPOSE 10081 
EXPOSE 10082

VOLUME ["/var/www/magento2"]
CMD ["/bin/bash","/usr/local/bin/startup.sh"]
