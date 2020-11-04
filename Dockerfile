FROM ubuntu:18.04

# Install wget
RUN apt-get update
RUN apt-get install -y wget

# Add 32-bit architecture
RUN dpkg --add-architecture i386
RUN apt-get update

# Install Wine
RUN apt-get install -y software-properties-common gnupg2 ca-certificates xvfb lib32gcc1 libntlm0 winbind wine64 winetricks --install-recommends
ENV WINEDEBUG=fixme-all

# Setup a Wine prefix
ENV WINEARCH=win64
RUN winecfg

# Install Mono
RUN wget -P /mono http://dl.winehq.org/wine/wine-mono/4.9.4/wine-mono-4.9.4.msi
RUN wineboot -u && msiexec /i /mono/wine-mono-4.9.4.msi
RUN rm -rf /mono/wine-mono-4.9.4.msi

USER container
ENV USER=container HOME=/home/container WINEARCH=win64 WINEPREFIX=/home/container/.wine64
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]