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
RUN mvn dependency:go-offline -ntp -B -pl code-help-core

COPY code-help-core code-help-core
RUN mvn clean package -ntp -B -pl code-help-core

FROM openjdk:17
WORKDIR /code-help/code-help-core
COPY --from=package code-help/code-help-core/code-help-core-api/target/code-help-core-api-0.0.1-SNAPSHOT.jar code-help-core-api/target/code-help-core-api-0.0.1-SNAPSHOT.jar
COPY --from=package code-help/code-help-core/code-help-core-api-docs/target/code-help-core-api-docs-0.0.1-SNAPSHOT.jar code-help-core-api-docs/target/code-help-core-api-docs-0.0.1-SNAPSHOT.jar
COPY --from=package code-help/code-help-core/code-help-core-app/target/code-help-core-app-0.0.1-SNAPSHOT.jar code-help-core-app/target/code-help-core-app-0.0.1-SNAPSHOT.jar
COPY --from=package code-help/code-help-core/code-help-core-domain/target/code-help-core-domain-0.0.1-SNAPSHOT.jar code-help-core-domain/target/code-help-core-domain-0.0.1-SNAPSHOT.jar
COPY --from=package code-help/code-help-core/code-help-core-service/target/code-help-core-service-0.0.1-SNAPSHOT.jar code-help-core-service/target/code-help-core-service-0.0.1-SNAPSHOT.jar

EXPOSE 3000
ENTRYPOINT [ "java", "-jar", "/code-help/code-help-core/code-help-core-app/target/code-help-core-app-0.0.1-SNAPSHOT.jar" ]