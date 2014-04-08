FROM fedora

# Create the management user
#RUN /usr/share/wildfly/bin/add-user.sh admin admin --silent

RUN yum -y install unzip 

ADD files/jboss-eap-6.2.0.zip /root/
RUN unzip -d /opt/ /root/jboss-eap-6.2.0.zip 

ADD files/jdk-6u45-linux-x64-rpm.bin /root/
RUN chmod +x /root/jdk-6u45-linux-x64-rpm.bin && /root/jdk-6u45-linux-x64-rpm.bin

RUN yum -y install tcpdump screen && sed -i 's/^# \(caption always.*\)/\1/' /etc/screenrc

# ssh 
RUN echo 'root:qazwsx' | chpasswd
RUN yum install -y openssh-server
RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
# http://stackoverflow.com/questions/2419412/ssh-connection-stop-at-debug1-ssh2-msg-kexinit-sent
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# Bad security, add a user and sudo instead!
RUN sed -ri 's/#PermitRootLogin yes/PermitRootLogin yes/g' /etc/ssh/sshd_config
# http://stackoverflow.com/questions/18173889/cannot-access-centos-sshd-on-docker
RUN sed -ri 's/UsePAM yes/#UsePAM yes/g' /etc/ssh/sshd_config
RUN sed -ri 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# Add splunk forwarder
ADD files/splunkforwarder-6.0.2-196940-linux-2.6-x86_64.rpm /root/
RUN rpm -Uvh /root/splunkforwarder-6.0.2-196940-linux-2.6-x86_64.rpm
ENV SPLUNK_HOME /opt/splunkforwarder/
# prepare environment for work with cli
RUN echo -e "export SPLUNK_HOME=/opt/splunkforwarder\nexport PATH=$PATH:$SPLUNK_HOME/bin/:/usr/java/latest/bin" > /etc/profile.d/splunk.sh

# startup scripts
ADD files/start-splunk-forwarder.sh /start-splunk-forwarder.sh
ADD files/start-jboss.sh /start-jboss.sh
ADD files/launch.sh /launch.sh
RUN chmod +x /*.sh


CMD /launch.sh

EXPOSE 8080 9990 9999 22
