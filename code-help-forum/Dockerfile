FROM openjdk:17-slim

ENV JAR_PATH /target/code-help-forum-0.0.1-SNAPSHOT.jar
ENV PROFILE docker
ENV JAVA_OPTIONS ''
ENV JAVA_PROPERTIES ''

WORKDIR /code-help


COPY $JAR_PATH forum-app.jar

EXPOSE 3001

ENTRYPOINT exec java $JAVA_OPTIONS -jar \
              -Dspring.profiles.active="$PROFILE" \
              $JAVA_PROPERTIES forum-app.jar