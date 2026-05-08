# 📦 git-annex-p2phttp

**Alpine · 轻量 · 开箱即用**  
在容器中运行 git-annex p2phttp 服务，快速将你的 git-annex 仓库发布到网络，可作为代码仓库服务器。

![License](https://img.shields.io/badge/license-AGPL--3.0-blue.svg)
![Alpine](https://img.shields.io/badge/base-Alpine%203.20-0D597F?logo=alpinelinux)
![git-annex](https://img.shields.io/badge/git--annex-p2phttp-orange?logo=git)

---

## 🚀 快速开始

### Docker

```bash
docker pull ghcr.io/hinnyuu/git-annex-p2phttp:latest

docker run -d \
  --name annex-server \
  -v /path/to/git-repos:/git-repos \
  -v /path/to/annex-data:/annex-data \
  -p 9417:9417 \
  ghcr.io/hinnyuu/git-annex-p2phttp:latest
```

### Podman（rootful）

> ⚠️ **目前仅支持 rootful 模式**，rootless 支持计划在后续版本中实现。  
> 如果你现在使用 rootless Podman 遇到权限问题，请暂时切换为 rootful（`sudo podman`）运行。

```bash
sudo podman pull ghcr.io/hinnyuu/git-annex-p2phttp:latest

sudo podman run -d \
  --name annex-server \
  -v /path/to/git-repos:/git-repos \
  -v /path/to/annex-data:/annex-data \
  -p 9417:9417 \
  ghcr.io/hinnyuu/git-annex-p2phttp:latest
```

## 📂 挂载卷说明

| 容器路径      | 必需         | 作用                                                                 |
| :------------ | :----------- | :------------------------------------------------------------------- |
| `/git-repos`  | **是**       | 存放 Git **裸仓库**的目录。服务自动扫描其中的仓库并对外提供访问。     |
| `/annex-data` | 否（但推荐）   | 用于存储 git-annex 对象数据的额外目录，适合分离仓库元数据与大量文件。 |

> 如果不挂载 `/annex-data`，Docker/Podman 仍然会创建一个匿名卷，不影响运行。

## ⚙️ 定制启动参数

默认启动命令为：

```bash
git-annex p2phttp --directory=/git-repos --jobs=4 --bind=0.0.0.0
```

你可以直接覆盖 `CMD` 来修改任何参数，例如：

```bash
docker run -d ... ghcr.io/hinnyuu/git-annex-p2phttp:latest \
  git-annex p2phttp --directory=/git-repos --jobs=8 --bind=127.0.0.1
```

📖 完整参数列表请见 [git-annex p2phttp 官方文档](https://git-annex.branchable.com/git-annex-p2phttp/)。

## 🏗️ 从源码构建

```bash
git clone https://github.com/hinnyuu/git-annex-p2phttp.git
cd git-annex-p2phttp

# Docker
docker build -t git-annex-p2phttp .

# Podman（rootful）
sudo podman build -t git-annex-p2phttp .
```

## 📘 使用示例

1. **准备裸仓库**  
   将已有的 git-annex 仓库克隆为裸仓库：

   ```bash
   git clone --bare /home/user/my-annex-repo /srv/git-repos/my-annex-repo.git
   ```

2. **启动服务**  
   挂载 `/srv/git-repos` 到容器：

   ```bash
   docker run -d \
     --name annex-server \
     -v /srv/git-repos:/git-repos \
     -p 9417:9417 \
     ghcr.io/hinnyuu/git-annex-p2phttp:latest
   ```

3. **客户端连接**  
   在其他机器上，通过 git-annex 连接该服务：

   ```bash
   git annex p2phttp --server http://your-server-ip:9417/ --uuid <repo-uuid>
   ```

## 🛡️ 安全提醒

- 默认监听 `0.0.0.0`，请确保防火墙已限制 9417 端口的访问来源。
- 如果只需要本地访问，可改为 `--bind=127.0.0.1` 并通过反向代理（如 nginx / caddy）暴露服务。

## 📄 许可

本项目基于 [AGPL-3.0](LICENSE) 协议开源。

---

🔄 **反馈与贡献**：欢迎提交 Issue 或 PR 至 [GitHub 仓库](https://github.com/hinnyuu/git-annex-p2phttp)。

*本 README 由 DeepSeek V4 Pro 协助撰写*