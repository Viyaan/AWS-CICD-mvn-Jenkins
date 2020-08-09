FROM maven:3.5.2-jdk-8-alpine AS MAVEN_BUILD
LABEL maintainer Byte Novus aka Viyaan
COPY pom.xml /build/
COPY src /build/src/
WORKDIR /build/
RUN mvn clean package
FROM openjdk:8-jre-alpine
WORKDIR /app
COPY --from=MAVEN_BUILD /build/target/*.jar /app/docker-boot-ecs-0.0.1.jar
ENTRYPOINT ["java", "-jar", "docker-boot-ecs-0.0.1.jar"]