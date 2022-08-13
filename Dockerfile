FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y gpg wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update
RUN apt-get install -y cmake
RUN DEBIAN_FRONTEND=noninteractive apt -y install pkg-config
RUN apt-get install -y gcc-arm-none-eabi gcc g++
RUN apt install libnewlib-arm-none-eabi
RUN DEBIAN_FRONTEND=noninteractive apt install -y gdb-multiarch automake autoconf build-essential texinfo libtool libftdi-dev libusb*
RUN apt install -y libstdc++-arm-none-eabi-newlib
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt install -y python3.8

RUN apt-get update
RUN apt update

WORKDIR /pico

# Clone development tools in their respective directories
RUN git clone https://github.com/raspberrypi/pico-sdk.git
RUN cd /pico/pico-sdk && git submodule update --init && cd /pico
ENV PICO_SDK_PATH /pico/pico-sdk
RUN git clone https://github.com/raspberrypi/pico-examples.git
RUN cd /pico/pico-examples && git submodule update --init && cd /pico
ENV PICO_EXAMPLES_PATH /pico/pico-examples
RUN git clone https://github.com/raspberrypi/pico-extras.git
RUN cd /pico/pico-extras && git submodule update --init && cd /pico
ENV PICO_EXTRAS_PATH /pico/pico-extras
RUN git clone https://github.com/raspberrypi/pico-playground.git
RUN cd /pico/pico-playground && git submodule update --init && cd /pico
ENV PICO_PLAYGROUND_PATH /pico/pico-playground

RUN cd /pico

RUN git clone https://github.com/raspberrypi/picoprobe.git
RUN cd /pico/picoprobe && mkdir /pico/picoprobe/build && cd build && cmake ../ && make -j4 && cd /pico


RUN git clone https://github.com/raspberrypi/picotool.git
RUN cd /pico/picotool && mkdir /pico/picotool/build && cd build && cmake ../ && make -j4 && cd /pico
RUN cp  -r /pico/picotool /usr/local/bin

# RUN apt install -y minicom
# RUN raspi-config nonint do_serial 2