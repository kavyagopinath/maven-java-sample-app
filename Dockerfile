# Build Stage
FROM maven:3.9.4-eclipse-temurin-11 AS build

# Set the working directory
WORKDIR /home/app

# Copy only the pom.xml first to cache dependency downloads
COPY pom.xml .

# Download dependencies
RUN mvn dependency:go-offline

# Copy the source code
COPY src ./src

# Apply formatting and package the application
RUN mvn spring-javaformat:apply && mvn clean package

# Package Stage
FROM eclipse-temurin:11-jre-alpine AS package

# Copy the built application from the build stage
COPY --from=build /home/app/target/spring-petclinic-2.3.1.BUILD-SNAPSHOT.jar /usr/local/lib/demo.jar

# Expose the application port
EXPOSE 8001

# Run the application
ENTRYPOINT ["java", "-Dserver.port=8001", "-jar", "/usr/local/lib/demo.jar"]
