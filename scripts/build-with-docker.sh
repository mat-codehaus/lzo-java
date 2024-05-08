#!/bin/bash

# Define the image name
IMAGE_NAME="lzo-builder"

# Define the container name
CONTAINER_NAME="LZOBuilder"

# Define the directory path inside the container
CONTAINER_DIR_PATH="/build/src/lzo-core/build/bundle/libs"

# Define the host directory to copy the directory to
HOST_DIR="./lzo-bundles"

# Build the Docker image
docker build -t $IMAGE_NAME -f ./Dockerfile.builder .

# Check if the container already exists and remove it
if [ "$(docker ps -aq -f name=^${CONTAINER_NAME}$)" ]; then
    echo "Removing existing container..."
    docker rm $CONTAINER_NAME
fi

# Create the Docker container
docker create --name $CONTAINER_NAME $IMAGE_NAME

# Copy the directory from the container to the host
docker cp $CONTAINER_NAME:$CONTAINER_DIR_PATH $HOST_DIR

# Remove the container after copying the directory
docker rm -f $CONTAINER_NAME

# Remove the Docker image
docker rmi -f $IMAGE_NAME

echo "Directory copied to $HOST_DIR and image $IMAGE_NAME deleted"

