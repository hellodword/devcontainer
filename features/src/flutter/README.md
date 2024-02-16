
# Flutter (flutter)

cpp image is **required** for cmake.

```json
{
    "image": "mcr.microsoft.com/devcontainers/cpp:ubuntu-22.04",
    "features": {
        "ghcr.io/hellodword/devcontainer/common:1": {},
        "ghcr.io/hellodword/devcontainer/common-gui:1": {},
        "ghcr.io/devcontainers/features/java:1": {
            "version": "17.0.10-jbr"
        },
        "ghcr.io/hellodword/devcontainer/android-sdk:1": {},
        "ghcr.io/hellodword/devcontainer/flutter:1": {}
    },
    "runArgs": [
        // Allow USB in container
        "--device-cgroup-rule", "c 189:* rmw"
    ],
    "initializeCommand": "mkdir -p ${localWorkspaceFolder}/.mount/.android"
}
```

## Example Usage

```json
"features": {
    "ghcr.io/hellodword/devcontainer/flutter:1": {}
}
```



## Customizations

### VS Code Extensions

- `dart-code.dart-code`
- `dart-code.flutter`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/hellodword/devcontainer/blob/main/features/src/flutter/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
