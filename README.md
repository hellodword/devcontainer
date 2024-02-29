# devcontainer

## resources

- https://containers.dev/
- https://github.com/mviereck/x11docker/wiki/How-to-provide-Wayland-socket-to-docker-container
- https://github.com/microsoft/vscode-docs/blob/c5995c0e408d5867e6f1a475212fb3c5076e1857/docs/remote/remote-overview.md
  - https://github.com/Microsoft/vscode-remote-release/issues
  - https://github.com/microsoft/vscode-docs/blob/c5995c0e408d5867e6f1a475212fb3c5076e1857/docs/remote/troubleshooting.md
  - https://github.com/microsoft/vscode-docs/blob/c5995c0e408d5867e6f1a475212fb3c5076e1857/docs/remote/faq.md#why-arent-the-remote-development-extensions-or-their-components-open-source
- https://github.com/manekinekko/awesome-devcontainers
  - https://github.com/search?q=path%3Adevcontainer-feature.json&type=code
  - https://github.com/search?q=path%3A.devcontainer%2Fdevcontainer.json&type=code
- https://github.com/devcontainers/action/issues/213
- https://www.jetpack.io/blog/creating-nix-powered-containers-with-devbox/
- https://github.com/dev-wasm

## security

- gVisor

  > `runArgs` 里加上 `--runtime runsc` 就可以，但会有一些问题：

  - 内核版本低
  - 默认情况下没办法 sudo 了，所以 `onCreateCommand` 避免 sudo
  - 已知在运行 GUI 应用方面有问题，未排查

- rootless
  - https://rootlesscontaine.rs/how-it-works/
  - [with podman](https://github.com/microsoft/vscode-docs/blob/c5995c0e408d5867e6f1a475212fb3c5076e1857/remote/advancedcontainers/docker-options.md#podman)
  - [Making Visual Studio Code devcontainer work properly on rootless Podman](https://web.archive.org/web/20230924063548/https://medium.com/@guillem.riera/making-visual-studio-code-devcontainer-work-properly-on-rootless-podman-8d9ddc368b30)

## tips

- `devcontainer-feature.json` 不支持 `initializeCommand`

  - [devcontainers/features issues#849](https://github.com/devcontainers/features/issues/849)

- `devcontainer-feature.json` 不支持 remoteEnv
- `devcontainer-feature.json` 的 containerEnv

  - 不支持 `$HOME` 或者一切容器内的环境变量，要写完整的路径 `/home/vscode`
  - 不支持一切求值表达式 `${localEnv:*}` 或 `${remoteEnv:*}` 或 `${containerEnv:*}` - [issue #7766](https://github.com/microsoft/vscode-remote-release/issues/7766) - [devcontainers/features issues#848](https://github.com/devcontainers/features/issues/848)

- GitHub Actions 中， `runneradmin` 才是 `1000:1000`，所以似乎要 sudo 才能实现 runnerUser 为 vscode 时，容器内为 `1000:1000`，否则可能会是 `1002:1002` 等等

  ```
  runneradmin:x:1000:
  runner:x:1001:

  runneradmin:x:1000:1000:Ubuntu:/home/runneradmin:/bin/bash
  runner:x:1001:127:,,,:/home/runner:/bin/bash
  ```

- 在 `devcontainer.json` 和 `devcontainer-feature.json` 中应尽量只使用 `localEnv` 而避免使用 `containerEnv` 或 `remoteEnv` 或 `remoteUser` 等值，支持程度非常混乱

- `devcontainer-feature.json` 的 `mounts` 在 `devcontainers/action` 进行 validate 时不支持 string，以至于无法使用 `readonly`、`consistency=cached` 等

  - https://github.com/devcontainers/action/issues/210
  - https://github.com/devcontainers/action/pull/209

  ```jsonc
  // "source=${localWorkspaceFolder}/.mount/.android,target=/home/vscode/.android,type=bind,consistency=cached",
  {
      "source": "${localWorkspaceFolder}/.mount/.android",
      "target": "/home/vscode/.android",
      "type": "bind"
  },
  // "source=/dev/bus/usb,target=/dev/bus/usb,type=bind,readonly"
  {
      "source": "/dev/bus/usb",
      "target": "/dev/bus/usb",
      "type": "bind"
  }
  ```

- `initializeCommand` 运行在 host，所以它的 `$HOME` 和 `${localEnv:HOME}` 等效，其余 lifecycle hooks 运行在容器内，所以是有区别的

- 用 go listen `:3000` 不会自动开端口，`localhost:3000` 才可以

## GUI

目前 VSCode 会自动进行 X11 & Wayland Forwarding:

- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_54.md#x11-forwarding
- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_75.md#x11--wayland-forwarding

但可能会有一些边缘情况或者 BUG：

- https://github.com/devcontainers/features/issues/860

## ssh & gpg agent forwarding

- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_37.md#ssh-agent-forwarding
- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_41.md#forwarding-ssh-agent
- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_46.md#gpg-forwarding
- https://github.com/microsoft/vscode-docs/blob/804ba516030bcd2c03afda5c9c8fc60763d05a0c/remote-release-notes/v1_74.md#improved-ssh-agent-and-gpg-agent-forwarding

## java feature list versions

```sh
. /usr/local/sdkman/bin/sdkman-init.sh
sdk list java

# 例如当前 flutter 对应的 gradle 7.5 就需要指定 java 版本为 17 及以下
```

## use usb

```json
{
    "runArgs": [
        "--device-cgroup-rule",
        "c 189:* rmw",
        "-v",
        "/dev/bus/usb:/dev/bus/usb:ro",
```

```sh
# find the major/miner numbers
$ lsusb | grep Google
Bus 003 Device 015: ID 1234:5678 Google Inc. Nexus/Pixel Device (charging + debug)

$ ls -l /dev/bus/usb/003/015
crw-rw----+ 1 root adbusers 189, 270 Feb 29 05:30 /dev/bus/usb/003/015

# 189 is major and 270 is miner
```

## image

- https://containers.dev/guide/prebuild#how-to

- https://github.com/devcontainers/images/issues/968
- http://web.archive.org/web/20240217044438/https://blog.ianpreston.ca/posts/2022-12-30-devcontainers.html

- https://containers.dev/implementors/reference/#labels
  - `devcontainer.metadata` 并不支持 `runArgs` 和 `initializeCommand`
