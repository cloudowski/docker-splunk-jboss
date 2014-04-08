FROM fedora

RUN yum -y install unzip 

# add jboss
ADD files/jboss-eap-5.2.0.zip /root/
RUN unzip -d /opt/ /root/jboss-eap-5.2.0.zip 

# java
ADD files/jdk-6u45-linux-x64-rpm.bin /root/
RUN chmod +x /root/jdk-6u45-linux-x64-rpm.bin && /root/jdk-6u45-linux-x64-rpm.bin

# utils
RUN yum -y install tcpdump screen && sed -i 's/^# \(caption always.*\)/\1/' /etc/screenrc

# ssh 
RUN echo 'root:qazwsx' | chpasswd
RUN yum install -y openssh-server
RUN mkdir -p /var/run/sshd ; chmod -rx /var/run/sshd
# http://stackoverflow.com/questions/2419412/ssh-connection-stop-at-debug1-ssh2-msg-kexinit-sent
RUN ssh-keygen -t rsa -f /etc/ssh/ssh_host_rsa_key
# Bad security, add a user and sudo instead!
RUN sed -i -e 's/#PermitRootLogin yes/PermitRootLogin yes/g' -e 's/UsePAM yes/#UsePAM yes/g' -e 's/#UsePAM no/UsePAM no/g' /etc/ssh/sshd_config

# main startup script
ADD files/launch.sh /launch.sh
RUN chmod +x /launch.sh

# Add splunk forwarder
ADD files/splunkforwarder-6.0.2-196940-linux-2.6-x86_64.rpm /root/
RUN rpm -Uvh /root/splunkforwarder-6.0.2-196940-linux-2.6-x86_64.rpm
ENV SPLUNK_HOME /opt/splunkforwarder/
ADD files/start-splunk-forwarder.sh /start-splunk-forwarder.sh
RUN chmod +x /start-splunk-forwarder.sh
# prepare environment for work with cli
RUN echo -e "export SPLUNK_HOME=/opt/splunkforwarder\nexport PATH=$PATH:$SPLUNK_HOME/bin/:/usr/java/latest/bin" > /etc/profile.d/splunk.sh

# jboss startup script
ADD files/start-jboss.sh /start-jboss.sh
RUN chmod +x /start-jboss.sh

CMD /launch.sh

EXPOSE 9999 9990 8080 22
