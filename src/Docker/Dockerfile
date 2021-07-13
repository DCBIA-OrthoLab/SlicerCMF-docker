FROM python:3.7

# Directories that don't need to be preserved in images
VOLUME ["/var/cache/apt", "/tmp"]

# xvfb: run x programs with virtual framebuffer
RUN apt-get update && \
  apt-get install -y git curl xvfb

# Slicer Dependencies
RUN DEBIAN_FRONTEND="noninteractive" apt-get install -y \
  libgl1-mesa-dri xserver-xorg-video-dummy xserver-xorg-input-void x11-xserver-utils \
  xinit libpulse-dev libnss3 libglu1-mesa libasound2 libxkbcommon-x11-0 libxcb-icccm4 \
  libxcb-image0 libxcb-keysyms1 libxcb-xkb1 libxcb-xinerama0 libdouble-conversion1 \
  libqt5dbus5 libqt5widgets5 libqt5network5 libqt5gui5 libqt5core5a

# Version 4.11.20210226
ARG SLICER_REVISION="29738"

# extract chosen slicer revision to /app/Slicer
RUN mkdir /app
RUN curl -L "https://download.slicer.org/download?os=linux&revision=$SLICER_REVISION" \
  | tar xz && mv Slicer-*-linux-amd64 /app/Slicer

# QT environment variables
ENV XDG_RUNTIME_DIR="/tmp/runtime-root"

# space-separated list of extension names to install
ARG SLICER_EXTENSIONS="BoneTextureExtension"

# copy to tmp so helper script is not preserved
COPY extension_installer.py /tmp
RUN xvfb-run /app/Slicer/Slicer --python-script /tmp/extension_installer.py

# setup slicer environment variables (PATH, LD_LIBRARY_PATH) for interactive bash session
RUN xvfb-run /app/Slicer/Slicer --launcher-show-set-environment-commands > /app/slicer-env.sh
ENTRYPOINT bash --init-file /app/slicer-env.sh
