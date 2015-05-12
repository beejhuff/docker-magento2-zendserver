# docker-magento2-zendserver
The magento2 docker files i use to have a Magento2 / Zend-Server / Docker Environment

You should have the file ZendServer-8.0.2-RepositoryInstaller-linux.tar.gz (download it here :  www.zend.com) at the root of the directory (same level as the Dockerfile).

To use it :
- 1) Git clone the project
<pre>
git clone https://github.com/pierrefay/docker-magento2-zendserver.git
</pre>

- 2) Build the image 
<pre>
docker  build -t pierrefay/magento2-zendserver .
</pre>

- 3) Run an instance:
<pre>
docker stop magento2-zendserver
docker rm magento2-zendserver
docker run --env BASE_URL="magento2.lan" --env TOKEN_GITHUB="#my_token_github#" -v /data/magento2-zendserver/html:/var/www/magento2 --name magento2-zendserver -p 80:80 -p 10081:10081 -p 10082:10082 pierrefay/magento2-zendserver
</pre>

Don't forget :

To change the "magento.lan" for the url you want to use with magento2 and to access to ZendServer.

To change #my_token_github# by your key (public github account key) to avoid the "Could not authenticate against github.com" error in case of too many deployments.


 - 4) Change your host to manage the url with the good IP on your computer:
At the end of the run you will see this message (then you can have the IP of your container):
<pre>
Starting web server apache2
AH00558: apache2: Could not reliably determine the server's fully qualified domain name, using 172.17.0.18
</pre>

Edit /etc/hosts like that :
<pre>
172.17.0.18 magento2.lan
</pre>

If you want to have the IP you can also run this command :
<pre>
CONTAINER_ID=$(docker ps | grep "$TAG "| awk 'magento2-zendserver')
IP=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' $CONTAINER_ID)
echo "Ip of $TAG: $IP"
</pre>
