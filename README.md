# devcontainer

## resources

- https://containers.dev/
- https://github.com/mviereck/x11docker/wiki/How-to-provide-Wayland-socket-to-docker-container

## tips

- containerEnv 中不支持 `$HOME` ，要写完整的路径 `/home/vscode`

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
