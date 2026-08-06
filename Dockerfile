# syntax=docker/dockerfile:1
# Imagen del backend Spring Boot. Multi-stage: compila con Maven y solo se
# queda con el JRE + el .jar para que la imagen final sea pequeña.

# --- build ---
FROM maven:3.9-eclipse-temurin-21 AS build
WORKDIR /app
COPY pom.xml .
RUN mvn -q -e -B dependency:go-offline
COPY src ./src
RUN mvn -q -e -B clean package -DskipTests

# --- run ---
FROM eclipse-temurin:21-jre
WORKDIR /app
COPY --from=build /app/target/archivos-0.1.0.jar app.jar
EXPOSE 8080
# Arranca con el perfil por defecto (NO dev): /api/dev/** queda desactivado.
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
