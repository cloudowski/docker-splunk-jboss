FROM slashroot/base

ADD files/splunk-6.0.1-189883-linux-2.6-x86_64.rpm /root/
RUN rpm -Uvh /root/splunk-6.0.1-189883-linux-2.6-x86_64.rpm

ENV SPLUNK_HOME /opt/splunk/


ADD files/launch.sh /
RUN chmod +x /launch.sh

# prepare environment for work with cli
RUN echo -e "export SPLUNK_HOME=/opt/splunk\nexport PATH=$PATH:$SPLUNK_HOME/bin/" > /etc/profile.d/splunk.sh

EXPOSE 8000 9997 22 

#ENTRYPOINT /launch.sh
CMD /launch.sh

