FROM tomcat:9-jdk17
LABEL maintainer="shiva"

# Copy WAR file to Tomcat webapps directory
COPY target/shiva-app.war /usr/local/tomcat/webapps/shiva-app.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
