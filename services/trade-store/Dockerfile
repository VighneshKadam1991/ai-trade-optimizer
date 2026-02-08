FROM eclipse-temurin:17-jdk

WORKDIR /app

# jar already built by pipeline root mvn clean install
COPY target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]
