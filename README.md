# devcontainer

## resources

- https://containers.dev/
- https://github.com/mviereck/x11docker/wiki/How-to-provide-Wayland-socket-to-docker-container

## tips

- `devcontainer-feature.json` 不支持 `initializeCommand`
    - [devcontainers/features issues#849](https://github.com/devcontainers/features/issues/849)

- `devcontainer-feature.json` 不支持 remoteEnv
- `devcontainer-feature.json` 的 containerEnv
    - 不支持 `$HOME` 或者一切容器内的环境变量，要写完整的路径 `/home/vscode`
    - 不支持一切求值表达式 `${localEnv:*}` 或 `${remoteEnv:*}` 或 `${containerEnv:*}`
            - [issue #7766](https://github.com/microsoft/vscode-remote-release/issues/7766)
            - [devcontainers/features issues#848](https://github.com/devcontainers/features/issues/848)


- GitHub Actions 中， `runneradmin` 才是 `1000:1000`，所以似乎要 sudo 才能实现 runnerUser 为 vscode 时，容器内为 `1000:1000`，否则可能会是 `1002:1002` 等等
    ```
    runneradmin:x:1000:
    runner:x:1001:

    runneradmin:x:1000:1000:Ubuntu:/home/runneradmin:/bin/bash
    runner:x:1001:127:,,,:/home/runner:/bin/bash
    ```
- 在 `devcontainer.json` 和 `devcontainer-feature.json` 中应尽量只使用 `localEnv` 而避免使用 `containerEnv` 或 `remoteEnv` 或 `remoteUser` 等值，支持程度非常混乱

- `devcontainer-feature.json` 的 `mounts` 在 `devcontainers/action` 进行 validate 时不支持 string，以至于无法使用 `readonly`、`consistency=cached` 等，考虑有空时 pr [修复](https://github.com/devcontainers/action/blob/a1930bf7eb60408bbfd6e201d88e33cdec41a25e/src/contracts/features.ts#L28-L33)
    ```json
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

## GUI

和 wayland 配合非常简单:

```json
{
    "image": "mcr.microsoft.com/devcontainers/base:ubuntu-22.04",
    "features": {
        "ghcr.io/hellodword/devcontainer/common:1": {},
        "ghcr.io/hellodword/devcontainer/common-gui:1": {}
    },
    "runArgs": [
        "-v",
        "${localEnv:XDG_RUNTIME_DIR}/${localEnv:WAYLAND_DISPLAY}:/tmp/${localEnv:WAYLAND_DISPLAY}"
    ],
    "containerEnv": {
		"WAYLAND_DISPLAY": "${localEnv:WAYLAND_DISPLAY}",
		"XDG_RUNTIME_DIR": "/tmp"
	}
}
```

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
