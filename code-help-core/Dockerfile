FROM openjdk:17-slim

ENV JAR_PATH code-help-core-app/target/code-help-core-app-0.0.1-SNAPSHOT.jar
ENV PROFILE docker
ENV JAVA_OPTIONS ''
ENV JAVA_PROPERTIES ''

WORKDIR /code-help/code-help-forum


COPY $JAR_PATH app.jar

EXPOSE 3000

ENTRYPOINT exec java $JAVA_OPTIONS -jar \
              -Dspring.profiles.active="$PROFILE" \
              $JAVA_PROPERTIES app.jar