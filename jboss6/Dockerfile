FROM slashroot/base

# Create the management user
#RUN /usr/share/wildfly/bin/add-user.sh admin admin --silent

RUN yum -y install unzip 

ADD files/jboss-eap-6.2.0.zip /root/
RUN unzip -d /opt/ /root/jboss-eap-6.2.0.zip 

ADD files/jdk-6u45-linux-x64-rpm.bin /root/
RUN chmod +x /root/jdk-6u45-linux-x64-rpm.bin && /root/jdk-6u45-linux-x64-rpm.bin

RUN yum -y install tcpdump screen && sed -i 's/^# \(caption always.*\)/\1/' /etc/screenrc

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
