FROM maven:3.8.1-openjdk-17-slim AS package
WORKDIR /code-help

COPY pom.xml .
COPY code-help-core/pom.xml code-help-core/pom.xml
COPY code-help-core/code-help-core-api/pom.xml code-help-core/code-help-core-api/pom.xml
COPY code-help-core/code-help-core-api-docs/pom.xml code-help-core/code-help-core-api-docs/pom.xml
COPY code-help-core/code-help-core-app/pom.xml code-help-core/code-help-core-app/pom.xml
COPY code-help-core/code-help-core-domain/pom.xml code-help-core/code-help-core-domain/pom.xml
COPY code-help-core/code-help-core-service/pom.xml code-help-core/code-help-core-service/pom.xml
COPY code-help-core/pom.xml code-help-core/pom.xml
COPY code-help-mobile-ui/pom.xml code-help-mobile-ui/pom.xml
COPY code-help-forum/pom.xml code-help-forum/pom.xml
RUN mvn dependency:go-offline -ntp -B -pl code-help-forum

COPY code-help-forum code-help-forum
RUN mvn clean package -ntp -B -pl code-help-forum

FROM openjdk:17
WORKDIR /code-help/code-help-forum
COPY --from=package /code-help/code-help-forum/target/code-help-forum-0.0.1-SNAPSHOT.jar target/code-help-forum-0.0.1-SNAPSHOT.jar
EXPOSE 3001
ENTRYPOINT [ "java", "-jar", "/code-help/code-help-forum/target/code-help-forum-0.0.1-SNAPSHOT.jar" ]