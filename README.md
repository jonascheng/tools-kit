# Tools kit

The tools kit include

* vi, nano
* wget, curl
* ip, nc, ifconfig, tcpdump
* protoc, [protoc-gen-go](https://grpc.io/docs/languages/go/quickstart/)
* [gRPC command line tool](https://github.com/grpc/grpc/blob/master/doc/command_line_tool.md)

# Usage

```bash
# attach to host network
docker run -it --network host jonascheng/tools-kit:latest bash
# attach to container network
docker run -it --network container:<name|id> jonascheng/tools-kit:latest bash
# attach to working directory
docker run -it -v $(pwd):/app -w /app jonascheng/tools-kit:latest bash
```

