## On va faire un multistage dockerfile
## Donc on va build le projet gen le jar et expose

# 1. Build
FROM maven:3.9-eclipse-temurin-21 AS build

WORKDIR /build
# Copier le fichier pom pour avoir les dependances
COPY pom.xml .
# Copier le dossier src
COPY src ./src
# Lancer le build
RUN mvn package -DskipTests
## A cette etape on a un jar dans le dossier target

# 2. Expose
FROM eclipse-temurin:21-jre-alpine

WORKDIR /app

COPY --from=build /build/target/*.jar app.jar

EXPOSE 8080
ENTRYPOINT ["java","-jar","app.jar"]

