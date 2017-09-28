# Usar a imagem original disponivel
FROM jboss/wildfly:10.1.0.Final
MAINTAINER Adriano Baptistella <adrianojosebaptistella@gmail.com>

# Acesso atraves do usuario root
USER root

# Diretorio de trabalho
WORKDIR /opt/jboss/wildfly

# Variaveis
ENV POSTGRES_JDBC='postgresql-9.4.1212.jre7.jar'
ENV SQLSERVER_JDBC='sqljdbc.jar'
ENV ORACLE_JDBC='ojdbc7.jar'
ENV FTP_URI='ftp://177.75.144.2'
ENV FTP_USER='equipeweb'
ENV FTP_PASS='36310600$'

# Instalar wget e limpar metadados
RUN yum install -y wget && yum -q clean all

# Criar pastas
RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main && mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main && mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7/main && mkdir -p /opt/jboss/wildfly/standalone/configuration/certs

# Criar grupo e usuario
RUN sh /opt/jboss/wildfly/bin/add-user.sh -u 'sysmo' -p '$y$m036310600' -g 'sysmo' -s

# Baixar drivers JDBC
CMD cd /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main && wget –tries=0 $FTP_URI/aws/drivers/postgres/module.xml --ftp-user=$FTP_USER --ftp-password=$FTP_PASS && wget –tries=0 $FTP_URI/aws/drivers/postgres/$POSTGRES_JDBC --ftp-user=$FTP_USER --ftp-password=$FTP_PASS
CMD cd /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main && wget –tries=0 $FTP_URI/aws/drivers/microsoft/module.xml --ftp-user=$FTP_USER --ftp-password=$FTP_PASS && wget –tries=0 $FTP_URI/aws/drivers/microsoft/$SQLSERVER_JDBC --ftp-user=$FTP_USER --ftp-password=$FTP_PASS
CMD cd /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7 && wget –tries=0 $FTP_URI/aws/drivers/oracle/module.xml --ftp-user=$FTP_USER --ftp-password=$FTP_PASS && wget –tries=0 $FTP_URI/aws/drivers/oracle/$ORACLE_JDBC --ftp-user=$FTP_USER --ftp-password=$FTP_PASS

# Transferir arquivos de configuracao
ADD execute.sh /tmp/
ADD command.cli /tmp/

# Rodar
RUN /tmp/execute.sh

# Expose default port
EXPOSE 8080 9990
