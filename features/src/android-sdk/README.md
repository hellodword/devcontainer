
# Android SDK (android-sdk)

- Install Android SDK `cmdline-tools`, `platform-tools`, `ndk` and, `build-tools`.

- The ~/.android will persisted in .mount/.android and `"initializeCommand": "mkdir -p ${localWorkspaceFolder}/.mount/.android"` is **required**.

- `"runArgs": [ "--device-cgroup-rule", "c 189:* rmw" ]` is **required** for usb.

- `"ghcr.io/devcontainers/features/java:1": { "version": "17.0.10-jbr" }` is **required** for JAVA_HOME.

## Example Usage

```json
"features": {
    "ghcr.io/hellodword/devcontainer/android-sdk:1": {}
}
```

## Options

| Options Id | Description | Type | Default Value |
|-----|-----|-----|-----|
| platform | SDK platform version, install latest if empty | string | - |
| ndk | NDK version, install latest if empty | string | - |
| build_tools | SDK build-tools version, install latest if empty | string | - |
| base_packages | packages will override default packages, split by space | string | - |
| extra_packages | extra packages, split by space | string | - |

## Customizations

### VS Code Extensions

- `vscjava.vscode-gradle`



---

_Note: This file was auto-generated from the [devcontainer-feature.json](https://github.com/hellodword/devcontainer/blob/main/features/src/android-sdk/devcontainer-feature.json).  Add additional notes to a `NOTES.md`._
