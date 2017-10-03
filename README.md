# dockerized-wildfly
### **Fazer o clone e buildar o Dockerfile**
> * git clone https://github.com/adrianobr/dockerized-wildfly.git
> * cd dockerized-wildfly
> * sudo docker build -t sysmo/wildfly .

### **Subir o novo container Wildfly**
> * sudo docker run -d --name wildfly --publish 80:8080 --publish 443:8443 --publish 9960:9990 --publish 9963:9993 --volume=/etc/localtime:/etc/localtime:ro --volume=/tmp/arquivos:/tmp/arquivos:rw --volume=/var/wildfly_home:/wildfly:rw -e JAVA_OPTS="-server -Xms512m -Xmx1024m -XX:MetaspaceSize=96m -XX:MaxMetaspaceSize=1024m -Dfile.encoding=UTF-8 -XX:NewRatio=2 -Djava.net.preferIPv4Stack=true -Duser.timezone=America/Sao_Paulo" sysmo/wildfly /opt/jboss/wildfly/bin/standalone.sh --server-config=standalone-full.xml -b 0.0.0.0 -bmanagement 0.0.0.0
