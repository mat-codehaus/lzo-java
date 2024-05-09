# Define a build argument to switch between Docker Hub and private repository
ARG REGISTRY=
# or ARG REGISTRY=private.reg/

# Use the argument to specify the repository in the FROM instruction
FROM ${REGISTRY}ubuntu:22.04

RUN apt-get update && apt-get install -y openjdk-8-jdk git curl unzip

# Set JAVA_HOME environment variable
ENV JAVA_HOME /usr/lib/jvm/java-8-openjdk-amd64

WORKDIR /opt

# Allow the Gradle download URL to be specified as a build argument
ARG GRADLE_URL=https://services.gradle.org/distributions/gradle-5.6-bin.zip

# Download and unzip Gradle using the build argument
RUN curl -L -o gradle-bin.zip ${GRADLE_URL} && \
    unzip gradle-bin.zip && \
    rm gradle-bin.zip

# Set environment variables
ENV GRADLE_HOME=/opt/gradle-5.6
ENV PATH=$PATH:$GRADLE_HOME/bin

# Check Gradle version to verify installation
RUN gradle -v

WORKDIR /build

COPY . src

RUN export JAVAL_OPTIONS="-Dfile.encoding=UTF-8" && \
  cd /build/src && \
  ./gradlew -PreleaseVersion=1.0.7 bundleJars
