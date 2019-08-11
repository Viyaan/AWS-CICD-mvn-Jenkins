FROM openjdk:8-jdk-alpine

# Add Maintainer Info
LABEL maintainer="viyaan.86@gmail.com"

# Add a volume pointing to /tmp
VOLUME /tmp

# Make port 8080 available to the world outside this container
EXPOSE 3000

# The application's jar file
ARG JAR_FILE=target/*.jar

# Add the application's jar to the container
ADD ${JAR_FILE} jenkinscicd.jar

# Run the jar file 
ENTRYPOINT ["java", "-jar","/jenkinscicd.jar"]