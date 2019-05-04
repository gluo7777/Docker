# FROM openjdk:8-jdk-alpine
# VOLUME /tmp
# ARG JAR_FILE
# COPY ${JAR_FILE} app.jar
# ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

# To take advantage of the clean separation between dependencies and application resources in a Spring Boot fat jar file, we will use a slightly different implementation of the Dockerfile:
# This Dockerfile has a DEPENDENCY parameter pointing to a directory where we have unpacked the fat jar. If we get that right, it already contains a BOOT-INF/lib directory with the dependency jars in it, and a BOOT-INF/classes directory with the application classes in it. Notice that we are using the application’s own main class hello.Application (this is faster than using the indirection provided by the fat jar launcher).
FROM openjdk:8-jdk-alpine
VOLUME /tmp
# Will not be able to curl without exposing a port
EXPOSE 8080
ARG DEPENDENCY=target/dependency
COPY ${DEPENDENCY}/BOOT-INF/lib /app/lib
COPY ${DEPENDENCY}/META-INF /app/META-INF
COPY ${DEPENDENCY}/BOOT-INF/classes /app
ENTRYPOINT ["java","-cp","app:app/lib/*","com.example.demo.DemoApplication"]