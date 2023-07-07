#!/bin/bash

KEY="YOUR KEY HERE"
SERVER="https://domain.com/api"
BASE_DIR="/your/base/dir"
DOCKER_DIR="/your/docker/dir"
ALBUM_DIR="${BASE_DIR}/Takeout/Google Photos/AlbumsProcessed"
PHOTO_DIR="${BASE_DIR}/Takeout/Google Photos/PhotosProcessed"

# Change the working directory to BASE_DIR
cd "$BASE_DIR"

# First unzip takeout files 
unzip "*.zip"

# Now run exif fixing docker
cd "$DOCKER_DIR"
## The reason for having a dedicated docker dir is because docker can only run on 
## a full linux FS. In my setup I have the remote dirs on a cifs mount so docker 
## won't run there
git clone --recurse-submodules https://github.com/MrYakobo/exif-wrapper.git
cd exif-wrapper
echo "TAKEOUT_DIR=${BASE_DIR}/Takeout" > .env
docker-compose up

# Upload photos
immich upload -y --key "$KEY" --server "$SERVER" "$PHOTO_DIR" -t 16 -al

# Upload albums
cd "$ALBUM_DIR"
for album in "$ALBUM_DIR"/*; do
  if [ -d "$album" ]; then
    echo "Uploading album: $album"
    sudo docker run -it --rm -v "$album:/import" ghcr.io/immich-app/immich-cli:latest upload \ 
      --key "$KEY" \
      --server "$SERVER" \ 
      -t 16 -al "$album"
  fi
done