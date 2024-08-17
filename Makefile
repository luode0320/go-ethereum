# 这个 Makefile 是为那些不经常使用 Go 源代码的人准备的。
# 如果你知道 GOPATH 是什么，那么你可能不需要使用 make。

.PHONY: geth all test lint fmt clean devtools help

# 定义 GOBIN 变量，用于存放编译生成的二进制文件
GOBIN = ./build/bin
GO ?= latest
# 定义 GORUN 变量，用于运行 Go 程序
GORUN = go run

#? geth: 构建 geth。
geth:
	# 使用 GORUN 运行 build/ci.go 脚本以安装 geth 命令
	$(GORUN) build/ci.go install ./cmd/geth
	# 输出构建完成的消息
	@echo "Done building."
	# 输出如何运行 geth 的提示
	@echo "Run \"$(GOBIN)/geth\" to launch geth."

#? all: 构建所有包和可执行文件。
all:
	# 使用 GORUN 运行 build/ci.go 脚本以安装所有命令
	$(GORUN) build/ci.go install

#? test: 运行测试。
test: all
	# 使用 GORUN 运行 build/ci.go 脚本以运行测试
	$(GORUN) build/ci.go test

#? lint: 运行选定的 linter 工具。
lint: ## Run linters.
	# 使用 GORUN 运行 build/ci.go 脚本以运行 linters
	$(GORUN) build/ci.go lint

#? fmt: 确保代码格式的一致性。
fmt:
	# 使用 gofmt 对所有 .go 文件进行格式化
	gofmt -s -w $(shell find . -name "*.go")

#? clean: 清理 Go 缓存、构建的可执行文件和自动生成的文件夹。
clean:
	# 清理 Go 缓存
	go clean -cache
	# 删除 build/_workspace/pkg/ 文件夹和 GOBIN 目录下的所有文件
	rm -fr build/_workspace/pkg/ $(GOBIN)/*

# devtools 目标安装用于 'go generate' 的必需工具。
# 你需要将 $GOBIN (或 $GOPATH/bin) 加入到 PATH 中才能使用 'go generate'。

#? devtools: 安装推荐的开发者工具。
devtools:
	# 安装 stringer 工具
	env GOBIN= go install golang.org/x/tools/cmd/stringer@latest
	# 安装 gencodec 工具
	env GOBIN= go install github.com/fjl/gencodec@latest
	# 安装 protoc-gen-go 工具
	env GOBIN= go install google.golang.org/protobuf/cmd/protoc-gen-go@latest
	# 安装 abigen 工具
	env GOBIN= go install ./cmd/abigen
	# 检查 solc 是否已安装
	@type "solc" 2> /dev/null || echo 'Please install solc'
	# 检查 protoc 是否已安装
	@type "protoc" 2> /dev/null || echo 'Please install protoc'

#? help: 获取更多关于 make 命令的信息。
help: Makefile
	# 输出 help 信息
	@echo ''
	@echo 'Usage:'
	@echo '  make [target]'
	@echo ''
	@echo 'Targets:'
	# 从 Makefile 中筛选出所有目标，并以冒号分割，进行表格输出
	@sed -n 's/^#?//p' $< | column -t -s ':' |  sort | sed -e 's/^/ /'
