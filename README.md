# devcontainer

## resources

- https://containers.dev/
- https://github.com/mviereck/x11docker/wiki/How-to-provide-Wayland-socket-to-docker-container

## tips

- containerEnv 中不支持 `$HOME` ，要写完整的路径 `/home/vscode`
- GitHub Actions 中， `runneradmin` 才是 `1000:1000`，所以似乎要 sudo 才能实现 runnerUser 为 vscode 时，容器内为 `1000:1000`，否则可能会是 `1002:1002` 等等
    ```
    runneradmin:x:1000:
    runner:x:1001:

    runneradmin:x:1000:1000:Ubuntu:/home/runneradmin:/bin/bash
    runner:x:1001:127:,,,:/home/runner:/bin/bash
    ```

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
