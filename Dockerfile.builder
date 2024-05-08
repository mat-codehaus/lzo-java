# Define a build argument to switch between Docker Hub and private repository
ARG REGISTRY=
# or ARG REGISTRY=private.reg/

# Use the argument to specify the repository in the FROM instruction
FROM ${REPO}ubuntu:22.04

RUN apt-get update && apt-get install -y openjdk-8-jdk git

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /build

COPY . src

RUN export JAVAL_OPTIONS="-Dfile.encoding=UTF-8" && \
  cd /build/src && \
  ./gradlew -PreleaseVersion=1.0.7 bundleJars
