FROM ubuntu:20.04

# Extend the system environments
ENV LD_LIBRARY_PATH /lib:/usr/lib:/usr/local/lib
ENV DEBIAN_FRONTEND=noninteractive

# Install all the required files from the repository
RUN apt update
RUN apt install -y build-essential curl wget git python3 python3-distutils python3-apt libassimp5 libavcodec58 libavformat58 libavutil56 libbullet2.88 libcg libcggl libegl1 libfreetype6 libgl1 libgles1 libgles2 libharfbuzz0b libjpeg8 libode8 libopenal1 libopenexr24 libopusfile0 libpng16-16 libswresample3 libswscale5 libtiff5 libvorbisfile3 nvidia-cg-toolkit

# Install pip
RUN curl -s -L https://bootstrap.pypa.io/get-pip.py | python3

# Install pip dependencies
RUN pip install limeade pyaes

# Create all the directories inadvance
RUN mkdir /fftw \
    /fftw/src

# Download FFTW
RUN wget -P /fftw http://www.fftw.org/fftw-3.3.7.tar.gz
RUN tar -zxvf /fftw/fftw-3.3.7.tar.gz -C /fftw/src --strip-components=1

# Compile FFTW
RUN cd /fftw/src \
    && ./configure --enable-shared \
    && make install

# Install panda3d
COPY ./py3.deb /panda3d/py3.deb
RUN cd /panda3d \
    && dpkg -i py3.deb