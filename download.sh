#!/usr/bin/env bash
set -e

TRACKS_DIR="tracks"
ARCHIVE_DIR="archive"

ARCHIVE_FILE="archive/archive.txt"

touch "$ARCHIVE_FILE"

if [ -z "${SOUNDCLOUD_URL:-}" ]; then
  echo "ERROR: the playlist URL is not set! exiting... bye!"
else
  echo "starting download from: $SOUNDCLOUD_URL"
  scdl \
  -l "$SOUNDCLOUD_URL" \
  --path "$TRACKS_DIR" \
  --download-archive "$ARCHIVE_FILE" \
  --name-format "%(artist)s - %(title)s" \
  --original-art \
  --onlymp3 \
  --hidewarnings \
  2>&1 | while IFS= read -r line; do
   echo "$line"
   if [[ "$line" == *"has already been recorded in the archive"* ]]; then
     pkill -P $$ scdl
     break
   fi
  done
fi
