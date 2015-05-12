# magento2-docker-for-development
The magento2 docker files i use to have a Magento2 / Zend-Server / Docker Environment

You should have the file ZendServer-8.0.2-RepositoryInstaller-linux.tar.gz (download it here :  www.zend.com) at the root of the directory (same level as the Dockerfile).

To use it :

- Build it
docker  build -t pierrefay/magento2-zendserver .

- Run it
docker stop magento2-zendserver
docker rm magento2-zendserver
docker run --env BASE_URL="magento2.lan" --env TOKEN_GITHUB="<mytokengithub>" -v /data/magento2-zendserver/html:/var/www/magento2 --name magento2-zendserver -p 80:80 -p 10081:10081 -p 10082:10082 pierrefay/magento2-zendserver

(of course you should change <mytokengithub> by your key (public github account key) to avoid the "Could not authenticate against github.com" Error in case of too many deployments.
