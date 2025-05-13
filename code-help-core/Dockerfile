FROM openjdk:17-slim

ARG VERSION='0.0.1-SNAPSHOT'
ENV JAR_PATH code-help-core-app/target/code-help-core-app-$VERSION.jar
ENV PROFILE docker
ENV JAVA_OPTIONS ''
ENV JAVA_PROPERTIES ''

WORKDIR /code-help

RUN apt update -y && \
    apt upgrade -y && \
    apt install -y nodejs

COPY $JAR_PATH core-app.jar

EXPOSE 3000

ENTRYPOINT exec java $JAVA_OPTIONS -jar \
              -Dspring.profiles.active="$PROFILE" \
              $JAVA_PROPERTIES core-app.jar