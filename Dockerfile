FROM ubuntu:20.04
RUN apt-get update
RUN apt-get install -y git
RUN apt-get install -y gpg wget
RUN wget -O - https://apt.kitware.com/keys/kitware-archive-latest.asc 2>/dev/null | gpg --dearmor - | tee /usr/share/keyrings/kitware-archive-keyring.gpg >/dev/null
RUN echo 'deb [signed-by=/usr/share/keyrings/kitware-archive-keyring.gpg] https://apt.kitware.com/ubuntu/ focal main' | tee /etc/apt/sources.list.d/kitware.list >/dev/null
RUN apt-get update
RUN apt-get install -y cmake
RUN apt-get install -y gcc-arm-none-eabi gcc g++
RUN DEBIAN_FRONTEND=noninteractive apt-get -y install gdb-multiarch automake autoconf build-essential texinfo libtool libftdi-dev libusb-dev
RUN apt install -y software-properties-common
RUN add-apt-repository ppa:deadsnakes/ppa
RUN apt update
RUN apt install -y python3.8
WORKDIR /pico

# Create directories for the tools needed for development on pico
RUN mkdir pico-sdk
RUN mkdir pico-examples
RUN mkdir pico-extras
RUN mkdir pico-playground

# Clone development tools in their respective directories
RUN git clone https://github.com/raspberrypi/pico-sdk.git
ENV PICO_SDK_PATH /pico/pico-sdk
RUN cd pico-sdk && git submodule update --init && cd ..
RUN git clone https://github.com/raspberrypi/pico-examples.git
RUN cd pico-examples && git submodule update --init && cd ..
ENV PICO_EXAMPLES_PATH /pico/pico-examples
RUN git clone https://github.com/raspberrypi/pico-extras.git
RUN cd pico-extras && git submodule update --init && cd ..
ENV PICO_EXTRAS_PATH /pico/pico-extras
RUN git clone https://github.com/raspberrypi/pico-playground.git
RUN cd pico-playground && git submodule update --init && cd ..
ENV PICO_PLAYGROUND_PATH /pico/pico-playground

RUN git clone https://github.com/raspberrypi/picoprobe.git
RUN git clone https://github.com/raspberrypi/picotool.git

RUN mkdir picoprobe/build
RUN cmake -B/pico/picoprobe/build -S/pico/picoprobe
RUN cd /pico/picoprobe/build && make -j4 && cd /pico
RUN cp picotool -r /usr/local/bin

RUN mkdir picotool/build
RUN cmake -B/pico/picotool/build -S/pico/picotool
RUN cd /pico/picotool/build && make -j4 && cd /pico
RUN make -j4

# cmake -B/path/to/my/build/folder -S/path/to/my/source/folder