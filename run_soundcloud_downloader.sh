#!/usr/bin/env bash
set -euo pipefail

# move to project directory
PROJECT_DIR=$(dirname "${BASH_SOURCE[0]}")
cd "$PROJECT_DIR"

# make sure that we have our log file
LOG_FILE="logs/download.log"
touch "$LOG_FILE"

echo "[$(date)] beginning of task" >> "$LOG_FILE" 2>&1

# load environment variables for cron
set -a
source .env
set +a

# run container
docker run --rm \
  --name scdl \
  --env-file .env \
  -v "$PROJECT_DIR/tracks:/soundcloud_downloader/tracks" \
  -v "$PROJECT_DIR/logs:/soundcloud_downloader/logs" \
  -v "$PROJECT_DIR/archive:/soundcloud_downloader/archive" \
  scdl >> "$LOG_FILE" 2>&1

# move stuff elsewhere if it's specified in .env
if [[ -z "$EXT_DIR" ]]; then
    echo "No external directory defined, no problemo the tracks will happily stay in ./tracks" >> "$LOG_FILE" 2>&1
else
    if [[ -d "$EXT_DIR" && "$(ls -A ./tracks 2>/dev/null)" ]]; then
        # Move all files from directory A to directory B
        mv ./tracks/* "$EXT_DIR/"
        echo "Tracks moved from ./tracks to $EXT_DIR" >> "$LOG_FILE" 2>&1
    else
        echo "No tracks to move!" >> "$LOG_FILE" 2>&1
    fi
fi

echo "[$(date)] end of task" >> "$LOG_FILE" 2>&1
