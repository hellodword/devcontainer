# Flutter (flutter)

## Example Usage

```jsonc
{
  "image": "ghcr.io/hellodword/devcontainers-images-flutter",
  "runArgs": [
    // Allow USB in container
    "--device-cgroup-rule",
    "c 189:* rmw"
  ],
  "initializeCommand": "mkdir -p ${localWorkspaceFolder}/.mount/.android"
}
```
