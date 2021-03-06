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
CMD mkdir -p /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main/
CMD mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main/
CMD mkdir -p /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7/main/
CMD mkdir -p /opt/jboss/wildfly/certificado/
CMD mkdir -p /tmp/arquivos/

# Criar grupo e usuario
RUN sh /opt/jboss/wildfly/bin/add-user.sh -u 'usuario' -p 'senha' -g 'nome_grupo' -s

# Transferir para o Wildfly os drivers locais
ADD drivers/postgres/module.xml /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main/
ADD drivers/postgres/postgresql-9.4.1212.jre7.jar /opt/jboss/wildfly/modules/system/layers/base/org/postgres/main/

ADD drivers/microsoft/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main/
ADD drivers/microsoft/sqljdbc.jar /opt/jboss/wildfly/modules/system/layers/base/com/microsoft/sqlserver/main/

ADD drivers/oracle/module.xml /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7/
ADD drivers/oracle/ojdbc7.jar /opt/jboss/wildfly/modules/system/layers/base/com/oracle/ojdbc7/

ADD 'certificado/suaempresa.com.br.jks' /opt/jboss/wildfly/certificado/

# Transferir arquivos de configuracao
ADD execute.sh /tmp/
ADD command.cli /tmp/

# Rodar
RUN ["chmod", "+x", "/tmp/execute.sh"]
RUN ["chmod", "+x", "/opt/jboss/wildfly/certificado/suaempresa.com.br.jks"]
RUN /tmp/execute.sh

# Expose default port
EXPOSE 8080 8443 9990 9993
