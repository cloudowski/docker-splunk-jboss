FROM fedora

MAINTAINER Tomasz Cholewa <slashroot@slashroot.eu>

RUN yum -y install unzip 
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
ADD files/start-splunk-forwarder.sh /start-splunk-forwarder.sh
RUN chmod +x /start-splunk-forwarder.sh
# prepare environment for work with cli
RUN echo -e "export SPLUNK_HOME=/opt/splunkforwarder\nexport PATH=$PATH:$SPLUNK_HOME/bin/:/usr/java/latest/bin" > /etc/profile.d/splunk.sh


EXPOSE 22
