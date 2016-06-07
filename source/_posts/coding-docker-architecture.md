title: Docker 架构
date: 2015-10-15 15:08:49
categories: Coding
tags:
  - docker
  - go
---

Docker 采用 C/S 架构。Docker client 和 Docker daemon 通信，以创建、运行或发布容器。可以将 Docker daemon 运行在本机或远程主机，client 和 daemon 通过 sockets 或 RESTful API 交互。

### 1. Docker核心
* **Docker daemon** 接受并处理Docker Client发送的请求，它是运行在宿主机上的系统进程。
* **Docker client** Docker的用户接口，用户通过执行 `docker` 命令操作 daemon 。

其基本结构可参考官方图：
![Docker架构](docker-architecture-1.svg)

### 2. Docker内部机制
* 镜像(Docker images)
* 仓库(Docker registries)
* 容器(Docker containers)

理解 Docker 内部机制需要理解这三个基本概念。

#### 2.1. 镜像
1. 镜像是一个只读模板，可以包含操作系统、Apache 及 Web 应用等；
2. 镜像用来创建容器；
3. 镜像是 Docker 的**构建(Build)**组件。

#### 2.2. 仓库
1. 仓库用来存储镜像，以供上传下载；
2. 仓库分公有、私有，公有仓库是 `Docker Hub` ；
3. 仓库是 Docker 的**分发(Distribution)**组件。

#### 2.3. 容器
1. 容器是独立、安全的应用平台，保存着应用运行所需要的一切内容；
2. 容器由镜像创建，可以被运行、启动、停止、移动或删除；
3. 容器是 Docker 的**运行(Run)**组件。

### 3. Docker架构

![Docker概念思维导图](docker-architecture-2.png)

参考文档：
* [Docker源码分析（一）：Docker架构](http://www.infoq.com/cn/articles/docker-source-code-analysis-part1)
* [Docker Docs](https://docs.docker.com)


