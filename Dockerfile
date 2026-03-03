FROM alpine:3.19

RUN apk add --no-cache \
    bash \
    ffmpeg \
    python3 \
    py3-pip \
    py3-virtualenv

# Create virtual environment
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Install scdl inside venv
RUN pip install --no-cache-dir scdl

WORKDIR /soundcloud_downloader

COPY download.sh .
RUN chmod +x download.sh

ENTRYPOINT ["./download.sh"]
