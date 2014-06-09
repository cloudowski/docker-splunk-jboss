FROM slashroot/base

RUN yum -y install java-1.7.0-openjdk.x86_64 

ADD files/liferay-portal-jboss-6.2-ce-ga2-20140319114139101.zip /root/
RUN unzip -d /opt /root/liferay-portal-jboss-6.2-ce-ga2-20140319114139101.zip

# startup scripts
ADD files/start-jboss.sh /start-jboss.sh
ADD files/launch.sh /launch.sh
RUN chmod +x /*.sh


CMD /launch.sh

EXPOSE 9999 9990 8080 22

RUN yum -y install mc ant
