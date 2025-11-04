FROM tomcat:9-jdk17
LABEL maintainer="shiva@example.com"

# Copy WAR file to Tomcat webapps directory
COPY target/hiring.war /usr/local/tomcat/webapps/hiring.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
