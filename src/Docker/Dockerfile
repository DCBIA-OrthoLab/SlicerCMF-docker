FROM python:3.7

# Directories that don't need to be preserved in images
VOLUME ["/var/cache/apt", "/tmp"]

# xvfb: run x programs with virtual framebuffer
# curl: invoke slicer download api
# jq: parse JSON api responses
# rsync: merge directories
RUN apt-get update && \
  apt-get install -y git curl xvfb jq rsync

# Slicer Dependencies
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  libgl1-mesa-dri xserver-xorg-video-dummy xserver-xorg-input-void x11-xserver-utils \
  xinit libpulse-dev libnss3 libglu1-mesa libasound2 libxkbcommon-x11-0 libxcb-icccm4 \
  libxcb-image0 libxcb-keysyms1 libxcb-xkb1 libxcb-xinerama0 libdouble-conversion1 \
  libqt5dbus5 libqt5widgets5 libqt5network5 libqt5gui5 libqt5core5a

WORKDIR /app
COPY slicer-dl.sh .

ARG SLICER_ROOT="/app/Slicer"
ARG SLICER_REVISION="4.11.20210226"
RUN bash slicer-dl.sh -v "$SLICER_REVISION" -d "$SLICER_ROOT" -s

# invoke slicer-dl twice so that changing SLICER_EXTENSIONS uses cached slicer install
# space-separated list of extension names
ARG SLICER_EXTENSIONS="BoneTextureExtension"
RUN bash slicer-dl.sh -v "$SLICER_REVISION" -d "$SLICER_ROOT" \
  $(for ext in $SLICER_EXTENSIONS; do echo "-e $ext"; done)

# QT environment variables
ENV XDG_RUNTIME_DIR="/tmp/runtime-root"

# generate script to setup slicer environment variables (PATH, LD_LIBRARY_PATH, etc)
RUN xvfb-run "$SLICER_ROOT"/Slicer --launcher-show-set-environment-commands > /app/slicer-env.sh

ENTRYPOINT bash --init-file /app/slicer-env.sh
