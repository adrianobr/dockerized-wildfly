# Usar a imagem original disponivel
FROM jboss/wildfly:10.1.0.Final
MAINTAINER Adriano Baptistella <adrianojosebaptistella@gmail.com>

# Acesso atraves do usuario root
USER root

# Diretorio de trabalho
WORKDIR /opt/jboss/wildfly

# Instalar wget e limpar metadados
RUN yum install -y wget && yum -q clean all

# Criar pastas
RUN mkdir -p /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main && mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main && mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7/main && mkdir -p /opt/jboss/wildfly/standalone/configuration/certs

# Criar grupo e usuario
RUN sh /opt/jboss/wildfly/bin/add-user.sh -u 'sysmo' -p '$y$m036310600' -g 'sysmo' -s

# Transferir para o Wildfly os drivers locais
ADD drivers/postgres/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main
ADD drivers/postgres/postgresql-9.4.1212.jre7.jar /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main

ADD drivers/microsoft/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main
ADD drivers/microsoft/sqljdbc.jar /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main

ADD drivers/oracle/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7
ADD drivers/oracle/ojdbc7.jar /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7

# Transferir arquivos de configuracao
ADD execute.sh /tmp/
ADD command.cli /tmp/

# Rodar
RUN /tmp/execute.sh

# Expose default port
EXPOSE 8080 9990
