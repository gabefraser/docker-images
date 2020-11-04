FROM ubuntu:18.04

# Install wget
RUN apt-get update
RUN apt-get install -y wget

# Add 32-bit architecture
RUN dpkg --add-architecture i386
RUN apt-get update

# Install Wine
RUN apt-get install -y software-properties-common gnupg2
RUN wget -nc https://dl.winehq.org/wine-builds/winehq.key
RUN apt-key add winehq.key
RUN apt-add-repository 'deb https://dl.winehq.org/wine-builds/ubuntu/ bionic main'
RUN apt-get install -y --install-recommends winehq-stable winbind
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEPREFIX=/root/.demo 
ENV WINEARCH=win64
RUN winecfg

# Install Mono
RUN wget -P /mono http://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi
RUN wineboot -u && msiexec /i /mono/wine-mono-4.9.4.msi
RUN rm -rf /mono/wine-mono-4.9.4.msi