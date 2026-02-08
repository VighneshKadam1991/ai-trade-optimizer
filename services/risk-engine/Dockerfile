#################################################
# Stage 1 — Build the jar
#################################################
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /build

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

#################################################
# Stage 2 — Runtime container
#################################################
FROM eclipse-temurin:17-jdk

WORKDIR /app

COPY --from=builder /build/target/*.jar app.jar

ENTRYPOINT ["java","-jar","app.jar"]
