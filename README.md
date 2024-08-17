## Go Ethereum

以太坊协议的 Golang 执行层实现。

[![API Reference](
https://pkg.go.dev/badge/github.com/ethereum/go-ethereum
)](https://pkg.go.dev/github.com/ethereum/go-ethereum?tab=doc)
[![Go Report Card](https://goreportcard.com/badge/github.com/ethereum/go-ethereum)](https://goreportcard.com/report/github.com/ethereum/go-ethereum)
[![Travis](https://app.travis-ci.com/ethereum/go-ethereum.svg?branch=master)](https://app.travis-ci.com/github/ethereum/go-ethereum)
[![Discord](https://img.shields.io/badge/discord-join%20chat-blue.svg)](https://discord.gg/nthXNEv)

自动构建可用于稳定版本和不稳定的 master 分支. 

二进制的档案发布于 https://geth.ethereum.org/downloads/.

## 构建源

有关先决条件和详细的构建说明，请阅读 [安装说明](https://geth.ethereum.org/docs/getting-started/installing-geth).

构建 'geth' 需要 Go（版本 1.21 或更高版本）和 C 编译器。您可以安装他们使用您最喜欢的包管理器.

安装依赖项后, 运行

```shell
make geth
```

或者，要构建全套实用程序，请执行以下操作：

```shell
make all
```

## 可执行文件
go-ethereum项目在 'cmd' 目录中提供了几个 wrappers/executables 包装器/可执行文件.

|  命令   | 描述                                                                                                                                                                                                                                                                                                                                                 |
| :--------: |----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| **`geth`** | 我们的主要以太坊 CLI 客户端. 它是以太坊网络（主网main、测试网test或私有private网）的入口点, 能够作为全节点运行（默认）, 备份节点（保留所有历史状态）或轻节点（实时检索数据）. 它可以被其他进程用作进入以太坊网络的网关，通过暴露在HTTP之上的JSON RPC、WebSocket 或者 IPC 传输. `geth --help` 以及 [CLI 页面](https://geth.ethereum.org/docs/fundamentals/command-line-options) 对于命令行选项.                                                                           |
|   `clef`   | 独立的签名工具，可以作为 'geth' 的后端签名者。                                                                                                                                                                                                                                                                                                                        |
|  `devp2p`  | 用于与网络层上的节点交互的实用程序，而无需运行完整的区块链。                                                                                                                                                                                                                                                                                                                     |
|  `abigen`  | 源代码生成器，用于将以太坊合约定义转换为易于使用、编译时类型安全的 Go 包. 它在平原上运作 [以太坊合约 ABI](https://docs.soliditylang.org/en/develop/abi-spec.html) 如果合同字节码也可用，则具有扩展功能. 但是，它也接受 Solidity 源文件，使开发更加简化. 请参阅我们的 [原生 DApp](https://geth.ethereum.org/docs/developers/dapp-developer/native-bindings) 页面了解详细信息.                                                                         |
| `bootnode` | 我们的以太坊客户端实现的精简版本，仅参与网络节点发现协议, 但不运行任何更高级别的应用程序协议. 它可以用作轻量级 bootstrap 节点，以帮助在专用网络中查找对等节点。                                                                                                                                                                                                                                                            |
|   `evm`    | EVM（以太坊虚拟机）的开发人员实用程序版本，能够在可配置的环境和执行模式下运行字节码片段. 其目的是允许对 EVM 操作码进行隔离、细粒度的调试 (e.g. `evm --code 60ff60ff --debug run`).                                                                |
| `rlpdump`  | 用于转换二进制 RLP 的开发人员实用工具 ([Recursive Length Prefix](https://ethereum.org/en/developers/docs/data-structures-and-encoding/rlp)) 转储 (以太坊协议使用的数据编码既包括网络方面，也包括共识方面) 实现用户友好的层次结构表示 (e.g. `rlpdump --hex CE0183FFFFFFC4C304050583616263`). |

## 运行 `geth`

在这里，浏览所有可能的命令行标志超出了范围 (请咨询我们的[CLI Wiki 页面](https://geth.ethereum.org/docs/fundamentals/command-line-options)),
但是，我们列举了一些常见的参数组合，以帮助您快速上手关于如何运行自己的 'geth' 实例。

### 硬件要求

最低:

* 具有 2+ 核心的 CPU
* 4GB 内存
* 1TB免费存储空间同步主网
* 8 MBit/sec 下载互联网服务

推荐:

* 具有 4+ 核的快速 CPU
* 16GB+ 内存
* 高性能 SSD，至少 1TB 的可用空间
* 25+ MBit/sec 下载互联网服务

### 以太坊主网络上的全节点

到目前为止，最常见的情况是人们想要简单地与以太坊互动网络：创建帐户;转移资金;部署合同并与之交互。

为此在特定用例中，用户不关心多年前的历史数据，因此我们可以快速同步到网络的当前状态。

要做到这一点:

```shell
$ geth console
```

此命令将:
 * 在快照同步模式下启动 'geth' (默认值，可以使用 '--syncmode' 标志进行更),
   导致它下载更多数据以换取避免处理整个历史记录以太坊网络，这是非常占用 CPU 资源的。
 * 启动内置交互 [JavaScript console](https://geth.ethereum.org/docs/interacting-with-geth/javascript-console),
   (通过尾随的 'console' 子命令) 通过它，您可以使用 [`web3` methods](https://github.com/ChainSafe/web3.js/blob/0.20.7/DOCUMENTATION.md) 
   (注意：捆绑在 'geth' 中的 'web3' '版本非常旧，并且没有与官方文档保持同步),
   以及 'geth' 自己的 [管理 APIs](https://geth.ethereum.org/docs/interacting-with-geth/rpc).
   这个工具是可选的，如果你把它省略了，你可以随时把它附加到已经运行的带有 'geth attach' 的 'geth' 实例。

### Görli 测试网络上的全节点

向开发人员过渡，如果您想尝试创建以太坊合同，你几乎肯定希望在不涉及任何真金白银的情况下这样做，直到您可以掌握整个系统的窍门。

换句话说，而不是附加到主 network，您希望将 **test** 网络与您的节点一起加入，这完全相当于主网络，但仅使用 play-Ether。

```shell
$ geth --goerli console
```

'console' 子命令的含义与上述相同，并且同样在测试网上也很有用。

但是，指定 '--goerli' 标志将稍微重新配置您的 'geth' 实例：

 * 客户端将连接到Görli测试网络，而不是连接到主要的以太坊网络，该网络使用不同的P2P启动节点，不同的网络ID和创世状态。
 * “geth”不会使用默认的数据目录（例如在 Linux 上为“~.ethereum”）， 
   而是将自己嵌套在“goerli”子文件夹（Linux 上为“~.ethereumgoerli”）中。
   请注意，在 OSX 和 Linux 上，这也意味着连接到正在运行的测试网节点需要使用自定义端点，
   因为默认情况下，“geth attach”会尝试连接到生产节点端点，例如，“geth attach <datadir>goerligeth.ipc”。
   Windows 用户不受此影响

*注意：尽管一些内部保护措施可以防止交易在主网络和测试网络之间交叉，但您应始终使用单独的账户进行游戏和真钱交易。
除非您手动移动帐户，否则默认情况下，'geth' 将正确分隔两个网络，并且不会在它们之间提供任何帐户.*

### 配置

作为将众多标志传递给 'geth' '二进制文件的替代方法，您还可以通过以下方式传递配置文件:

```shell
$ geth --config /path/to/your_config.toml
```

要了解文件的外观，您可以使用 'dumpconfig' 子命令来导出现有配置：

```shell
$ geth --your-favourite-flags dumpconfig
```

*注意：这仅适用于 'geth' v1.6.0 及更高版本.*

#### Docker 快速入门

在您的机器上启动并运行以太坊的最快方法之一是使用docker：

```shell
docker run -d --name ethereum-node -v /Users/alice/ethereum:/root \
           -p 8545:8545 -p 30303:30303 \
           ethereum/client-go
```

这将在快照同步模式下启动 'geth'，数据库内存限额为 1GB，因为上述命令确实如此。 
它还将在您的主目录中创建一个持久卷，用于保存您的区块链并映射默认端口。
还有一个 'alpine' 标签可用于图像的超薄版本。

不要忘记 '--http.addr 0.0.0.0'，如果你想从其他容器和或主机访问 RPC。
默认情况下，'geth' 绑定到本地接口，并且无法从外部访问 RPC 端点。

### 以编程方式连接 'geth' 节点

作为开发人员，您迟早会希望通过自己的程序开始与 'geth' 和以太坊网络进行交互，而不是通过控制台手动进行交互. 

为了帮助这个, `geth` 内置了对基于 JSON-RPC 的 API 的支持 ([标准 APIs](https://ethereum.github.io/execution-apis/api-documentation/)
and [`geth` 特定 APIs](https://geth.ethereum.org/docs/interacting-with-geth/rpc)).

这些可以通过 HTTP、WebSockets 和 IPC（基于 UNIX 上的 UNIX 套接字）公开平台，以及 Windows 上的命名管道）。

IPC 接口默认开启，并公开了 'geth' 支持的所有 API，而 HTTP 和 WS 接口需要手动启用，并且只公开一个,
由于安全原因，API 的子集。这些可以打开/关闭并配置为你所期望的。

基于 HTTP 的 JSON-RPC API 选项：

  * `--http` 启用 HTTP-RPC 服务器
  * `--http.addr` HTTP-RPC服务器监听接口 (default: `localhost`)
  * `--http.port` HTTP-RPC服务器监听端口 (default: `8545`)
  * `--http.api` 通过 HTTP-RPC 接口提供的 API (default: `eth,net,web3`)
  * `--http.corsdomain` 以逗号分隔的域列表，从中接受跨域请求 (浏览器强制执行)
  * `--ws` 启用 WS-RPC 服务器
  * `--ws.addr` WS-RPC 服务器监听接口 (default: `localhost`)
  * `--ws.port` WS-RPC 服务器监听端口 (default: `8546`)
  * `--ws.api` 通过 WS-RPC 接口提供的 API (default: `eth,net,web3`)
  * `--ws.origins` 接受 WebSocket 请求的来源
  * `--ipcdisable` 禁用 IPC-RPC 服务器
  * `--ipcapi` 通过IPC-RPC接口提供的API (default: `admin,debug,eth,miner,net,personal,txpool,web3`)
  * `--ipcpath` datadir 中 IPC 套接字/管道的文件名 (显式路径会转义它)

您需要使用自己的编程环境的功能（库、工具等）来通过 HTTP 连接, 
WS 或 IPC 到配置了上述标志的“geth”节点，您将需要 [JSON-RPC](https://www.jsonrpc.org/specification) 在所有运输工具上. 
您可以对多个请求重复使用同一连接！

**注意：请理解打开基于 HTTP/WS 的安全影响在这样做之前运输！
互联网上的黑客正在积极尝试颠覆具有公开 API 的以太坊节点！
此外，所有浏览器选项卡都可以在本地访问运行 Web 服务器，因此恶意网页可能会尝试破坏本地可用蜜蜂属！**

### 运营专用网络

维护自己的专用网络涉及更多，因为需要进行大量配置在官方授予的网络上需要手动设置。

#### 定义私有创世状态

首先，您需要创建网络的创世状态，所有节点都需要如此了解并同意。
它由一个小的 JSON 文件组成（例如，将其命名为 'genesis.json'）：

```json
{
  "config": {
    "chainId": <arbitrary positive integer>,
    "homesteadBlock": 0,
    "eip150Block": 0,
    "eip155Block": 0,
    "eip158Block": 0,
    "byzantiumBlock": 0,
    "constantinopleBlock": 0,
    "petersburgBlock": 0,
    "istanbulBlock": 0,
    "berlinBlock": 0,
    "londonBlock": 0
  },
  "alloc": {},
  "coinbase": "0x0000000000000000000000000000000000000000",
  "difficulty": "0x20000",
  "extraData": "",
  "gasLimit": "0x2fefd8",
  "nonce": "0x0000000000000042",
  "mixhash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "parentHash": "0x0000000000000000000000000000000000000000000000000000000000000000",
  "timestamp": "0x00"
}
```

对于大多数用途，上述字段应该没问题，尽管我们建议将 'nonce' 更改为某个随机值，以防止未知的远程节点能够连接到您。
如果您想为一些账户预注资金以便于测试，请创建账户并在 'alloc' 字段中填充其地址。

```json
"alloc": {
  "0x0000000000000000000000000000000000000001": {
    "balance": "111111111"
  },
  "0x0000000000000000000000000000000000000002": {
    "balance": "222222222"
  }
}
```

在上述 JSON 文件中定义了创世状态后，您需要在启动之前使用它初始化每个 'geth' 节点，以确保所有区块链参数都已正确设置：

```shell
$ geth init path/to/genesis.json
```

#### 创建交汇点

在您想要运行的所有节点都初始化为所需的创世状态后，您需要启动一个 Bootstrap 节点，其他人可以使用该节点在您的网络中和/或上方找到彼此互联网。
干净的方法是配置并运行一个专用的 bootnode：

```shell
$ bootnode --genkey=boot.key
$ bootnode --nodekey=boot.key
```

引导节点联机时, 它将显示一个 [`enode` URL](https://ethereum.org/en/developers/docs/networking-layer/network-addresses/#enode)其他节点可以用来连接到它并交换对等信息. 
请务必替换显示的 IP 地址信息 (most probably `[::]`) 使用外部可访问的 IP 获取实际的 'enode' URL.

*注意：您也可以使用成熟的 'geth' 节点作为引导节点，但数量较少推荐方式.*

#### 启动您的成员节点

引导节点可操作且可从外部访问 (you can try `telnet <ip> <port>` to ensure it's indeed reachable), 
通过 '--bootnodes' 标志启动指向 BootNode 的每个后续 'geth' 节点以进行对等发现. 
可能还需要将专用网络的数据目录分开, 因此，也要指定自定义的 '--datadir' 标志.

```shell
$ geth --datadir=path/to/custom/data/folder --bootnodes=<bootnode-enode-url-from-above>
```

*注意：由于您的网络将与主网络和测试网络完全切断，因此您将还需要配置一个矿工来处理交易并为您创建新的区块.*

#### 经营私人矿机


在专用网络设置中，单个 CPU 矿工实例绰绰有余实际用途，因为它可以在正确的时间间隔产生稳定的块流无需大量资源
（考虑在单个线程上运行，无需多个线程一个）。
要启动用于挖矿的 'geth' 实例，请使用所有常用的扩展标志运行它由：

```shell
$ geth <usual-flags> --mine --miner.threads=1 --miner.etherbase=0x0000000000000000000000000000000000000000
```

这将开始在单个 CPU 线程上挖掘块和事务, 记入所有对 '--miner.etherbase' 指定的账户进行处理. 
您可以通过更改默认的 gas limit 块收敛来进一步调整采矿 (`--miner.targetgaslimit`) 价格交易在以下地被接受 (`--miner.gasprice`).


## License

The go-ethereum library (i.e. all code outside of the `cmd` directory) is licensed under the
[GNU Lesser General Public License v3.0](https://www.gnu.org/licenses/lgpl-3.0.en.html),
also included in our repository in the `COPYING.LESSER` file.

The go-ethereum binaries (i.e. all code inside of the `cmd` directory) are licensed under the
[GNU General Public License v3.0](https://www.gnu.org/licenses/gpl-3.0.en.html), also
included in our repository in the `COPYING` file.
