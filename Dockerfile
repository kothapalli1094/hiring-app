FROM tomcat:8.0.20-jre8
# Define environment variables for Nexus repository and the artifact to download
ENV NEXUS_REPO_URL="http://44.204.106.16:8081/repository/maven-snapshots/"
ENV ARTIFACT_PATH="com/shiva/shiva-app/1.0-SNAPSHOT/shiva-app-1.0-20251030.095917-2.war"

# Download the WAR file from Nexus and copy it to the Tomcat webapps directory
ADD $NEXUS_REPO_URL$ARTIFACT_PATH /usr/local/tomcat/webapps/shiva-app.war

# Expose port 8080 (Tomcat's default port)
EXPOSE 8080

# Start Tomcat
CMD ["catalina.sh", "run"]
