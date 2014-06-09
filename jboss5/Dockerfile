FROM slashroot/base

RUN yum -y install unzip 

# add jboss
ADD files/jboss-eap-5.2.0.zip /root/
RUN unzip -d /opt/ /root/jboss-eap-5.2.0.zip 

# java
ADD files/jdk-6u45-linux-x64-rpm.bin /root/
RUN chmod +x /root/jdk-6u45-linux-x64-rpm.bin && /root/jdk-6u45-linux-x64-rpm.bin

# main startup script
ADD files/launch.sh /launch.sh
RUN chmod +x /launch.sh

# jboss startup script
ADD files/start-jboss.sh /start-jboss.sh
RUN chmod +x /start-jboss.sh

CMD /launch.sh

EXPOSE 9999 9990 8080 22
