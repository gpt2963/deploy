# Use CentOS 7 as base image
FROM centos:7

# Install wget and tar for downloading and extracting Java
RUN yum install -y wget tar

# Install OpenJDK 11 using yum
RUN yum install -y java-11-openjdk-devel && \
    yum clean all

# Set environment variables
ENV JAVA_HOME /usr/lib/jvm/java-11-openjdk
ENV CATALINA_HOME /usr/local/tomcat
ENV PATH $CATALINA_HOME/bin:$PATH

# Download and install Tomcat
RUN wget https://archive.apache.org/dist/tomcat/tomcat-10/v10.0.13/bin/apache-tomcat-10.0.13.tar.gz && \
    tar -xzvf apache-tomcat-10.0.13.tar.gz && \
    mv apache-tomcat-10.0.13 $CATALINA_HOME && \
    rm apache-tomcat-10.0.13.tar.gz

# Remove default Tomcat webapps
RUN rm -rf $CATALINA_HOME/webapps/*

# Copy your .war file into the Tomcat webapps directory
COPY ROOT.war $CATALINA_HOME/webapps/

# Expose Tomcat port as 8080
EXPOSE 8080

# Add roles and user to tomcat-users.xml
RUN echo '<tomcat-users>' > $CATALINA_HOME/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> $CATALINA_HOME/conf/tomcat-users.xml && \
    echo '  <role rolename="admin-gui"/>' >> $CATALINA_HOME/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-script"/>' >> $CATALINA_HOME/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="password" roles="manager-gui,admin-gui,manager-script"/>' >> $CATALINA_HOME/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> $CATALINA_HOME/conf/tomcat-users.xml

# Start Tomcat
CMD ["catalina.sh", "run"]

