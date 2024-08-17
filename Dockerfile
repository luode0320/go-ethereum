# 支持在最终镜像上设置各种标签
# 提交哈希值
ARG COMMIT=""
# 版本号
ARG VERSION=""
# 构建编号
ARG BUILDNUM=""

# 在标准的 Go 构建容器中构建 Geth
FROM golang:1.22-alpine as builder

# 安装必要的依赖项
RUN apk add --no-cache gcc musl-dev linux-headers git

# 获取依赖项 - 如果 go.mod 和 go.sum 文件不变，这些依赖项会被缓存
COPY go.mod /go-ethereum/
COPY go.sum /go-ethereum/
RUN cd /go-ethereum && go mod download

# 将整个项目复制到构建容器中
ADD . /go-ethereum
# 在构建容器中构建静态链接的 Geth 二进制文件
RUN cd /go-ethereum && go run build/ci.go install -static ./cmd/geth

# 从 Alpine 容器中拉取 Geth
FROM alpine:latest

# 安装必要的证书
RUN apk add --no-cache ca-certificates
# 从构建阶段复制 Geth 二进制文件到最终的容器中
COPY --from=builder /go-ethereum/build/bin/geth /usr/local/bin/

# 暴露 Geth 使用的端口
EXPOSE 8545 8546 30303 30303/udp
# 设置容器启动时执行的命令
ENTRYPOINT ["geth"]

# 添加一些元数据标签以帮助程序化镜像消费
ARG COMMIT=""
ARG VERSION=""
ARG BUILDNUM=""

# 为镜像添加标签
LABEL commit="$COMMIT" version="$VERSION" buildnum="$BUILDNUM"
