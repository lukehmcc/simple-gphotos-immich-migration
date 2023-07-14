#!/bin/bash

read -p "Enter API key: " KEY
read -p "Enter server address (https://sld.tld/api): " SERVER
read -p "Enter your base dir (where the takeout zips are): " BASE_DIR
read -p "Enter the docker dir (make sure not to use a network mount path - can be the same as base dir): " DOCKER_DIR
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
git clone --recurse-submodules https://github.com/lukehmcc/exif-wrapper.git
cd exif-wrapper
echo "TAKEOUT_DIR=${BASE_DIR}/Takeout" > .env
docker compose up

# Upload photos
docker run -it --rm -v "$PHOTO_DIR:/import" ghcr.io/immich-app/immich-cli:latest upload -y -k "$KEY" -s "$SERVER" -t 16

# Upload albums
cd "$ALBUM_DIR"
for album in *; do
  if [ -d "$album" ]; then
    echo "Uploading album: $album"
    docker run -it --rm -v "$(pwd)/$album:/import/$album" ghcr.io/immich-app/immich-cli:latest upload -y -k "$KEY" -s "$SERVER" -t 16 -al "$album"
  fi
done
