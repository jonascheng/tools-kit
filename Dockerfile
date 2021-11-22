FROM debian:stable as build-env

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
RUN cmake -DgRPC_INSTALL=ON /var/local/git/grpc \
    && make && make install
RUN cmake -DgRPC_BUILD_TESTS=ON -DgRPC_INSTALL=ON /var/local/git/grpc \
    && make grpc_cli

# release
FROM debian:stable-slim

RUN apt-get update && apt-get install -y \
    tcpdump ncat net-tools iproute2 curl wget \
    && apt-get clean

COPY --from=build-env /usr/local/bin /usr/local/bin
COPY --from=build-env /var/local/git/grpc/cmake/build/grpc_cli /usr/local/bin/grpc_cli

ENTRYPOINT /bin/bash

