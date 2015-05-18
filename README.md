#Magento2 & Zendserver docker container

- 1) Build your container :
./build.sh

- 2) start your container :
./run-server.sh \<instance_name\> \<token_github\>

The \<instance_name\> will be your docker container name. It will be use for the magento installation : http://www. \<instance_name\> .lan/
The script will add the host (www. \<instance_name\> .lan) automatically into /etc/hosts

\<token_github\> is your public github token, if you run too many time the container github will block the script installation because of too many anonymous requests.
it will allow you to avoid the "Could not authenticate against github.com" error in case of too many deployments.

Be carefull to not have an apache2 or mysql running in the same  time (the ports 80 et 3306 must be free).

- 3) Where can i edit the files ?

Once started the file will be in the folder /data/\<instance_name\>/
- The database file will be in /data/\<instance_name\>/mysql/
- The magento file will be in /data/\<instance_name\>/html/

