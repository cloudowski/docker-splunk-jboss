FROM slashroot/base

RUN yum -y install unzip 

ADD files/jboss-as-7.1.1.Final.zip /root/
RUN unzip -d /opt/ /root/jboss-as-7.1.1.Final.zip

ADD files/jdk-7u51-linux-x64.rpm /root/
RUN rpm -Uvh /root/jdk-7u51-linux-x64.rpm

# startup scripts
ADD files/start-splunk-forwarder.sh /start-splunk-forwarder.sh
ADD files/start-jboss.sh /start-jboss.sh
ADD files/launch.sh /launch.sh
RUN chmod +x /*.sh


CMD /launch.sh

EXPOSE 9999 
EXPOSE 9990
EXPOSE 8080
EXPOSE 22
