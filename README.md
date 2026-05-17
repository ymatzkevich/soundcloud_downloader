# soundcloud_downloader
Automatically downloading your favourite Soundcloud tracks!

This is a setup to automatically download your tracks from Soundcloud with all the traditional artist, album, cover information encoded in the file tags.

## Build a Docker image using the Dockerfile
The general idea here is to have a Docker container being created and running a script and then stopping + removing itself when done with the script. To build the image required for the container:
```bash
chmod +x setup.sh && ./setup.sh
```
The name given to the image is `scdl`. It is based on Alpine Linux and has additional packages like ffmpeg, pipx and scdl installed.

## Give environment variables
```bash
nano .env
```
and then in there give:
```bash
SOUNDCLOUD_URL=https://soundcloud.com/your-username/likes
EXT_DIR="/path/to/dir"
```
`EXT_DIR` is optional (only if you need to automatically put your tracks somewhere else e.g. syncthing folder to have your cool tracks on your cool phone)
## In a task scheduler
In the crontab or the task scheduler of the NAS we configure a task that will run the `run_soundcloud_downloader.sh` script every fixed amount of time (depending on user activity on Soundcloud) to automatically download and move the tracks in some specified directory.
For example, a cron job running at 7:00 every day would look like:
```
0 7 * * * /path/to/soundcloud_downloader/run_soundcloud_downloader.sh 
```
The `archive.txt` file is used to track what tracks were already downloaded. 
In order to have a tabula rasa you can simply create an empty text file and the new tracks will be recorded there.

## Logs
The task will log all the work done in `logs/download.log`. 

## To do
* mv overwrite to the other folder
* pre built image 
* avoid folders mess
* log file max size

## ADR: why use `scdl` instead of `yt-dlp` library ?

### context
wanted:
- deterministic audio output
- embedded cover art
- reliable metadata
- all tracks in one directory
- simple automation without cleanup

`yt-dlp` looked attractive because it is modern, multi-site, and preserves original uploads

### decision
use `scdl` as backend for soundcloud downloads.

### why not `yt-dlp`
- soundcloud metadata/artwork sometimes missing => tagging failed
- mixed source formats produced inconsistent output
- aac leftovers and failed conversions required manual cleanup
- silent failures with incomplete metadata
- playlist/likes handling more cumbersome
- preserving original/lossless uploads was not a priority for this project
- too strict/general-purpose for unreliable soundcloud data

### why `scdl`
- uses soundcloud api directly
- always produces predictable playable mp3 files
- metadata and artwork handling more reliable
- simpler playlist/likes support
- deterministic output easier to automate and organize
- no messy leftovers from failed conversions

### consequence
original/lossless audio may be discarded due to mp3 re-encoding

tradeoff accepted because project priority is consistency and automation:
clean soundcloud mp3 archives with tags and cover art
