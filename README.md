# simple-gphotos-immich-migration
This is a hackey (yet simple) way to import gphotos into immich.

## Install Instructions
### Prereq
- docker & compose plugin
- git

### Steps
1. Download takeout files and put them in a directory
2. Get API key as described [here](https://immich.app/docs/features/bulk-upload#obtain-the-api-key)
3. Download the script and run it:
```bash
wget -Nnv https://raw.githubusercontent.com/lukehmcc/simple-gphotos-immich-migration/master/process_and_upload.sh && bash process_and_upload.sh; rm -f process_and_upload.sh
```
4. Respond to the prompts and you're on your merry way!

Ideally you should do this through an app like `tmux` as this can take a long time and a disconnected session will mean you have to restart. Instructions for how to use `tmux` [here](https://www.linode.com/docs/guides/persistent-terminal-sessions-with-tmux/).
