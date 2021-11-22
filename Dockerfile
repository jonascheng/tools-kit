FROM golang:1.17-buster as build-env

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

# protoc-gen-go
RUN go install github.com/golang/protobuf/protoc-gen-go@latest

# release
FROM golang:1.17-buster

ENV GO111MODULE=on
ENV PATH="$PATH:$(go env GOPATH)/bin"

# install tools-kit
RUN apt-get update && apt-get install -y \
    tcpdump ncat net-tools iproute2 curl wget \
    nano vim \
    && apt-get clean

COPY --from=build-env /usr/local/bin /usr/local/bin
COPY --from=build-env /var/local/git/grpc/cmake/build/grpc_cli /usr/local/bin/grpc_cli
COPY --from=build-env /go/bin /go/bin

