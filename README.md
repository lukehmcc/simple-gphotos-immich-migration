# simple-gphotos-immich-migration
This is a hackey (yet simple) way to import gphotos into immich.

## Install Instructions
### Prereq
- docker & compose plugin
- git

### Steps
1. Download takeout files and put them in a directory
2. Get API key as described [here](https://immich.app/docs/features/bulk-upload#obtain-the-api-key)
3. Download the script:
```bash
wget https://raw.githubusercontent.com/lukehmcc/simple-gphotos-immich-migration/master/process_and_upload.sh
chmod +x process_and_upload.sh
```
4. Edit the script to change 3 values:
  - Change `BASE_DIR` to where you put the takeout files
  - Change `DOCKER_DIR` to a directory with a native linux FS (exfat, btrfs, etc) NOT a network mount directory because that won't work. If not network mounted you can set `DOCKER_DIR` to the same value as `BASE_DIR`.
  - Change `API_KEY` to the key you found earlier
5. Now simply run the script 
```./process_and_upload```
