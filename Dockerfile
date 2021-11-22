FROM debian:stable as base

# essential packages
RUN apt-get update && apt-get install -y \
    git \
    && apt-get clean

# grpb-cli
RUN apt-get install -y \
    build-essential autoconf libtool pkg-config cmake \
    && apt-get clean
RUN git clone -b v1.42.0 https://github.com/grpc/grpc /var/local/git/grpc
RUN cd /var/local/git/grpc && git submodule update --init
WORKDIR /var/local/git/grpc/cmake/build
#RUN mkdir -p cmake/build && cd cmake/build \
RUN cmake -DgRPC_BUILD_TESTS=ON -DgRPC_INSTALL=ON /var/local/git/grpc \
    && make && make install

ENV PATH /var/local/git/grpc/bins/opt:$PATH

ENTRYPOINT bash

