# Frida (frida)

## Example Usage

```jsonc
{
    "image": "ghcr.io/hellodword/devcontainers-images-frida",
    "runArgs": [
        // Allow USB in container
        "--device-cgroup-rule",
        "c 189:* rmw"
    ],
    "initializeCommand": "mkdir -p ${localWorkspaceFolder}/.mount/.android; cp $HOME/.android/adbkey ${localWorkspaceFolder}/.mount/.android/adbkey && cp $HOME/.android/adbkey.pub ${localWorkspaceFolder}/.mount/.android/adbkey.pub"
}
```
